import React, { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Flex,
  Input,
  LabeledList,
  Section,
  Slider,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import { replaceRegexChars } from './helpers';

type STUIData = {
  tabs: Array<string>;
  logs: Map<string, Array<string>>;
};

export const STUI = () => {
  const { data } = useBackend<STUIData>();
  const [selectedTab, setSelectedTab] = useState('Attack');
  const [searchTerm, setSearchTerm] = useState('');
  const [logsfontnumber, setLogsFontSize] = useState(7);

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
              <STUItabs
                selectedTab={selectedTab}
                setSelectedTab={setSelectedTab}
              />
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
            <RenderLogs
              logs={logs}
              searchTerm={searchTerm}
              logsfontnumber={logsfontnumber}
            />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const RenderLogs = (props: {
  readonly logs: Array<string>;
  readonly searchTerm: string;
  readonly logsfontnumber: number;
}) => {
  const { logs, searchTerm, logsfontnumber } = props;
  const bigfontsize = logsfontnumber + 5 + 'pt';
  return (
    <Section fill scrollable>
      {logs
        .filter((x) =>
          x
            .toLowerCase()
            .match(
              searchTerm ? replaceRegexChars(searchTerm.toLowerCase()) : '',
            ),
        )
        .map((log, i) => (
          <RenderLog log={log} key={i} logsfontnumber={logsfontnumber} />
        ))}
      <Box align="center" fontSize={bigfontsize}>
        {logs.length > 1 ? '--- End of Logs --' : '--- No Logs --'}
      </Box>
    </Section>
  );
};

const RenderLog = (props: {
  readonly log: string;
  readonly logsfontnumber: number;
}) => {
  const { log, logsfontnumber } = props;
  const logsfontsize = logsfontnumber + 'pt';
  return (
    <Box fontSize={logsfontsize} key={log}>
      {log}
    </Box>
  );
};

const STUItabs = (props: {
  readonly selectedTab: string;
  readonly setSelectedTab: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { selectedTab, setSelectedTab } = props;
  const { act, data } = useBackend<STUIData>();
  const tabs = data.tabs ?? [''];
  return (
    <Tabs fluid textAlign="center">
      <Tabs.Tab
        color="green"
        icon="sync-alt"
        selected
        onClick={() => act('update')}
      >
        Update
      </Tabs.Tab>
      {tabs.map((tab) => (
        <Tabs.Tab
          key={tab}
          selected={tab === selectedTab}
          onClick={() => setSelectedTab(tab)}
        >
          {tab}
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};
