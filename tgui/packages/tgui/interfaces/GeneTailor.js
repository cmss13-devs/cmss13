import { useBackend, useLocalState } from '../backend';
import { Input, Button, Stack, Section, Tabs, Box, Dropdown, Tooltip, LabeledList, Collapsible } from '../components';
import { Window } from '../layouts';
const PAGES = [
  {
    title: 'Stats',
    component: () => StatActions,
    color: 'green',
    icon: 'angles-up',
  },
  {
    title: 'Abilities',
    component: () => AbilityActions,
    color: 'green',
    icon: 'bolt-lightning',
  },
  {
    title: 'Appearance',
    component: () => PlaceHolderActions,
    color: 'green',
    icon: 'paintbrush',
  },
  {
    title: 'Evolution',
    component: () => EvolutionActions,
    color: 'green',
    icon: 'dna',
  },
];
const PlaceHolderActions = (props, context) => {
  return;
};
const StatActions = (props, context) => {
  const { act, data } = useBackend(context);
  let combat_stats = [
    'melee_damage_lower',
    'melee_damage_upper',
    'melee_vehicle_damage',
    'attack_delay',
    'tackle_min',
    'tackle_max',
    'tackle_chance',
    'tacklestrength_min',
    'tacklestrength_max',
    'spit_delay',
  ];
  let health_stats = [
    'max_health',
    'plasma_gain',
    'plasma_max',
    'xeno_explosion_resistance',
    'armor_deflection',
    'evasion',
    'speed',
    'heal_resting',
    'innate_healing',
  ];
  let fluff_stats = [
    'caste_desc',
    'tier',
    'is_intelligent',
    'fire_immunity',
    'fire_intensity_resistance',
    'aura_strength',
    'build_time_mult',
    'can_hold_facehuggers',
    'can_hold_eggs',
    'can_be_queen_healed',
    'can_be_revived',
    'can_vent_crawl',
    'caste_luminosity',
    'hugger_nurturing',
    'huggers_max',
    'throwspeed',
    'hugger_delay',
    'eggs_max',
    'egg_cooldown',
  ];
  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 0);
  const { selected_template, xeno_stats, caste_stats } = data;
  if (!selected_template) return;
  // Should probably be a state
  const setCustomCastStat = (key, value) => {
    caste_stats[key] = value;
  };
  const setCustomXenoStat = (key, value) => {
    xeno_stats[key] = value;
  };
  return (
    <Section>
      <Collapsible title="Combat statistics">
        <LabeledList>
          {Object.keys(caste_stats).map((element, i) => {
            if (!combat_stats.includes(element)) {
              return;
            }
            return (
              <LabeledList.Item key={i} label={element}>
                <Input
                  value={caste_stats[element]}
                  onInput={(key, val) => setCustomCastStat(element, val)}
                />
              </LabeledList.Item>
            );
          })}
        </LabeledList>
      </Collapsible>
      <Collapsible title="Health and Mobility">
        {Object.keys(caste_stats).map((element, i) => {
          if (!health_stats.includes(element)) {
            return;
          }
          return (
            <LabeledList.Item key={i} label={element}>
              <Input
                value={caste_stats[element]}
                onInput={(key, val) => setCustomCastStat(element, val)}
              />
            </LabeledList.Item>
          );
        })}
      </Collapsible>
      <Collapsible title="Fluff and Miscellaneous">
        {Object.keys(caste_stats).map((element, i) => {
          if (!fluff_stats.includes(element)) {
            return;
          }
          return (
            <LabeledList.Item key={i} label={element}>
              <Input
                value={caste_stats[element]}
                onInput={(key, val) => setCustomCastStat(element, val)}
              />
            </LabeledList.Item>
          );
        })}
      </Collapsible>
      <Collapsible
        title="Other"
        buttons={
          <Tooltip content="Change those at your own risk">
            <Button icon="circle-question" />
          </Tooltip>
        }>
        <LabeledList>
          {Object.keys(xeno_stats).map((element, i) => {
            if (
              combat_stats.includes(element) ||
              health_stats.includes(element) ||
              fluff_stats.includes(element)
            ) {
              return;
            }
            return (
              <LabeledList.Item key={i} label={element}>
                <Input
                  value={xeno_stats[element]}
                  onInput={(key, val) => setCustomXenoStat(element, val)}
                />
              </LabeledList.Item>
            );
          })}
        </LabeledList>
      </Collapsible>
    </Section>
  );
};

const EvolutionActions = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_gt_evolutions, selected_template, evolves_into, devolves_into } =
    data;
  if (!selected_template) return;
  return (
    <Section>
      <Section
        title="Evolves from"
        align="center"
        buttons={
          <Tooltip content="Changes here are permanent, mind your clicks. There are no rules, it can devolve into multiple things from multiple tiers">
            <Button icon="circle-question" />
          </Tooltip>
        }>
        {Object.keys(glob_gt_evolutions).map((element, i) => (
          <Box level={2} title={element} key={i}>
            <Stack align="right" grow={1}>
              {Object.values(glob_gt_evolutions[element]).map((value, key) => (
                <Button.Checkbox
                  key={key}
                  width="100%"
                  height="100%"
                  checked={devolves_into.includes(value)}
                  color="purple"
                  content={value}
                  onClick={() => {
                    act('change_evolution', { type: 'devolve', key: value });
                  }}
                />
              ))}
            </Stack>
          </Box>
        ))}
      </Section>
      <Section
        title="Evolves into"
        align="center"
        buttons={
          <Tooltip content="Changes here are permanent, mind your clicks. There are no rules, it can evolve into multiple things from multiple tiers">
            <Button icon="circle-question" />
          </Tooltip>
        }>
        {Object.keys(glob_gt_evolutions).map((element, i) => (
          <Box level={2} title={element} key={i}>
            <Stack align="right" grow={1}>
              {Object.values(glob_gt_evolutions[element]).map((value, key) => (
                <Button.Checkbox
                  key={key}
                  width="100%"
                  height="100%"
                  checked={evolves_into.includes(value)}
                  color="purple"
                  content={value}
                  onClick={() => {
                    act('change_evolution', { type: 'evolve', key: value });
                  }}
                />
              ))}
            </Stack>
          </Box>
        ))}
      </Section>
    </Section>
  );
};

