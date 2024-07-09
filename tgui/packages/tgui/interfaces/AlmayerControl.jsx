import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Flex,
  NoticeBox,
  Section,
} from '../components';
import { Window } from '../layouts';

export const AlmayerControl = (_props) => {
  const { act, data } = useBackend();

  const worldTime = data.worldtime;
  const messages = data.messages;

  const evacstatus = data.evac_status;
  const evacEta = data.evac_eta;

  const AlertLevel = data.alert_level;

  const minimumTimeElapsed = worldTime > data.distresstimelock;

  const canMessage = data.time_message < worldTime; // ship announcement
  const canRequest = // requesting distress beacon
    data.time_request < worldTime && AlertLevel === 2 && minimumTimeElapsed;
  const canEvac = (evacstatus === 0, AlertLevel >= 2); // triggering evac
  const canDestruct =
    data.time_destruct < worldTime && minimumTimeElapsed && AlertLevel === 2;
  const canCentral = data.time_central < worldTime; // messaging HC

  let distress_reason;
  let destruct_reason;
  if (AlertLevel === 3) {
    distress_reason = 'Self-destruct in progress. Beacon disabled.';
    destruct_reason = 'Self-destruct is already active!';
  } else if (AlertLevel !== 2) {
    distress_reason = 'Ship is not under an active emergency.';
    destruct_reason = 'Ship is not under an active emergency.';
  } else if (data.time_request < worldTime) {
    distress_reason =
      'Beacon is currently recharging. Time remaining: ' +
      Math.ceil((data.time_message - worldTime) / 10) +
      'secs.';
  } else if (data.time_destruct < worldTime) {
    destruct_reason =
      'A request has already been sent to HC. Please wait: ' +
      Math.ceil((data.time_destruct - worldTime) / 10) +
      'secs to send another.';
  } else if (!minimumTimeElapsed) {
    distress_reason = "It's too early to launch a distress beacon.";
    destruct_reason = "It's too early to initiate the self-destruct.";
  }

  let alertLevelString;
  let alertLevelColor;
  if (AlertLevel === 3) {
    alertLevelString = 'DELTA';
    alertLevelColor = 'purple';
  }
  if (AlertLevel === 2) {
    alertLevelString = 'RED';
    alertLevelColor = 'red';
  }
  if (AlertLevel === 1) {
    alertLevelString = 'BLUE';
    alertLevelColor = 'blue';
  }
  if (AlertLevel === 0) {
    alertLevelString = 'GREEN';
    alertLevelColor = 'green';
  }

  return (
    <Window width={450} height={700}>
      <Window.Content scrollable>
        <Section title="Ship Control">
          <Flex height="100%" direction="column">
            <Flex.Item>
              <Button
                fluid
                color={alertLevelColor}
                icon="triangle-exclamation"
                disabled={AlertLevel === 3}
                onClick={() => act('change_sec_level')}
              >
                Change alert level; current alert level: {alertLevelString}.
              </Button>
            </Flex.Item>
            <Flex.Item>
              {!canMessage && (
                <Button color="bad" warning={1} fluid icon="ban">
                  Shipwide announcement recharging:{' '}
                  {Math.ceil((data.time_message - worldTime) / 10)} secs
                </Button>
              )}
              {!!canMessage && (
                <Button
                  fluid
                  icon="bullhorn"
                  title="Make a shipwide announcement"
                  onClick={() => act('ship_announce')}
                  disabled={!canMessage}
                >
                  Make a shipwide announcement
                </Button>
              )}
            </Flex.Item>
            <Flex.Item>
              {!canCentral && (
                <Button color="bad" warning={1} fluid icon="ban">
                  Quantum relay re-cycling :{' '}
                  {Math.ceil((data.time_message - worldTime) / 10)} secs
                </Button>
              )}
              {!!canCentral && (
                <Button
                  fluid
                  icon="paper-plane"
                  title="Send a message to USCM High Command"
                  onClick={() => act('messageUSCM')}
                  disabled={!canCentral}
                >
                  Send a message to USCM High Command
                </Button>
              )}
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                icon="medal"
                title="Give a medal"
                onClick={() => act('award')}
              >
                Give a medal
              </Button>
            </Flex.Item>
            <Section title="Emergency measures">
              {AlertLevel < 2 && (
                <NoticeBox color="bad" warning={1} textAlign="center">
                  The ship must be under red alert in order to enact evacuation
                  procedures.
                </NoticeBox>
              )}
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
                    Initiate Evacuation
                  </Button.Confirm>
                </Flex.Item>
              )}
              {evacstatus === 1 && (
                <Flex.Item>
                  <NoticeBox color="good" info={1} textAlign="center">
                    Evacuation ongoing. Time until escape pod launch: {evacEta}.
                  </NoticeBox>
                  <Button.Confirm
                    fluid
                    color="red"
                    icon="ban"
                    confirmColor="bad"
                    confirmContent="Confirm?"
                    confirmIcon="question"
                    onClick={() => act('evacuation_cancel')}
                  >
                    Cancel Evacuation
                  </Button.Confirm>
                </Flex.Item>
              )}
              {evacstatus === 2 && (
                <NoticeBox color="good" info={1} textAlign="center">
                  Escape pods launching.
                </NoticeBox>
              )}
              {evacstatus === 3 && (
                <NoticeBox color="good" success={1} textAlign="center">
                  Evacuation complete.
                </NoticeBox>
              )}
              <Flex.Item>
                {!canDestruct && (
                  <Button
                    disabled={1}
                    tooltip={destruct_reason}
                    fluid
                    icon="ban"
                  >
                    Self-destruct disabled!
                  </Button>
                )}
                {canDestruct && (
                  <Button.Confirm
                    fluid
                    color="red"
                    icon="explosion"
                    confirmColor="bad"
                    confirmContent="Confirm Self-destruct?"
                    confirmIcon="question"
                    onClick={() => act('destroy')}
                  >
                    Request to initiate Self-destruct
                  </Button.Confirm>
                )}
              </Flex.Item>
              <Flex.Item>
                {!canRequest && (
                  <Button
                    disabled={1}
                    tooltip={distress_reason}
                    fluid
                    icon="ban"
                  >
                    Distress Beacon disabled
                  </Button>
                )}
                {canRequest && (
                  <Button.Confirm
                    fluid
                    color="orange"
                    icon="phone-volume"
                    confirmColor="bad"
                    confirmContent="Confirm?"
                    confirmIcon="question"
                    onClick={() => act('distress')}
                  >
                    Send Distress Beacon
                  </Button.Confirm>
                )}
              </Flex.Item>
            </Section>
          </Flex>
        </Section>
        {messages && (
          <>
            <Divider />
            <Collapsible title="Messages">
              <Flex>
                {messages.map((entry) => {
                  return (
                    <Flex.Item key={entry} grow>
                      <Section
                        title={entry.title}
                        buttons={
                          <Button
                            color="red"
                            icon="trash"
                            onClick={() =>
                              act('delmessage', { number: entry.number })
                            }
                          >
                            Delete message
                          </Button>
                        }
                      >
                        <Box>{entry.text}</Box>
                      </Section>
                    </Flex.Item>
                  );
                })}
              </Flex>
            </Collapsible>
          </>
        )}
      </Window.Content>
    </Window>
  );
};
