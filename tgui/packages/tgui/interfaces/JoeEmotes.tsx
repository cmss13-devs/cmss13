import { useBackend, useLocalState } from '../backend';
import { Box, Button, Divider, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

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

export const JoeEmotes = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const { categories, emotes, on_cooldown } = data;
  const [categoryIndex, setCategoryIndex] = useLocalState(
    'category_index',
    'Farewell'
  );

  const mapped_emote = emotes.filter(
    (emote) => emote && emote.category === categoryIndex
  );

  return (
    <Window
      width={750}
      height={600}
      theme="crtblue"
      title="Working Joe Voice Synthesizer">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <span
              style={{
                'position': 'relative',
                'top': '8px',
              }}>
              <Tabs>
                {categories.map((item, index) => (
                  <Tabs.Tab
                    key={index}
                    selected={item === categoryIndex}
                    onClick={() => {
                      setCategoryIndex(item);
                    }}>
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
                {mapped_emote.map((item, index) => (
                  <Stack.Item key={index}>
                    <Stack>
                      <span
                        style={{
                          'verticalAlign': 'middle',
                        }}
                      />{' '}
                      <Stack.Item>
                        <Box
                          m={1}
                          height="20px"
                          width="32px"
                          style={{
                            '-ms-interpolation-mode': 'nearest-neighbor',
                            'verticalAlign': 'middle',
                          }}
                        />
                      </Stack.Item>
                      <Stack.Item mt={-0.5}>
                        <Button
                          content={item.text}
                          disabled={on_cooldown}
                          tooltip={item.id}
                          onClick={() =>
                            act('emote', {
                              emotePath: item.path,
                            })
                          }
                        />
                      </Stack.Item>
                    </Stack>
                    <Divider />
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
