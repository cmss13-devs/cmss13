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
              content="Activate System"
              onClick={() => act('dest_start')}
            />
          )}
          {dest_status === 2 && (
            <>
              <Button.Confirm
                fluid
                color="red"
                textAlign="center"
                icon="explosion"
                content="DETONATE"
                onClick={() => act('dest_trigger')}
              />
              <Button.Confirm
                fluid
                color="yellow"
                textAlign="center"
                icon="ban"
                content="CANCEL"
                onClick={() => act('dest_cancel')}
              />
            </>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
