import { useBackend, useLocalState } from '../backend';
import { Button, Stack, Section, Flex, Tabs, Box } from '../components';
import { Window } from '../layouts';
import { logger } from '../logging';
import { Table, TableCell, TableRow } from '../components/Table';
import { classes } from '../../common/react';


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
  const clearance_level = data.clearance_level;
  const all_levels = ["1", "2", "3", "4", "5"];
  const costs = { "1": 7, "2": 9, "3": 11, "4": 13, "5": 15 };
  const available_levels = Array.from(Array(clearance_level).keys())
    .map(x => (x + 1).toString());
  return (
    <Section title="Purchase Reports">
      <Flex wrap justify="space-between">
        {all_levels.map(x => (
          <Flex.Item key={x} xs={3}>
            <Button
              className={classes(["DoButton", !available_levels.includes(x) && "HiddenButton"])}
              disabled={!available_levels.includes(x)}
              onClick={() => act("purchase_document", { purchase_tier: x })}
            >
              Level {x} ${costs[x]}
            </Button>
          </Flex.Item>))}
      </Flex>
    </Section>);
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

  logger.info(researchDocs);
  return (
    <Section>
      <Table>
        <TableRow>
          <TableCell textAlign="center">
            <span>Compound</span>
          </TableCell>
          <TableCell textAlign="center">
            <span>Actions</span>
          </TableCell>
        </TableRow>
        {researchDocs.map(x =>
          (
            <TableRow key={x.id}>
              <TableCell>{x.type}</TableCell>
              <TableCell>
                <Button onClick={() => act("read_document", { "print_type": 'XRF Scans', "print_title": x.id })}>
                  read
                </Button>
                <Button onClick={() => act("print", { "print_type": 'XRF Scans', "print_title": x.id })}>
                  print
                </Button>
                {isMainTerminal
                  && (
                    <Button onClick={() => act("publish_document", { "print_type": x.id, "print_title": x.type })}>
                      publish
                    </Button>)}
                {isMainTerminal && x.isPublished
                  && (
                    <Button onClick={() => act("unpublish_document", { "print_type": x.id, "print_title": x.type })}>
                      unpublish
                    </Button>)}
              </TableCell>
            </TableRow>
          )
        )}
      </Table>
    </Section>);
};

const ResearchManager = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
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
        <hr className="sep" />
        <Stack.Item>
          <Flex justify="space-between" align="center">
            {x_access === 0
              && (
                <Flex.Item>
                  <span>Upgrade Clearance</span>
                </Flex.Item>)}
            {x_access !== 0
              && (
                <Flex.Item>
                  <span>Maximum clearance reached</span>
                </Flex.Item>)}
            {clearance_level < 5
              && (
                <Flex.Item>
                  <Button
                    className="DoButton"
                    disabled={clearance_level === 5}
                    onClick={() => act("broker_clearance")}
                  >
                    Improve ({data.broker_cost})
                  </Button>
                </Flex.Item>)}
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
          </Flex>
        </Stack.Item>
      </Stack>
      <hr className="sep" />
      <PurchaseDocs />
      <hr className="sep" />
    </Box>
  );
};

const ResearchOverview = (_, context) => {
  const [selectedTab, setSelectedTab] = useLocalState(context, 'research_tab', 1);
  return (
    <>
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
      {selectedTab === 1 && <ResearchManager />}
      {selectedTab === 2 && <CompoundTable />}
    </>
  );
};

export const ResearchTerminal = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  const [sharpen, setSharpen] = useLocalState(context, 'sharpen', 0);
  logger.info(data);
  return (
    <Window
      theme="crt"
      height={400}
      width={400}
    >
      <Window.Content scrollable className={classes([!sharpen && 'crt'])}>
        <Section title={`Clearance Level ${data.clearance_level}`} className="container">
          <ResearchOverview />
        </Section>
        <Section>
          <Button className="DoButton" onClick={() => setSharpen(sharpen === 0 ? 1 : 0)}>
            Toggle Sharpen
          </Button>
        </Section>
      </Window.Content>
    </Window>);
};
