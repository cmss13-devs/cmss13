import { useBackend } from '../backend';
import { Button, Section, NoticeBox, Dimmer, Icon, Stack } from '../components';
import { Window } from '../layouts';

export const NuclearBomb = (_props, context) => {
  const { act, data } = useBackend(context);

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
                <Button
                  fluid={1}
                  icon="lock"
                  content="Enable safety"
                  onClick={() => act('toggleSafety')}
                />
              )) || (
                <Button.Confirm
                  fluid={1}
                  icon="exclamation-triangle"
                  content="Disable safety"
                  onClick={() => act('toggleSafety')}
                />
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.command_lockout && (
                <Button
                  fluid={1}
                  icon="lock"
                  content="Enable command lockout"
                  onClick={() => act('toggleCommandLockout')}
                />
              )) || (
                <Button.Confirm
                  fluid={1}
                  icon="exclamation-triangle"
                  content="Disable command lockout"
                  onClick={() => act('toggleCommandLockout')}
                />
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.anchor && (
                <Button
                  fluid={1}
                  icon="lock"
                  content="Activate anchor"
                  onClick={() => act('toggleAnchor')}
                />
              )) || (
                <Button.Confirm
                  fluid={1}
                  icon="lock-open"
                  content="Deactivate anchor"
                  onClick={() => act('toggleAnchor')}
                />
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.decrypting && (
                <Button.Confirm
                  fluid={1}
                  icon="exclamation-triangle"
                  color="green"
                  content="Start decryption"
                  disabled={cantDecrypt}
                  onClick={() => act('toggleEncryption')}
                />
              )) || (
                <Button.Confirm
                  fluid={1}
                  icon="power-off"
                  content="Stop decryption"
                  onClick={() => act('toggleEncryption')}
                />
              )}
            </Stack.Item>
            <Stack.Item>
              {(!data.timing && (
                <Button.Confirm
                  fluid={1}
                  icon="exclamation-triangle"
                  color="red"
                  content="Activate nuke"
                  disabled={cantNuke}
                  onClick={() => act('toggleNuke')}
                />
              )) || (
                <Button.Confirm
                  fluid={1}
                  icon="power-off"
                  content="Deactivate nuke"
                  onClick={() => act('toggleNuke')}
                />
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
