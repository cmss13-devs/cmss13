import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, Input, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

export const PhoneMenu = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={500} height={400}>
      <Window.Content>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = (props) => {
  const { act, data } = useBackend();
  const { availability, last_caller } = data;
  const available_transmitters = Object.keys(data.available_transmitters);
  const transmitters = data.transmitters.filter((val1) =>
    available_transmitters.includes(val1.phone_id),
  );

  const categories = [];
  for (let i = 0; i < transmitters.length; i++) {
    let data = transmitters[i];
    if (categories.includes(data.phone_category)) continue;

    categories.push(data.phone_category);
  }

  const [currentSearch, setSearch] = useState('');
  const [selectedPhone, setSelectedPhone] = useState(null);
  const [currentCategory, setCategory] = useState(categories[0]);

  let dnd_tooltip = 'Do Not Disturb is DISABLED';
  let dnd_locked = 'No';
  let dnd_icon = 'volume-high';
  if (availability === 1) {
    dnd_tooltip = 'Do Not Disturb is ENABLED';
    dnd_icon = 'volume-xmark';
  } else if (availability >= 2) {
    dnd_tooltip = 'Do Not Disturb is ENABLED (LOCKED)';
    dnd_locked = 'Yes';
    dnd_icon = 'volume-xmark';
  } else if (availability < 0) {
    dnd_tooltip = 'Do Not Disturb is DISABLED (LOCKED)';
    dnd_locked = 'Yes';
  }

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs>
            {categories.map((val) => (
              <Tabs.Tab
                selected={val === currentCategory}
                onClick={() => setCategory(val)}
                key={val}
              >
                {val}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          <Input
            fluid
            value={currentSearch}
            placeholder="Search for a phone"
            onInput={(e, value) => setSearch(value.toLowerCase())}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable>
            <Tabs vertical>
              {transmitters.map((val) => {
                if (
                  val.phone_category !== currentCategory ||
                  !val.phone_id.toLowerCase().match(currentSearch)
                ) {
                  return;
                }
                return (
                  <Tabs.Tab
                    selected={selectedPhone === val.phone_id}
                    onClick={() => {
                      if (selectedPhone === val.phone_id) {
                        act('call_phone', { phone_id: selectedPhone });
                      } else {
                        setSelectedPhone(val.phone_id);
                      }
                    }}
                    key={val.phone_id}
                    color={val.phone_color}
                    onFocus={() =>
                      document.activeElement
                        ? document.activeElement.blur()
                        : false
                    }
                    icon={val.phone_icon}
                  >
                    {val.phone_id}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Section>
        </Stack.Item>
        {!!selectedPhone && (
          <Stack.Item>
            <Button
              color="good"
              fluid
              textAlign="center"
              onClick={() => act('call_phone', { phone_id: selectedPhone })}
            >
              Dial
            </Button>
          </Stack.Item>
        )}
        {!!last_caller && <Stack.Item>Last Caller: {last_caller}</Stack.Item>}
        <Stack.Item>
          <Button
            color="red"
            tooltip={dnd_tooltip}
            disabled={dnd_locked === 'Yes'}
            icon={dnd_icon}
            fluid
            textAlign="center"
            onClick={() => act('toggle_dnd')}
          >
            Do Not Disturb
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
