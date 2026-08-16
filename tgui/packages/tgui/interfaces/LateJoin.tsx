import { classes } from 'common/react';
import { type ComponentProps } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Icon,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type RoleInformation = {
  readonly Title: string;
  readonly DisplayTitle: string;
  readonly Slots: number;
  readonly Players: number;
  readonly Active: number;
};

type LateJoinData = {
  HijackInitiated?: boolean;
  Categories: Object;
};

// Specific ordering for role categories
const CategoryOrder = [
  'Marines',
  'Command',
  'Auxiliary Combat Support',
  'Requisitions',
  'Medbay',
  'Military Police',
  'Engineering',
  'Miscellaneous',
  'Other',
];

export const LateJoin = (props, context) => {
  const { act, data } = useBackend<LateJoinData>();

  return (
    <Window theme={'crtgreen'} width={600} height={600}>
      <Window.Content className="LateJoin" scrollable>
        {data.HijackInitiated ? (
          <Box>
            <Stack
              className="HijackIndicator"
              align="center"
              justify="space-around"
            >
              <Stack.Item>
                <Icon name="warning" size={2}></Icon>
              </Stack.Item>
              <Stack.Item>
                <h1>HIJACK IN PROGRESS</h1>
              </Stack.Item>
              <Stack.Item>
                <Icon name="warning" size={2}></Icon>
              </Stack.Item>
            </Stack>
            <Divider></Divider>
          </Box>
        ) : null}
        {CategoryOrder.map((category) => {
          return category in data.Categories ? (
            data.Categories[category].length > 0 ? (
              <RoleCategory
                key={category}
                category={category}
                roles={data.Categories[category]}
              />
            ) : null
          ) : null;
        })}
      </Window.Content>
    </Window>
  );
};

type RoleIconProps = ComponentProps<'img'> & {
  readonly role: string;
};

const RoleIcon = (props: RoleIconProps) => {
  const { role } = props;
  return (
    <i
      className={classes(['RoleIcon', role.toLowerCase().replaceAll(' ', '_')])}
    />
  );
};

type RoleSlotInfoProps = ComponentProps<typeof Box> & {
  readonly role: RoleInformation;
};
const RoleSlotInfo = (props: RoleSlotInfoProps) => {
  const { role } = props;

  const infSlots = role.Slots === -1;
  const roleSlots = 'x' + role.Slots;
  let slotClasses = ['SlotCount'];

  return (
    <Flex
      direction="row"
      className="SlotInfo"
      justify="space-evenly"
      align="center"
    >
      <Flex.Item>
        <Flex
          direction="row"
          align="center"
          justify="space-evenly"
          className="SlotInfoRow"
        >
          <Flex.Item className="SlotInfoRow big-text">
            <Icon name="users" />
          </Flex.Item>
          <Flex.Item className="SlotInfoRow big-text">x{role.Active}</Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item>
        <Flex direction="row" align="center" justify="space-evenly">
          <Flex.Item className="SlotInfoRow big-text">
            <Icon name="door-open" />
          </Flex.Item>
          <Flex.Item className="SlotInfoRow big-text">
            {infSlots ? <Icon name="infinity"></Icon> : <Box>{roleSlots}</Box>}
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

type RoleCategoryProps = ComponentProps<typeof Flex> & {
  readonly category: string;
  readonly roles: Array<RoleInformation>;
};

const RoleCategory = (props: RoleCategoryProps) => {
  const { category, roles } = props;
  const { act } = useBackend<LateJoinData>();

  return (
    <Section title={category} className="RoleCategory">
      <Stack vertical>
        {roles.map((role) => {
          return (
            <Stack.Item key={role.Title}>
              <Button
                className="JoinButton"
                fluid
                onClick={() => act(role.Title)}
              >
                <Flex direction="row" justify="flex-start" align="center">
                  <Flex.Item grow={1}>
                    <Stack align="center">
                      <Stack.Item>
                        <RoleIcon role={role.Title} />
                      </Stack.Item>
                      <Stack.Item>
                        <h3 className="big-text">{role.DisplayTitle}</h3>
                      </Stack.Item>
                    </Stack>
                  </Flex.Item>
                  <Flex.Item grow={1}>
                    <RoleSlotInfo role={role} />
                  </Flex.Item>
                  <Flex.Item>
                    <Box className="medium-text">
                      Join
                      <Icon name="caret-right"></Icon>
                    </Box>
                  </Flex.Item>
                </Flex>
              </Button>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};
