import { useState } from 'react';

import { BooleanLike, classes } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Divider, Section, Stack, Tooltip } from '../components';
import { Window } from '../layouts';

type Item = {
  name: string;
  description: string;
  cost: number;
  unique: BooleanLike;
  path: string;
  components: string[];
  sell_value: number;
};

type BackendContext = {
  items_t1: Item[];
  items_t2: Item[];
  items_t3: Item[];
  owned_items: string[];
  gold: number;
  at_item_capacity: BooleanLike;
  price_overrides: { [type: string]: number };
  gold_name_short: string;
};

export const ItemStoreEntry = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const setItem = props.setItem;
  const item: Item = props.item;
  if (!item.name) {
    return;
  }
  return (
    <Tooltip
      innerhtml={
        item.path in data.price_overrides
          ? `<h2>${item.name}</h2><br>Cost: ${data.price_overrides[item.path]} ${data.gold_name_short}` +
            item.description
          : `<h2>${item.name}</h2><br>Cost: ${item.cost} ${data.gold_name_short}` +
            item.description
      }
    >
      <Button
        onClick={() => setItem(item)}
        textAlign={'center'}
        style={{ paddingTop: '6px' }}
      >
        <span className={classes(['mobaitems45x45', `${item.icon_state}`])} />
        <br />

        {data.owned_items.indexOf(item.name) !== -1 && item.unique
          ? '----'
          : item.path in data.price_overrides
            ? data.price_overrides[item.path]
            : item.cost}
      </Button>
    </Tooltip>
  );
};

export const MobaItemStore = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const { items_t1, items_t2, items_t3, owned_items } = data;
  const [chosenItem, setItem] = useState<Item | null>(null);
  return (
    <Window title="Mutation Store" width={850} height={450} theme="xeno">
      <Window.Content>
        <Stack fill vertical>
          <Stack fill>
            <Stack.Item grow mr={1}>
              <Section fill height="100%">
                {items_t1.map((item) => (
                  <ItemStoreEntry
                    setItem={setItem}
                    key={item.path}
                    item={item}
                  />
                ))}
                <Divider />
                {items_t2.map((item) => (
                  <ItemStoreEntry
                    setItem={setItem}
                    key={item.path}
                    item={item}
                  />
                ))}
                <Divider />
                {items_t3.map((item) => (
                  <ItemStoreEntry
                    setItem={setItem}
                    key={item.path}
                    item={item}
                  />
                ))}
              </Section>
            </Stack.Item>
            <Divider vertical />
            <Stack.Item width="30%">
              <Section title="Selected Item">
                {chosenItem !== null ? (
                  <Stack vertical>
                    <Stack.Item>
                      <center>{chosenItem.name}</center>
                    </Stack.Item>
                    <Stack.Item>
                      <Box
                        dangerouslySetInnerHTML={{
                          __html:
                            chosenItem.path in data.price_overrides
                              ? `Cost: ${data.price_overrides[chosenItem.path]} ${data.gold_name_short}` +
                                chosenItem.description
                              : `Cost: ${chosenItem.cost} ${data.gold_name_short}` +
                                chosenItem.description,
                        }}
                      />
                      {chosenItem.components.length ? (
                        <Box>
                          <br />
                          Components:
                          <br />
                          {chosenItem.components.map((text: string, i) => (
                            <Box key={`${text}-${i}-${chosenItem.path}`}>
                              - {text}
                            </Box>
                          ))}
                        </Box>
                      ) : (
                        // eslint-disable-next-line react/jsx-no-useless-fragment
                        <></>
                      )}
                    </Stack.Item>
                    {owned_items.indexOf(chosenItem.name) !== -1 &&
                    chosenItem.unique ? (
                      <Stack.Item
                        style={{
                          color: '#5baa27',
                          paddingTop: '4px',
                          paddingBottom: '4px',
                          textAlign: 'center',
                        }}
                      >
                        Item Already Purchased.
                      </Stack.Item>
                    ) : (
                      <Stack.Item>
                        <Button
                          textAlign="center"
                          width="100%"
                          disabled={
                            data.at_item_capacity ||
                            data.gold <
                              (chosenItem.path in data.price_overrides
                                ? data.price_overrides[chosenItem.path]
                                : chosenItem.cost)
                          }
                          tooltip={
                            data.at_item_capacity
                              ? 'You have the maximum number of items allowed.'
                              : null
                          }
                          onClick={() =>
                            act('buy_item', {
                              path: chosenItem.path,
                            })
                          }
                        >
                          Purchase Item
                        </Button>
                      </Stack.Item>
                    )}
                    {owned_items.indexOf(chosenItem.name) !== -1 ? (
                      <Stack.Item>
                        <Button
                          textAlign="center"
                          width="100%"
                          tooltip={`+${chosenItem.sell_value}${data.gold_name_short}`}
                          onClick={() =>
                            act('sell_item', {
                              path: chosenItem.path,
                            })
                          }
                        >
                          Sell Item
                        </Button>
                      </Stack.Item>
                    ) : (
                      // eslint-disable-next-line react/jsx-no-useless-fragment
                      <></>
                    )}
                  </Stack>
                ) : (
                  <div />
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack>
      </Window.Content>
    </Window>
  );
};
