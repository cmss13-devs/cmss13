import { useBackend } from '../backend';
import { Button, Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const ResearchDoorDisplay = () => {
  const { act, data } = useBackend();

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
                  fluid
                  icon="lock-open"
                  content="Open shutter"
                  onClick={() => act('shutter')}
                />
              )) || (
                <Button
                  fluid
                  icon="lock"
                  content="Close shutter"
                  onClick={() => act('shutter')}
                />
              )}
            </Flex.Item>
            <Flex.Item>
              {(!data.open_door && (
                <Button
                  fluid
                  icon="door-open"
                  content="Open door"
                  onClick={() => act('door')}
                />
              )) || (
                <Button
                  fluid
                  icon="door-closed"
                  content="Close door"
                  onClick={() => act('door')}
                />
              )}
            </Flex.Item>
            {!!data.has_divider && (
              <Flex.Item>
                <Button
                  fluid
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
                    fluid
                    icon="sun"
                    content="Activate flash"
                    onClick={() => act('flash')}
                  />
                )) || (
                  <Button
                    fluid
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
