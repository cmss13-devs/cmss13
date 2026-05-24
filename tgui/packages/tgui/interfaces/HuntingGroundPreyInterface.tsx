import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type HGEquipmentPreset = {
  name: string;
  path: string;
  description: string;
};

type BackendContext = {
  presets: { [key: string]: HGEquipmentPreset[] };
};

export const HuntingGroundPreyInterface = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const [chosenPreset, setPreset] = useState<AIEquipmentPreset | null>(null);
  const { presets } = data;
  return (
    <Window
      title="Choose your category and number of prey."
      width={800}
      height={900}
    >
      <Window.Content>
        <Stack fill vertical>
          <Stack fill>
            <Stack.Item grow mr={1}>
              <Section fill scrollable>
                {Object.keys(presets).map((dictKey) => (
                  <Collapsible title={dictKey} key={dictKey} color="good">
                    {presets[dictKey].map((squad) => (
                      <Box pb={'12px'} key={squad.path}>
                        <Button
                          fontSize="15px"
                          textAlign="center"
                          selected={squad === chosenPreset}
                          width="100%"
                          key={squad.path}
                          onClick={() => setPreset(squad)}
                        >
                          {squad.name}
                        </Button>
                      </Box>
                    ))}
                  </Collapsible>
                ))}
              </Section>
            </Stack.Item>
            <Divider vertical />
            <Stack.Item width="30%">
              <Section title="Prey of...">
                {chosenPreset !== null ? (
                  <Stack vertical>
                    <Stack.Item>{chosenPreset.description}</Stack.Item>
                    <Stack.Item>
                      <Button
                        textAlign="center"
                        width="100%"
                        onClick={() =>
                          act('create_ai', {
                            path: chosenPreset.path,
                          })
                        }
                      >
                        Spawn
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
