import { useBackend } from 'tgui/backend';
import { Button, NoticeBox, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = { filt_on: boolean };

export const FiltrationControl = () => {
  const { act, data } = useBackend<Data>();

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
            <NoticeBox textAlign="center" success fontSize="20px">
              Filtration is online
            </NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
