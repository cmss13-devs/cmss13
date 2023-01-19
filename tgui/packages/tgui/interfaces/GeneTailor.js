import { useBackend, useLocalState } from '../backend';
import {
  Input,
  Button,
  Stack,
  Section,
  Tabs,
  Box,
  Dropdown,
  Slider,
  Tooltip,
  LabeledList,
  Collapsible,
} from '../components';
import { Window } from '../layouts';
var custom_caste_stats;
var custom_xeno_stats;
var changed_values = [];
const PAGES = [
  {
    title: 'Stats',
    component: () => StatActions,
    color: 'green',
    icon: 'angles-up',
  },
  {
    title: 'Abilities',
    component: () => PlaceHolderActions,
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
  }
];

const StatActions = (props, context) => {
  const { act, data } = useBackend(context);
  let combat_stats = ["melee_damage_lower", "melee_damage_upper", "melee_vehicle_damage", "attack_delay", "tackle_min", "tackle_max", "tackle_chance", "tacklestrength_min", "tacklestrength_max", "spit_delay"];
  let health_stats = ["max_health", "plasma_gain", "plasma_max", "xeno_explosion_resistance", "armor_deflection", "evasion", "speed", "heal_resting", "innate_healing"];
  let fluff_stats =  ["caste_desc", "tier", "display_name", "is_intelligent", "fire_immunity", "fire_intensity_resistance", "aura_strength", "build_time_mult", "can_hold_facehuggers", "can_hold_eggs", "can_be_queen_healed", "can_be_revived", "can_vent_crawl", "caste_luminosity", "hugger_nurturing", "huggers_max", "throwspeed", "hugger_delay", "eggs_max", "egg_cooldown"];
  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 0);
  //Should probably be a state so it actually updates
  const setCustomStat = (key, value) => {
      custom_caste_stats[key] = value;
      if(!changed_values.includes(key)){
        changed_values.push(key);
      }
  };
  return (
    <Section>
      <Collapsible title="Combat statistics">
        <LabeledList>
          {Object.keys(custom_caste_stats).map((element, i) => {
            if(!combat_stats.includes(element)){
              return ;
            }
            return(
            <LabeledList.Item label={element}>
              <Input
                value={custom_caste_stats[element]}
                onInput={(key, val) => setCustomStat(element, val)}/>
            </LabeledList.Item>
            );
        })}
        </LabeledList>
      </Collapsible>
      <Collapsible title="Health and mobility">
        {Object.keys(custom_caste_stats).map((element, i) => {
            if(!health_stats.includes(element)){
              return ;
            }
            return(
            <LabeledList.Item label={element}>
              <Input value={custom_caste_stats[element]}/>
            </LabeledList.Item>
              );
        })}
      </Collapsible>
      <Collapsible title="Fluff and Miscellaneous">
        {Object.keys(custom_caste_stats).map((element, i) => {
            if(!fluff_stats.includes(element)){
              return ;
            }
            return(
            <LabeledList.Item label={element}>
              <Input value={custom_caste_stats[element]}/>
            </LabeledList.Item>
              );
        })}
      </Collapsible>
      <Collapsible title="Other" buttons={
      <Tooltip content="Only change those if you know what you're doing, you've been warned">
        <Button icon="circle-question"/>
        </Tooltip>
        }>
        <LabeledList>
          {Object.keys(custom_xeno_stats).map((element, i) => {
            if(combat_stats.includes(element) || health_stats.includes(element) || fluff_stats.includes(element)){
              return;
            }
            return(
            <LabeledList.Item label={element}>
              <Input value={custom_xeno_stats[element]}/>
            </LabeledList.Item>
              );
        })}
        </LabeledList>
      </Collapsible>
    </Section>
  );
}

const EvolutionActions = (props, context) => {
  const { act, data } = useBackend(context);
  const { glob_gt_evolutions } = data;
  return (
    <Section>
      <Section title="Evolves from" align="center">
        {Object.keys(glob_gt_evolutions).map((element, i) => (
            <Box level={2} title={element} key={i}>
              <Stack align="right" grow={1}>
                {glob_gt_evolutions[element].map((option, optionIndex) => (
                  <Button.Checkbox
                    key={optionIndex}
                    width="100%"
                    height="100%"
                    icon={option.icon}
                    checked="PlaceHolder"
                    color="purple"
                    content={option.name}
                    onClick={() => act('mob_transform', { key: option.key })}
                  />
                ))}
              </Stack>
            </Box>
        ))}
      </Section>
      <Section title="Evolves into" align="center">
        {Object.keys(glob_gt_evolutions).map((element, i) => (
          <Box level={2} title={element} key={i}>
            <Stack align="right" grow={1}>
              {glob_gt_evolutions[element].map((option, optionIndex) => (
                <Button.Checkbox
                  key={optionIndex}
                  width="100%"
                  height="100%"
                  icon={option.icon}
                  checked="PlaceHolder"
                  color="purple"
                  content={option.name}
                  onClick={() => act('mob_transform', { key: option.key })}
                />
              ))}
            </Stack>
          </Box>
        ))}
      </Section>
    </Section>
  );
};
const PlaceHolderActions = (props, context) => {
  const { act, data } = useBackend(context);
  return;
}
export const GeneTailor = (props, context) => {
  const types = ["caste", "strain"];
  const { act, data } = useBackend(context);
  const {xeno_stats, caste_stats} = data;
  const setTemplate = () => {
    custom_caste_stats= Object.keys(caste_stats).sort().reduce((obj, key) => {obj[key] = caste_stats[key];return obj;},{});
    custom_xeno_stats= Object.keys(xeno_stats).sort().reduce((obj, key) => {obj[key] = xeno_stats[key];return obj;},{});
  };

  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 1);
  const PageComponent = PAGES[pageIndex].component();
  return (
    <Window
      /*theme = "hive_status"*/
      width={800}
      height={600}>
      <Window.Content>
        <Section md={1}>
            <LabeledList>
              <LabeledList.Item label="Name">
                <Input width={25}/>
              </LabeledList.Item>
              <LabeledList.Item label="Type">
                <Dropdown
                    options={types}
                    onClick={(value) =>
                      act('set_type', {
                        selected_type: value
                      })}
                  />
              </LabeledList.Item>
              <LabeledList.Item label="Hive">
                <Dropdown/>
              </LabeledList.Item>
              <LabeledList.Item label="Template">
                <Button color="red" content="Load template" align="center" onClick={() => setTemplate()}/>
              </LabeledList.Item>
            </LabeledList>
        </Section>
        <Section width="98%" position = "fixed" bottom ="0px" >
          <Stack>
            <Button color="red" content="Apply type" width="50%" height="25px" align="center"/>
            <Button color="green" content="Spawn Mob" width="50%" height="25px" align="center"
                  onClick={() =>
                    act('spawn_mob', {
                      caste_stats: custom_caste_stats,
                      xeno_stats: custom_xeno_stats,
                      to_change_stats: changed_values,
                    })}
            />
          </Stack>
        </Section>
        <Section height="28px" mt="20px" bottom="10px" pl="3px" pt="4px" fitted>
          <Stack vertical grow>
            <Stack.Item width="100%">
              <Section fitted>
                <Tabs horizontal fluid>
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
            <Stack.Item grow mt={5} mr={1}>
              <Section  height="380px" scrollable fill>
                <PageComponent/>
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
