import { classes } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

export const INFINITE_BUILD_AMOUNT = -1;

type Data = {
  constructions: {
    name: string;
    desc: string;
    image: string;
    plasma_cost: number;
    max_per_xeno: number;
    id: string;
  }[];
  selected_resin: string | null;
};

export const ChooseResin = (props) => {
  const { act, data } = useBackend<Data>();
  const { constructions, selected_resin } = data;

  const [compact, setCompact] = useState(false);

  let heightScale = 80;
  if (compact) heightScale = 45;

  return (
    <Window
      width={350}
      height={15 + constructions.length * heightScale}
      theme="hive_status"
    >
      <Window.Content>
        <Section
          title="Structures"
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
            {constructions.map((val, index) => (
              <Tabs.Tab
                key={index}
                selected={val.id === selected_resin}
                onClick={() => act('choose_resin', { type: val.id })}
              >
                <Stack align="center">
                  <Stack.Item>
                    <span
                      className={classes([
                        `chooseresin${compact ? '32x32' : '64x64'}`,
                        `${val.image}${compact ? '' : '_big'}`,
                        'ChooseResin__BuildIcon',
                      ])}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box>
                      {val.name}
                      {val.max_per_xeno !== INFINITE_BUILD_AMOUNT &&
                        ` (${val.max_per_xeno} Max)`}
                    </Box>
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
