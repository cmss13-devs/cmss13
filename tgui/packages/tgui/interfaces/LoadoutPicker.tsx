import { useEffect, useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  DmIcon,
  Input,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';
import { Loader } from './common/Loader';

type LoadoutPickerData = {
  fluff_gear: LoadoutItem[];
  fluff_categories: Category[];
  fluff_points: number;
  max_fluff_points: number;

  loadout: LoadoutItem[];
  loadout_categories: Category[];
  loadout_points: number;
  selected_job: string;
  max_job_points: number;
  selected_loadout_slot: number;
  max_save_slots: number;

  loadout_slot_names: { [key: string]: string };
};

type Category = {
  name: string;
  items: LoadoutItem[];
};

type LoadoutItem = {
  name: string;
  type: string;
  fluff_cost: number;
  loadout_cost: number;

  icon: string;
  icon_state: string;
};

export const LoadoutPicker = () => {
  const { act, data } = useBackend<LoadoutPickerData>();

  const {
    fluff_categories,
    loadout_categories,
    selected_loadout_slot,
    max_save_slots,
    loadout_slot_names,
  } = data;

  const [selected, setSelected] = useState<Category | undefined>();

  const [menu, setMenu] = useState<'fluff' | 'loadout'>('fluff');

  const [renameSlot, setRenamingSlot] = useState<number | null>(null);

  useEffect(() => {
    if (menu === 'fluff') {
      setSelected(fluff_categories[0]);
    } else {
      setSelected(loadout_categories[0]);
    }
  }, [fluff_categories, menu]);

  return (
    <Window height={600} width={950} theme="crtblue">
      <Window.Content className="LoadoutPicker">
        <Stack fill>
          <Stack.Item>
            <Sidebar
              setSelected={setSelected}
              selected={selected!}
              setMenu={setMenu}
              menu={menu}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Stack vertical fill>
              {menu === 'loadout' && (
                <Stack.Item>
                  <Stack fill justify="space-evenly">
                    {Array.from({ length: max_save_slots }).map((_, val) => (
                      <Stack.Item grow key={val}>
                        {renameSlot === val ? (
                          <Input
                            placeholder="Slot name..."
                            onChange={(_, newName) => {
                              act('name_slot', {
                                name: newName,
                                slot: val + 1,
                              });
                              setRenamingSlot(null);
                            }}
                          />
                        ) : (
                          <Button
                            selected={selected_loadout_slot === val + 1}
                            onClick={() => act('slot', { picked: val + 1 })}
                            onContextMenu={(event) => {
                              event.preventDefault();
                              setRenamingSlot(val);
                            }}
                            tooltip="Right click to rename"
                            fluid
                          >
                            {loadout_slot_names &&
                            loadout_slot_names[(val + 1).toString()]
                              ? loadout_slot_names[(val + 1).toString()]
                              : `Slot ${val + 1}`}
                          </Button>
                        )}
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
              )}
              {selected && (
                <Stack.Item grow>
                  <Section title={selected.name} fill width="100%" scrollable>
                    <Stack wrap>
                      {selected.items.map((item) => (
                        <Stack.Item key={item.type} className="ItemPicker">
                          <ItemRender item={item} />
                        </Stack.Item>
                      ))}
                    </Stack>
                  </Section>
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Sidebar = (props: {
  readonly setSelected: (_) => void;
  readonly selected: Category;
  readonly setMenu: (_) => void;
  readonly menu: 'fluff' | 'loadout';
}) => {
  const { data } = useBackend<LoadoutPickerData>();

  const {
    fluff_categories,
    loadout_categories,
    fluff_points,
    max_fluff_points,
    loadout_points,
    max_job_points,
    fluff_gear,
    selected_job,
    loadout,
  } = data;

  const { setSelected, selected, setMenu, menu } = props;

  const toMap = menu === 'fluff' ? fluff_categories : loadout_categories;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Stack>
          {loadout_categories.length > 0 && (
            <Stack.Item grow>
              <Button
                fluid
                icon={'person-rifle'}
                onClick={() => setMenu('loadout')}
              >
                Loadout
              </Button>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Button fluid icon={'shirt'} onClick={() => setMenu('fluff')}>
              Fluff
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Section scrollable height="220px">
          <Stack vertical height="200px">
            {menu === 'loadout' && (
              <>
                <Stack.Item>
                  <Box>{selected_job}</Box>
                </Stack.Item>
                <Divider />
              </>
            )}
            {!toMap.length && (
              <Stack.Item>
                <Box>No loadout for this role.</Box>
              </Stack.Item>
            )}
            {toMap.map((category) => (
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
          title={
            menu === 'fluff'
              ? `Gear (${fluff_points}/${max_fluff_points} points)`
              : `Loadout (${loadout_points}/${max_job_points} points)`
          }
          height="100%"
          scrollable
        >
          <Stack wrap width="180px" height="240px">
            {(menu === 'fluff' ? fluff_gear : loadout).map((item, index) => (
              <Stack.Item key={`${index}${item.type}`} className="ItemPicker">
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

  const { icon, icon_state, name, fluff_cost, loadout_cost, type } = item;

  const { data, act } = useBackend<LoadoutPickerData>();

  const { fluff_points, max_fluff_points, loadout_points, max_job_points } =
    data;

  const atLimit = loadout_cost
    ? loadout_points + loadout_cost > max_job_points
    : fluff_points + fluff_cost > max_fluff_points;

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
            {fluff_cost ? fluff_cost : loadout_cost}
          </Box>
        </Button>
      </Stack.Item>
    </Stack>
  );
};
