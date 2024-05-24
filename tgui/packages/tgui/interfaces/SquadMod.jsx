import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const SquadMod = (props) => {
  const { act, data } = useBackend();
  const { squads = [], human, id_name, has_id, authenticated } = data;
  return (
    <Window width={450} height={520}>
      <Window.Content>
        <Section
          title={id_name ? id_name : 'No Card Inserted'}
          buttons={
            <Button
              icon={authenticated ? 'sign-out-alt' : 'sign-in-alt'}
              content={authenticated ? 'Log Out' : 'Log In'}
              color={authenticated ? 'bad' : 'good'}
              onClick={() => {
                act(authenticated ? 'logout' : 'authenticate');
              }}
            />
          }
        >
          <Button
            fluid
            icon="eject"
            content={id_name ? id_name : '....'}
            onClick={() => act('eject')}
          />
        </Section>
        {!!has_id && !!authenticated && (
          <Section>
            <Stack vertical>
              <Stack.Item>
                <NoticeBox>
                  {human
                    ? `Selected for squad transfer: ${human}`
                    : 'Ask or force person to place hand on my scanner.'}
                </NoticeBox>
              </Stack.Item>
            </Stack>
          </Section>
        )}
        {!!human && !!has_id && !!authenticated && (
          <Section title="Squad Transfer">
            {squads.map((entry) => (
              <Button
                key={entry.name}
                fluid
                backgroundColor={entry.color}
                onClick={() =>
                  act('PRG_squad', {
                    name: entry.name,
                  })
                }
              >
                {entry.name}
              </Button>
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
