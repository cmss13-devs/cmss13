import { useBackend } from '../backend';
import { Button, Section, LabeledList, ProgressBar, Divider, NumberInput, Dimmer, Icon } from '../components';
import { Window } from '../layouts';

export const SupplyDropConsole = (_props, context) => {
  const { act, data } = useBackend(context);

  const active = data.active;

  const can_pick_squad = data.can_pick_squad;

  const timeLeft = data.next_fire;
  const timeLeftPct = timeLeft / data.launch_cooldown;

  const canFire = (
    timeLeft === 0);

  return (
    <Window
      width={350}
      height={350}>
      <Window.Content scrollable>
        {!!can_pick_squad && (
          <Button
            ml={1}
            icon="bullhorn"
            selected={data.current_squad}
            content={data.current_squad
              ? `Current squad is
                ${data.current_squad}`
              : 'No squad selected'}
            onClick={() => act('pick_squad')}
          />
        )}
        <Section title="Supply drop">
          <LabeledList>
            <LabeledList.Item label="X Offset">
              <NumberInput
                value={data.x_offset}
                onChange={(e, value) => act('set_x', { set_x: `${value}` })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Y Offset">
              <NumberInput
                value={data.y_offset}
                onChange={(e, value) => act('set_y', { set_y: `${value}` })}
              />
            </LabeledList.Item>
          </LabeledList>
          <Divider />
          <Section
            title="Supply pad status"
            buttons={
              <Button
                icon="reload"
                content="Update"
                onClick={() => act('refresh_pad')}
              />
            }>
            <ProgressBar
              width="100%"
              value={timeLeftPct}
              ranges={{
                good: [-Infinity, 0.33],
                average: [0.33, 0.67],
                bad: [0.67, Infinity],
              }}>
              {Math.ceil(timeLeft / 10)} sec(s)
            </ProgressBar>
          </Section>
          <Button
            disabled={!canFire}
            color="good"
            content="Launch Supply drop"
            onClick={() => act('send_beacon')}
          />
          {active === 1 && (
            <Dimmer fontSize="32px">
              <Icon name="cog" spin />
              {'Building items...'}
            </Dimmer>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
