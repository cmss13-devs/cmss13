import { useBackend, useLocalState } from '../backend';
import { Tabs, Section, Box, Flex, Input } from '../components';
import { Window } from '../layouts';

export const STUI = (props, context) => {
  const { act, data } = useBackend(context);
  const tabs = data.tabs || ["Attack"];
  const [
    selectedTab,
    setSelectedTab,
  ] = useLocalState(context, 'progress', tabs[0]);
  const logs = data.logs[selectedTab].length ? data.logs[selectedTab] : ["No logs"];

  const [searchTerm, setSearchTerm] = useLocalState(context, 'searchTerm', "");

  return (
    <Window
      width={900}
      height={700}>
      <Window.Content>
        <Flex height="100%" direction="column" >
          <Flex.Item>
            <Section fitted >
              <STUItabs />
            </Section>
          </Flex.Item>
          <Flex.Item>
            <Box width="10px" />
            <Box>
              <Flex align="center" justify="space-between" align-items="stretch">
                <Flex.Item>
                  Search:
                </Flex.Item>
                <Flex.Item>
                  <Input
                    value={searchTerm}
                    onInput={(_, value) => setSearchTerm(value)}
                    width="840px"
                  />
                </Flex.Item>
              </Flex>
            </Box>
          </Flex.Item>
          <Flex.Item mt={1} grow={1} basis={0}>
            <Section fill scrollable >
              {logs.map(log => {
                if (!log.toLowerCase().match(searchTerm)) {
                  return;
                }
                return (
                  <Box key={log}>{log}</Box>
                );
              })}
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
