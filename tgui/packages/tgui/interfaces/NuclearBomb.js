import { useBackend } from '../backend';
import { Button, Section, Flex, NoticeBox, Dimmer, Icon } from '../components';
import { Window } from '../layouts';

export const NuclearBomb = (_props, context) => {
  const { act, data } = useBackend(context);

  const cantNuke = (
    !data.anchor,
    !!data.safety);

  return (
    <Window
      width={350}
      height={170}>
      <Window.Content scrollable>
        <Section>
          <Flex height="100%" direction="column">
            <Flex.Item>
              <NoticeBox danger textAlign="center">
                {data.timing
                  ? `Time until detonation :
                  ${data.timeleft}`
                  : 'Not currently active.'}
              </NoticeBox>
            </Flex.Item>
            <Flex.Item>
              {!data.safety && (
                <Button
                  fluid={1}
                  icon="lock"
                  content="Enable safety"
                  onClick={() => act('toggleSafety')}
                />
              ) || (
                <Button.Confirm
                  fluid={1}
                  icon="exclamation-triangle"
                  content="Disable safety"
                  onClick={() => act('toggleSafety')}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {!data.command_lockout && (
                <Button
                  fluid={1}
                  icon="lock"
                  content="Enable command lockout"
                  onClick={() => act('toggleCommandLockout')}
                />
              ) || (
                <Button.Confirm
                  fluid={1}
                  icon="exclamation-triangle"
                  content="Disable command lockout"
                  onClick={() => act('toggleCommandLockout')}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {!data.anchor && (
                <Button
                  fluid={1}
                  icon="lock"
                  content="Activate anchor"
                  onClick={() => act('toggleAnchor')}
                />
              ) || (
                <Button.Confirm
                  fluid={1}
                  icon="lock-open"
                  content="Deactivate anchor"
                  onClick={() => act('toggleAnchor')}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {!data.timing && (
                <Button.Confirm
                  fluid={1}
                  icon="exclamation-triangle"
                  color="red"
                  content="Activate nuke"
                  disabled={cantNuke}
                  onClick={() => act('toggleNuke')}
                />
              ) || (
                <Button.Confirm
                  fluid={1}
                  icon="power-off"
                  content="Deactivate nuke"
                  onClick={() => act('toggleNuke')}
                />
              )}
            </Flex.Item>
          </Flex>
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
