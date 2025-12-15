import type { BooleanLike } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

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
  theme: string;
};

const EmoteTab = () => {
  const { data, act } = useBackend<BackendContext>();
  const { categories, emotes, on_cooldown } = data;
  const [categoryIndex, setCategoryIndex] = useState(categories[0]);

  const [search, setSearch] = useState('');

  const mapped_emote = emotes.filter(
    (emote) =>
      (emote && !search && emote.category === categoryIndex) ||
      (search && emote.text.toLowerCase().includes(search.toLowerCase())),
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
            <Input
              placeholder="Search..."
              onInput={(_, val) => setSearch(val)}
              onEnter={() => {
                mapped_emote[0]
                  ? act('emote', { emotePath: mapped_emote[0].path })
                  : null;
              }}
            />
            {categories.map((item, key) => (
              <Tabs.Tab
                key={item}
                selected={!search && item === categoryIndex}
                onClick={() => {
                  setSearch('');
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

export const Emotes = () => {
  return (
    <Window
      width={810}
      height={600}
      theme={useBackend<BackendContext>().data.theme}
    >
      <Window.Content>
        <EmoteTab />
      </Window.Content>
    </Window>
  );
};
