import { Fragment } from "inferno";
import { useBackend, useLocalState } from '../backend';
import { Input, Button, Stack, Section, Tabs, Box, Dropdown, Slider, Tooltip } from '../components';
import { Window } from '../layouts';

const PAGES = [
  {
    title: 'General',
    component: () => GeneralActions,
    color: "green",
    icon: "tools",
  },
  {
    title: 'Punish',
    component: () => PunishmentActions,
    color: "red",
    icon: "gavel",
  },
  {
    title: 'Physical',
    component: () => PhysicalActions,
    color: "red",
    icon: "bolt",
    canAccess: data => {
      return !!data.is_human || !!data.is_xeno;
    },
  },
  {
    title: 'Transform',
    component: () => TransformActions,
    color: "orange",
    icon: "exchange-alt",
    canAccess: data => {
      return hasPermission(data, "mob_transform");
    },
  },
  {
    title: 'Fun',
    component: () => FunActions,
    color: "blue",
    icon: "laugh",
    canAccess: data => {
      return hasPermission(data, "fun");
    },
  },
  {
    title: 'Antag',
    component: () => AntagActions,
    color: "blue",
    icon: "crosshairs",
    canAccess: data => {
      return (data.is_human || data.is_xeno);
    },
  },
];

const hasPermission = (data, action) => {
  if (!(action in data.glob_pp_actions)) return false;

  const action_data = data.glob_pp_actions[action];
  return !!(action_data.permissions_required & data.current_permissions);
};

