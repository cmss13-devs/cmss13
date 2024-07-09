import { useBackend } from '../backend';
import { Button, Dimmer, Icon, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const NuclearBomb = () => {
  const { act, data } = useBackend();

  const cantNuke = (!data.anchor, !!data.safety, !data.decryption_complete);
  const cantDecrypt = (!data.anchor, data.decryption_complete);

  return (
    <Window theme="retro" width={350} height={250}>
      <Window.Content scrollable>
        <Section>
          <Stack height="100%" direction="column">
            <Stack.Item>
              <NoticeBox textAlign="center">
                {data.decryption_complete
                  ? 'Decryption complete.'
                  : `Decryption time left :
                  ${data.decryption_time} minutes`}
              </NoticeBox>
            </Stack.Item>
            <Stack.Item>
              <NoticeBox danger textAlign="center">
                {data.timing
                  ? `Time until detonation :
                  ${data.timeleft}`
                  : 'Not currently active.'}
              </NoticeBox>
            </Stack.Item>
            <Stack.Item>
              {(!data.safety && (
                <Button fluid icon="lock" onClick={() => act('toggleSafety')}>
                  Enable safety
                </Button>
              )) || (
                <Button.Confirm
                  fluid
                  icon="exclamation-triangle"
                  onClick={() => act('toggleSafety')}
                >
                  Disable safety
                </Button.Confirm>
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.command_lockout && (
                <Button
                  fluid
                  icon="lock"
                  onClick={() => act('toggleCommandLockout')}
                >
                  Enable command lockout
                </Button>
              )) || (
                <Button.Confirm
                  fluid
                  icon="exclamation-triangle"
                  onClick={() => act('toggleCommandLockout')}
                >
                  Disable command lockout
                </Button.Confirm>
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.anchor && (
                <Button fluid icon="lock" onClick={() => act('toggleAnchor')}>
                  Activate anchor
                </Button>
              )) || (
                <Button.Confirm
                  fluid
                  icon="lock-open"
                  onClick={() => act('toggleAnchor')}
                >
                  Deactivate anchor
                </Button.Confirm>
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.decrypting && (
                <Button.Confirm
                  fluid
                  icon="exclamation-triangle"
                  color="green"
                  disabled={cantDecrypt}
                  onClick={() => act('toggleEncryption')}
                >
                  Start decryption
                </Button.Confirm>
              )) || (
                <Button.Confirm
                  fluid
                  icon="power-off"
                  onClick={() => act('toggleEncryption')}
                >
                  Stop decryption
                </Button.Confirm>
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.timing && (
                <Button.Confirm
                  fluid
                  icon="exclamation-triangle"
                  color="red"
                  disabled={cantNuke}
                  onClick={() => act('toggleNuke')}
                >
                  Activate nuke
                </Button.Confirm>
              )) || (
                <Button.Confirm
                  fluid
                  icon="power-off"
                  onClick={() => act('toggleNuke')}
                >
                  Deactivate nuke
                </Button.Confirm>
              )}
            </Stack.Item>
          </Stack>
          {!data.allowed && (
            <Dimmer fontSize="32px">
              <Icon name="exclamation-triangle" />
              {' Access Denied!'}
            </Dimmer>
          )}
          {!!data.being_used && (
            <Dimmer fontSize="32px">
              <Icon name="cog" spin />
              {' Processing...'}
            </Dimmer>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
