import { useBackend, useLocalState } from '../backend';
import {
  Tabs,
  Section,
  Box,
  Flex,
  Input,
  Slider,
  LabeledList,
} from '../components';
import { Window } from '../layouts';

export const STUI = (props, context) => {
  const { act, data } = useBackend(context);
  const tabs = data.tabs || ['Attack'];
  const [selectedTab, setSelectedTab] = useLocalState(
    context,
    'progress',
    tabs[0]
  );
  const logs = data.logs[selectedTab].length ? data.logs[selectedTab] : [''];

  const [searchTerm, setSearchTerm] = useLocalState(context, 'searchTerm', '');

  const [logsfontnumber, setLogsFontSize] = useLocalState(
    context,
    'logsfontnumber',
    7
  );
  const logsfontsize = logsfontnumber + 'pt';

  const bigfontnumber = logsfontnumber + 5;
  const bigfontsize = bigfontnumber + 'pt';

  return (
    <Window width={900} height={700}>
      <Window.Content>
        <Flex height="100%" direction="column">
          <Flex.Item>
            <Section fitted>
              <STUItabs />
            </Section>
          </Flex.Item>
          <Box height="10px" />
          <Flex.Item>
            <LabeledList>
              <LabeledList.Item label="Search">
                <Input
                  value={searchTerm}
                  onInput={(_, value) => setSearchTerm(value)}
                  width="810px"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Font Size">
                <Slider
                  inline
                  maxValue={20}
                  minValue={4}
                  value={logsfontnumber}
                  onChange={(e, value) => setLogsFontSize(value)}
                  unit="pt"
                  step={0.5}
                  stepPixelSize={20}
                />
              </LabeledList.Item>
            </LabeledList>
          </Flex.Item>
          <Flex.Item mt={1} grow={1} basis={0}>
            <Section fill scrollable>
              {logs.map((log) => {
                if (!log.toLowerCase().match(searchTerm)) {
                  return;
                }
                return (
                  <Box fontSize={logsfontsize} key={log}>
                    {log}
                  </Box>
                );
              })}
              {(logs.length > 1 && (
                <Box align="center" fontSize={bigfontsize}>
                  --- End of Logs --
                </Box>
              )) || (
                <Box align="center" fontSize={bigfontsize}>
                  --- No Logs --
                </Box>
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
  const tabs = data.tabs || ['Attack'];
  const [selectedTab, setSelectedTab] = useLocalState(
    context,
    'progress',
    tabs[0]
  );
  return (
    <Tabs fluid textAlign="center">
      <Tabs.Tab
        color="green"
        icon="sync-alt"
        selected={1}
        onClick={() => act('update')}>
        Update
      </Tabs.Tab>
      {tabs.map((tab) => (
        <Tabs.Tab
          key={tab}
          selected={tab === selectedTab}
          onClick={() => setSelectedTab(tab)}>
          {tab}
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};
