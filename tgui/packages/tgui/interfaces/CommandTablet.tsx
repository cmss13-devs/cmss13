import { useBackend } from 'tgui/backend';
import { Button, Flex, NoticeBox, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  faction: string;
  cooldown_message: number;
  distresstimelock: number;
  alert_level: number;
  evac_status: number;
  endtime: number;
  distresstime: number;
  worldtime: number;
};

export const CommandTablet = () => {
  const { act, data } = useBackend<Data>();

  const evacstatus = data.evac_status;

  const AlertLevel = data.alert_level;

  const minimumTimeElapsed = data.worldtime > data.distresstimelock;

  const canAnnounce = data.endtime < data.worldtime;

  const distressCooldown = data.worldtime < data.distresstime;

  const canEvac = evacstatus === 0 && AlertLevel >= 2;

  const canDistress =
    AlertLevel === 2 && !distressCooldown && minimumTimeElapsed;

  let distress_reason;
  if (AlertLevel === 3) {
    distress_reason = 'Self-destruct in progress. Beacon disabled.';
  } else if (AlertLevel !== 2) {
    distress_reason = 'Ship is not under an active emergency.';
  } else if (distressCooldown) {
    distress_reason = 'Beacon is currently recharging.';
  } else if (!minimumTimeElapsed) {
    distress_reason = "It's too early to launch a distress beacon.";
  }

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        <Section title="Command">
          <Flex height="100%" direction="column">
            <Flex.Item>
              {!canAnnounce && (
                <Button color="bad" fluid icon="ban">
                  Announcement recharging:{' '}
                  {Math.ceil((data.endtime - data.worldtime) / 10)} secs
                </Button>
              )}
              {!!canAnnounce && (
                <Button
                  fluid
                  icon="bullhorn"
                  onClick={() => act('announce')}
                  disabled={!canAnnounce}
                >
                  Make an announcement
                </Button>
              )}
            </Flex.Item>
            <Flex.Item>
              <Button fluid icon="medal" onClick={() => act('award')}>
                Give a medal
              </Button>
            </Flex.Item>
            <Flex.Item>
              <Button fluid icon="globe-africa" onClick={() => act('mapview')}>
                View tactical map
              </Button>
            </Flex.Item>
            {data.faction === 'USCM' && (
              <Section title="Evacuation">
                {AlertLevel < 2 && (
                  <NoticeBox color="bad" warning textAlign="center">
                    The ship must be under red alert in order to enact
                    evacuation procedures.
                  </NoticeBox>
                )}
                <Flex.Item>
                  {!canDistress && (
                    <Button
                      disabled={1}
                      tooltip={distress_reason}
                      fluid
                      icon="ban"
                    >
                      {'Distress Beacon disabled'}
                    </Button>
                  )}
                  {canDistress && (
                    <Button.Confirm
                      fluid
                      color="orange"
                      icon="phone-volume"
                      confirmColor="bad"
                      confirmContent="Confirm?"
                      confirmIcon="question"
                      onClick={() => act('distress')}
                    >
                      {'Send Distress Beacon'}
                    </Button.Confirm>
                  )}
                </Flex.Item>
                {evacstatus === 0 && (
                  <Flex.Item>
                    <Button.Confirm
                      fluid
                      color="orange"
                      icon="door-open"
                      confirmColor="bad"
                      confirmContent="Confirm?"
                      confirmIcon="question"
                      onClick={() => act('evacuation_start')}
                      disabled={!canEvac}
                    >
                      {'Initiate Evacuation'}
                    </Button.Confirm>
                  </Flex.Item>
                )}
                {evacstatus === 1 && (
                  <NoticeBox color="good" info textAlign="center">
                    Evacuation ongoing.
                  </NoticeBox>
                )}
                {evacstatus === 2 && (
                  <NoticeBox color="good" info textAlign="center">
                    Escape pods launching.
                  </NoticeBox>
                )}
                {evacstatus === 3 && (
                  <NoticeBox color="good" success textAlign="center">
                    Evacuation complete.
                  </NoticeBox>
                )}
              </Section>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
