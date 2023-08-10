import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, Section, Flex, NoticeBox, Collapsible, Divider, Box } from '../components';
import { Window } from '../layouts';

export const AlmayerControl = (_props, context) => {
  const { act, data } = useBackend(context);

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
                fluid={1}
                color={alertLevelColor}
                icon="triangle-exclamation"
                disabled={AlertLevel === 3}
                onClick={() => act('change_sec_level')}>
                Change alert level; current alert level: {alertLevelString}.
              </Button>
            </Flex.Item>
            <Flex.Item>
              {!canMessage && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  Shipwide announcement recharging:{' '}
                  {Math.ceil((data.time_message - worldTime) / 10)} secs
                </Button>
              )}
              {!!canMessage && (
                <Button
                  fluid={1}
                  icon="bullhorn"
                  title="Make a shipwide announcement"
                  content="Make a shipwide announcement"
                  onClick={() => act('ship_announce')}
                  disabled={!canMessage}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {!canCentral && (
                <Button color="bad" warning={1} fluid={1} icon="ban">
                  Quantum relay re-cycling :{' '}
                  {Math.ceil((data.time_message - worldTime) / 10)} secs
                </Button>
              )}
              {!!canCentral && (
                <Button
                  fluid={1}
                  icon="paper-plane"
                  title="Send a message to USCM High Command"
                  content="Send a message to USCM High Command"
                  onClick={() => act('messageUSCM')}
                  disabled={!canCentral}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid={1}
                icon="medal"
                title="Give a medal"
                content="Give a medal"
                onClick={() => act('award')}
              />
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
                    fluid={1}
                    color="orange"
                    icon="door-open"
                    content={'Initiate Evacuation'}
                    confirmColor="bad"
                    confirmContent="Confirm?"
                    confirmIcon="question"
                    onClick={() => act('evacuation_start')}
                    disabled={!canEvac}
                  />
                </Flex.Item>
              )}
              {evacstatus === 1 && (
                <Flex.Item>
                  <NoticeBox color="good" info={1} textAlign="center">
                    Evacuation ongoing. Time until escape pod launch: {evacEta}.
                  </NoticeBox>
                  <Button.Confirm
                    fluid={1}
                    color="red"
                    icon="ban"
                    content={'Cancel Evacuation'}
                    confirmColor="bad"
                    confirmContent="Confirm?"
                    confirmIcon="question"
                    onClick={() => act('evacuation_cancel')}
                  />
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
                    content={'Self-destruct disabled!'}
                    tooltip={destruct_reason}
                    fluid={1}
                    icon="ban"
                  />
                )}
                {canDestruct && (
                  <Button.Confirm
                    fluid={1}
                    color="red"
                    icon="explosion"
                    content={'Request to initiate Self-destruct'}
                    confirmColor="bad"
                    confirmContent="Confirm Self-destruct?"
                    confirmIcon="question"
                    onClick={() => act('destroy')}
                  />
                )}
              </Flex.Item>
              <Flex.Item>
                {!canRequest && (
                  <Button
                    disabled={1}
                    content={'Distress Beacon disabled'}
                    tooltip={distress_reason}
                    fluid={1}
                    icon="ban"
                  />
                )}
                {canRequest && (
                  <Button.Confirm
                    fluid={1}
                    color="orange"
                    icon="phone-volume"
                    content={'Send Distress Beacon'}
                    confirmColor="bad"
                    confirmContent="Confirm?"
                    confirmIcon="question"
                    onClick={() => act('distress')}
                  />
                )}
              </Flex.Item>
            </Section>
          </Flex>
        </Section>
        {messages && (
          <Fragment>
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
                            content={'Delete message'}
                            color="red"
                            icon="trash"
                            onClick={() =>
                              act('delmessage', { number: entry.number })
                            }
                          />
                        }>
                        <Box>{entry.text}</Box>
                      </Section>
                    </Flex.Item>
                  );
                })}
              </Flex>
            </Collapsible>
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};
