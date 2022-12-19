import { useBackend } from '../backend';
import { Button, Section, ProgressBar, NoticeBox, Box, Dimmer, Icon, Dropdown } from '../components';
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
    <Window width={500} height={350}>
      <Window.Content scrollable>
        <Section title="Teleporter Control">
          {(timeLeft < 0 && (
            <NoticeBox success={1} textAlign="center">
              Ready to send!
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
          <Dropdown
            displayText="Source"
            icon="right-from-bracket"
            width={12}
            selected={data.source}
            options={Object.keys(data.locations)}
            onSelected={act('set_source', { location: value })}
          />
          <Dropdown
            displayText="Destination"
            icon="right-to-bracket"
            width={12}
            selected={data.destination}
            options={Object.keys(data.locations)}
            onSelected={act('set_dest', { location: value })}
          />
          <Button.Confirm
            fontSize="20px"
            textAlign="center"
            disabled={!!cantFire}
            fluid={1}
            icon="plane-departure"
            color="good"
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
