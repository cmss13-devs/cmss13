import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Dimmer,
  Divider,
  Icon,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const OrbitalCannonConsole = () => {
  const { act, data } = useBackend();

  const timeLeft = data.nextchambertime - data.worldtime;
  const timeLeftPct = timeLeft / data.chamber_cooldown;

  const cantChamber = timeLeft > 0 || !data.loadedtray;

  const fullyLoaded = !!data.warhead && data.fuel > 0;

  const fuelLoadedPct = data.fuel / 6;

  return (
    <Window width={500} height={500}>
      <Window.Content scrollable>
        <Section title="Warhead status">
          {(!!data.warhead && (
            <NoticeBox info>{data.warhead} loaded!</NoticeBox>
          )) || <NoticeBox danger>No warhead loaded!</NoticeBox>}
        </Section>
        <Section title="Fuel status">
          <Box textAlign="center">
            <ProgressBar
              width="100%"
              value={fuelLoadedPct}
              ranges={{
                bad: [-Infinity, 0.51],
                good: [0.51, Infinity],
              }}
            >
              <Box textAlign="center">{data.fuel} Fuel Blocks loaded</Box>
            </ProgressBar>
          </Box>
          <Divider />
          <Collapsible title="Fuel Requirements">
            <Box>
              Warhead Fuel Requirements:
              <br />
              HE Orbital Warhead:
              <b> {data.hefuel} Solid Fuel blocks.</b>
              <br />
              Incendiary Orbital Warhead:
              <b> {data.incfuel} Solid Fuel blocks.</b>
              <br />
              Cluster Orbital Warhead:
              <b> {data.clusterfuel} Solid Fuel blocks.</b>
            </Box>
          </Collapsible>
        </Section>
        <Section title="Tray status">
          {timeLeft > 0 && (
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
                {Math.ceil(timeLeft / 10)} seconds until the cannon can be
                chambered!
              </Box>
            </ProgressBar>
          )}
          {(!data.loadedtray && (
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={!fullyLoaded}
              icon="truck-loading"
              color="good"
              onClick={() => act('load_tray')}
            >
              Load tray
            </Button>
          )) || (
            <Box>
              {(!data.chamberedtray && (
                <Button
                  fontSize="20px"
                  textAlign="center"
                  fluid
                  icon="sign-out-alt"
                  color="good"
                  onClick={() => act('unload_tray')}
                >
                  Unload tray
                </Button>
              )) || (
                <NoticeBox fontSize="15px" textAlign="center" fluid danger>
                  The tray is chambered, you cannot unchamber it.
                </NoticeBox>
              )}
            </Box>
          )}
          {!data.chamberedtray && !!data.loadedtray && (
            <Button.Confirm
              fontSize="20px"
              textAlign="center"
              disabled={!!cantChamber || !fullyLoaded}
              fluid
              icon="sign-in-alt"
              color="good"
              confirmContent="You cannot unchamber the tray. Confirm?"
              onClick={() => act('chamber_tray')}
            >
              Chamber tray
            </Button.Confirm>
          )}
        </Section>
        {(!data.linkedtray || !data.linkedcannon || !!data.disabled) && (
          <Dimmer fontSize="32px">
            <Icon name="exclamation-triangle" />
            {!data.linkedtray && ' No tray linked to console!'}
            {!data.linkedcannon && ' No cannon linked to console!'}
            {!!data.disabled && '  Cannon disabled!'}
          </Dimmer>
        )}
      </Window.Content>
    </Window>
  );
};
