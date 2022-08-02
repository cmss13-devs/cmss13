import { useBackend } from '../backend';
import { Button, Stack, Section, Box, Slider } from '../components';
import { Window } from '../layouts';

export const TechNode = (props, context) => {
  const { act, data } = useBackend(context);
  if (data.stats_dynamic) {
    if (data.stats) {
      if (data.original_stats) data.stats = data.original_stats;
      else data.original_stats = data.stats;

      data.stats = data.stats.concat(data.stats_dynamic || []);
    } else {
      data.original_stats = [];
      data.stats = data.stats_dynamic;
    }
  }

  const {
    total_points,
    unlocked,
    theme,
    cost,
    name,
    desc,
    extra_buttons,
    extra_sliders,
    stats,
  } = data;

  return (
    <Window
      width={500}
      height={300}
      theme={theme}
    >
      <Window.Content>
        <Stack vertical height="100%">
          <Stack.Item grow>
            <Section title="Information" fill scrollable>
              <Stack vertical>
                <Stack.Item>
                  <Label label="Name" content={name} />
                </Stack.Item>
                <Stack.Item>
                  <Label label="Description" content={desc} />
                </Stack.Item>
                <Stack.Item>
                  <Label label="Cost" content={cost} />
                </Stack.Item>
                {!!stats && (
                  <Stack.Item>
                    <Label label="Statistics" content={(
                      <Stack vertical>
                        {stats.map((stat, i) => (
                          <Stack.Item key={i}>
                            <Button
                              content={stat.content}
                              color={stat.color}
                              icon={stat.icon}
                              tooltip={stat.tooltip}
                              tooltipPosition="top"
                            />
                          </Stack.Item>
                        ))}
                      </Stack>
                    )} />
                  </Stack.Item>
                )}
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item grow>
                  <Label label="Current Points" content={Math.round(total_points*10)/10} />
                </Stack.Item>
                {!!extra_buttons && (
                  <Stack.Item>
                    <Stack>
                      {extra_buttons.map(val => (
                        <Stack.Item key={val}>
                          <Button.Checkbox
                            checked={val.enabled}
                            content={val.name}
                            onClick={() => act(val.action, val)}
                          />
                        </Stack.Item>
                      ))}
                    </Stack>
                  </Stack.Item>
                )}
                {!!extra_sliders && (
                  <Stack.Item>
                    <Stack>
                      {extra_sliders.map(val => (
                        <Stack.Item key={val}>
                          <Slider
                            value={val.value}
                            unit={val.unit}
                            stepPixelSize={5}
                            step={val.step}
                            minValue={val.minValue}
                            maxValue={val.maxValue}
                            onChange={(e, value) =>
                              act(val.action, { value: value })}
                          />
                        </Stack.Item>
                      ))}
                    </Stack>
                  </Stack.Item>
                )}
              </Stack>
              <Stack mt={1} vertical>
                <Stack.Item grow>
                  {!!unlocked && (
                    <Box
                      textAlign="center"
                      className="TechNode__purchased"
                      width="100%"
                      backgroundColor="green"
                    >
                      Purchased
                    </Box>
                  ) || (
                    <Button
                      content="Purchase"
                      textAlign="center"
                      fluid
                      height="100%"
                      icon="shopping-cart"
                      color={total_points >= cost? "good" : "bad"}
                      onClick={() => act("purchase")}
                    />
                  )}
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const Label = (props, context) => {
  const { label, content, ...rest } = props;

  return (
    <Stack {...rest}>
      <Stack.Item width="25%">
        <Box color="label">{label}:</Box>
      </Stack.Item>
      <Stack.Item width="75%">
        <Box className="TechNode__content">{content}</Box>
      </Stack.Item>
    </Stack>
  );
};
