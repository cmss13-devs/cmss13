import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const SquadMod = (props) => {
  const { act, data } = useBackend();
  const { squads = [], human, id_name, has_id } = data;
  return (
    <Window width={400} height={300}>
      <Window.Content>
        <Section>
          <Stack vertical>
            <Stack.Item>
              <Button fluid icon="eject" onClick={() => act('PRG_eject')}>
                {id_name}
              </Button>
            </Stack.Item>
            {!has_id && (
              <Stack.Item>
                <NoticeBox>
                  Insert ID of person, that you want transfer.
                </NoticeBox>
              </Stack.Item>
            )}
            {!human && (
              <Stack.Item>
                <NoticeBox>
                  Ask or force person, to place hand on my scanner.
                </NoticeBox>
              </Stack.Item>
            )}
            {!!human && (
              <Stack.Item>
                <NoticeBox>Selected for squad transfer: {human}</NoticeBox>
              </Stack.Item>
            )}
          </Stack>
        </Section>
        {!!(human && has_id) && (
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
