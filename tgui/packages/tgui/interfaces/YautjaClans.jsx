import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Tabs } from '../components';
import { Window } from '../layouts';

const PAGES = {
  view_clans: () => ViewClans,
};

export const YautjaClans = (props) => {
  const { data } = useBackend();
  const { current_menu } = data;
  const PageComponent = PAGES[current_menu]();

  return (
    <Window theme="crtgreen" width={780} height={725}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const ViewClans = (props) => {
  const { data, act } = useBackend();
  const { clans } = data;
  const [selectedClan, setSelectedClan] = useState(0);

  return (
    <Section>
      <Tabs textAlign="center" variant="scrollable" scrollButtons="auto">
        {clans.map((category, i) => (
          <Tabs.Tab
            key={i}
            selected={i === selectedClan}
            onClick={() => setSelectedClan(i)}
          >
            {category.label}
          </Tabs.Tab>
        ))}
      </Tabs>
      <Section color={clans[selectedClan].color}>
        <h1>{clans[selectedClan].label}</h1>
        <h3>Total Honor: {clans[selectedClan].honor}</h3>
        <Box mb=".75rem" italic>
          {clans[selectedClan].desc}
        </Box>
      </Section>
      {clans[selectedClan].members.map((yautja, i) => (
        <Section key={i} title={yautja.player_label}>
          <LabeledList>
            <LabeledList.Item label="Name">{yautja.name}</LabeledList.Item>
            <LabeledList.Item label="Rank">{yautja.rank}</LabeledList.Item>
            <LabeledList.Item label="Ancillary">None</LabeledList.Item>
          </LabeledList>
          <Button bold mt="1rem" width="23vw" disabled={1 || 2}>
            Change Clan
          </Button>
          <Button bold mt="1rem" width="23vw" disabled={1 || 2}>
            Change Rank
          </Button>
          <Button bold mt="1rem" width="23vw" disabled={1 || 2}>
            Assign Ancillary
          </Button>
          <Button bold mt="1rem" width="23vw" disabled={1 || 2}>
            Delete Player
          </Button>
        </Section>
      ))}
    </Section>
  );
};
