import { map } from 'common/collections';
import { type BooleanLike, classes } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Divider,
  Flex,
  ProgressBar,
  Section,
  Table,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

const GreedRedRange: Record<string, [number, number]> = {
  good: [-Infinity, 0.25],
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

const RedGreenRange: Record<string, [number, number]> = {
  bad: [-Infinity, 0.25],
  average: [0.25, 0.5],
  good: [0.5, Infinity],
};

type Data = {
  recoil_max: number;
  scatter_max: number;
  firerate_max: number;
  damage_max: number;
  accuracy_max: number;
  range_max: number;
  effective_range_max: number;
  falloff_max: number;
  penetration_max: number;
  punch_max: number;
  automatic: BooleanLike;
  auto_only: BooleanLike;
  icon: string;
  name: string;
  desc: string;
  two_handed_only: BooleanLike;
  recoil: number;
  unwielded_recoil: number;
  firerate: number;
  burst_firerate: number;
  firerate_second: number;
  burst_firerate_second: number;
  scatter: number;
  unwielded_scatter: number;
  burst_scatter: number;
  burst_amount: number;
  has_ammo: BooleanLike;
  ammo_name: string;
  damage: number;
  falloff: number;
  total_projectile_amount: number;
  penetration: number;
  accuracy: number;
  unwielded_accuracy: number;
  min_accuracy: number;
  max_range: number;
  projectile_max_range_add: number;
  effective_range_max_mod: number;
  effective_range: number;
  damage_armor_profile_headers: number[];
  damage_armor_profile_marine: number[];
  damage_armor_profile_xeno: number[];
};

export const WeaponStats = (props) => {
  const { act, data } = useBackend<Data>();
  const { has_ammo } = data;

  return (
    <Window width={has_ammo ? 600 : 300} height={has_ammo ? 600 : 500}>
      <Window.Content>
        <GeneralInfo />
        {has_ammo ? (
          <>
            <DamageTable />
            <Divider />
          </>
        ) : null}
        <Flex direction="row">
          <Flex.Item grow>
            <WeaponInfo />
          </Flex.Item>
          {has_ammo ? (
            <Flex.Item grow>
              <AmmoInfo />
            </Flex.Item>
          ) : null}
        </Flex>
      </Window.Content>
    </Window>
  );
};

const GeneralInfo = (props) => {
  const { data } = useBackend<Data>();
  const { name, desc, automatic, burst_amount, auto_only, icon } = data;
  return (
    <Section>
      <Flex direction="column">
        <Flex.Item>
          <Box textAlign="center" bold>
            {name}
          </Box>
        </Flex.Item>
        <Flex.Item align="center">
          <Box height="5px" />
          <Box align="center">
            <span className={classes(['Icon', 'gunlineart96x96', `${icon}`])} />
          </Box>
          <Box height="5px" />
        </Flex.Item>
        <Flex.Item>
          <Box textAlign="center">{desc}</Box>
        </Flex.Item>
        <Flex.Item align="center">
          <Flex direction="row">
            <Flex.Item>
              <span
                className={classes([
                  'Icon',
                  'gunlineartmodes96x32',
                  `${!auto_only ? 'single' : 'disabled_single'}`,
                ])}
              />
            </Flex.Item>
            <Flex.Item>
              <span
                className={classes([
                  'Icon',
                  'gunlineartmodes96x32',
                  `${
                    !auto_only && burst_amount > 1 ? 'burst' : 'disabled_burst'
                  }`,
                ])}
              />
            </Flex.Item>
            <Flex.Item>
              <span
                className={classes([
                  'Icon',
                  'gunlineartmodes96x32',
                  `${automatic ? 'auto' : 'disabled_automatic'}`,
                ])}
              />
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const WeaponInfo = (props) => {
  const { data } = useBackend<Data>();
  return (
    <Section title="Weapon Info">
      <Recoil />
      <Scatter />
      <Firerate />
    </Section>
  );
};

const Recoil = (props) => {
  const { data } = useBackend<Data>();
  const { recoil, unwielded_recoil, recoil_max, two_handed_only } = data;
  return (
    <>
      <ProgressBar value={recoil / recoil_max} ranges={GreedRedRange}>
        Wielded recoil: {recoil} / {recoil_max}
      </ProgressBar>
      {!two_handed_only ? (
        <>
          <Box height="5px" />
          <ProgressBar
            value={unwielded_recoil / recoil_max}
            ranges={GreedRedRange}
          >
            Unwielded recoil: {unwielded_recoil} / {recoil_max}
          </ProgressBar>
        </>
      ) : null}
      <Box height="5px" />
    </>
  );
};

const Scatter = (props) => {
  const { data } = useBackend<Data>();
  const {
    scatter,
    unwielded_scatter,
    scatter_max,
    burst_scatter,
    two_handed_only,
  } = data;
  return (
    <>
      <ProgressBar value={scatter / scatter_max} ranges={GreedRedRange}>
        Wielded scatter: {scatter} / {scatter_max}
      </ProgressBar>
      {!two_handed_only ? (
        <>
          <Box height="5px" />
          <ProgressBar
            value={unwielded_scatter / scatter_max}
            ranges={GreedRedRange}
          >
            Unwielded scatter: {unwielded_scatter} / {scatter_max}
          </ProgressBar>
          <Box height="5px" />
          <ProgressBar
            value={burst_scatter / scatter_max}
            ranges={GreedRedRange}
          >
            Burst scatter multiplier: {burst_scatter} / {scatter_max}
          </ProgressBar>
        </>
      ) : null}
      <Box height="5px" />
    </>
  );
};

const Firerate = (props) => {
  const { data } = useBackend<Data>();
  const {
    firerate_max,
    firerate,
    firerate_second,
    burst_firerate,
    burst_firerate_second,
    burst_amount,
  } = data;
  return (
    <>
      <ProgressBar value={firerate / firerate_max} ranges={RedGreenRange}>
        Fire rate: {firerate}rpm, {firerate_second} per second
      </ProgressBar>
      <Box height="5px" />
      <ProgressBar value={burst_firerate / firerate_max} ranges={RedGreenRange}>
        Burst fire rate: {burst_firerate}rpm, {burst_firerate_second} per second
      </ProgressBar>
      <Box height="5px" />
      {burst_amount > 1 ? (
        <ProgressBar value={burst_amount / 6}>
          Shots per burst: {burst_amount}
        </ProgressBar>
      ) : null}
    </>
  );
};

const AmmoInfo = (props) => {
  const { data } = useBackend<Data>();
  const { ammo_name } = data;
  return (
    <Section title="Ammo Info">
      <Box textAlign="center">Loaded ammo: {ammo_name}</Box>
      <Box height="5px" />
      <Damage />
      <Accuracy />
      <Range />
      <ArmourPen />
    </Section>
  );
};

const Damage = (props) => {
  const { data } = useBackend<Data>();
  const { damage, damage_max } = data;
  return (
    <>
      <ProgressBar value={damage / damage_max}>Damage: {damage}</ProgressBar>
      <Box height="5px" />
    </>
  );
};

const Accuracy = (props) => {
  const { data } = useBackend<Data>();
  const {
    accuracy,
    unwielded_accuracy,
    accuracy_max,
    two_handed_only,
    min_accuracy,
  } = data;
  return (
    <>
      <ProgressBar value={accuracy / accuracy_max} ranges={RedGreenRange}>
        Wielded accurate range: {accuracy} / {accuracy_max}
      </ProgressBar>
      {!two_handed_only ? (
        <>
          <Box height="5px" />
          <ProgressBar
            value={unwielded_accuracy / accuracy_max}
            ranges={RedGreenRange}
          >
            Unwielded accurate range: {unwielded_accuracy} / {accuracy_max}
          </ProgressBar>
        </>
      ) : null}
      {min_accuracy ? (
        <>
          <Box height="5px" />
          <ProgressBar value={min_accuracy / accuracy_max}>
            Minimum accurate range: {min_accuracy}
          </ProgressBar>
        </>
      ) : null}
      <Box height="5px" />
    </>
  );
};

const Range = (props) => {
  const { data } = useBackend<Data>();
  const {
    max_range,
    projectile_max_range_add,
    range_max,
    falloff,
    falloff_max,
    effective_range,
    effective_range_max,
    effective_range_max_mod,
  } = data;
  return (
    <>
      <ProgressBar
        value={(max_range + projectile_max_range_add) / range_max}
        ranges={RedGreenRange}
      >
        Max range: {max_range + projectile_max_range_add} / {range_max}
      </ProgressBar>
      <Box height="5px" />
      <ProgressBar
        value={
          (effective_range + effective_range_max_mod) / effective_range_max
        }
        ranges={RedGreenRange}
      >
        Effective range: {effective_range + effective_range_max_mod}
      </ProgressBar>
      <Box height="5px" />
      <ProgressBar value={falloff / falloff_max} ranges={GreedRedRange}>
        Falloff: {falloff} / {falloff_max}
      </ProgressBar>
      <Box height="5px" />
    </>
  );
};

const ArmourPen = (props) => {
  const { data } = useBackend<Data>();
  const { penetration, penetration_max } = data;
  return (
    <>
      <ProgressBar value={penetration / penetration_max} ranges={RedGreenRange}>
        Armour penetration: {penetration} / {penetration_max}
      </ProgressBar>
      <Box height="5px" />
    </>
  );
};

const DamageTable = (props) => {
  const { data } = useBackend<Data>();
  const {
    damage_armor_profile_marine,
    damage_armor_profile_xeno,
    damage_armor_profile_headers,
  } = data;
  return (
    <Section title="Damage table">
      <Table>
        <Table.Row>
          <Table.Cell bold textAlign="left">
            Armour Value
          </Table.Cell>
          {map(damage_armor_profile_headers, (entry, i) => (
            <Table.Cell bold key={i}>
              {entry}
            </Table.Cell>
          ))}
        </Table.Row>
        <Table.Row>
          <Table.Cell textAlign="left">Bioform</Table.Cell>
          {map(damage_armor_profile_xeno, (entry, i) => (
            <Table.Cell key={i}>{entry}</Table.Cell>
          ))}
        </Table.Row>
        <Table.Row>
          <Table.Cell textAlign="left">Humanoid</Table.Cell>
          {map(damage_armor_profile_marine, (entry, i) => (
            <Table.Cell key={i}>{entry}</Table.Cell>
          ))}
        </Table.Row>
      </Table>
    </Section>
  );
};
