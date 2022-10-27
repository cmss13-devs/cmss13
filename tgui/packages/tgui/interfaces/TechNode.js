import { useBackend } from '../backend';
import { Stack, Section, LabeledList, Button } from '../components';
import { Window } from '../layouts';

export const TechNode = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    total_points,
    can_afford,
    valid_tier,
    unlocked,
    theme,
    cost,
    name,
    desc,
    stats,
  } = data;

  return (
    <Window width={500} height={300} theme={theme}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Section
              title="Information"
              fill
              buttons={
                <Button
                  content={'Tech points: ' + total_points}
                  backgroundColor="transparent"
                />
              }>
              <LabeledList>
                <LabeledList.Item label="Name">{name}</LabeledList.Item>
                <LabeledList.Item label="Description">{desc}</LabeledList.Item>
                <LabeledList.Item label="Cost">{cost}</LabeledList.Item>

                {!!stats && (
                  <LabeledList.Item label="Statistics">
                    {stats.map((stat, i) => (
                      <Button
                        key={i}
                        content={stat.content}
                        color={stat.color}
                        icon={stat.icon}
                        tooltip={stat.tooltip}
                        mr="100%"
                      />
                    ))}
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Button
                content="Purchase"
                color="green"
                textAlign="center"
                width="100%"
                p=".5rem"
                disabled={!can_afford || !valid_tier || unlocked ? true : false}
                tooltip={
                  unlocked
                    ? 'Already unlocked'
                    : !valid_tier
                    ? 'Tech tier not unlocked'
                    : !can_afford
                    ? 'Not enough tech points'
                    : ''
                }
                onClick={() => act('purchase')}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
