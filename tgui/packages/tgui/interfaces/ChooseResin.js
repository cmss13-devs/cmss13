import { classes } from "common/react";
import { useBackend, useLocalState } from '../backend';
import { Tabs, Box, Section, Stack, Button } from '../components';
import { Window } from '../layouts';

export const INFINITE_BUILD_AMOUNT = -1;

export const ChooseResin = (props, context) => {
  const { act, data } = useBackend(context);
  const { constructions, selected_resin } = data;

  const [compact, setCompact] = useLocalState(context, "chooseresin_compact", false);

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
          buttons={(
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
          )}
          scrollable
          fill
        >
          <Tabs vertical fluid fill>
            {constructions.map((val, index) => (
              <Tabs.Tab
                key={index}
                selected={val.id === selected_resin}
                onClick={() => act("choose_resin", { type: val.id })}
              >
                <Stack align="center">
                  <Stack.Item>
                    <span
                      className={classes([
                        `chooseresin${compact? "32x32" : "64x64"}`,
                        `${val.image}${compact? "" : "_big"}`,
                        "ChooseResin__BuildIcon",
                      ])}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box fontSiz>
                      {val.name}
                      {val.max_per_xeno !== INFINITE_BUILD_AMOUNT
                        && ` (${val.max_per_xeno} Max)`}
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
