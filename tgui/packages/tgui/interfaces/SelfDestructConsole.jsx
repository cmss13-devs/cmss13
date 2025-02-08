import { useBackend } from '../backend';
import { Button, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const SelfDestructConsole = (props) => {
  const { act, data } = useBackend();
  const { dest_status } = data;

  let statusMessage = 'ERROR!';
  let statusColor = 'bad';

  switch (dest_status) {
    case 0:
      statusMessage = 'DISARMED.';
      statusColor = 'blue';
      break;
    case 1:
      statusMessage = 'AWAITING INPUT.';
      statusColor = 'yellow';
      break;
    case 2:
      statusMessage = 'ARMED!';
      statusColor = 'green';
      break;
  }

  return (
    <Window width={300} height={170}>
      <Window.Content>
        <Section>
          <NoticeBox textAlign="center" color={statusColor}>
            Self Destruct status: {statusMessage}
          </NoticeBox>
          {dest_status === 1 && (
            <Button.Confirm
              fluid
              color="average"
              textAlign="center"
              icon="power-off"
              onClick={() => act('dest_start')}
            >
              Activate System
            </Button.Confirm>
          )}
          {dest_status === 2 && (
            <>
              <Button.Confirm
                fluid
                color="red"
                textAlign="center"
                icon="explosion"
                onClick={() => act('dest_trigger')}
              >
                DETONATE
              </Button.Confirm>
              <Button.Confirm
                fluid
                color="yellow"
                textAlign="center"
                icon="ban"
                onClick={() => act('dest_cancel')}
              >
                CANCEL
              </Button.Confirm>
            </>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
