import { useBackend } from '../backend';
import { Button, Section, LabeledList, ProgressBar, Divider, NumberInput, Dimmer, Icon } from '../components';
import { Window } from '../layouts';

export const CommandTablet = (_props, context) => {
  const { act, data } = useBackend(context);

  const evacstatus = data.evac_status;

  const timeLeft = data.cooldown_message;
  const timeLeftPct = timeLeft / data.launch_cooldown;

  const canAnnounce = (
    timeLeft === 0);

  const canEvac = (
    evacstatus === 1);

  return (
    <Window
      width={350}
      height={350}>
      <Window.Content scrollable>
        {!!canEvac && (
          <Button
            ml={1}
            icon="rocket-launch"
            content={"Initiate Evacuation"}
            onClick={() => act('evacuation_start')}
          />
        )}
        <Section title="Supply Drop">
          <LabeledList>
            <LabeledList.Item label="Longitude">
              <NumberInput
                width="4em"
                step={1}
                minValue={-1000}
                maxValue={1000}
                value={data.x_offset}
                onChange={(e, value) => act('set_x', { set_x: `${value}` })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Latitude">
              <NumberInput
                width="4em"
                step={1}
                minValue={-1000}
                maxValue={1000}
                value={data.y_offset}
                onChange={(e, value) => act('set_y', { set_y: `${value}` })}
              />
            </LabeledList.Item>
          </LabeledList>
          <Divider />
          <Section
            title="Supply Pad Status"
            buttons={
              <Button
                icon="sync-alt"
                content="Update"
                onClick={() => act('refresh_pad')}
              />
            }>
            {data.loaded
              ? `Supply Pad Status :
                ${data.crate_name} loaded.`
              : 'No crate loaded.'}
            <ProgressBar
              width="100%"
              value={timeLeftPct}
              ranges={{
                good: [-Infinity, 0.33],
                average: [0.33, 0.67],
                bad: [0.67, Infinity],
              }}>
              {Math.ceil(timeLeft / 10)} seconds
            </ProgressBar>
          </Section>
          <Button
            disabled={!canFire}
            icon="paper-plane"
            color="good"
            content="Launch Supply Drop"
            onClick={() => act('send_beacon')}
          />
          {active === 1 && (
            <Dimmer fontSize="32px">
              <Icon name="cog" spin />
              {'Launching...'}
            </Dimmer>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
