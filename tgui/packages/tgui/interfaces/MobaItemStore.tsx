import { useState } from 'react';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Divider, Section, Stack, Tooltip } from '../components';
import { Window } from '../layouts';

type Item = {
  name: string;
  description: string;
  cost: number;
  unique: BooleanLike;
  path: string;
};

type BackendContext = {
  items: Item[];
  owned_items: string[];
  gold: number;
  at_item_capacity: BooleanLike;
};

export const MobaItemStore = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const { items, owned_items } = data;
  const [chosenItem, setItem] = useState<Item | null>(null);
  return (
    <Window title="Mutation Store" width={800} height={600} theme="xeno">
      <Window.Content>
        <Stack fill vertical>
          <Stack fill>
            <Stack.Item grow mr={1}>
              <Section fill height="100%">
                {items.map((item) => (
                  <Tooltip innerhtml={item.description} key={item.path}>
                    <Button
                      width="100%"
                      fontSize="15px"
                      textAlign="center"
                      onClick={() => setItem(item)}
                    >
                      {item.name}
                    </Button>
                  </Tooltip>
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
                          __html: chosenItem.description,
                        }}
                      />
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
                          disabled={data.at_item_capacity}
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
