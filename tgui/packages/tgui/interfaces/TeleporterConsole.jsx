import { useBackend } from '../backend';
import { Button, Section, ProgressBar, NoticeBox, Box, Dimmer, Icon, Dropdown, LabeledList } from '../components';
import { Window } from '../layouts';

export const TeleporterConsole = (_props, context) => {
  const { act, data } = useBackend(context);

  const timeLeft = data.next_teleport_time - data.worldtime;
  const timeLeftPct = timeLeft / data.cooldown_length;

  const cantFire =
    timeLeft > 0 ||
    !data.source ||
    !data.destination ||
    data.source === data.destination;

  return (
    <Window width={500} height={300} theme="weyland">
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
            <NoticeBox success={1} textAlign="center">
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
              }}>
              <Box textAlign="center">
                {Math.ceil(timeLeft / 10)} seconds until capacitors have
                recharged.
              </Box>
            </ProgressBar>
          )}
          <Box height="10px" />
          <LabeledList>
            <LabeledList.Item label="Source">
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
            <LabeledList.Item label="Destination">
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
            fluid={1}
            icon="plane-departure"
            content="Commence Teleportation Sequence"
            onClick={() => act('teleport')}
          />
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
