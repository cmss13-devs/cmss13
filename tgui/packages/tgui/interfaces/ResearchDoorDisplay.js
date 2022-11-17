import { useBackend } from '../backend';
import { Button, Section, Flex, NoticeBox } from '../components';
import { Window } from '../layouts';

export const ResearchDoorDisplay = (_props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window width={350} height={170}>
      <Window.Content scrollable>
        <Section>
          <Flex height="100%" direction="column">
            <Flex.Item>
              <NoticeBox info textAlign="center">
                Linked door : {data.door_id}
              </NoticeBox>
            </Flex.Item>
            <Flex.Item>
              {(!data.open_shutter && (
                <Button
                  fluid={1}
                  icon="lock-open"
                  content="Open shutter"
                  onClick={() => act('shutter')}
                />
              )) || (
                <Button
                  fluid={1}
                  icon="lock"
                  content="Close shutter"
                  onClick={() => act('shutter')}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {(!data.open_door && (
                <Button
                  fluid={1}
                  icon="door-open"
                  content="Open door"
                  onClick={() => act('door')}
                />
              )) || (
                <Button
                  fluid={1}
                  icon="door-closed"
                  content="Close door"
                  onClick={() => act('door')}
                />
              )}
            </Flex.Item>
            {!!data.has_divider && (
              <Flex.Item>
                <Button
                  fluid={1}
                  icon="arrows-alt-v"
                  content="Toggle divider"
                  onClick={() => act('divider')}
                />
              </Flex.Item>
            )}
            {!!data.has_flash && (
              <Flex.Item>
                {(!data.flash_charging && (
                  <Button
                    fluid={1}
                    icon="sun"
                    content="Activate flash"
                    onClick={() => act('flash')}
                  />
                )) || (
                  <Button
                    fluid={1}
                    color="bad"
                    icon="sync-alt"
                    content="Flash recharging!"
                  />
                )}
              </Flex.Item>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
