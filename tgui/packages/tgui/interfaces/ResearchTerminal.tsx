import { useBackend, useLocalState } from '../backend';
import { Button, Stack, Section, Flex, Tabs, Box } from '../components';
import { Window } from '../layouts';
import { logger } from '../logging';
import { Table, TableCell, TableRow } from '../components/Table';
import { classes } from '../../common/react';
import { BoxProps } from '../components/Box';


interface TerminalProps {
  "clearance_level": number;
  "research_documents": Map<string, {string: string}>;
  "published_documents": Map<string, Map<string, string>>;
  "rsc_credits": number;
  "broker_cost": number;
  "base_purchase_cost": number;
  "main_terminal": number;
  "terminal_view": number;
  "clearance_x_access": number;
  "photocopier_error": number;
  "printer_toner": number;
}

const PurchaseDocs = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  const [purchaseSelection, setPurchaseSelection] = useLocalState(context, 'purchase_confirm', '0');
  const clearance_level = data.clearance_level;
  const all_levels = ["1", "2", "3", "4", "5"];
  const costs = { "1": 7, "2": 9, "3": 11, "4": 13, "5": 15 };
  const available_levels = Array.from(Array(clearance_level).keys())
    .map(x => (x + 1).toString());

  return (
    <Stack vertical>
      <Stack.Item>
        <span>Purchase Reports</span>
      </Stack.Item>
      <hr />
      <Stack.Item>
        <Flex justify="space-between" fill className="purchase-flex">
          {all_levels.map(x => {
            const isDisabled = (!available_levels.includes(x)) || costs[x] > data.rsc_credits;
            return (
              <Flex.Item key={x}>
                <Button
                  className={classes([
                    !available_levels.includes(x) && "HiddenButton",
                    isDisabled && "Button-disabled",
                  ])}
                  disabled={isDisabled}
                  onClick={() => setPurchaseSelection(x)}
                >
                  Level {x} {costs[x]}CR
                </Button>
              </Flex.Item>); })}
        </Flex>
        <hr />

        {purchaseSelection !== '0'
          && (
            <ConfirmationDialogue
              className="Confirm-Dialogue"
              onConfirm={() => {
                act("purchase_document", { purchase_document: purchaseSelection });
                setPurchaseSelection('0');
              }}
              onCancel={() => setPurchaseSelection('0')}
            >
              <span>
                Are you sure you want to purchase a
                level <u>{purchaseSelection}</u> document?
                <br />
                It will cost <u>{costs[purchaseSelection]}</u> credits.
              </span>
            </ConfirmationDialogue>)}
      </Stack.Item>
    </Stack>);
};

interface ConfirmationProps extends BoxProps {
  onConfirm: () => any;
  onCancel: () => any;
}

const ConfirmationDialogue = (props: ConfirmationProps, context) => {
  return (
    <Stack vertical className={props.className}>
      <Stack.Item>
        {props.children}
      </Stack.Item>
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Button className="Button ConfirmButton" icon="check" onClick={props.onConfirm}>
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
    </Stack>);
};

const NoCompoundsDetected = (_, context) => {
  return (
    <span>
      Error: no chemicals have been detected.
    </span>);
};

const CompoundTable = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  const isMainTerminal = data.main_terminal === 1;
  const hasScans = (docs) => Object.keys(docs).includes('XRF Scans');

  const published = !hasScans(data.published_documents)
    ? []
    : Array.from(Object.keys(data.published_documents['XRF Scans']));

  const documents = !hasScans(data.research_documents)
    ? []
    : Array.from(Object.keys(data.research_documents['XRF Scans']));

  const researchDocs = documents.map(x => {
    return { id: x, type: data.research_documents['XRF Scans'][x], isPublished: published.includes(x) };
  });

  if(researchDocs.length === 0) {
    return <NoCompoundsDetected />;
  }

  return (
    <div className="chem-table-wrapper">
      <Table>
        <TableRow>
          <TableCell textAlign="center">
            <span className="table_header">Compound</span>
          </TableCell>
          <TableCell textAlign="center">
            <span className="table_header">Actions</span>
          </TableCell>
        </TableRow>
        {researchDocs.map(x =>
          (
            <TableRow key={x.id}>
              <TableCell className="chemical-td">
                <span className="compound_label">
                  {x.type}
                </span>
              </TableCell>
              <TableCell>
                <Flex className="compound_actions" justify="space-around" align-items="stretch" wrap={false}>
                  <Flex.Item>
                    <Button icon="book" onClick={() => act("read_document", { "print_type": 'XRF Scans', "print_title": x.id })}>
                      Read
                    </Button>
                  </Flex.Item>
                  <Flex.Item>
                    <Button
                      className={classes([data.photocopier_error && "Button-disabled"])}
                      disabled={data.photocopier_error}
                      icon="print"
                      onClick={() => act("print", { "print_type": 'XRF Scans', "print_title": x.id })}
                    >
                      Print
                    </Button>
                  </Flex.Item>
                  {isMainTerminal && !x.isPublished
                  && (
                    <Flex.Item>
                      <Button icon="upload" onClick={() => act("publish_document", { "print_type": 'XRF Scans', "print_title": x.id })}>
                        Publish
                      </Button>
                    </Flex.Item>)}
                  {isMainTerminal && x.isPublished
                  && (
                    <Flex.Item>
                      <Button icon="remove" onClick={() => act("unpublish_document", { "print_type": 'XRF Scans', "print_title": x.id })}>
                        Unpublish
                      </Button>
                    </Flex.Item>)}
                </Flex>
              </TableCell>
            </TableRow>
          )
        )}
      </Table>
    </div>);
};

