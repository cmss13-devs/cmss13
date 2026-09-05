import { classes } from 'common/react';
import { storage } from 'common/storage';
import { useEffect, useState } from 'react';
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
  UPPEnabled: boolean;
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

  const [themeDisabled, setThemeDisabled] = useState<boolean | undefined>();

  useEffect(() => {
    storage.get('lobby-theme-disabled').then((val) => setThemeDisabled(!!val));
  }, []);

  const theme = themeDisabled
    ? 'weyland_yutani'
    : data.UPPEnabled
      ? 'crtred'
      : 'crtgreen';
  return (
    <Window theme={theme} width={650} height={750}>
      <Window.Content className="LateJoin" scrollable>
        {(data.HijackInitiated === true) ? (
          <Box>
            <Stack
              className="HijackIndicator"
              align="center"
              justify="space-around"
            >
              <Stack.Item>
                <Icon name="warning" size={2} />
              </Stack.Item>
              <Stack.Item>
                <h1>HIJACK IN PROGRESS</h1>
              </Stack.Item>
              <Stack.Item>
                <Icon name="warning" size={2} />
              </Stack.Item>
            </Stack>
            <Divider />
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
  const normalizedRoleName = role.toLowerCase().replaceAll(' ', '_');
  return (
    <i
      className={classes([
        'RoleIcon',
        'role_icons8x8',
        `${normalizedRoleName}`,
      ])}
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

  return (
    <Flex direction="row" justify="space-around" align="flex-end">
      <Flex.Item basis="30%">
        <Flex direction="row" align="center">
          <Flex.Item basis="60%" className="SlotInfoRow big-text">
            <Icon name="users" />
          </Flex.Item>
          <Flex.Item basis="40%" className="SlotInfoRow big-text">x{role.Active}</Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item basis="30%">
        <Flex direction="row" align="center">
          <Flex.Item basis="60%" className="SlotInfoRow big-text">
            <Icon name="door-open" />
          </Flex.Item>
          <Flex.Item basis="40%" className="SlotInfoRow big-text">
            {infSlots ? <Icon name="infinity" /> : roleSlots}
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
                <Flex direction="row" align="center">
                  <Flex.Item basis="55%" className="RoleTitle">
                    <Stack align="center">
                      <Stack.Item>
                        <RoleIcon role={role.Title} />
                      </Stack.Item>
                      <Stack.Item>
                        <h3 className="big-text">{role.DisplayTitle}</h3>
                      </Stack.Item>
                    </Stack>
                  </Flex.Item>
                  <Flex.Item basis="40%" className="RoleSlotInfo">
                    <RoleSlotInfo role={role} />
                  </Flex.Item>
                  <Flex.Item basis="15%" className="RoleJoin">
                    <Flex justify="flex-end">
                      <Flex.Item>
                        <Box className="medium-text">
                          Join
                          <Icon name="caret-right" />
                        </Box>
                      </Flex.Item>
                    </Flex>

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
