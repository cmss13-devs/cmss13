import { range } from 'common/collections';
import type { BooleanLike } from 'common/react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Image, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

const ROWS = 5;
const COLUMNS = 6;

const BUTTON_DIMENSIONS = '64px';

type GridSpotKey = string;

const getGridSpotKey = (spot: [number, number]): GridSpotKey => {
  return `${spot[0]}/${spot[1]}`;
};

const CornerText = (props: {
  readonly align: 'left' | 'right';
  readonly children: string;
}): JSX.Element => {
  const { align, children } = props;

  return (
    <Box
      className={
        align === 'left'
          ? 'StripMenu__cornertext_left'
          : 'StripMenu__cornertext_right'
      }
    >
      {children}
    </Box>
  );
};

type AlternateAction = {
  icon: string;
  text: string;
};

const ALTERNATE_ACTIONS: Record<string, AlternateAction> = {
  remove_splints: {
    icon: 'crutch',
    text: 'Remove splints',
  },

  remove_accessory: {
    icon: 'tshirt',
    text: 'Remove accessory',
  },

  retrieve_tag: {
    icon: 'tags',
    text: 'Retrieve info tag',
  },

  toggle_internals: {
    icon: 'mask-face',
    text: 'Toggle internals',
  },
};

type Slot = {
  displayName: string;
  gridSpot: GridSpotKey;
  image?: string;
  additionalComponent?: JSX.Element;
  hideEmpty?: boolean;
};

const SLOTS: Record<string, Slot> = {
  glasses: {
    displayName: 'glasses',
    gridSpot: getGridSpotKey([0, 1]),
    image: 'inventory-glasses.png',
  },

  head: {
    displayName: 'headwear',
    gridSpot: getGridSpotKey([0, 2]),
    image: 'inventory-head.png',
  },

  wear_mask: {
    displayName: 'mask',
    gridSpot: getGridSpotKey([1, 2]),
    image: 'inventory-mask.png',
  },

  wear_r_ear: {
    displayName: 'right earwear',
    gridSpot: getGridSpotKey([0, 3]),
    image: 'inventory-ears.png',
  },

  wear_l_ear: {
    displayName: 'left earwear',
    gridSpot: getGridSpotKey([1, 3]),
    image: 'inventory-ears.png',
  },

  handcuffs: {
    displayName: 'handcuffs',
    gridSpot: getGridSpotKey([1, 4]),
    hideEmpty: true,
  },

  legcuffs: {
    displayName: 'legcuffs',
    gridSpot: getGridSpotKey([1, 5]),
    hideEmpty: true,
  },

  w_uniform: {
    displayName: 'uniform',
    gridSpot: getGridSpotKey([2, 1]),
    image: 'inventory-uniform.png',
  },

  wear_suit: {
    displayName: 'suit',
    gridSpot: getGridSpotKey([2, 2]),
    image: 'inventory-suit.png',
  },

  gloves: {
    displayName: 'gloves',
    gridSpot: getGridSpotKey([2, 3]),
    image: 'inventory-gloves.png',
  },

  r_hand: {
    displayName: 'right hand',
    gridSpot: getGridSpotKey([2, 4]),
    image: 'inventory-hand_r.png',
    additionalComponent: <CornerText align="left">R</CornerText>,
  },

  l_hand: {
    displayName: 'left hand',
    gridSpot: getGridSpotKey([2, 5]),
    image: 'inventory-hand_l.png',
    additionalComponent: <CornerText align="right">L</CornerText>,
  },

  shoes: {
    displayName: 'shoes',
    gridSpot: getGridSpotKey([3, 2]),
    image: 'inventory-shoes.png',
  },

  j_store: {
    displayName: 'suit storage item',
    gridSpot: getGridSpotKey([4, 0]),
    image: 'inventory-suit_storage.png',
  },

  id: {
    displayName: 'ID',
    gridSpot: getGridSpotKey([4, 1]),
    image: 'inventory-id.png',
  },

  belt: {
    displayName: 'belt',
    gridSpot: getGridSpotKey([4, 2]),
    image: 'inventory-belt.png',
  },

  back: {
    displayName: 'backpack',
    gridSpot: getGridSpotKey([4, 3]),
    image: 'inventory-back.png',
  },

  l_store: {
    displayName: 'left pocket',
    gridSpot: getGridSpotKey([4, 4]),
    image: 'inventory-pocket.png',
  },

  r_store: {
    displayName: 'right pocket',
    gridSpot: getGridSpotKey([4, 5]),
    image: 'inventory-pocket.png',
  },
};

