import { type ComponentProps, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui/components';
import { Table, TableCell, TableRow } from 'tgui/components/Table';
import { Window } from 'tgui/layouts';

export interface DocumentLog {
  ['XRF Scans']?: Array<DocumentRecord>;
}
export interface Chemical {
  name: string;
  property_hint: string;
  recipe_hint: string;
  id: string;
  gen_tier: number;
}

export interface DocumentRecord {
  document_title: string;
  time: string;
  document: string;
  category: string;
}

interface TerminalProps {
  clearance_level: number;
  research_documents: DocumentLog;
  published_documents: DocumentLog;
  rsc_credits: number;
  broker_cost: number;
  base_purchase_cost: number;
  main_terminal: number;
  terminal_view: number;
  clearance_x_access: number;
  photocopier_error: number;
  printer_toner: number;
  is_contract_picked: number;
  contract_chems: Chemical[];
  world_time: number;
  next_reroll: number;
  contract_cooldown: number;
}

interface ConfirmationProps extends ComponentProps<typeof Box> {
  readonly onConfirm: () => any;
  readonly onCancel: () => any;
}

const ConfirmationDialogue = (props: ConfirmationProps) => {
  return (
    <Stack vertical className="Confirm-Dialogue">
      <Stack.Item>{props.children}</Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button
              className="Button ConfirmButton"
              icon="check"
              onClick={props.onConfirm}
            >
              Confirm
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="cancel" onClick={props.onCancel}>
              Cancel
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const NoCompoundsDetected = () => {
  return <span>ERROR: no chemicals have been detected.</span>;
};

interface CompoundRecordProps extends ComponentProps<typeof Box> {
  readonly compound: CompoundData;
  readonly canPrint: boolean;
}

const CompoundRecord = (props: CompoundRecordProps) => {
  const { data, act } = useBackend<TerminalProps>();
  const isMainTerminal = data.main_terminal === 1;
  const { compound } = props;
  const doc_ref = {
    print_type: compound.category,
    print_title: compound.id,
  };
  return (
    <TableRow key={compound.id}>
      <TableCell>
        <span className="compound_label">{compound.type.time}</span>
      </TableCell>

      <TableCell>
        <span className="compound_label">{compound.type.doctype}</span>
      </TableCell>

      <TableCell className="chemical-td">
        {compound.type.document.split(' ')[0] === 'Simulation' ? (
          <span className="compound_label">
            {compound.type.document.split(' ')[3]}
          </span>
        ) : (
          <span className="compound_label">
            {compound.type.document.split(' ')[2]}
          </span>
        )}
      </TableCell>

      <TableCell>
        <Flex
          className="compound_actions"
          justify="space-around"
          align-items="stretch"
          wrap={false}
        >
          <Flex.Item>
            <Button icon="book" onClick={() => act('read_document', doc_ref)}>
              Read
            </Button>
          </Flex.Item>
          {props.canPrint && (
            <Flex.Item>
              <Button
                disabled={data.photocopier_error || data.printer_toner === 0}
                icon="print"
                onClick={() => act('print', doc_ref)}
              >
                Print
              </Button>
            </Flex.Item>
          )}
          {isMainTerminal && !compound.isPublished && (
            <Flex.Item>
              <Button
                icon="upload"
                onClick={() => act('publish_document', doc_ref)}
              >
                Publish
              </Button>
            </Flex.Item>
          )}
          {isMainTerminal && compound.isPublished && (
            <Flex.Item>
              <Button
                icon="remove"
                onClick={() => act('unpublish_document', doc_ref)}
              >
                Unpublish
              </Button>
            </Flex.Item>
          )}
        </Flex>
      </TableCell>
    </TableRow>
  );
};

interface DocInfo {
  time: string;
  document: string;
  doctype: string;
}

interface CompoundData {
  id: string;
  category: string;
  docNumber: number;
  type: DocInfo;
  isPublished: boolean;
}

const ResearchReportTable = (props: {
  readonly hideOld: boolean;
  readonly setHideOld: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  const { data } = useBackend<TerminalProps>();
  const { hideOld, setHideOld } = props;
  const documents = Object.keys(data.research_documents)
    .map((x) => {
      const output = data.research_documents[x] as DocumentRecord[];
      output.forEach((y) => {
        y.category = x;
      });
      return output;
    })
    .flat() as DocumentRecord[];
  return (
    <Stack vertical>
      <Stack.Item>
        <Flex justify="space-between" fill={1}>
          <Flex.Item>
            {hideOld && (
              <Button onClick={() => setHideOld(false)}>
                Show All Reports
              </Button>
            )}
            {!hideOld && (
              <Button onClick={() => setHideOld(true)}>Hide Old Reports</Button>
            )}
          </Flex.Item>
        </Flex>
      </Stack.Item>
      <Divider />
      <Stack.Item>
        <CompoundTable
          hideOld={hideOld}
          docs={documents}
          timeLabel="Scan Time"
          canPrint
        />
      </Stack.Item>
    </Stack>
  );
};

export interface CompoundTableProps extends ComponentProps<typeof Box> {
  readonly docs: DocumentRecord[];
  readonly timeLabel: string;
  readonly canPrint: boolean;
  readonly hideOld?: boolean | true;
}

export const CompoundTable = (props: CompoundTableProps) => {
  const { data } = useBackend<TerminalProps>();
  const published = Object.keys(data.published_documents)
    .map((x) => {
      const output = data.published_documents[x] as DocumentRecord[];
      output.forEach((y) => {
        y.category = x;
      });
      return output;
    })
    .flat() as DocumentRecord[];
  const [sortby, setSortBy] = useState('time');
  const [sortdir, setSortdir] = useState('asc');
  const { docs, hideOld } = props;

  const outputDocs: Map<String, CompoundData> = new Map();
  docs
    .map<CompoundData>((x) => {
      const document_prefix = x.document_title.split(' ')[0];
      const doc_number = Number.parseInt(document_prefix, 10);
      const doctype: DocInfo = {
        doctype: Number.isNaN(doc_number) ? 'Synthesis' : 'Analysis',
        document: x.document,
        time: x.time,
      };
      const isPublished = (chemName: string) =>
        published.filter((x) => x.document_title.includes(chemName)).length > 0;

      return {
        id: x.document_title,
        category: x.category,
        docNumber: Number.isNaN(doc_number) ? 0 : doc_number,
        type: doctype,
        isPublished: isPublished(doctype.document),
      };
    })
    .forEach((x) => {
      if (hideOld) {
        if (!outputDocs.has(x.type.document)) {
          outputDocs.set(x.type.document, x);
          return;
        }

        if (
          x.type.time.localeCompare(
            outputDocs.get(x.type.document)?.type.time ?? '',
          )
        ) {
          outputDocs.set(x.type.document, x);
        }
      } else {
        outputDocs.set(x.id + x.type.time, x);
      }
    });

  if (outputDocs.size === 0) {
    return <NoCompoundsDetected />;
  }

  const iconRef = (name: string, isNum: boolean) =>
    sortby === name
      ? sortdir === 'asc'
        ? isNum
          ? 'arrow-down-1-9'
          : 'arrow-down-a-z' // small to big
        : isNum
          ? 'arrow-down-9-1'
          : 'arrow-down-z-a' // big to small
      : 'space';

  const sortColClick = (name: string) => {
    if (sortby === name) {
      setSortdir(sortdir === 'asc' ? 'desc' : 'asc');
    } else {
      setSortBy(name);
    }
  };

  return (
    <Table className={props.className}>
      <TableRow>
        <TableCell textAlign="center">
          <Button
            icon={iconRef('time', true)}
            onClick={() => sortColClick('time')}
          >
            {props.timeLabel}
          </Button>
        </TableCell>
        <TableCell textAlign="center">
          <span>Type</span>
        </TableCell>
        <TableCell textAlign="center">
          <Button
            icon={iconRef('name', false)}
            onClick={() => sortColClick('name')}
          >
            Compound
          </Button>
        </TableCell>
        <TableCell textAlign="center">
          <span>Actions</span>
        </TableCell>
      </TableRow>
      {Array.from(outputDocs.values())
        .sort((a, b) => {
          if (sortby === 'time') {
            if (sortdir === 'asc') {
              return a.type.time < b.type.time ? -1 : 1;
            } else {
              return a.type.time > b.type.time ? -1 : 1;
            }
          } else {
            if (sortdir === 'asc') {
              return a.type.document.localeCompare(b.type.document);
            } else {
              return b.type.document.localeCompare(a.type.document);
            }
          }
        })
        .map((x, i) => (
          <CompoundRecord compound={x} key={i} canPrint={props.canPrint} />
        ))}
    </Table>
  );
};

const PhotocopierMissing = () => {
  return <span>ERROR: no linked printer found.</span>;
};

const TonerEmpty = () => {
  return <span>ERROR: Printer toner is empty.</span>;
};

const ImproveClearanceConfirmation = (props: {
  readonly isConfirm: string | undefined;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
}) => {
  const { data, act } = useBackend<TerminalProps>();
  const { isConfirm, setConfirm } = props;
  if (isConfirm === undefined || isConfirm !== 'broker_clearance') {
    return null;
  }
  return (
    <Stack vertical>
      <Stack.Item>
        <ConfirmationDialogue
          onConfirm={() => {
            act('broker_clearance');
            setConfirm(undefined);
          }}
          onCancel={() => setConfirm(undefined)}
        >
          <span>
            Are you sure you want to spend <u>{data.broker_cost}</u> research
            credits to increase the clearance immediately?
          </span>
        </ConfirmationDialogue>
      </Stack.Item>
    </Stack>
  );
};

const XClearanceConfirmation = (props: {
  readonly isConfirm: string | undefined;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
}) => {
  const { data, act } = useBackend<TerminalProps>();
  const { isConfirm, setConfirm } = props;
  if (isConfirm === undefined || isConfirm !== 'request_clearance_x_access') {
    return null;
  }
  return (
    <Stack vertical>
      <Stack.Item>
        <ConfirmationDialogue
          onConfirm={() => {
            act('request_clearance_x_access');
            setConfirm(undefined);
          }}
          onCancel={() => setConfirm(undefined)}
        >
          <span>
            Are you sure you wish request clearance level <u>X</u> access for{' '}
            <u>5</u> credits?
          </span>
        </ConfirmationDialogue>
      </Stack.Item>
    </Stack>
  );
};

const ResearchManager = (props: {
  readonly isConfirm: string | undefined;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
}) => {
  const { data } = useBackend<TerminalProps>();
  const { isConfirm, setConfirm } = props;
  return (
    <Box>
      <Stack vertical>
        <Stack.Item>
          <span>Credits available: {data.rsc_credits}</span>
        </Stack.Item>
      </Stack>
      <hr />
      <ImproveClearanceConfirmation
        isConfirm={isConfirm}
        setConfirm={setConfirm}
      />
      <XClearanceConfirmation isConfirm={isConfirm} setConfirm={setConfirm} />
      <Contracts />
    </Box>
  );
};

const ErrorStack = () => {
  const { data } = useBackend<TerminalProps>();
  return (
    <Stack>
      {data.photocopier_error === 1 && (
        <Stack.Item>
          <PhotocopierMissing />
        </Stack.Item>
      )}
      {data.printer_toner === 0 && (
        <Stack.Item>
          <TonerEmpty />
        </Stack.Item>
      )}
    </Stack>
  );
};

const Contracts = () => {
  const { data, act } = useBackend<TerminalProps>();
  const timeLeft = data.next_reroll - data.world_time;
  const timeLeftPct = timeLeft / data.contract_cooldown;
  const contractKeys =
    data.contract_chems.length === 0
      ? []
      : Array.from(Array(data.contract_chems.length).keys());
  return (
    <Box px={'7px'}>
      <Section title={'Chemical Contracts'} mt={'5px'}>
        <ProgressBar
          width="100%"
          value={timeLeftPct}
          ranges={{
            average: [-Infinity, Infinity],
          }}
        >
          <Box textAlign="center">
            Contracts Refresh in: {Math.ceil(timeLeft / 10)}
          </Box>
        </ProgressBar>
      </Section>
      {contractKeys.map((value, key) => (
        <Flex grow direction="row" key={key}>
          <Flex.Item grow={1}>
            <Section title={<span>{data.contract_chems[key].name}</span>} fill>
              <span>
                Difficulty:{' '}
                {data.contract_chems[key].gen_tier === 1
                  ? 'Easy'
                  : data.contract_chems[key].gen_tier === 2
                    ? 'Intermediate'
                    : 'Hard'}
              </span>
              <Flex.Item>
                Early assesment shows one part of the recipe is{' '}
                {data.contract_chems[key].recipe_hint}
              </Flex.Item>
              <Flex.Item>
                Early testing shows property of{' '}
                {data.contract_chems[key].property_hint}
              </Flex.Item>
              <Button
                my={1}
                fluid
                icon="print"
                disabled={data.is_contract_picked}
                tooltip={
                  'Taking this contract will put a 5 minute cooldown on new chemical. You can only pick one.'
                }
                tooltipPosition="top"
                onClick={() =>
                  act('take_contract', { id: data.contract_chems[key].id })
                }
              >
                {data.is_contract_picked ? 'UNAVAILABLE' : 'Take Contract'}
              </Button>
            </Section>
          </Flex.Item>
        </Flex>
      ))}
    </Box>
  );
};

const PublishedMaterial = (props: { readonly hideOld: boolean }) => {
  const { data } = useBackend<TerminalProps>();
  const { hideOld } = props;
  const documents = Object.keys(data.published_documents)
    .map((x) => {
      const output = data.published_documents[x] as DocumentRecord[];
      output.forEach((y) => {
        y.category = x;
      });
      return output;
    })
    .flat() as DocumentRecord[];

  return (
    <Stack vertical>
      <Stack.Item>
        <CompoundTable
          hideOld={hideOld}
          docs={documents}
          timeLabel="Published"
          canPrint
        />
      </Stack.Item>
    </Stack>
  );
};

const ResearchOverview = (props: {
  readonly isConfirm: string | undefined;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
  readonly selectedTab: number;
  readonly setSelectedTab: React.Dispatch<React.SetStateAction<number>>;
}) => {
  const { isConfirm, setConfirm, selectedTab, setSelectedTab } = props;
  const [hideOld, setHideOld] = useState(true);

  return (
    <div className="TabWrapper">
      <Tabs fluid>
        <Tabs.Tab
          selected={selectedTab === 1}
          onClick={() => {
            setSelectedTab(1);
            setConfirm(undefined);
          }}
          icon="gear"
          color="black"
        >
          Manage Research
        </Tabs.Tab>
        <Tabs.Tab
          selected={selectedTab === 2}
          onClick={() => {
            setSelectedTab(2);
            setConfirm(undefined);
          }}
          icon="flask"
          color="black"
        >
          View Chemicals
        </Tabs.Tab>
        <Tabs.Tab
          selected={selectedTab === 3}
          onClick={() => {
            setSelectedTab(3);
            setConfirm(undefined);
          }}
          icon="book"
          color="black"
        >
          Published Material
        </Tabs.Tab>
      </Tabs>
      <div className="TabbedContent">
        <Stack vertical>
          <Stack.Item>
            <ErrorStack />
          </Stack.Item>
          <Stack.Item>
            {selectedTab === 1 && (
              <ResearchManager isConfirm={isConfirm} setConfirm={setConfirm} />
            )}
            {selectedTab === 2 && (
              <ResearchReportTable hideOld={hideOld} setHideOld={setHideOld} />
            )}
            {selectedTab === 3 && <PublishedMaterial hideOld={hideOld} />}
          </Stack.Item>
        </Stack>
      </div>
    </div>
  );
};

const ClearanceImproveButton = (props: {
  readonly setSelectedTab: React.Dispatch<React.SetStateAction<number>>;
  readonly setConfirm: React.Dispatch<React.SetStateAction<string | undefined>>;
}) => {
  const { data, act } = useBackend<TerminalProps>();
  const { setSelectedTab, setConfirm } = props;
  const clearance_level = data.clearance_level;
  const x_access = data.clearance_x_access;
  const isDisabled = data.rsc_credits < data.broker_cost;
  return (
    <>
      <Button
        onClick={() => {
          act('reprint_last_contract');
        }}
        tooltip={'Reprint Last picked contract in the case you lost it.'}
      >
        Reprint Last Contract
      </Button>
      {clearance_level < 5 && (
        <Button
          disabled={isDisabled}
          onClick={() => {
            setSelectedTab(1);
            setConfirm('broker_clearance');
          }}
        >
          Improve {data.broker_cost}CR
        </Button>
      )}
      {clearance_level === 5 && x_access === 0 && (
        <Button
          disabled={data.rsc_credits < 5}
          onClick={() => {
            setSelectedTab(1);
            setConfirm('request_clearance_x_access');
          }}
        >
          Request X (5)
        </Button>
      )}
      {x_access !== 0 && <Button disabled>Maximum clearance reached</Button>}
    </>
  );
};

export const ResearchTerminal = () => {
  const { data, act } = useBackend<TerminalProps>();
  const [selectedTab, setSelectedTab] = useState(1);
  const [isConfirm, setConfirm] = useState<string | undefined>(undefined);
  return (
    <Window width={480 * 2} height={320 * 2} theme="crtyellow">
      <Window.Content className="ResearchTerminal">
        <Section
          fill
          scrollable
          title={`Clearance Level ${data.clearance_level}`}
          buttons={
            <ClearanceImproveButton
              setSelectedTab={setSelectedTab}
              setConfirm={setConfirm}
            />
          }
        >
          <ResearchOverview
            isConfirm={isConfirm}
            setConfirm={setConfirm}
            selectedTab={selectedTab}
            setSelectedTab={setSelectedTab}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
