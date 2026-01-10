import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Button, Flex, NoticeBox, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  has_divider: BooleanLike;
  door_id: string;
  has_flash: BooleanLike;
  open_door: BooleanLike;
  open_shutter: BooleanLike;
  flash_charging: BooleanLike;
};

export const ResearchDoorDisplay = () => {
  const { act, data } = useBackend<Data>();

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
                <Button fluid icon="lock-open" onClick={() => act('shutter')}>
                  Open shutter
                </Button>
              )) || (
                <Button fluid icon="lock" onClick={() => act('shutter')}>
                  Close shutter
                </Button>
              )}
            </Flex.Item>
            <Flex.Item>
              {(!data.open_door && (
                <Button fluid icon="door-open" onClick={() => act('door')}>
                  Open door
                </Button>
              )) || (
                <Button fluid icon="door-closed" onClick={() => act('door')}>
                  Close door
                </Button>
              )}
            </Flex.Item>
            {!!data.has_divider && (
              <Flex.Item>
                <Button
                  fluid
                  icon="arrows-alt-v"
                  onClick={() => act('divider')}
                >
                  Toggle divider
                </Button>
              </Flex.Item>
            )}
            {!!data.has_flash && (
              <Flex.Item>
                {(!data.flash_charging && (
                  <Button fluid icon="sun" onClick={() => act('flash')}>
                    Activate flash
                  </Button>
                )) || (
                  <Button fluid color="bad" icon="sync-alt">
                    Flash recharging!
                  </Button>
                )}
              </Flex.Item>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
