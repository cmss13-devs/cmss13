import { classes } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

export const ChooseFruit = (props) => {
  const { act, data } = useBackend();
  const { fruits, selected_fruit } = data;

  const [compact, setCompact] = useState(false);

  let heightScale = 80;
  if (compact) heightScale = 45;

  return (
    <Window
      width={350}
      height={15 + fruits.length * heightScale}
      theme="hive_status"
    >
      <Window.Content>
        <Section
          title="Fruits"
          buttons={
            <Button
              color="transparent"
              tooltip="Compact Mode"
              tooltipPosition="left"
              selected={compact}
              onClick={() => {
                setCompact(!compact);
                act('refresh_ui');
              }}
              icon="compress-arrows-alt"
            />
          }
          scrollable
          fill
        >
          <Tabs vertical fluid fill>
            {fruits.map((val, index) => (
              <Tabs.Tab
                key={index}
                selected={val.id === selected_fruit}
                onClick={() => act('choose_fruit', { type: val.id })}
              >
                <Stack align="center">
                  <Stack.Item>
                    <span
                      className={classes([
                        `choosefruit${compact ? '32x32' : '64x64'}`,
                        `${val.image}${compact ? '' : '_big'}`,
                        'ChooseResin__BuildIcon',
                      ])}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box fontSiz>{val.name}</Box>
                  </Stack.Item>
                </Stack>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Window.Content>
    </Window>
  );
};