export const PlayerPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 0);
  const [canModifyCkey, setModifyCkey] = useLocalState(context, 'canModifyCkey', false);
  const PageComponent = PAGES[pageIndex].component();
  const { mob_name, mob_type, client_key, client_ckey, client_rank } = data;

  return (
    <Window
      title={`${mob_name} Player Panel`}
      width={600}
      height={500}
    >
      <Window.Content scrollable>
        <Section md={1}>
          <Stack>
            <Stack.Item width="80px" color="label">Name:</Stack.Item>
            <Stack.Item grow={1} align="right">
              {!!hasPermission(data, "set_name") && (
                <Input width={25} value={mob_name} onChange={(e, value) => act("set_name", { name: value })} />
              ) || mob_name}
            </Stack.Item>
          </Stack>
          <Stack mt={1}>
            <Stack.Item width="80px" color="label">Mob Type:</Stack.Item>
            <Stack.Item grow={1} align="right">{mob_type}</Stack.Item>
            <Stack.Item align="right">
              <Button
                icon="window-restore"
                content="Access Variables"
                disabled={!hasPermission(data, "access_variables")}
                onClick={() => act("access_variables")}
              />
            </Stack.Item>
          </Stack>
          <Stack mt={1}>
            <Stack.Item width="80px" color="label">Client:</Stack.Item>
            <Stack.Item grow={1} align="left">
              {((canModifyCkey || !client_key) && hasPermission(data, "set_ckey")) && (
                <Input
                  value={client_ckey}
                  onChange={(e, value) => act("set_ckey", { ckey: value })}
                />
              ) || (<Box inline>{client_key}</Box>) }
            </Stack.Item>
            {!!client_ckey && (
              <Stack.Item align="right">
                { !!hasPermission(data, "set_name") && (
                  <Button
                    ml={1}
                    icon={canModifyCkey? "lock-open" : "lock"}
                    content={canModifyCkey? "Unlocked" : "Locked"}
                    onClick={() => setModifyCkey(!canModifyCkey)}
                    color={canModifyCkey? "average" : "good"}
                  />
                )}
                <Button
                  ml={1}
                  icon="comment-dots"
                  disabled={!hasPermission(data, "private_message")}
                  onClick={() => act("private_message")}
                  content="Private Message"
                />
                <Button
                  ml={1}
                  icon="phone-alt"
                  disabled={!hasPermission(data, "subtle_message")}
                  onClick={() => act("subtle_message")}
                  content="Subtle Message"
                />
              </Stack.Item>
            )}
          </Stack>
          {client_rank && (
            <Stack mt={1}>
              <Stack.Item width="80px" color="label">Rank:</Stack.Item>
              <Stack.Item>
                <Button
                  icon="window-restore"
                  content={client_rank}
                  disabled={!hasPermission(data, "access_admin_datum")}
                  onClick={() => act("access_admin_datum")}
                />
              </Stack.Item>
            </Stack>
          )}
        </Section>
        <Stack grow>
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
                      onClick={() => setPageIndex(i)}>
                      {page.title}
                    </Tabs.Tab>
                  );
                })}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item
            position="relative"
            grow
            basis={0}
            ml={1}
          >
            <PageComponent />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const GeneralActions = (props, context) => {
  const { act, data } = useBackend(context);

  const { mob_sleeping, mob_frozen } = data;
  return (
    <Section fill>
      <Section level={2} title="Damage">
        <Stack
          align="right"
          grow={1}
        >
          <Button
            width="100%"
            icon="first-aid"
            color="green"
            content="Rejuvenate"
            disabled={!hasPermission(data, "mob_rejuvenate")}
            onClick={() => act("mob_rejuvenate")}
          />
          <Button.Confirm
            width="100%"
            icon="skull"
            color="average"
            content="Kill"
            confirmColor="average"
            disabled={!hasPermission(data, "mob_kill")}
            onClick={() => act("mob_kill")}
          />
          <Button.Confirm
            width="100%"
            height="100%" // weird ass bug here, so height set to 100%
            icon="skull-crossbones"
            color="bad"
            content="Gib"
            confirmColor="bad"
            disabled={!hasPermission(data, "mob_gib")}
            onClick={() => act("mob_gib")}
          />
        </Stack>
      </Section>

      <Section level={2} title="Teleportation">
        <Stack
          align="right"
          grow={1}
        >
          <Button.Confirm
            width="100%"
            icon="reply"
            content="Bring"
            disabled={!hasPermission(data, "mob_bring")}
            onClick={() => act("mob_bring")}
          />
          <Button
            width="100%"
            height="100%"
            icon="share"
            content="Jump To"
            disabled={!hasPermission(data, "jump_to")}
            onClick={() => act("jump_to")}
          />
        </Stack>
      </Section>

      <Section level={2} title="Miscellaneous">
        <Stack
          align="right"
          grow={1}
        >
          <Button.Checkbox
            width="100%"
            content="Toggle Sleeping"
            checked={mob_sleeping > 500}
            color={mob_sleeping > 500? "good" : "bad"}
            disabled={!hasPermission(data, "mob_sleep")}
            onClick={() => act("mob_sleep", { sleep: mob_sleeping > 500? false : true })}
          />
          <Button.Checkbox
            width="100%"
            content="Toggle Frozen"
            checked={mob_frozen}
            color={mob_frozen? "good" : "bad"}
            disabled={!hasPermission(data, "toggle_frozen")}
            onClick={() => act("toggle_frozen", { freeze: !mob_frozen })}
          />
          <Button
            width="100%"
            height="100%"
            content="Send Back to Lobby"
            icon="history"
            disabled={!hasPermission(data, "send_to_lobby")}
            onClick={() => act("send_to_lobby")}
          />
        </Stack>
        {hasPermission(data, "mob_force_emote") && (
          <Stack
            align="right"
            grow={1}
            mt={2}
          >
            <Stack.Item width="100px" align="left" color="label">Force Say:</Stack.Item>
            <Stack.Item align="right" grow={1}>
              <Input
                width="100%"
                grow={1}
                onEnter={(e, value) => act("mob_force_say", { to_say: value })}
              />
            </Stack.Item>
          </Stack>
        )}
        {hasPermission(data, "mob_force_emote") && (
          <Stack
            align="right"
            grow={1}
            mt={2}
          >
            <Stack.Item width="100px" align="left" color="label">Force Emote:</Stack.Item>
            <Stack.Item align="right" grow={1}>
              <Input
                width="100%"
                grow={1}
                onEnter={(e, value) => act("mob_force_emote", { to_emote: value })}
              />
            </Stack.Item>
          </Stack>
        )}
      </Section>
    </Section>
  );
};

