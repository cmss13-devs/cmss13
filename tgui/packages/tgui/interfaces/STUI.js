import { useBackend, useLocalState } from '../backend';
import { Tabs, Section, Box, Flex } from '../components';
import { Window } from '../layouts';

export const STUI = (props, context) => {
  const { act, data } = useBackend(context);
  const tabs = data.tabs || ["Attack"];
  const [
    selectedTab,
    setSelectedTab,
  ] = useLocalState(context, 'progress', tabs[0]);
  const logs = data.logs[selectedTab].length ? data.logs[selectedTab] : ["No logs"];

  return (
    <Window
      width={700}
      height={500}>
      <Window.Content>
        <Flex height="100%" direction="column" >
          <Flex.Item>
            <Section fitted >
              <STUItabs />
            </Section>
          </Flex.Item>
          <Flex.Item mt={1} grow={1} basis={0}>
            <Section fill scrollable >
              {logs.map(log => (
                <Box key={log}>{log}</Box>
              ))}
              {logs.length > 1 && (
                <Box align="center">--- End of Logs --</Box>
              )}
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const STUItabs = (props, context) => {
  const { act, data } = useBackend(context);
  const tabs = data.tabs || ["Attack"];
  const [
    selectedTab,
    setSelectedTab,
  ] = useLocalState(context, 'progress', tabs[0]);
  return (
    <Tabs fluid textAlign="center">
      <Tabs.Tab
        color="green"
        icon="sync-alt"
        selected={1}
        onClick={() => act('update')} >
        Update
      </Tabs.Tab>
      {tabs.map(tab => (
        <Tabs.Tab
          key={tab}
          selected={tab === selectedTab}
          onClick={() => setSelectedTab(tab)} >
          {tab}
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};
