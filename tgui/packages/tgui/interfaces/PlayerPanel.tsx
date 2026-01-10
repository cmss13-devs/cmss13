import type { BooleanLike } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Input,
  Section,
  Slider,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

const PAGES = [
  {
    title: 'General',
    component: () => GeneralActions,
    color: 'green',
    icon: 'tools',
  },
  {
    title: 'Punish',
    component: () => PunishmentActions,
    color: 'red',
    icon: 'gavel',
  },
  {
    title: 'Physical',
    component: () => PhysicalActions,
    color: 'red',
    icon: 'bolt',
    canAccess: (data) => {
      return !!data.is_human || !!data.is_xeno;
    },
  },
  {
    title: 'Transform',
    component: () => TransformActions,
    color: 'orange',
    icon: 'exchange-alt',
    canAccess: (data) => {
      return hasPermission(data, 'mob_transform');
    },
  },
  {
    title: 'Fun',
    component: () => FunActions,
    color: 'blue',
    icon: 'laugh',
    canAccess: (data) => {
      return hasPermission(data, 'fun');
    },
  },
  {
    title: 'Antag',
    component: () => AntagActions,
    color: 'blue',
    icon: 'crosshairs',
    canAccess: (data) => {
      return data.is_human || data.is_xeno;
    },
  },
];

const hasPermission = (data, action) => {
  if (!(action in data.glob_pp_actions)) return false;

  const action_data = data.glob_pp_actions[action];
  return !!(action_data.permissions_required & data.current_permissions);
};

type ClientData = {
  client_key: string;
  client_ckey: string;
  client_muted: number;
  client_age: number;
  first_join: string;
  client_rank: string;
  client_name_banned_status: BooleanLike;
};

type StatusFlags = {
  Stun: number;
  Knockdown: number;
  Knockout: number;
  Push: number;
  Slow: number;
  Daze: number;
  Godmode: number;
  'No Permanent Damage': number;
};

type MobLimbs = {
  Head: string;
  'Left leg': string;
  'Right leg': string;
  'Left arm': string;
  'Right arm': string;
};

type TransformEntry = { name: String; key: string; color: string };

type Data = {
  mob_type: string;
  is_human: BooleanLike;
  is_xeno: BooleanLike;
  glob_status_flags: StatusFlags;
  glob_limbs: MobLimbs;
  glob_hives: Record<string, number>;
  glob_mute_bits: { name: string; bitflag: number }[];
  glob_pp_actions: {
    name: string;
    avtion_tag: string;
    permissions_required: BooleanLike;
  }[];
  glob_span: { name: string; span: string }[];
  glob_pp_transformables: {
    Humanoid: TransformEntry[];
    'Alien Tier 1': TransformEntry[];
    'Alien Tier 2': TransformEntry[];
    'Alien Tier 3': TransformEntry[];
    'Alien Tier 4': TransformEntry[];
    Miscellaneous: TransformEntry[];
  };
  mob_name: string;
  mob_sleeping: number;
  mob_frozen: BooleanLike;
  mob_speed: number;
  mob_status_flags: number;
  mob_feels_pain: BooleanLike;
  current_permissions: number;
} & Partial<ClientData>;

