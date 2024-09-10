import { classes } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Divider, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

type Tutorial = {
  name: string;
  path: string;
  id: string;
  description: string;
  image: string;
};

type TutorialCategory = {
  tutorials: Tutorial[];
  name: string;
};

type BackendContext = {
  tutorial_categories: TutorialCategory[];
  completed_tutorials: string[];
};

export const TutorialMenu = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const { tutorial_categories, completed_tutorials } = data;
  const [chosenTutorial, setTutorial] = useState<Tutorial | null>(null);
  const [categoryIndex, setCategoryIndex] = useState('Space Station 13');
  return (
    <Window title="Tutorial Menu" width={800} height={600} theme="usmc">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <span
              style={{
                position: 'relative',
                top: '0px',
              }}
            >
              <Tabs>
                {tutorial_categories.map((item, key) => (
                  <Tabs.Tab
                    key={item.name}
                    selected={item.name === categoryIndex}
                    onClick={() => {
                      setCategoryIndex(item.name);
                    }}
                  >
                    {item.name}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </span>
          </Stack.Item>
          <Stack fill>
            <Stack.Item grow mr={1}>
              <Section fill height="100%">
                {tutorial_categories.map(
                  (tutorial_category) =>
                    tutorial_category.name === categoryIndex &&
                    tutorial_category.tutorials
                      .sort((a, b) => (a.name < b.name ? -1 : 1))
                      .map((tutorial) => (
                        <div
                          style={{ paddingBottom: '12px' }}
                          key={tutorial.id}
                        >
                          <Button
                            fontSize="15px"
                            textAlign="center"
                            selected={tutorial === chosenTutorial}
                            color={
                              completed_tutorials.indexOf(tutorial.id) === -1
                                ? 'good'
                                : 'default'
                            }
                            width="100%"
                            key={tutorial.id}
                            onClick={() => setTutorial(tutorial)}
                          >
                            {tutorial.name}
                          </Button>
                        </div>
                      )),
                )}
              </Section>
            </Stack.Item>
            <Divider vertical />
            <Stack.Item width="30%">
              <Section title="Selected Tutorial">
                {chosenTutorial !== null ? (
                  <Stack vertical>
                    <Stack.Item>
                      <div
                        style={{
                          display: 'flex',
                          justifyContent: 'center',
                          alignItems: 'center',
                        }}
                      >
                        <Box key={chosenTutorial.id}>
                          <span
                            className={classes([
                              'tutorial128x128',
                              `${chosenTutorial.image}`,
                            ])}
                          />
                        </Box>
                      </div>
                    </Stack.Item>
                    <Stack.Item>{chosenTutorial.description}</Stack.Item>
                    {completed_tutorials.indexOf(chosenTutorial.id) === -1 ? (
                      <div />
                    ) : (
                      <Stack.Item
                        style={{
                          color: '#5baa27',
                          paddingTop: '4px',
                          paddingBottom: '4px',
                          textAlign: 'center',
                        }}
                      >
                        Tutorial has been completed.
                      </Stack.Item>
                    )}
                    <Stack.Item>
                      <Button
                        textAlign="center"
                        width="100%"
                        onClick={() =>
                          act('select_tutorial', {
                            tutorial_path: chosenTutorial.path,
                          })
                        }
                      >
                        Start Tutorial
                      </Button>
                    </Stack.Item>
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
