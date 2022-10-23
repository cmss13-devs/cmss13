import { useBackend } from '../backend';
import { Section, Flex, NoticeBox, Button, Box } from '../components';
import { Window } from '../layouts';

export const EscapePodConsole = (_props, context) => {
  const { act, data } = useBackend(context);

  let statusMessage = 'ERROR';
  let buttonColor = 'bad';
  let delayed = 0;
  let operable = 0;

  switch (data.docking_status) {
    case 4:
      statusMessage = 'SYSTEMS OK';
      buttonColor = 'good';
      operable = 1;
      break;
    case 5:
      statusMessage = 'SYSTEMS DOWN';
      break;
    case 6:
      statusMessage = 'STANDING BY';
      buttonColor = 'neutral';
      operable = 1;
      break;
    case 7:
      statusMessage = 'DELAYED';
      buttonColor = 'yellow';
      delayed = 1;
      operable = 1;
      break;
    case 8:
      statusMessage = 'LAUNCHING';
      buttonColor = 'grey';
      break;
    case 9:
      statusMessage = 'TRAVELLING';
      buttonColor = 'good';
      break;
  }

  let doorStatus = 'ERROR';
  let doorColor = 'bad';

  if (!data.door_state) {
    doorStatus = 'OPEN';
    doorColor = 'yellow';
  } else {
    if (data.door_lock) {
      doorStatus = 'SECURED';
      doorColor = 'green';
    } else {
      doorStatus = 'UNSECURED';
      doorColor = 'yellow';
    }
  }

  return (
    <Window width={400} height={270}>
      <Window.Content scrollable>
        <Section title="Information display">
          <Flex height="100%" direction="column">
            <Flex.Item>
              <NoticeBox textAlign="center" color={buttonColor}>
                Escape Pod Status : {statusMessage}
              </NoticeBox>
            </Flex.Item>
            <Flex.Item>
              <NoticeBox textAlign="center" color={doorColor}>
                Docking Hatch : {doorStatus}
              </NoticeBox>
            </Flex.Item>
          </Flex>
        </Section>
        <Section title="Pod controls">
          <Flex direction="column">
            <Flex.Item>
              <Button
                content={data.door_state ? 'Unlock door' : 'Lock door'}
                color="red"
                fluid
                icon={data.door_state ? 'lock-open' : 'lock'}
                disabled={!operable}
                onClick={() => act('lock_door')}
              />
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                content="Manual eject"
                icon="plane-departure"
                color="red"
                fluid
                disabled={!operable || delayed}
                onClick={() => act('force_launch')}
              />
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                content={delayed ? 'Undelay Launch' : 'Delay launch'}
                icon="clock"
                color="yellow"
                fluid
                disabled={!data.can_delay}
                onClick={() => act('delay_launch')}
              />
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
