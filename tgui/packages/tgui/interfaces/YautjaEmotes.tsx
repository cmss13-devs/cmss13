import { useState } from 'react';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Divider, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

type Emote = {
  id: string;
  text: string;
  category: string;
  path: string;
};

type BackendContext = {
  categories: string[];
  emotes: Emote[];
  on_cooldown: BooleanLike;
};

const EmoteTab = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const { categories, emotes, on_cooldown } = data;
  const [categoryIndex, setCategoryIndex] = useState('Fake Sound');
  const mapped_emote = emotes.filter(
    (emote) => emote && emote.category === categoryIndex,
  );
  return (
    <Stack fill vertical>
      <Stack.Item>
        <span
          style={{
            position: 'relative',
            top: '8px',
          }}
        >
          <Tabs>
            {categories.map((item, key) => (
              <Tabs.Tab
                key={item}
                selected={item === categoryIndex}
                onClick={() => {
                  setCategoryIndex(item);
                }}
              >
                {item}
              </Tabs.Tab>
            ))}
          </Tabs>
        </span>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical mt={-2}>
            <Divider />
            {mapped_emote.map((item) => (
              <Stack.Item key={item.id}>
                <Stack>
                  <span
                    style={{
                      verticalAlign: 'middle',
                    }}
                  />{' '}
                  <Stack.Item>
                    <Box
                      m={1}
                      height="20px"
                      width="32px"
                      style={{
                        verticalAlign: 'middle',
                      }}
                    />
                  </Stack.Item>
                  <Stack.Item mt={-0.5}>
                    <Button
                      tooltip={item.id}
                      disabled={on_cooldown}
                      onClick={() =>
                        act('emote', {
                          emotePath: item.path,
                        })
                      }
                    >
                      {item.text}
                    </Button>
                  </Stack.Item>
                </Stack>
                <Divider />
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const YautjaEmotes = (props) => {
  return (
    <Window
      width={750}
      height={600}
      theme="crtgreen"
      title="Yautja Audio Panel"
    >
      <Window.Content>
        <EmoteTab />
      </Window.Content>
    </Window>
  );
};
