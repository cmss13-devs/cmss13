import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dimmer,
  Dropdown,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  worldtime: number;
  next_teleport_time: number;
  cooldown_length: number;
  teleporting: BooleanLike;
  locations: Record<string, string>;
  source: string;
  destination: string;
  name: string;
};

export const TeleporterConsole = () => {
  const { act, data } = useBackend<Data>();

  const timeLeft = data.next_teleport_time - data.worldtime;
  const timeLeftPct = timeLeft / data.cooldown_length;

  const cantFire =
    timeLeft > 0 ||
    !data.source ||
    !data.destination ||
    data.source === data.destination;

  return (
    <Window width={500} height={380} theme="weyland">
      <Window.Content scrollable>
        <NoticeBox textAlign="center">
          This teleporter is operating on the {data.name} network.
        </NoticeBox>
        <Section title="Teleporter Control">
          {!data.source ? (
            <NoticeBox info textAlign="center">
              No source!
            </NoticeBox>
          ) : null}
          {!data.destination ? (
            <NoticeBox danger textAlign="center">
              No destination!
            </NoticeBox>
          ) : null}
          {data.source === data.destination ? (
            <NoticeBox danger textAlign="center">
              Source cannot match destination!
            </NoticeBox>
          ) : null}
          {(timeLeft < 0 && (
            <NoticeBox success textAlign="center">
              Capacitors charged!
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
                {Math.ceil(timeLeft / 10)} seconds until capacitors have
                recharged.
              </Box>
            </ProgressBar>
          )}
          <Box height="10px" />
          <LabeledList>
            <LabeledList.Item label="Source" verticalAlign="top">
              <Dropdown
                displayText={data.source ? data.source : 'Select source'}
                icon="right-from-bracket"
                width="350px"
                height="25px"
                selected={data.source}
                options={Object.keys(data.locations)}
                onSelected={(value) => {
                  act('set_source', { location: value });
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Destination" verticalAlign="top">
              <Dropdown
                displayText={
                  data.destination ? data.destination : 'Select destination'
                }
                icon="right-to-bracket"
                width="350px"
                height="25px"
                selected={data.destination}
                options={Object.keys(data.locations)}
                onSelected={(value) => {
                  act('set_dest', { location: value });
                }}
              />
            </LabeledList.Item>
          </LabeledList>
          <Box height="10px" />
          <Button.Confirm
            fontSize="20px"
            textAlign="center"
            disabled={!!cantFire}
            fluid
            icon="plane-departure"
            onClick={() => act('teleport')}
          >
            Commence Teleportation Sequence
          </Button.Confirm>
        </Section>
        {!!data.teleporting && (
          <Dimmer fontSize="32px">
            <Icon name="cog" spin />
            {' Teleportation in progress.'}
          </Dimmer>
        )}
      </Window.Content>
    </Window>
  );
};
