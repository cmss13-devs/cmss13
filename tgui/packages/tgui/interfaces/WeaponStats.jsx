import { map } from 'common/collections';
import { classes } from 'common/react';
import { useBackend } from '../backend';
import { ProgressBar, Section, Box, Flex, Table, Divider } from '../components';
import { Window } from '../layouts';

const GreedRedRange = {
  good: [-Infinity, 0.25],
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

const RedGreenRange = {
  bad: [-Infinity, 0.25],
  average: [0.25, 0.5],
  good: [0.5, Infinity],
};

export const WeaponStats = (props) => {
  const { act, data } = useBackend();
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
  const { data } = useBackend();
  const {
    name,
    desc,
    automatic,
    burst_amount,
    two_handed_only,
    auto_only,
    baseicon,
    icon,
  } = data;
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
  const { data } = useBackend();
  return (
    <Section title="Weapon Info">
      <Recoil />
      <Scatter />
      <Firerate />
    </Section>
  );
};

const Recoil = (props) => {
  const { data } = useBackend();
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
            ranges={GreedRedRange}>
            Unwielded recoil: {unwielded_recoil} / {recoil_max}
          </ProgressBar>
        </>
      ) : null}
      <Box height="5px" />
    </>
  );
};

const Scatter = (props) => {
  const { data } = useBackend();
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
            ranges={GreedRedRange}>
            Unwielded scatter: {unwielded_scatter} / {scatter_max}
          </ProgressBar>
          <Box height="5px" />
          <ProgressBar
            value={burst_scatter / scatter_max}
            ranges={GreedRedRange}>
            Burst scatter multiplier: {burst_scatter} / {scatter_max}
          </ProgressBar>
        </>
      ) : null}
      <Box height="5px" />
    </>
  );
};

const Firerate = (props) => {
  const { data } = useBackend();
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
        Single fire: {firerate}rpm, {firerate_second} per second
      </ProgressBar>
      <Box height="5px" />
      <ProgressBar value={burst_firerate / firerate_max} ranges={RedGreenRange}>
        Burst fire: {burst_firerate}rpm, {burst_firerate_second} per second
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
  const { data } = useBackend();
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
  const { data } = useBackend();
  const { damage, damage_max } = data;
  return (
    <>
      <ProgressBar value={damage / damage_max}>Damage: {damage}</ProgressBar>
      <Box height="5px" />
    </>
  );
};

const Accuracy = (props) => {
  const { data } = useBackend();
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
            ranges={RedGreenRange}>
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
  const { data } = useBackend();
  const { max_range, range_max, falloff, falloff_max } = data;
  return (
    <>
      <ProgressBar value={max_range / range_max} ranges={RedGreenRange}>
        Max range: {max_range} / {range_max}
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
  const { data } = useBackend();
  const { penetration, penetration_max, armor_punch, punch_max } = data;
  return (
    <>
      <ProgressBar value={penetration / penetration_max} ranges={RedGreenRange}>
        Armour penetration: {penetration} / {penetration_max}
      </ProgressBar>
      <Box height="5px" />
      <ProgressBar value={armor_punch / punch_max} ranges={RedGreenRange}>
        Armour punch: {armor_punch} / {punch_max}
      </ProgressBar>
    </>
  );
};

const DamageTable = (props) => {
  const { data } = useBackend();
  const {
    damage_armor_profile_marine,
    damage_armor_profile_xeno,
    damage_armor_profile_armorbreak,
    damage_armor_profile_headers,
    glob_armourbreak,
  } = data;
  return (
    <Section title="Damage table">
      <Table>
        <Table.Row>
          <Table.Cell bold textAlign="left">
            Armour Value
          </Table.Cell>
          {map((entry, i) => (
            <Table.Cell bold key={i}>
              {entry}
            </Table.Cell>
          ))(damage_armor_profile_headers)}
        </Table.Row>
        <Table.Row>
          <Table.Cell textAlign="left">Bioform</Table.Cell>
          {map((entry, i) => <Table.Cell key={i}>{entry}</Table.Cell>)(
            damage_armor_profile_xeno
          )}
        </Table.Row>
        <Table.Row>
          <Table.Cell textAlign="left">Humanoid</Table.Cell>
          {map((entry, i) => <Table.Cell key={i}>{entry}</Table.Cell>)(
            damage_armor_profile_marine
          )}
        </Table.Row>
        {!glob_armourbreak ? (
          <Table.Row>
            <Table.Cell textAlign="left">Armor break</Table.Cell>
            {map((entry, i) => <Table.Cell key={i}>{entry}</Table.Cell>)(
              damage_armor_profile_armorbreak
            )}
          </Table.Row>
        ) : null}
      </Table>
    </Section>
  );
};
