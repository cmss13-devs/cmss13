import { useBackend, useLocalState } from '../backend';
import { Button, Section, Flex, Box, Tooltip, Input, NoticeBox, Icon, Stack } from '../components';
import { Window } from '../layouts';
import { classes } from 'common/react';
import { logger } from '../logging';
import { Table, TableCell, TableRow } from '../components/Table';

interface TerminalProps {
  "clearance_level": number;
  "research_documents": ResearchDocs;
  "rsc_credits": number;
  "broker_cost": number;
  "base_purchase_cost": number;
  "main_terminal": number;
  "terminal_view": number;
  "clearance_x_access": number;
}

interface ResearchDocs {

}

const ClearanceController = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  return (<Box>
    <Stack>
      <Stack.Item>
        Clearance {data.clearance_level}
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act("broker_clearance")}>Purchase Clearance</Button>
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act("request_clearance_x_access")}>Purchase X</Button>
      </Stack.Item>
    </Stack>

  </Box>)
}

const PurchaseDocs = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  return (<Box>
    <Stack>
      <Stack.Item>
        <Button onClick={() => act("purchase_document", {purchase_tier: 1})}>1</Button>
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act("purchase_document", {purchase_tier: 2})}>2</Button>
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act("purchase_document", {purchase_tier: 3})}>3</Button>
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act("purchase_document", {purchase_tier: 4})}>4</Button>
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act("purchase_document", {purchase_tier: 5})}>5</Button>
      </Stack.Item>
    </Stack>

  </Box>)
}

const CompoundTable = (_, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  const keys = Object.keys(data.research_documents)[0]
  const scans = data.research_documents[keys]
  const formulas = Object.keys(scans)
  return (<Table>
    <TableRow>
      <TableCell>Compound</TableCell>
      <TableCell>Actions</TableCell>
    </TableRow>
    {formulas.map(x => (<TableRow>
        <TableCell>{scans[x]}</TableCell>
        <TableCell>
          <Button onClick={() => act("read_document", {"print_type": keys, "print_title": x})}>
            read
          </Button>
          <Button onClick={() => act("print", {"print_type": keys, "print_title": x})}>
            print
          </Button>
          <Button onClick={() => act("publish_document", {"print_type": keys, "print_title": x})}>
            publish
          </Button>
          <Button onClick={() => act("unpublish_document", {"print_type": keys, "print_title": x})}>
            unpublish
          </Button>
        </TableCell>
    </TableRow>))}
  </Table>)
}

export const ResearchTerminal = (props, context) => {
  const { data, act } = useBackend<TerminalProps>(context);
  logger.info(data)
  return (<Window
      height={800}
      width={400}
    >
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <ClearanceController/>
          </Stack.Item>
          <Stack.Item>
            <PurchaseDocs />
          </Stack.Item>
          <Stack.Item>
            <CompoundTable />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>)
}