export const PlayerPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const [pageIndex, setPageIndex] = useState(0);
  const [canModifyCkey, setModifyCkey] = useState(false);
  const PageComponent = PAGES[pageIndex].component();
  const {
    mob_name,
    mob_type,
    client_key,
    client_ckey,
    client_rank,
    client_age,
    first_join,
  } = data;

  return (
    <Window title={`${mob_name} Player Panel`} width={600} height={500}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item width="80px" color="label">
                  Name:
                </Stack.Item>
                <Stack.Item grow align="right">
                  {(!!hasPermission(data, 'set_name') && (
                    <Input
                      width={25}
                      value={mob_name}
                      onChange={(e, value) => act('set_name', { name: value })}
                    />
                  )) ||
                    mob_name}
                </Stack.Item>
              </Stack>
              <Stack mt={1}>
                <Stack.Item width="80px" color="label">
                  Mob Type:
                </Stack.Item>
                <Stack.Item grow align="right">
                  {mob_type}
                </Stack.Item>
                <Stack.Item align="right">
                  <Button
                    icon="window-restore"
                    disabled={!hasPermission(data, 'access_variables')}
                    onClick={() => act('access_variables')}
                  >
                    Access Variables
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="window-restore"
                    disabled={!hasPermission(data, 'show_notes')}
                    onClick={() => act('access_playtimes')}
                  >
                    View Playtimes
                  </Button>
                </Stack.Item>
              </Stack>
              <Stack mt={1}>
                <Stack.Item width="80px" color="label">
                  Client:
                </Stack.Item>
                <Stack.Item grow align="left">
                  {((canModifyCkey || !client_key) &&
                    hasPermission(data, 'set_ckey') && (
                      <Input
                        value={client_ckey}
                        onChange={(e, value) =>
                          act('set_ckey', { ckey: value })
                        }
                      />
                    )) || <Box inline>{client_key}</Box>}
                </Stack.Item>
                {!!client_ckey && (
                  <Stack.Item align="right">
                    {!!hasPermission(data, 'set_name') && (
                      <Button
                        ml={1}
                        icon={canModifyCkey ? 'lock-open' : 'lock'}
                        onClick={() => setModifyCkey(!canModifyCkey)}
                        color={canModifyCkey ? 'average' : 'good'}
                      >
                        {canModifyCkey ? 'Unlocked' : 'Locked'}
                      </Button>
                    )}
                    <Button
                      ml={1}
                      icon="comment-dots"
                      disabled={!hasPermission(data, 'private_message')}
                      onClick={() => act('private_message')}
                    >
                      Private Message
                    </Button>
                    <Button
                      ml={1}
                      icon="phone-alt"
                      disabled={!hasPermission(data, 'subtle_message')}
                      onClick={() => act('subtle_message')}
                    >
                      Subtle Message
                    </Button>
                  </Stack.Item>
                )}
              </Stack>
              {client_rank && (
                <Stack mt={1}>
                  <Stack.Item width="80px" color="label">
                    Rank:
                  </Stack.Item>
                  <Stack.Item grow align="left">
                    <Button
                      icon="window-restore"
                      disabled={!hasPermission(data, 'access_admin_datum')}
                      onClick={() => act('access_admin_datum')}
                    >
                      {client_rank}
                    </Button>
                  </Stack.Item>
                  <Stack.Item align="right">
                    <Button
                      ml={1}
                      icon="exclamation-triangle"
                      disabled={!hasPermission(data, 'alert_message')}
                      onClick={() => act('alert_message')}
                    >
                      Alert Message
                    </Button>
                  </Stack.Item>
                </Stack>
              )}
              {client_age && (
                <Stack mt={1}>
                  <Stack.Item width="80px" color="label">
                    Account age:
                  </Stack.Item>
                  <Stack.Item grow align="right">
                    {client_age}
                  </Stack.Item>
                </Stack>
              )}
              {first_join && (
                <Stack mt={1}>
                  <Stack.Item width="80px" color="label">
                    <Tooltip content="This is estimated, and depending on database integrity, may not be accurate to a user's first join date.">
                      <Box position="relative">First join:</Box>
                    </Tooltip>
                  </Stack.Item>
                  <Stack.Item grow align="right">
                    {first_join}
                  </Stack.Item>
                </Stack>
              )}
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item>
                <Section fitted>
                  <Tabs vertical>
                    {PAGES.map((page, i) => {
                      if (page.canAccess && !page.canAccess(data)) {
                        return;
                      }

                      return (
                        <Tabs.Tab
                          key={i}
                          color={page.color}
                          selected={i === pageIndex}
                          icon={page.icon}
                          onClick={() => setPageIndex(i)}
                        >
                          {page.title}
                        </Tabs.Tab>
                      );
                    })}
                  </Tabs>
                </Section>
              </Stack.Item>
              <Stack.Item position="relative" grow basis={0} ml={1}>
                <Section fill scrollable>
                  <PageComponent />
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const GeneralActions = (props) => {
  const { act, data } = useBackend<Data>();

  const { mob_sleeping, mob_frozen } = data;
  return (
    <>
      <Section title="Damage">
        <Stack align="right" fill>
          <Button.Confirm
            width="100%"
            icon="first-aid"
            color="green"
            confirmColor="green"
            disabled={!hasPermission(data, 'mob_rejuvenate')}
            onClick={() => act('mob_rejuvenate')}
          >
            Rejuvenate
          </Button.Confirm>
          <Button.Confirm
            width="100%"
            icon="skull"
            color="average"
            confirmColor="average"
            disabled={!hasPermission(data, 'mob_kill')}
            onClick={() => act('mob_kill')}
          >
            Kill
          </Button.Confirm>
          <Button.Confirm
            width="100%"
            icon="skull-crossbones"
            color="bad"
            confirmColor="bad"
            disabled={!hasPermission(data, 'mob_gib')}
            onClick={() => act('mob_gib')}
          >
            Gib
          </Button.Confirm>
        </Stack>
      </Section>

      <Section title="Teleportation">
        <Stack align="right" fill>
          <Button.Confirm
            width="100%"
            icon="reply"
            disabled={!hasPermission(data, 'mob_bring')}
            onClick={() => act('mob_bring')}
          >
            Bring
          </Button.Confirm>
          <Button
            width="100%"
            disabled={!hasPermission(data, 'jump_to')}
            onClick={() => act('mob_follow')}
          >
            Follow
          </Button>
          <Button
            width="100%"
            icon="share"
            disabled={!hasPermission(data, 'jump_to')}
            onClick={() => act('jump_to')}
          >
            Jump To
          </Button>
        </Stack>
      </Section>

      <Section title="Miscellaneous">
        <Stack align="right" fill>
          <Button.Checkbox
            width="100%"
            checked={mob_sleeping > 500}
            color={mob_sleeping > 500 ? 'good' : 'bad'}
            disabled={!hasPermission(data, 'mob_sleep')}
            onClick={() =>
              act('mob_sleep', { sleep: mob_sleeping > 500 ? false : true })
            }
          >
            Toggle Sleeping
          </Button.Checkbox>
          <Button.Checkbox
            width="100%"
            checked={mob_frozen}
            color={mob_frozen ? 'good' : 'bad'}
            disabled={!hasPermission(data, 'toggle_frozen')}
            onClick={() => act('toggle_frozen', { freeze: !mob_frozen })}
          >
            Toggle Frozen
          </Button.Checkbox>
          <Button
            width="100%"
            icon="history"
            disabled={!hasPermission(data, 'send_to_lobby')}
            onClick={() => act('send_to_lobby')}
          >
            Send Back to Lobby
          </Button>
        </Stack>
        {hasPermission(data, 'mob_force_emote') && (
          <Stack align="right" fill mt={2}>
            <Stack.Item width="100px" align="left" color="label">
              Force Say:
            </Stack.Item>
            <Stack.Item align="right" grow>
              <Input
                width="100%"
                onEnter={(e, value) => act('mob_force_say', { to_say: value })}
              />
            </Stack.Item>
          </Stack>
        )}
        {hasPermission(data, 'mob_force_emote') && (
          <Stack align="right" fill mt={2}>
            <Stack.Item width="100px" align="left" color="label">
              Force Emote:
            </Stack.Item>
            <Stack.Item align="right" grow>
              <Input
                width="100%"
                onEnter={(e, value) =>
                  act('mob_force_emote', { to_emote: value })
                }
              />
            </Stack.Item>
          </Stack>
        )}
      </Section>
    </>
  );
};

const PunishmentActions = (props) => {
  const { act, data } = useBackend<Data>();
  const { glob_mute_bits, client_muted = 0 } = data;
  return (
    <>
      <Section title="Banishment">
        <Stack align="right" fill>
          <Button.Confirm
            width="100%"
            icon="gavel"
            color="red"
            disabled={!hasPermission(data, 'mob_ban')}
            onClick={() => act('mob_ban')}
          >
            Timed Ban
          </Button.Confirm>
          <Button.Confirm
            width="100%"
            icon="gavel"
            color="red"
            disabled={!hasPermission(data, 'mob_eorg_ban')}
            onClick={() => act('mob_eorg_ban')}
          >
            EORG Ban
          </Button.Confirm>
          <Button
            width="100%"
            icon="ban"
            color="red"
            disabled={!hasPermission(data, 'mob_jobban')}
            onClick={() => act('mob_jobban')}
          >
            Job-ban
          </Button>
        </Stack>
      </Section>

      <Section title="Permanent Banishment">
        <Stack align="right" fill>
          <Button.Confirm
            width="100%"
            icon="gavel"
            color="red"
            disabled={!hasPermission(data, 'permanent_ban')}
            onClick={() => act('permanent_ban')}
          >
            Permanent Ban
          </Button.Confirm>
          <Button.Confirm
            width="100%"
            icon="gavel"
            color="red"
            disabled={!hasPermission(data, 'sticky_ban')}
            onClick={() => act('sticky_ban')}
          >
            Sticky Ban
          </Button.Confirm>
        </Stack>
      </Section>

      <Section title="Record-keeping">
        <Stack align="right" fill>
          <Button
            width="100%"
            icon="clipboard-list"
            color="average"
            disabled={!hasPermission(data, 'show_notes')}
            onClick={() => act('show_notes')}
          >
            Check Notes
          </Button>
          <Button
            width="100%"
            icon="clipboard-list"
            color="average"
            disabled={!hasPermission(data, 'check_ckey')}
            onClick={() => act('check_ckey')}
          >
            Check Ckey
          </Button>
        </Stack>
      </Section>

      <Section title="Mute">
        <Stack align="right" fill>
          {glob_mute_bits.map((bit, i) => {
            const isMuted = client_muted && client_muted & bit.bitflag;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                checked={isMuted}
                color={isMuted ? 'good' : 'bad'}
                disabled={!hasPermission(data, 'mob_mute')}
                onClick={() =>
                  act('mob_mute', {
                    mute_flag: !isMuted
                      ? client_muted | bit.bitflag
                      : client_muted & ~bit.bitflag,
                  })
                }
              >
                {bit.name}
              </Button.Checkbox>
            );
          })}
        </Stack>
      </Section>

      <Section title="Human Name">
        <Stack align="right" fill>
          <Button
            width="100%"
            icon="clipboard-list"
            color="average"
            disabled={!hasPermission(data, 'reset_human_name')}
            onClick={() => act('reset_human_name')}
          >
            Human name reset
          </Button>
          <Button
            width="100%"
            icon="clipboard-list"
            color="bad"
            disabled={!hasPermission(data, 'ban_human_name')}
            onClick={() => act('ban_human_name')}
          >
            {!data?.client_name_banned_status
              ? 'Human name ban'
              : 'Human name unban'}
          </Button>
        </Stack>
      </Section>
      <Section title="Xenomorph Name">
        <Stack align="right" fill>
          <Button
            width="100%"
            icon="clipboard-list"
            color="average"
            disabled={!hasPermission(data, 'reset_xeno_name')}
            onClick={() => act('reset_xeno_name')}
          >
            Xeno name reset
          </Button>
          <Button
            width="100%"
            icon="clipboard-list"
            color="bad"
            disabled={!hasPermission(data, 'ban_xeno_name')}
            onClick={() => act('ban_xeno_name')}
          >
            Xeno name ban
          </Button>
        </Stack>
      </Section>
    </>
  );
};

