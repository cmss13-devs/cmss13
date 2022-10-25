import { useBackend } from '../backend';
import {
  Button,
  Section,
  LabeledList,
  ProgressBar,
  Divider,
  NumberInput,
  Dimmer,
  Icon,
  NoticeBox,
  Box,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const SupplyDropConsole = (_props, context) => {
  const { act, data } = useBackend(context);

  const active = data.active;

  const can_pick_squad = data.can_pick_squad;

  const timeLeft = data.nextfiretime - data.worldtime;
  const timeLeftPct = timeLeft / data.launch_cooldown;

  const cantFire = (timeLeft < 0, data.loaded === null);

  const squads = data.squad_list;

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        {!!can_pick_squad && (
          <NoticeBox info={1} fluid={1} textAlign="center">
            {data.current_squad
              ? `Current squad is :
                ${data.current_squad}`
              : 'No squad selected'}
          </NoticeBox>
        )}
        {!!can_pick_squad && (
          <Tabs horizontal textAlign="center" fluid>
            {squads.map((val) => {
              return (
                <Tabs.Tab
                  onClick={() => {
                    act('pick_squad', { squad_name: val.squad_name });
                  }}
                  key={val.squad_name}>
                  <Box color={val.squad_color}>{val.squad_name}</Box>
                </Tabs.Tab>
              );
            })}
          </Tabs>
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
            <NoticeBox info={1} textAlign="center">
              {data.loaded
                ? `Supply Pad Status :
                  ${data.crate_name} loaded.`
                : 'No crate loaded.'}
            </NoticeBox>
            {(timeLeft < 0 && (
              <NoticeBox success={1} textAlign="center">
                Ready to fire!
              </NoticeBox>
            )) || (
              <ProgressBar
                width="100%"
                value={timeLeftPct}
                ranges={{
                  good: [-Infinity, 0.33],
                  average: [0.33, 0.67],
                  bad: [0.67, Infinity],
                }}>
                <Box textAlign="center">
                  {Math.ceil(timeLeft / 10)} seconds until next launch
                </Box>
              </ProgressBar>
            )}
            <Button
              fontSize="20px"
              textAlign="center"
              disabled={!!cantFire}
              fluid={1}
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
        </Section>
      </Window.Content>
    </Window>
  );
};