const AbilityActions = (props, context) => {
  const { act, data } = useBackend(context);
  const { xeno_abilities, xeno_passives } = data;

  const [abilities, addAbility] = useLocalState(
    context,
    'Abilities',
    xeno_abilities
  );
  return (
    <Stack vertical>
      <Stack.Item>
        <Section
          title="Passives"
          buttons={
            <Box>
              <Tooltip content="Can be stacked, some examples of passives : Vanguard shield, Acider acid Slash, Hedgehog shards, Berserker rage...">
                <Button icon="circle-question" />
              </Tooltip>
              <Button icon="plus" onClick={() => act('add_delegate')} />
              <Button icon="minus" onClick={() => act('remove_delegate')} />
            </Box>
          }
        />
        <LabeledList>
          {Object.values(xeno_passives).map((value, key) => {
            return (
              <LabeledList.Item key={key} textAlign="left">
                <b>{value}</b>
              </LabeledList.Item>
            );
          })}
        </LabeledList>
      </Stack.Item>
      <Stack.Item>
        <Section
          title="Abilities"
          buttons={
            <Box>
              <Tooltip content="Note that some abilities REQUIRE a passive to work to their full potential or at all, if an ability does not behave properly try adding the original owner's passive">
                <Button icon="circle-question" />
              </Tooltip>
              <Button icon="plus" onClick={() => act('add_ability')} />
              <Button icon="minus" onClick={() => act('remove_ability')} />
            </Box>
          }
        />
        <LabeledList>
          {Object.values(abilities).map((value, key) => {
            return (
              <LabeledList.Item key={key} textAlign="left">
                <b>{value}</b>
              </LabeledList.Item>
            );
          })}
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};

export const GeneTailor = (props, context) => {
  const types = ['caste', 'strain'];
  const { act, data } = useBackend(context);
  const { xeno_stats, caste_stats, selected_template, hives } = data;
  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 1);
  const PageComponent = PAGES[pageIndex].component();
  return (
    <Window
      /* theme = "hive_status"*/
      width={800}
      height={600}>
      <Window.Content>
        <Section md={1}>
          <LabeledList>
            <LabeledList.Item label="Template">
              <Button
                color={selected_template ? 'good' : 'bad'}
                content={
                  selected_template ? selected_template : 'Load a template'
                }
                align="center"
                onClick={() => act('load_template')}
              />
              <Tooltip content="What your xenomorph will be based of, you can then change any property you wish, this is mandatory">
                <Button icon="circle-question" />
              </Tooltip>
            </LabeledList.Item>
            <LabeledList.Item label="Type">
              <Tooltip width="200px" content="W.I.P, has no effect for now">
                <Dropdown
                  width="200px"
                  options={selected_template ? types : []}
                  onSelected={(value) =>
                    act('set_type', {
                      selected_type: value,
                    })
                  }
                />
              </Tooltip>
            </LabeledList.Item>
            <LabeledList.Item label="Hive">
              <Dropdown
                width="200px"
                options={selected_template ? hives : []}
                onSelected={(value) => (xeno_stats['hivenumber'] = value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Name">
              <Input
                width="200px"
                // placeholder={selected_template ? "" : "no template detected !"}
                onInput={(e, value) =>
                  act('set_name', {
                    name: value,
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section width="788px" position="fixed" bottom="0px">
          <Stack>
            <Tooltip content="Create a custom caste, allowing Xenomorphs to evolve according to the specifications in the evolution tab, note that this applies to every hive.">
              <Button
                color="purple"
                content="Apply Genome"
                width="100%"
                height="25px"
                align="center"
                onClick={() =>
                  act('apply_genome', {
                    caste_stats: caste_stats,
                    xeno_stats: xeno_stats,
                  })
                }
              />
            </Tooltip>
            <Tooltip content="Transform an existing Xenomorph">
              <Button
                color="yellow"
                content="Transform Mob"
                width="100%"
                height="25px"
                align="center"
                onClick={() =>
                  act('transform_mob', {
                    caste_stats: caste_stats,
                    xeno_stats: xeno_stats,
                  })
                }
              />
            </Tooltip>
            <Tooltip content="Spawn it under yourself">
              <Button
                color="green"
                content="Spawn Mob"
                width="100%"
                height="25px"
                align="center"
                onClick={() =>
                  act('spawn_mob', {
                    caste_stats: caste_stats,
                    xeno_stats: xeno_stats,
                  })
                }
              />
            </Tooltip>
          </Stack>
        </Section>
        <Section height="28px" mt="20px" bottom="10px" pl="3px" pt="4px" fitted>
          <Stack vertical grow>
            <Stack.Item width="100%">
              <Section fitted>
                <Tabs horizontal fluid>
                  {PAGES.map((page, i) => {
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
            <Stack.Item grow mt={5} mr={1}>
              <Section height="360px" scrollable fill>
                <PageComponent />
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