enum ObscuringLevel {
  Completely = 1,
  Hidden = 2,
}

type Interactable = {
  interacting: BooleanLike;
};

/**
 * Some possible options:
 *
 * null - No interactions, no item, but is an available slot
 * { interacting: 1 } - No item, but we're interacting with it
 * { icon: icon, name: name } - An item with no alternate actions
 *   that we're not interacting with.
 * { icon, name, interacting: 1 } - An item with no alternate actions
 *   that we're interacting with.
 */
type StripMenuItem =
  | null
  | Interactable
  | ((
      | {
          icon: string;
          name: string;
          alternate: string;
        }
      | {
          obscured: ObscuringLevel;
        }
      | {
          no_item_action: string;
        }
    ) &
      Partial<Interactable>);

type StripMenuData = {
  items: Record<keyof Slot, StripMenuItem>;
  name: string;
};

const StripContent = (props: { readonly item: StripMenuItem }) => {
  if (props.item && 'name' in props.item) {
    return (
      <Image
        fixBlur
        src={`data:image/jpeg;base64,${props.item.icon}`}
        width={BUTTON_DIMENSIONS}
        height={BUTTON_DIMENSIONS}
        className="StripMenu__contentbox"
      />
    );
  }
  if (props.item && 'obscured' in props.item) {
    return (
      <Icon
        name={
          props.item.obscured === ObscuringLevel.Completely
            ? 'ban'
            : 'eye-slash'
        }
        size={3}
        ml={0}
        mt={1.3}
        className="StripMenu__obscured"
      />
    );
  }
  return <> </>;
};

export const StripMenu = (props) => {
  const { act, data } = useBackend<StripMenuData>();

  const gridSpots = new Map<GridSpotKey, string>();
  for (const key of Object.keys(data.items)) {
    const item = data.items[key];
    if (item === null && SLOTS[key].hideEmpty) continue;
    gridSpots.set(SLOTS[key].gridSpot, key);
  }

  return (
    <Window title={`Stripping ${data.name}`} width={430} height={400}>
      <Window.Content>
        <Stack fill vertical>
          {range(0, ROWS).map((row) => (
            <Stack.Item key={row}>
              <Stack fill>
                {range(0, COLUMNS).map((column) => {
                  const key = getGridSpotKey([row, column]);
                  const keyAtSpot = gridSpots.get(key);

                  if (!keyAtSpot) {
                    return (
                      <Stack.Item
                        key={key}
                        width={BUTTON_DIMENSIONS}
                        height={BUTTON_DIMENSIONS}
                      />
                    );
                  }

                  const item = data.items[keyAtSpot];
                  const slot = SLOTS[keyAtSpot];

                  let alternateAction: AlternateAction | undefined;

                  let content;
                  let tooltip;

                  if (item === null) {
                    tooltip = slot.displayName;
                  } else if ('name' in item) {
                    alternateAction = ALTERNATE_ACTIONS[item.alternate];
                    tooltip = item.name;
                  } else if ('obscured' in item) {
                    tooltip = `obscured ${slot.displayName}`;
                  } else if ('no_item_action' in item) {
                    tooltip = slot.displayName;
                    alternateAction = ALTERNATE_ACTIONS[item.no_item_action];
                  }

                  return (
                    <Stack.Item
                      key={key}
                      style={{
                        width: BUTTON_DIMENSIONS,
                        height: BUTTON_DIMENSIONS,
                      }}
                    >
                      <Box className="StripMenu__itembox">
                        <Button
                          onClick={() => {
                            if (item === null || 'no_item_action' in item) {
                              act('equip', {
                                key: keyAtSpot,
                              });
                            } else {
                              act('strip', {
                                key: keyAtSpot,
                              });
                            }
                          }}
                          fluid
                          tooltip={tooltip}
                          className="StripMenu__itembutton"
                          style={{
                            background: item?.interacting
                              ? 'hsl(39, 73%, 30%)'
                              : undefined,
                          }}
                        >
                          {slot.image && (
                            <Image
                              src={resolveAsset(slot.image)}
                              fixBlur
                              className="StripMenu__itemslot"
                            />
                          )}
                          {item && <StripContent item={item} />}
                          {slot.additionalComponent}
                        </Button>

                        {alternateAction !== undefined && (
                          <Button
                            onClick={() => {
                              act('alt', {
                                key: keyAtSpot,
                              });
                            }}
                            tooltip={alternateAction.text}
                            className="StripMenu__alternativeaction"
                          >
                            <Icon name={alternateAction.icon} />
                          </Button>
                        )}
                      </Box>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};
