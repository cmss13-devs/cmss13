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
      <hr className="sep" />
      <Stack.Item>
        <Flex justify="space-between" fill className="purchase-flex">
          {all_levels.map(x => (
            <Flex.Item key={x}>
              <Button
                className={classes(["DoButton", !available_levels.includes(x) && "HiddenButton"])}
                disabled={!available_levels.includes(x)}
                onClick={() => setPurchaseSelection(x)}
              >
                Level {x} {costs[x]}CR
              </Button>
            </Flex.Item>))}
        </Flex>
        <hr className="sep" />

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
            <Button className="DoButton ConfirmButton" icon="check" onClick={props.onConfirm}>
              Confirm
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button className="DoButton" icon="cancel" onClick={props.onCancel}>
              Cancel
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>);
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

  return (
    <div className="chem-table-wrapper">
      <Table className="chem_table">
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
              <TableCell className="action-td">
                <Flex className="compound_actions" justify="space-around" align-items="stretch" wrap={false}>
                  <Flex.Item>
                    <Button className="DoButton" icon="book" onClick={() => act("read_document", { "print_type": 'XRF Scans', "print_title": x.id })}>
                      Read
                    </Button>
                  </Flex.Item>
                  <Flex.Item>
                    <Button className="DoButton" icon="print" onClick={() => act("print", { "print_type": 'XRF Scans', "print_title": x.id })}>
                      Print
                    </Button>
                  </Flex.Item>
                  {isMainTerminal && !x.isPublished
                  && (
                    <Flex.Item>
                      <Button className="DoButton" icon="upload" onClick={() => act("publish_document", { "print_type": 'XRF Scans', "print_title": x.id })}>
                        Publish
                      </Button>
                    </Flex.Item>)}
                  {isMainTerminal && x.isPublished
                  && (
                    <Flex.Item>
                      <Button className="DoButton" icon="remove" onClick={() => act("unpublish_document", { "print_type": 'XRF Scans', "print_title": x.id })}>
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
      <hr className="sep" />
      <PurchaseDocs />
    </Box>
  );
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
  const clearance_level = data.clearance_level;
  const x_access = data.clearance_x_access;
  return (
    <>
      {clearance_level < 5
        && (
          <Button
            className="DoButton"
            disabled={data.rsc_credits < data.broker_cost}
            onClick={() => act("broker_clearance")}
          >
            Improve ({data.broker_cost})
          </Button>)}
      {(clearance_level === 5 && x_access === 0)
          && (
            <Flex.Item>
              <Button
                className="DoButton"
                onClick={() => act("request_clearance_x_access")}
              >
                Request X (5)
              </Button>
            </Flex.Item>)}
      {x_access !== 0
        && (
          <Flex.Item>
            <span>Maximum clearance reached</span>
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
      width={480}
      height={320}
      theme="crt"
    >
      <Window.Content scrollable className={classes([!sharpen && 'crt'])}>
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
              <Button className="DoButton" onClick={() => setSharpen(sharpen === 0 ? 1 : 0)}>
                Toggle Sharpen
              </Button>
            </Section>)}
      </Window.Content>
    </Window>);
};