const PhotocopierMissing = () => {
  return (<span>
    ERROR: no linked printer found.
          </span>);
};

const TonerEmpty = () => {
  return (<span>
    ERROR: Printer toner is empty.
          </span>);
};

const ImproveClearanceConfirmation = (props, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  const [isConfirm, setConfirm] = useLocalState<string|undefined>(context, 'purchase_confirmation', undefined);
  if (isConfirm === undefined || isConfirm !== "broker_clearance") {
    return null;
  }
  return (
    <Stack vertical>
        <Stack.Item>
          <ConfirmationDialogue
            className="Confirm-Dialogue"
            onConfirm={() => {
              act("broker_clearance");
              setConfirm(undefined);
            }}
            onCancel={() => setConfirm(undefined)}
          >
            <span className="Tab__text">
              The CL can swipe their ID card on the console to increase clearance for
              free, given enough DEFCON. Are you sure you want to spend <u>{data.broker_cost}</u> research
              credits to increase the clearance immediately?
            </span>
          </ConfirmationDialogue>
        </Stack.Item>
    </Stack>);
};

const XClearanceConfirmation = (props, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  const [isConfirm, setConfirm] = useLocalState<string|undefined>(context, 'purchase_confirmation', undefined);
  if (isConfirm === undefined || isConfirm !== 'request_clearance_x_access') {
    return null;
  }
  return (
    <Stack vertical>
        <Stack.Item>
          <ConfirmationDialogue
            className="Confirm-Dialogue"
            onConfirm={() => {
              act("request_clearance_x_access");
              setConfirm(undefined);
            }}
            onCancel={() => setConfirm(undefined)}
          >
            <span className="Tab__text">
              Are you sure you wish request clearance level <u>X</u> access for <u>5</u> credits?
            </span>
          </ConfirmationDialogue>
        </Stack.Item>
    </Stack>);
};

const ResearchManager = (_, context) => {
  const { data } = useBackend<TerminalProps>(context);
  const clearance_level = data.clearance_level;
  const x_access = data.clearance_x_access;
  return (
    <Box>
      <Stack vertical>
        <Stack.Item>
          <span>
            Credits available: {data.rsc_credits}
          </span>
        </Stack.Item>
      </Stack>
      <hr />
      <PurchaseDocs />
      <ImproveClearanceConfirmation />
      <XClearanceConfirmation />
    </Box>
  );
};

const ErrorStack = (_, context) => {
  const { data } = useBackend<TerminalProps>(context);
  return (<Stack>
    {data.photocopier_error === 1 && <PhotocopierMissing />}
    {data.printer_toner === 0 && <TonerEmpty />}
          </Stack>);
};

const ResearchOverview = (_, context) => {
  const [selectedTab, setSelectedTab] = useLocalState(context, 'research_tab', 1);
  return (
    <div className="TabWrapper">
      <Tabs fluid fill >
        <Tabs.Tab
          selected={selectedTab === 1}
          onClick={() => setSelectedTab(1)}
          icon="gear"
          color="black"
        >
          Manage Research
        </Tabs.Tab>
        <Tabs.Tab
          selected={selectedTab === 2}
          onClick={() => setSelectedTab(2)}
          icon="flask"
          color="black"
        >
          View Chemicals
        </Tabs.Tab>
      </Tabs>
      <div className="TabbedPage">
        <div className="TabbedContent">
          <br />
          <ErrorStack />
          {selectedTab === 1 && <ResearchManager />}
          {selectedTab === 2 && <CompoundTable />}
        </div>
      </div>
    </div>
  );
};

const ClearanceImproveButton = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  const [selectedTab, setSelectedTab] = useLocalState(context, 'research_tab', 1);
  const [confirm, setConfirm] = useLocalState<string|undefined>(context, 'purchase_confirmation', undefined);
  const clearance_level = data.clearance_level;
  const x_access = data.clearance_x_access;
  const isDisabled = data.rsc_credits < data.broker_cost;
  return (
    <>
      {clearance_level < 5
        && (
          <Button
            className={classes([isDisabled && "Button-disabled"])}
            disabled={isDisabled}
            onClick={() => {
              setSelectedTab(1);
              setConfirm("broker_clearance");
            }}
          >
            Improve {data.broker_cost}
          </Button>)}
      {(clearance_level === 5 && x_access === 0)
          && (
            <Flex.Item>
              <Button
                className={classes([data.rsc_credits < 5 && "Button-disabled"])}
                onClick={() => {
                  setSelectedTab(1);
                  setConfirm("request_clearance_x_access");
                }}
              >
                Request X (5)
              </Button>
            </Flex.Item>)}
      {x_access !== 0
        && (
          <Flex.Item>
            <Button
              disabled
              className={classes([isDisabled && "Button-disabled"])}
            >
              Maximum clearance reached
            </Button>
          </Flex.Item>)}
    </>
  );
};

export const ResearchTerminal = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  const [sharpen, setSharpen] = useLocalState(context, 'sharpen', 0);
  logger.info(data);
  const showSharpen = false;
  return (
    <Window
      width={480 * 2}
      height={320 * 2}
      theme="crtyellow"
    >
      <Window.Content scrollable>
        <Section
          title={`Clearance Level ${data.clearance_level}`}
          className="container"
          buttons={<ClearanceImproveButton />}
        >
          <ResearchOverview />
        </Section>
        {showSharpen
          && (
            <Section>
              <Button onClick={() => setSharpen(sharpen === 0 ? 1 : 0)}>
                Toggle Sharpen
              </Button>
            </Section>)}
      </Window.Content>
    </Window>);
};
