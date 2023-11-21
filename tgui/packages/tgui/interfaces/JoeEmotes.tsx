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

const EmoteTab = (props, context) => {
  const { data, act } = useBackend<BackendContext>(context);
  const { categories, emotes, on_cooldown } = data;
  const [categoryIndex, setCategoryIndex] = useLocalState(
    context,
    'category_index',
    'Farewell'
  );
  const mapped_emote = emotes.filter(
    (emote) => emote && emote.category === categoryIndex
  );
  return (
    <Stack fill vertical>
      <Stack.Item>
        <span
          style={{
            'position': 'relative',
            'top': '8px',
          }}>
          <Tabs>
            {categories.map((item, key) => (
              <Tabs.Tab
                key={item}
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
            {mapped_emote.map((item) => (
              <Stack.Item key={item.id}>
                <Stack>
                  <span
                    style={{
                      'vertical-align': 'middle',
                    }}
                  />{' '}
                  <Stack.Item>
                    <Box
                      m={1}
                      height="20px"
                      width="32px"
                      style={{
                        '-ms-interpolation-mode': 'nearest-neighbor',
                        'vertical-align': 'middle',
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
  );
};

export const JoeEmotes = (props, context) => {
  return (
    <Window
      width={750}
      height={600}
      theme="crtblue"
      title="Working Joe Voice Synthesizer">
      <Window.Content>
        <EmoteTab />
      </Window.Content>
    </Window>
  );
};
