import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  LabeledList,
  NoticeBox,
  NumberInput,
  ProgressBar,
  Section,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  can_pick_squad: BooleanLike;
  squad_list: { squad_name: string; squad_color: string }[];
  current_squad: String;
  launch_cooldown: number;
  nextfiretime: number;
  worldtime: number;
  x_offset: number;
  y_offset: number;
  z_offset: number;
  loaded: string | null;
  crate_name: string | null;
};

export const SupplyDropConsole = () => {
  const { act, data } = useBackend<Data>();

  const can_pick_squad = data.can_pick_squad;

  const timeLeft = data.nextfiretime - data.worldtime;
  const timeLeftPct = timeLeft / data.launch_cooldown;

  const cantFire = timeLeft > 0 && data.loaded === null;

  const squads = data.squad_list;

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        {!!can_pick_squad && (
          <NoticeBox info textAlign="center">
            {data.current_squad
              ? `Current squad is :
                ${data.current_squad}`
              : 'No squad selected'}
          </NoticeBox>
        )}
        {!!can_pick_squad && (
          <Tabs textAlign="center" fluid>
            {squads.map((val) => {
              return (
                <Tabs.Tab
                  onClick={() => {
                    act('pick_squad', { squad_name: val.squad_name });
                  }}
                  key={val.squad_name}
                >
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
                minValue={-Infinity}
                maxValue={Infinity}
                value={data.x_offset}
                onChange={(value) => act('set_x', { set_x: `${value}` })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Latitude">
              <NumberInput
                width="4em"
                step={1}
                minValue={-Infinity}
                maxValue={Infinity}
                value={data.y_offset}
                onChange={(value) => act('set_y', { set_y: `${value}` })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Height">
              <NumberInput
                width="4em"
                step={1}
                minValue={-Infinity}
                maxValue={Infinity}
                value={data.z_offset}
                onChange={(value) => act('set_z', { set_z: `${value}` })}
              />
            </LabeledList.Item>
          </LabeledList>
          <Divider />
          <Section
            title="Supply Pad Status"
            buttons={
              <Button icon="sync-alt" onClick={() => act('refresh_pad')}>
                Update
              </Button>
            }
          >
            <NoticeBox info textAlign="center">
              {data.loaded
                ? `Supply Pad Status :
                  ${data.crate_name} loaded.`
                : 'No crate loaded.'}
            </NoticeBox>
            {(timeLeft < 0 && (
              <NoticeBox success textAlign="center">
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
                }}
              >
                <Box textAlign="center">
                  {Math.ceil(timeLeft / 10)} seconds until next launch
                </Box>
              </ProgressBar>
            )}
            <Button
              fontSize="20px"
              textAlign="center"
              disabled={!!cantFire}
              fluid
              icon="paper-plane"
              color="good"
              onClick={() => act('send_beacon')}
            >
              Launch Supply Drop
            </Button>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