const PunishmentActions = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_mute_bits, client_muted } = data;
  return (
    <Section fill>
      <Section level={2} title="Banishment">
        <Stack
          align="right"
          grow={1}
        >
          <Button.Confirm
            width="100%"
            icon="gavel"
            color="red"
            content="Ban"
            disabled={!hasPermission(data, "mob_ban")}
            onClick={() => act("mob_ban")}
          />
          <Button.Confirm
            width="100%"
            icon="gavel"
            color="red"
            content="EORG Ban"
            disabled={!hasPermission(data, "mob_eorg_ban")}
            onClick={() => act("mob_eorg_ban")}
          />
          <Button
            width="100%"
            height="100%"
            icon="ban"
            color="red"
            content="Job-ban"
            disabled={!hasPermission(data, "mob_jobban")}
            onClick={() => act("mob_jobban")}
          />
        </Stack>
      </Section>

      <Section level={2} title="Record-keeping">
        <Stack
          align="right"
          grow={1}
        >
          <Button
            width="100%"
            icon="clipboard-list"
            color="average"
            content="Check Notes"
            disabled={!hasPermission(data, "show_notes")}
            onClick={() => act("show_notes")}
          />
        </Stack>
      </Section>

      <Section level={2} title="Mute">
        <Stack
          align="right"
          grow={1}
        >
          {glob_mute_bits.map((bit, i) => {
            const isMuted = (client_muted
              && (client_muted & bit.bitflag));
            return (<Button.Checkbox
              key={i}
              width="100%"
              height="100%"
              checked={isMuted}
              color={isMuted? "good" : "bad"}
              content={bit.name}
              disabled={!hasPermission(data, "mob_mute")}
              onClick={() => act("mob_mute", { "mute_flag": !isMuted? client_muted | bit.bitflag : client_muted & ~bit.bitflag })}
            />);
          }) }
        </Stack>
      </Section>

      <Section level={2} title="Xenomorph Name">
        <Stack
          align="right"
          grow={1}
        >
          <Button
            width="100%"
            icon="clipboard-list"
            color="average"
            content="Xeno name reset"
            disabled={!hasPermission(data, "reset_xeno_name")}
            onClick={() => act("reset_xeno_name")}
          />
          <Button
            width="100%"
            height="100%"
            icon="clipboard-list"
            color="bad"
            content="Xeno name ban"
            disabled={!hasPermission(data, "ban_xeno_name")}
            onClick={() => act("ban_xeno_name")}
          />
        </Stack>
      </Section>
    </Section>
  );
};

const TransformActions = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_pp_transformables } = data;
  return (
    <Section fill>
      {Object.keys(glob_pp_transformables).map((element, i) => (
        <Section level={2} title={element} key={i}>
          <Stack
            align="right"
            grow={1}
          >
            {glob_pp_transformables[element].map((option, optionIndex) => (
              <Button.Confirm
                key={optionIndex}
                width="100%"
                height="100%"
                icon={option.icon}
                color={option.color}
                content={option.name}
                disabled={!hasPermission(data, "mob_transform")}
                onClick={() => act("mob_transform", { key: option.key })}
              />
            ))}
          </Stack>
        </Section>
      ))}
    </Section>
  );
};

