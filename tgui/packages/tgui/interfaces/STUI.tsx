import { useEffect, useState } from 'react';
import { useBackend, useLocalState } from '../backend';
import { Tabs, Section, Box, Flex, Input, Slider, LabeledList } from '../components';
import { Window } from '../layouts';

type STUIData = {
  tabs: Array<string>;
  logs: Map<string, Array<string>>;
};

const useSearchTerm = () => {
  const [searchTerm, setSearchTerm] = useLocalState('searchTerm', '');
  return { searchTerm, setSearchTerm };
};

const useLogFont = () => {
  const [logsfontnumber, setLogsFontSize] = useLocalState('logsfontnumber', 7);
  return {
    logsfontnumber,
    setLogsFontSize,
  };
};

const useTabs = () => {
  const [selectedTab, setSelectedTab] = useLocalState('progress', 'Attack');
  return {
    selectedTab,
    setSelectedTab,
  };
};

export const STUI = () => {
  const { data } = useBackend<STUIData>();
  const { selectedTab } = useTabs();
  const { searchTerm, setSearchTerm } = useSearchTerm();
  const { logsfontnumber, setLogsFontSize } = useLogFont();

  const [logs, setLogs] = useState<Array<string>>([]);

  useEffect(() => {
    setLogs(data.logs[selectedTab].length ? data.logs[selectedTab] : []);
  }, [data.logs, selectedTab]);

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
            <RenderLogs logs={logs} />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const RenderLogs = (props: { readonly logs: Array<string> }) => {
  const { searchTerm } = useSearchTerm();
  const { logs } = props;
  const { logsfontnumber } = useLogFont();
  const bigfontsize = logsfontnumber + 5 + 'pt';
  return (
    <Section fill scrollable>
      {logs
        .filter((x) => x.toLowerCase().match(searchTerm) !== null)
        .map((log, i) => (
          <RenderLog log={log} key={i} />
        ))}
      <Box align="center" fontSize={bigfontsize}>
        {logs.length > 1 ? '--- End of Logs --' : '--- No Logs --'}
      </Box>
    </Section>
  );
};

const RenderLog = (props: { readonly log: string }) => {
  const { logsfontnumber } = useLogFont();
  const logsfontsize = logsfontnumber + 'pt';
  return (
    <Box fontSize={logsfontsize} key={props.log}>
      {props.log}
    </Box>
  );
};

const STUItabs = () => {
  const { act, data } = useBackend<STUIData>();
  const tabs = data.tabs ?? [''];
  const { selectedTab, setSelectedTab } = useTabs();
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