const TransformActions = (props) => {
  const { act, data } = useBackend<Data>();
  const { glob_pp_transformables } = data;
  return (
    <>
      {Object.keys(glob_pp_transformables).map((element, i) => (
        <Section title={element} key={i}>
          <Stack align="right" fill>
            {glob_pp_transformables[element].map((option, optionIndex) => (
              <Button.Confirm
                key={optionIndex}
                width="100%"
                icon={option.icon}
                color={option.color}
                disabled={!hasPermission(data, 'mob_transform')}
                onClick={() => act('mob_transform', { key: option.key })}
              >
                {option.name}
              </Button.Confirm>
            ))}
          </Stack>
        </Section>
      ))}
    </>
  );
};

const FunActions = (props) => {
  const { act, data } = useBackend<Data>();
  const { glob_span } = data;

  const [getSpanSetting, setSpanSetting] = useState(glob_span[0].span);
  const [lockExplode, setLockExplode] = useState(true);
  const [expPower, setExpPower] = useState(50);
  const [falloff, setFalloff] = useState(75);
  return (
    <>
      {hasPermission(data, 'mob_narrate') && (
        <Section title="Narrate">
          <Stack align="right" fill>
            {glob_span.map((spanData, i) => (
              <Button.Checkbox
                key={i}
                checked={getSpanSetting === spanData.span}
                onClick={() => setSpanSetting(spanData.span)}
              >
                {spanData.name}
              </Button.Checkbox>
            ))}
          </Stack>
          <Stack align="right" fill mt={2}>
            <Stack.Item width="100px" align="left" color="label">
              Narrate:
            </Stack.Item>
            <Stack.Item align="right" grow>
              <Input
                width="100%"
                onEnter={(e, value) =>
                  act('mob_narrate', {
                    to_narrate: `<span class='${getSpanSetting}'>${value}</span>`,
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Section>
      )}

      {hasPermission(data, 'mob_explode') && (
        <Section
          title="Explosion"
          buttons={
            <Button
              ml={1}
              icon={lockExplode ? 'lock' : 'lock-open'}
              onClick={() => setLockExplode(!lockExplode)}
              color={lockExplode ? 'good' : 'bad'}
            >
              {lockExplode ? 'Locked' : 'Unlocked'}
            </Button>
          }
        >
          <Stack align="right" fill mt={1}>
            <Stack.Item>
              <Button
                width="100%"
                color="red"
                disabled={lockExplode}
                onClick={() =>
                  act('mob_explode', { power: expPower, falloff: falloff })
                }
              >
                <Box height="100%" pt={2} pb={2} textAlign="center">
                  Detonate
                </Box>
              </Button>
            </Stack.Item>
            <Stack.Item ml={1} grow>
              <Slider
                unit="Explosive Power"
                value={expPower}
                onChange={(e, value) => setExpPower(value)}
                ranges={{
                  good: [0, 200],
                  average: [200, 400],
                  bad: [400, 500],
                }}
                minValue={0}
                maxValue={500}
              />
              <Slider
                unit="Falloff"
                value={falloff}
                onChange={(e, value) => setFalloff(value)}
                ranges={{
                  bad: [0, 10],
                  average: [10, 75],
                  good: [75, 200],
                }}
                minValue={1}
                maxValue={200}
                mt={1}
                stepPixelSize={2}
              />
            </Stack.Item>
          </Stack>
        </Section>
      )}
    </>
  );
};

const AntagActions = (props) => {
  const { act, data } = useBackend<Data>();
  const { glob_hives, is_xeno, is_human } = data;

  const [selectedHivenumber, setHivenumber] = useState(
    Object.keys(glob_hives)[0],
  );
  return (
    <>
      {!!is_human && (
        <Section title="Mutiny">
          <Stack align="right" fill>
            <Button
              width="100%"
              icon="chess-pawn"
              color="orange"
              disabled={!hasPermission(data, 'make_mutineer')}
              onClick={() => act('make_mutineer')}
            >
              Make Mutineer
            </Button>
            <Button
              width="100%"
              icon="crown"
              color="orange"
              disabled={!hasPermission(data, 'make_mutineer')}
              onClick={() => act('make_mutineer', { leader: true })}
            >
              Make Mutineering Leader
            </Button>
          </Stack>
        </Section>
      )}
      <Section
        title="Xenomorph"
        buttons={
          <Dropdown
            width={12}
            color="purple"
            menuWidth="12rem"
            selected={selectedHivenumber}
            options={Object.keys(glob_hives)}
            onSelected={(value) => setHivenumber(value)}
          />
        }
      >
        <Stack align="right" fill mt={1}>
          {!!is_human && (
            <>
              <Button
                width="100%"
                icon="chess-pawn"
                color="purple"
                disabled={!hasPermission(data, 'make_cultist')}
                onClick={() =>
                  act('make_cultist', {
                    hivenumber: glob_hives[selectedHivenumber],
                  })
                }
              >
                Make Xeno Cultist
              </Button>
              <Button
                width="100%"
                icon="crown"
                color="purple"
                disabled={!hasPermission(data, 'make_cultist')}
                onClick={() =>
                  act('make_cultist', {
                    leader: true,
                    hivenumber: glob_hives[selectedHivenumber],
                  })
                }
              >
                Make Xeno Cultist Leader
              </Button>
            </>
          )}
          {!!is_xeno && (
            <Button
              width="100%"
              icon="random"
              color="purple"
              onClick={() =>
                act('xeno_change_hivenumber', {
                  hivenumber: glob_hives[selectedHivenumber],
                })
              }
            >
              Change Hivenumber
            </Button>
          )}
        </Stack>
      </Section>
    </>
  );
};

const PhysicalActions = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    is_human,
    glob_limbs,
    mob_speed,
    mob_status_flags,
    glob_status_flags,
    mob_feels_pain,
  } = data;

  const limbs = Object.keys(glob_limbs);
  const limb_flags = limbs.map((_, i) => 1 << i);

  const [delimbOption, setDelimbOption] = useState(0);
  return (
    <>
      <Section title="Status Flags">
        {Object.keys(glob_status_flags).map((val, i) => (
          <Button.Checkbox
            key={i}
            disabled={!hasPermission(data, 'set_status_flags')}
            color={mob_status_flags & glob_status_flags[val] ? 'good' : 'bad'}
            checked={mob_status_flags & glob_status_flags[val]}
            onClick={() =>
              act('set_status_flags', {
                status_flags:
                  mob_status_flags & glob_status_flags[val]
                    ? mob_status_flags & ~glob_status_flags[val]
                    : mob_status_flags | glob_status_flags[val],
              })
            }
          >
            {val}
          </Button.Checkbox>
        ))}
        <Button.Checkbox
          disabled={!hasPermission(data, 'set_pain')}
          color={mob_feels_pain ? 'good' : 'bad'}
          checked={mob_feels_pain}
          onClick={() => act('set_pain', { feels_pain: !mob_feels_pain })}
        >
          Feels Pain
        </Button.Checkbox>
      </Section>
      {!!is_human && (
        <Section
          title="Limbs"
          buttons={
            <Stack align="right" fill>
              {limbs.map((val, index) => (
                <Button.Checkbox
                  key={index}
                  textAlign="center"
                  checked={delimbOption & limb_flags[index]}
                  onClick={() =>
                    setDelimbOption(
                      delimbOption & limb_flags[index]
                        ? delimbOption & ~limb_flags[index]
                        : delimbOption | limb_flags[index],
                    )
                  }
                >
                  {val}
                </Button.Checkbox>
              ))}
            </Stack>
          }
        >
          <Stack align="right" fill>
            <Button.Confirm
              width="100%"
              icon="unlink"
              color="red"
              disabled={!hasPermission(data, 'mob_delimb')}
              onClick={() =>
                act('mob_delimb', {
                  limbs: limb_flags.map(
                    (val, index) =>
                      !!(delimbOption & val) && glob_limbs[limbs[index]],
                  ),
                })
              }
            >
              Delimb
            </Button.Confirm>
            <Button.Confirm
              width="100%"
              icon="link"
              color="green"
              disabled={!hasPermission(data, 'mob_relimb')}
              onClick={() =>
                act('mob_relimb', {
                  limbs: limb_flags.map(
                    (val, index) =>
                      !!(delimbOption & val) && glob_limbs[limbs[index]],
                  ),
                })
              }
            >
              Relimb
            </Button.Confirm>
          </Stack>
        </Section>
      )}
      <Section title="Game">
        <Stack>
          {!!is_human && (
            <Button.Confirm
              icon="undo"
              width="100%"
              disabled={!hasPermission(data, 'cryo_human')}
              onClick={() => act('cryo_human')}
              tooltip="This will delete the mob, with all of their items and re-open the slot for other players to play."
            >
              Send to cryogenics
            </Button.Confirm>
          )}
          <Button.Confirm
            icon="dumpster"
            width="100%"
            disabled={!hasPermission(data, 'strip_equipment')}
            onClick={() => act('strip_equipment', { drop_items: true })}
          >
            Drop all items
          </Button.Confirm>
        </Stack>
        {!!is_human && (
          <Stack>
            <Button.Confirm
              icon="clipboard-list"
              width="100%"
              disabled={!hasPermission(data, 'set_squad')}
              onClick={() => act('set_squad')}
            >
              Set Squad
            </Button.Confirm>
            <Button.Confirm
              icon="clipboard-list"
              width="100%"
              disabled={!hasPermission(data, 'set_faction')}
              onClick={() => act('set_faction')}
            >
              Set Faction
            </Button.Confirm>
          </Stack>
        )}
        <Stack mt={1}>
          {hasPermission(data, 'set_speed') && (
            <Slider
              minValue={-10}
              maxValue={10}
              value={-mob_speed}
              stepPixelSize={6}
              step={0.25}
              onChange={(e, value) => act('set_speed', { speed: -value })}
              unit="Mob Speed"
            />
          )}
        </Stack>
      </Section>
      <Section title="Equipment">
        <Stack align="right" fill>
          <Button
            width="100%"
            icon="user-tie"
            disabled={!hasPermission(data, 'select_equipment')}
            onClick={() => act('select_equipment')}
            color="orange"
          >
            Select Equipment
          </Button>
          <Button
            width="100%"
            icon="trash-alt"
            disabled={!hasPermission(data, 'select_equipment')}
            onClick={() => act('strip_equipment')}
            color="red"
          >
            Strip Equipment
          </Button>
        </Stack>
      </Section>
    </>
  );
};
