import { useBackend } from '../backend';
import { Section, NoticeBox, Button } from '../components';
import { Window } from '../layouts';

export const FiltrationControl = (_props, context) => {
  const { act, data } = useBackend(context);

  const FiltOn = data.filt_on;

  return (
    <Window width={350} height={150}>
      <Window.Content scrollable>
        <Section>
          {(!FiltOn && (
            <Button.Confirm
              textAlign="center"
              fluid={1}
              icon="power-off"
              content="Start Filtration"
              fontSize="20px"
              color="good"
              onClick={() => act('activate_filt')}
            />
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
