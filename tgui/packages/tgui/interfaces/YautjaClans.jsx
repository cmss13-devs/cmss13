import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section, Tabs } from '../components';
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
      <Tabs fluid textAlign="center">
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

      <Section>
        {clans[selectedClan].clan.map((yautja, i) => (
          <Section key={i} title={yautja.ckey}>
            <LabeledList>
              <LabeledList.Item label="Name">{yautja.name}</LabeledList.Item>
              <LabeledList.Item label="Rank">{yautja.rank}</LabeledList.Item>

              <LabeledList.Item label="Honor">
                {yautja.honor_amount}
              </LabeledList.Item>
            </LabeledList>
            <Button bold mt="1rem">
              Change Rank
            </Button>
          </Section>
        ))}
      </Section>
    </Section>
  );
};
