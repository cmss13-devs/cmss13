import { type BooleanLike, classes } from 'common/react';
import { storage } from 'common/storage';
import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Dropdown, Icon, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { LoadingScreen } from './common/LoadingToolbox';

type RoleInformation = {
  readonly Title: string;
  readonly DisplayTitle: string;
  readonly IsLeader: BooleanLike;
  readonly Available: BooleanLike;
  readonly WhitelistLocked: BooleanLike;
  readonly JobBanned: BooleanLike;
  readonly Squads:
    | {
        readonly Name: string;
        readonly Color: string;
        readonly Open: number | null;
      }[]
    | null;
  readonly Slots: number;
  readonly Players: number;
  readonly Active: number;
};

type LateJoinData = {
  EvacInitiated?: BooleanLike;
  Categories: Record<string, RoleInformation[]>;
  UPPEnabled: BooleanLike;
  PreferredSquad: string;
  SquadPreferences: string[];
};

// Same order as on the crew manifest
const CategoryOrder = [
  { name: 'Command', department: 'command' },
  { name: 'Auxiliary Combat Support', department: 'auxiliary' },
  { name: 'Marines', department: 'marines' },
  { name: 'Military Police', department: 'security' },
  { name: 'Engineering', department: 'engineering' },
  { name: 'Requisitions', department: 'requisitions' },
  { name: 'Medbay', department: 'medical' },
  { name: 'Miscellaneous', department: 'miscellaneous' },
  { name: 'Other', department: 'other' },
];

export const LateJoin = () => {
  const { act, data } = useBackend<LateJoinData>();

  const [themeDisabled, setThemeDisabled] = useState<boolean | undefined>();

  useEffect(() => {
    storage.get('lobby-theme-disabled').then((val) => setThemeDisabled(!!val));
  }, []);

  if (themeDisabled === undefined) {
    return (
      <Window width={900} height={800}>
        <Window.Content>
          <LoadingScreen />
        </Window.Content>
      </Window>
    );
  }

  const theme = themeDisabled
    ? 'weyland_yutani'
    : data.UPPEnabled
      ? 'crtred'
      : 'crtgreen';
  return (
    <Window theme={theme} width={900} height={800}>
      <Window.Content scrollable overflowY="auto">
        <Box className="LateJoin">
          <Stack
            className="LateJoin__legend"
            align="center"
            justify="space-between"
          >
            <Stack.Item>
              <Icon name="door-open" /> Open slots{' / '}
              <Icon name="users" /> Active / total
            </Stack.Item>
            <Stack.Item>
              <Stack align="center">
                <Stack.Item>Squad preference:</Stack.Item>
                <Stack.Item>
                  <Dropdown
                    width="14em"
                    menuWidth="14em"
                    selected={data.PreferredSquad}
                    displayText={<Box color="#000">{data.PreferredSquad}</Box>}
                    options={data.SquadPreferences}
                    onSelected={(squad) =>
                      act('set_preferred_squad', { squad })
                    }
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
          {!!data.EvacInitiated && (
            <Box className="LateJoin__evacuation">
              <Icon name="warning" /> EVACUATION IN PROGRESS
            </Box>
          )}
          <Box className="LateJoin__categories">
            {CategoryOrder.map(({ name, department }) =>
              data.Categories[department]?.length ? (
                <RoleCategory
                  key={name}
                  category={name}
                  department={department}
                  roles={data.Categories[department]}
                />
              ) : null,
            )}
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

const RoleIcon = ({ role }: { readonly role: string }) => {
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

type RoleCategoryProps = {
  readonly category: string;
  readonly department: string;
  readonly roles: Array<RoleInformation>;
};

const RoleCategory = (props: RoleCategoryProps) => {
  const { category, department, roles } = props;
  const { act } = useBackend<LateJoinData>();
  const hasSquads = roles.some((role) => role.Squads?.length);

  return (
    <Box
      className={classes(['RoleCategory', hasSquads && 'RoleCategory--squads'])}
    >
      <Box
        className={`LateJoin__row LateJoin__categoryHeader text-dept-${department}`}
        color="#ccc"
      >
        <Box as="h2" className="LateJoin__categoryName">
          {category}
        </Box>
        {hasSquads && <Box fontSize="0.667em">Squads</Box>}
        <Box fontSize="0.667em">Open</Box>
        <Box fontSize="0.667em">Active/total</Box>
      </Box>
      {roles.map((role) => (
        <Button
          key={role.Title}
          fluid
          compact
          disabled={!role.Available}
          tooltip={
            role.JobBanned
              ? `You are job banned from ${role.DisplayTitle}.`
              : role.WhitelistLocked
                ? `${role.DisplayTitle} requires whitelist access.`
                : undefined
          }
          className={classes([
            `bg-dept-${department}`,
            `border-dept-${department}`,
            role.IsLeader && 'LateJoin__leader',
            (role.JobBanned || role.WhitelistLocked) && 'LateJoin__restricted',
          ])}
          style={{
            backgroundColor: '#ccc',
            borderColor: '#ccc',
            color: '#000',
          }}
          onClick={() => act(role.Title)}
        >
          <Box className="LateJoin__row">
            <RoleIcon role={role.Title} />
            <Box className="LateJoin__roleName">{role.DisplayTitle}</Box>
            {hasSquads && (
              <div
                className="LateJoin__squadAvailability"
                onClick={(event) => event.stopPropagation()}
                onKeyDown={(event) => {
                  if (event.key === 'Enter' || event.key === ' ') {
                    event.stopPropagation();
                  }
                }}
              >
                {role.Squads?.map((squad) => {
                  const open = squad.Open;
                  const hasSpace =
                    !!role.Available && (open === null || open > 0);
                  const availability = !role.Available
                    ? 'role unavailable'
                    : open === null
                      ? 'unlimited openings'
                      : `${open} opening${open === 1 ? '' : 's'}`;
                  return (
                    <button
                      key={squad.Name}
                      type="button"
                      disabled={!hasSpace}
                      className={classes([
                        'LateJoin__squadBadge',
                        hasSpace
                          ? `bg-dept-${squad.Name.toLowerCase().replace(/\s+/g, '-')}`
                          : 'LateJoin__squadBadge--full',
                      ])}
                      style={{
                        backgroundColor: hasSpace ? squad.Color : undefined,
                      }}
                      title={
                        hasSpace
                          ? `Join ${squad.Name} as ${role.DisplayTitle}: ${availability}`
                          : `${squad.Name}: ${availability}`
                      }
                      aria-label={`Join ${squad.Name} as ${role.DisplayTitle}`}
                      onClick={() => act(role.Title, { squad: squad.Name })}
                    >
                      {squad.Name[0]}
                    </button>
                  );
                })}
              </div>
            )}
            <Box>
              {role.Slots === -1 ? (
                <Icon name="infinity" ml={0} mr={0} />
              ) : (
                Math.max(0, role.Slots - role.Players)
              )}
            </Box>
            <Box>
              {role.Active}
              {' / '}
              {role.Slots === -1 ? (
                <Icon name="infinity" ml={0} mr={0} />
              ) : (
                role.Slots
              )}
            </Box>
          </Box>
          {!!(role.JobBanned || role.WhitelistLocked) && (
            <Box className="LateJoin__restrictionOverlay">
              <Icon name={role.JobBanned ? 'ban' : 'lock'} ml={0} mr={0} />
              {role.JobBanned ? 'JOB BANNED' : 'WHITELISTED'}
              <Icon name={role.JobBanned ? 'ban' : 'lock'} ml={0} mr={0} />
            </Box>
          )}
        </Button>
      ))}
    </Box>
  );
};
