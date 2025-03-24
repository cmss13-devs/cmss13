import { classes } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  design: { name: string; desc: string; image: string; id: string }[];
  selected_design: string | null;
};

export const ChooseDesign = (props) => {
  const { act, data } = useBackend<Data>();
  const { design, selected_design } = data;

  const [compact, setCompact] = useState(false);

  let heightScale = 80;
  if (compact) heightScale = 45;

  return (
    <Window
      width={350}
      height={15 + design.length * heightScale}
      theme="hive_status"
    >
      <Window.Content>
        <Section
          title="Choose Design"
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
            {design.map((val, index) => (
              <Tabs.Tab
                key={index}
                selected={val.id === selected_design}
                onClick={() => act('choose_design', { type: val.id })}
              >
                <Stack align="center">
                  <Stack.Item>
                    <span
                      className={classes([
                        `choosedesign${compact ? '32x32' : '64x64'}`,
                        `${val.image}${compact ? '' : '_big'}`,
                        'ChooseResin__BuildIcon',
                      ])}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box>{val.name}</Box>
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
