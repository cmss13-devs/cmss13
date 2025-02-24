import { useState } from 'react';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Divider, Section, Stack } from '../components';
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
};

export const MobaItemStore = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const { items, owned_items } = data;
  const [chosenItem, setItem] = useState<Item | null>(null);
  // const [categoryIndex, setCategoryIndex] = useState('Space Station 13');
  return (
    <Window title="Mutation Store" width={800} height={600} theme="xeno">
      <Window.Content>
        <Stack fill vertical>
          <Stack fill>
            <Stack.Item grow mr={1}>
              <Section fill height="100%">
                {items.map((item) => (
                  <Button
                    tooltip={item.description}
                    width="100%"
                    fontSize="15px"
                    textAlign="center"
                    key={item.path}
                    onClick={() => setItem(item)}
                  >
                    {item.name}
                  </Button>
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
                    <Stack.Item>{chosenItem.description}</Stack.Item>
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
