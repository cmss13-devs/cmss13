import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, DmIcon, Section, Stack } from '../components';
import { Window } from '../layouts';
import { Loader } from './common/Loader';

type LoadoutPickerData = {
  categories: {
    name: string;
    items: LoadoutItem[];
  }[];
  points: number;
  max_points: number;
  loadout: LoadoutItem[];
};

type LoadoutItem = {
  name: string;
  cost: number;
  icon: string;
  icon_state: string;
};

export const LoadoutPicker = () => {
  const { data } = useBackend<LoadoutPickerData>();

  const { categories, points, max_points, loadout } = data;

  const [selected, setSelected] = useState(categories[0]);

  return (
    <Window height={485} width={610} theme="crtblue">
      <Window.Content className="LoadoutPicker">
        <Stack fill>
          <Stack.Item>
            <Stack vertical fill>
              <Stack.Item>
                <Section scrollable height="220px">
                  <Stack vertical height="200px">
                    {categories.map((category) => (
                      <Stack.Item key={category.name}>
                        <Button fluid onClick={() => setSelected(category)}>
                          {category.name}
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section
                  title={`Loadout (${points}/${max_points} points)`}
                  height="100%"
                  scrollable
                >
                  <Stack wrap width="180px" height="165px">
                    {loadout.map((item) => (
                      <Stack.Item key={item.name} className="ItemPicker">
                        <ItemRender item={item} loadout />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section title={selected.name} fill width="100%" scrollable>
              <Stack wrap>
                {selected.items.map((item) => (
                  <Stack.Item key={item.name} className="ItemPicker">
                    <ItemRender item={item} />
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ItemRender = (props: {
  readonly item: LoadoutItem;
  readonly loadout?: boolean;
}) => {
  const { item, loadout } = props;

  const { icon, icon_state, name, cost } = item;

  const { data, act } = useBackend<LoadoutPickerData>();

  const { points, max_points } = data;

  const atLimit = points + cost >= max_points;

  return (
    <Stack>
      <Stack.Item>
        <Button
          tooltip={name}
          onClick={() => act(loadout ? 'remove' : 'add', { name: name })}
          disabled={!loadout && atLimit}
        >
          <DmIcon
            icon={icon}
            icon_state={icon_state}
            height="64px"
            width="64px"
            fallback={<Loader />}
          />
          <Box position="absolute" bottom="0px">
            {cost}
          </Box>
        </Button>
      </Stack.Item>
    </Stack>
  );
};
