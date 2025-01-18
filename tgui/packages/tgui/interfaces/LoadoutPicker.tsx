import { useEffect, useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, DmIcon, Section, Stack } from '../components';
import { Window } from '../layouts';
import { Loader } from './common/Loader';

type LoadoutPickerData = {
  fluff_categories: Category[];
  fluff_points: number;
  max_fluff_points: number;
  fluff_gear: LoadoutItem[];

  loadout_categories: Category[];
};

type Category = {
  name: string;
  items: LoadoutItem[];
};

type LoadoutItem = {
  name: string;
  type: string;
  fluff_cost: number;
  icon: string;
  icon_state: string;
};

export const LoadoutPicker = () => {
  const { data } = useBackend<LoadoutPickerData>();

  const { fluff_categories, loadout_categories } = data;

  const [selected, setSelected] = useState<Category | undefined>();

  return (
    <Window height={485} width={910} theme="crtblue">
      <Window.Content className="LoadoutPicker">
        <Stack fill>
          <Stack.Item>
            <Sidebar setSelected={setSelected} selected={selected!} />
          </Stack.Item>
          <Stack.Item grow>
            {selected && (
              <Section title={selected.name} fill width="100%" scrollable>
                <Stack wrap>
                  {selected.items.map((item) => (
                    <Stack.Item key={item.name} className="ItemPicker">
                      <ItemRender item={item} />
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Sidebar = (props: {
  readonly setSelected: (_) => void;
  readonly selected: Category;
}) => {
  const { data } = useBackend<LoadoutPickerData>();

  const {
    fluff_categories,
    loadout_categories,
    fluff_points,
    max_fluff_points,
    fluff_gear,
  } = data;

  const { selected, setSelected } = props;

  const [menu, setMenu] = useState<'fluff' | 'loadout'>('fluff');

  useEffect(() => {
    if (menu === 'fluff') {
      setSelected(fluff_categories[0]);
    } else {
      setSelected(loadout_categories[0]);
    }
  }, [fluff_categories, menu]);

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <Button icon={'shirt'}>Fluff</Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon={'person-rifle'}>Loadout</Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Section scrollable height="220px">
          <Stack vertical height="200px">
            {fluff_categories.map((category) => (
              <Stack.Item key={category.name}>
                <Button
                  fluid
                  selected={selected === category}
                  onClick={() => setSelected(category)}
                >
                  {category.name}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          title={`Loadout (${fluff_points}/${max_fluff_points} points)`}
          height="100%"
          scrollable
        >
          <Stack wrap width="180px" height="165px">
            {fluff_gear.map((item) => (
              <Stack.Item key={item.type} className="ItemPicker">
                <ItemRender item={item} loadout />
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const ItemRender = (props: {
  readonly item: LoadoutItem;
  readonly loadout?: boolean;
}) => {
  const { item, loadout } = props;

  const { icon, icon_state, name, fluff_cost, type } = item;

  const { data, act } = useBackend<LoadoutPickerData>();

  const { fluff_points: points, max_fluff_points: max_points } = data;

  const atLimit = points + fluff_cost > max_points;

  return (
    <Stack>
      <Stack.Item>
        <Button
          tooltip={name}
          onClick={() => act(loadout ? 'remove' : 'add', { type: type })}
          disabled={!loadout && atLimit}
          width="78px"
          height="74px"
          mb="3px"
          mt="3px"
        >
          <DmIcon
            icon={icon}
            icon_state={icon_state}
            height="64px"
            width="64px"
            mb={1}
            mt={1}
            fallback={<Loader />}
          />
          <Box position="absolute" bottom="0px">
            {fluff_cost}
          </Box>
        </Button>
      </Stack.Item>
    </Stack>
  );
};