const FunActions = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_span } = data;
  const [getSpanSetting, setSpanSetting] = useLocalState(context, "span_setting", glob_span[0].span);

  const [lockExplode, setLockExplode] = useLocalState(context, "explode_lock_toggle", true);
  const [expPower, setExpPower] = useLocalState(context, "exp_power", 50);
  const [falloff, setFalloff] = useLocalState(context, "falloff", 75);
  return (
    <Section fill>
      {hasPermission(data, "mob_narrate") && (
        <Section level={2} title="Narrate">
          <Stack
            align="right"
            grow={1}
          >
            {glob_span.map((spanData, i) => (
              <Button.Checkbox
                content={spanData.name}
                key={i}
                checked={getSpanSetting === spanData.span}
                onClick={() => setSpanSetting(spanData.span)}
                height="100%"
              />
            ))}
          </Stack>
          <Stack
            align="right"
            grow={1}
            mt={2}
          >
            <Stack.Item width="100px" align="left" color="label">Narrate:</Stack.Item>
            <Stack.Item align="right" grow={1}>
              <Input
                width="100%"
                grow={1}
                onEnter={(e, value) => act("mob_narrate",
                  {
                    to_narrate:
                      `<span class='${getSpanSetting}'>${value}</span>`,
                  }
                )}
              />
            </Stack.Item>
          </Stack>
        </Section>
      )}

      {hasPermission(data, "mob_explode") && (
        <Section title="Explosion" level={2} buttons={(
          <Button
            ml={1}
            icon={lockExplode? "lock" : "lock-open"}
            content={lockExplode? "Locked" : "Unlocked"}
            onClick={() => setLockExplode(!lockExplode)}
            color={lockExplode? "good" : "bad"}
          />
        )}>
          <Stack
            align="right"
            grow={1}
            mt={1}
          >
            <Stack.Item>
              <Button
                width="100%"
                height="100%"
                color="red"
                disabled={lockExplode}
                onClick={() => act("mob_explode", { power: expPower, falloff: falloff })}
              >
                <Box height="100%" pt={2} pb={2} textAlign="center">Detonate</Box>
              </Button>
            </Stack.Item>
            <Stack.Item
              ml={1}
              grow={1}
            >
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
    </Section>
  );
};

const AntagActions = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_hives, is_xeno, is_human } = data;

  const [selectedHivenumber, setHivenumber] = useLocalState(context, "selected_hivenumber", Object.keys(glob_hives)[0]);
  return (
    <Section fill>
      {!!is_human && (
        <Section level={2} title="Mutiny">
          <Stack
            align="right"
            grow={1}
          >
            <Button
              height="100%"
              width="100%"
              icon="chess-pawn"
              color="orange"
              disabled={!hasPermission(data, "make_mutineer")}
              onClick={() => act("make_mutineer")}
              content="Make Mutineer"
            />
            <Button
              height="100%"
              width="100%"
              icon="crown"
              color="orange"
              disabled={!hasPermission(data, "make_mutineer")}
              onClick={() => act("make_mutineer", { leader: true })}
              content="Make Mutineering Leader"
            />
          </Stack>
        </Section>
      )}
      <Section level={2} title="Xenomorph" buttons={
        <Dropdown
          width={12}
          color="purple"
          selected={selectedHivenumber}
          options={Object.keys(glob_hives)}
          onSelected={value => setHivenumber(value)}
        />
      }>
        <Stack
          align="right"
          grow={1}
          mt={1}
        >
          {!!is_human && (
            <Fragment>
              <Button
                height="100%"
                width="100%"
                icon="chess-pawn"
                color="purple"
                disabled={!hasPermission(data, "make_cultist")}
                onClick={() => act("make_cultist", { hivenumber: glob_hives[selectedHivenumber] })}
                content="Make Xeno Cultist"
              />
              <Button
                height="100%"
                width="100%"
                icon="crown"
                color="purple"
                disabled={!hasPermission(data, "make_cultist")}
                onClick={() => act("make_cultist", { leader: true, hivenumber: glob_hives[selectedHivenumber] })}
                content="Make Xeno Cultist Leader"
              />
            </Fragment>
          )}
          {!!is_xeno && (
            <Button
              height="100%"
              width="100%"
              icon="random"
              content="Change Hivenumber"
              color="purple"
              onClick={() => act("xeno_change_hivenumber", { hivenumber: glob_hives[selectedHivenumber] })}
            />
          )}
        </Stack>
      </Section>
    </Section>
  );
};

