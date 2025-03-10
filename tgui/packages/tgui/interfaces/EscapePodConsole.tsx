import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, NoticeBox, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

interface EscapePodProps {
  docking_status: number;
  door_lock: 0 | 1;
  door_state: 0 | 1;
  can_delay: 0 | 1;
  launch_without_evac: number;
}

export const EscapePodConsole = () => {
  const { act, data } = useBackend<EscapePodProps>();

  let statusMessage = 'ERROR';
  let buttonColor = 'bad';
  let delayed = 0;
  let operable = 0;

  switch (data.docking_status) {
    case 4:
      statusMessage = 'NO EVACUATION';
      buttonColor = 'neutral';
      if (data.launch_without_evac) {
        operable = 1;
      }
      break;
    case 5:
      statusMessage = 'SYSTEMS DOWN';
      break;
    case 6:
      statusMessage = 'STANDING BY';
      buttonColor = 'good';
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
                color="red"
                fluid
                icon={data.door_state ? 'lock-open' : 'lock'}
                disabled={!operable}
                onClick={() => act('lock_door')}
              >
                {data.door_state ? 'Unlock door' : 'Lock door'}
              </Button>
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="plane-departure"
                color="red"
                fluid
                disabled={!operable || delayed}
                onClick={() => act('force_launch')}
              >
                Manual eject
              </Button>
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="clock"
                color="yellow"
                fluid
                disabled={!data.can_delay}
                onClick={() => act('delay_launch')}
              >
                {delayed ? 'Undelay Launch' : 'Delay launch'}
              </Button>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
