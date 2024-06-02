import { useBackend } from '../backend';
import { Button, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const FiltrationControl = () => {
  const { act, data } = useBackend();

  const FiltOn = data.filt_on;

  return (
    <Window width={350} height={150}>
      <Window.Content scrollable>
        <Section>
          {(!FiltOn && (
            <Button.Confirm
              textAlign="center"
              fluid
              icon="power-off"
              fontSize="20px"
              color="good"
              onClick={() => act('activate_filt')}
            >
              Start Filtration
            </Button.Confirm>
          )) || (
            <NoticeBox textAlign="center" success={1} fontSize="20px">
              Filtration is online
            </NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