const PhysicalActions = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    is_human, glob_limbs, mob_speed,
    mob_status_flags, glob_status_flags,
    mob_feels_pain,
  } = data;

  const limbs = Object.keys(glob_limbs);
  const limb_flags = limbs.map((_, i) => (1<<i));

  const [delimbOption, setDelimbOption] = useLocalState(context, "delimb_flags", 0);
  return (
    <Section fill>
      <Section level={2} title="Status Flags">
        {Object.keys(glob_status_flags).map((val, i) => (
          <Button.Checkbox
            key={i}
            content={val}
            disabled={!hasPermission(data, "set_status_flags")}
            color={(mob_status_flags & glob_status_flags[val])? "good" : "bad"}
            checked={(mob_status_flags & glob_status_flags[val])}
            onClick={() => act("set_status_flags",
              {
                status_flags:
                  (mob_status_flags & glob_status_flags[val])
                    ? mob_status_flags & ~glob_status_flags[val]
                    : mob_status_flags|glob_status_flags[val],
              }
            )}
          />
        ))}
        <Button.Checkbox
          content="Feels Pain"
          disabled={!hasPermission(data, "set_pain")}
          color={mob_feels_pain? "good" : "bad"}
          checked={mob_feels_pain}
          onClick={() => act("set_pain", { feels_pain: !mob_feels_pain })}
        />
      </Section>
      {!!is_human && (
        <Section level={2} title="Limbs" buttons={(
          <Stack
            align="right"
            grow={1}
          >
            {limbs.map((val, index) => (
              <Button.Checkbox
                key={index}
                content={val}
                height="100%"
                textAlign="center"
                checked={delimbOption & limb_flags[index]}
                onClick={() => setDelimbOption(
                  (delimbOption & limb_flags[index])
                    ? delimbOption & ~limb_flags[index]
                    : delimbOption|limb_flags[index]
                )}
              />
            ))}
          </Stack>
        )}>
          <Stack
            align="right"
            grow={1}
          >
            <Button.Confirm
              width="100%"
              icon="unlink"
              content="Delimb"
              color="red"
              disabled={!hasPermission(data, "mob_delimb")}
              onClick={() => act("mob_delimb", {
                limbs: limb_flags.map((val, index) =>
                  !!(delimbOption & val) && glob_limbs[limbs[index]]
                ),
              })}
            />
            <Button.Confirm
              width="100%"
              height="100%"
              icon="link"
              content="Relimb"
              color="green"
              disabled={!hasPermission(data, "mob_relimb")}
              onClick={() => act("mob_relimb", {
                limbs: limb_flags.map((val, index) =>
                  !!(delimbOption & val) && glob_limbs[limbs[index]]
                ),
              })}
            />
          </Stack>
        </Section>
      )}
      <Section level={2} title="Game">
        <Stack>
          {!!is_human && (
            <Button.Confirm
              content="Send to cryogenics"
              icon="undo"
              width="100%"
              height="100%"
              disabled={!hasPermission(data, "cryo_human")}
              onClick={() => act("cryo_human")}
            >
              <Tooltip
                content="This will delete the mob, with all of their items and re-open the slot for other players to play."
              />
            </Button.Confirm>
          )}
          <Button.Confirm
            content="Drop all items"
            icon="dumpster"
            width="100%"
            height="100%"
            disabled={!hasPermission(data, "strip_equipment")}
            onClick={() => act("strip_equipment", { drop_items: true })}
          />
        </Stack>
        <Stack
          mt={1}
        >
          {hasPermission(data, "set_speed") && (
            <Slider
              minValue={-10}
              maxValue={10}
              value={-mob_speed}
              stepPixelSize={6}
              step={0.25}
              onChange={(e, value) => act("set_speed", { speed: -value })}
              unit="Mob Speed"
            />
          )}
        </Stack>
      </Section>
      <Section title="Equipment" level={2}>
        <Stack
          align="right"
          grow={1}
        >
          <Button
            width="100%"
            height="100%"
            icon="user-tie"
            disabled={!hasPermission(data, "select_equipment")}
            content="Select Equipment"
            onClick={() => act("select_equipment")}
            color="orange"
          />
          <Button
            width="100%"
            height="100%"
            icon="trash-alt"
            disabled={!hasPermission(data, "select_equipment")}
            content="Strip Equipment"
            onClick={() => act("strip_equipment")}
            color="red"
          />
        </Stack>
      </Section>
    </Section>
  );
};
