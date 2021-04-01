import { useBackend, useLocalState } from '../backend';
import { Stack, Section, Tabs, Input, Button } from '../components';
import { Window } from '../layouts';

export const PhoneMenu = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={500}
      height={400}
    >
      <Window.Content>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const available_transmitters = Object.keys(data.available_transmitters);
  const transmitters = data.transmitters.filter(val1 =>
    available_transmitters.includes(val1.phone_id));

  const [currentSearch, setSearch]
    = useLocalState(context, "current_search", "");

  const [selectedPhone, setSelectedPhone]
    = useLocalState(context, "selected_phone", null);

  const categories = [];
  for (let i = 0; i < transmitters.length; i++) {
    let data = transmitters[i];
    if (categories.includes(data.phone_category)) continue;

    categories.push(data.phone_category);
  }

  const [currentCategory, setCategory]
    = useLocalState(context, "current_category", categories[0]);

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Tabs>
            {categories.map(val => (
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
          <Section
            fill
            scrollable
            onComponentDidMount={node => node.focus()}
          >
            <Tabs vertical>
              {transmitters.map(val => {
                if (val.phone_category !== currentCategory
                  || !val.phone_id.toLowerCase().match(currentSearch)) {
                  return;
                }
                return (
                  <Tabs.Tab
                    selected={selectedPhone === val.phone_id}
                    onClick={() => {
                      if (selectedPhone === val.phone_id) {
                        act("call_phone", { phone_id: selectedPhone });
                      } else {
                        setSelectedPhone(val.phone_id);
                      }
                    }}
                    key={val.phone_id}
                    color={val.phone_color}
                    onFocus={() => document.activeElement
                      ? document.activeElement.blur() : false}
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
              content="Dial"
              color="good"
              fluid
              textAlign="center"
              onClick={() => act("call_phone", { phone_id: selectedPhone })}
            />
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};
