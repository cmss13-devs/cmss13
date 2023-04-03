import { Fragment } from 'inferno';
import { map } from 'common/collections';
import { resolveAsset } from '../assets';
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

export const WeaponStats = (props, context) => {
  const { act, data } = useBackend(context);
  const { has_ammo } = data;

  return (
    <Window width={has_ammo ? 600 : 300} height={has_ammo ? 600 : 500}>
      <Window.Content>
        <GeneralInfo />
        {has_ammo ? (
          <Fragment>
            <DamageTable />
            <Divider />
          </Fragment>
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

const GeneralInfo = (props, context) => {
  const { data } = useBackend(context);
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
            <img src={resolveAsset(icon)} />
          </Box>
          <Box height="5px" />
        </Flex.Item>
        <Flex.Item>
          <Box textAlign="center">{desc}</Box>
        </Flex.Item>
        <Flex.Item align="center">
          <Flex direction="row">
            <Flex.Item>
              {!auto_only ? (
                <img src={resolveAsset('single.png')} />
              ) : (
                <img src={resolveAsset('disabled_single.png')} />
              )}
            </Flex.Item>
            <Flex.Item>
              {!auto_only && burst_amount > 1 ? (
                <img src={resolveAsset('burst.png')} />
              ) : (
                <img src={resolveAsset('disabled_burst.png')} />
              )}
            </Flex.Item>
            <Flex.Item>
              {automatic ? (
                <img src={resolveAsset('auto.png')} />
              ) : (
                <img src={resolveAsset('disabled_automatic.png')} />
              )}
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const WeaponInfo = (props, context) => {
  const { data } = useBackend(context);
  return (
    <Section title="Weapon Info">
      <Recoil />
      <Scatter />
      <Firerate />
    </Section>
  );
};

const Recoil = (props, context) => {
  const { data } = useBackend(context);
  const { recoil, unwielded_recoil, recoil_max, two_handed_only } = data;
  return (
    <Fragment>
      <ProgressBar value={recoil / recoil_max} ranges={GreedRedRange}>
        Wielded recoil: {recoil} / {recoil_max}
      </ProgressBar>
      {!two_handed_only ? (
        <Fragment>
          <Box height="5px" />
          <ProgressBar
            value={unwielded_recoil / recoil_max}
            ranges={GreedRedRange}>
            Unwielded recoil: {unwielded_recoil} / {recoil_max}
          </ProgressBar>
        </Fragment>
      ) : null}
      <Box height="5px" />
    </Fragment>
  );
};

const Scatter = (props, context) => {
  const { data } = useBackend(context);
  const {
    scatter,
    unwielded_scatter,
    scatter_max,
    burst_scatter,
    two_handed_only,
  } = data;
  return (
    <Fragment>
      <ProgressBar value={scatter / scatter_max} ranges={GreedRedRange}>
        Wielded scatter: {scatter} / {scatter_max}
      </ProgressBar>
      {!two_handed_only ? (
        <Fragment>
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
        </Fragment>
      ) : null}
      <Box height="5px" />
    </Fragment>
  );
};

const Firerate = (props, context) => {
  const { data } = useBackend(context);
  const {
    firerate_max,
    firerate,
    firerate_second,
    burst_firerate,
    burst_firerate_second,
    burst_amount,
  } = data;
  return (
    <Fragment>
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
    </Fragment>
  );
};

const AmmoInfo = (props, context) => {
  const { data } = useBackend(context);
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

const Damage = (props, context) => {
  const { data } = useBackend(context);
  const { damage, damage_max } = data;
  return (
    <Fragment>
      <ProgressBar value={damage / damage_max}>Damage: {damage}</ProgressBar>
      <Box height="5px" />
    </Fragment>
  );
};

const Accuracy = (props, context) => {
  const { data } = useBackend(context);
  const {
    accuracy,
    unwielded_accuracy,
    accuracy_max,
    two_handed_only,
    min_accuracy,
  } = data;
  return (
    <Fragment>
      <ProgressBar value={accuracy / accuracy_max} ranges={RedGreenRange}>
        Wielded accuracy: {accuracy} / {accuracy_max}
      </ProgressBar>
      {!two_handed_only ? (
        <Fragment>
          <Box height="5px" />
          <ProgressBar
            value={unwielded_accuracy / accuracy_max}
            ranges={RedGreenRange}>
            Unwielded accuracy: {unwielded_accuracy} / {accuracy_max}
          </ProgressBar>
        </Fragment>
      ) : null}
      {min_accuracy ? (
        <Fragment>
          <Box height="5px" />
          <ProgressBar value={min_accuracy / accuracy_max}>
            Minimum accuracy: {min_accuracy}
          </ProgressBar>
        </Fragment>
      ) : null}
      <Box height="5px" />
    </Fragment>
  );
};

const Range = (props, context) => {
  const { data } = useBackend(context);
  const { max_range, range_max, falloff, falloff_max } = data;
  return (
    <Fragment>
      <ProgressBar value={max_range / range_max} ranges={RedGreenRange}>
        Max range: {max_range} / {range_max}
      </ProgressBar>
      <Box height="5px" />
      <ProgressBar value={falloff / falloff_max} ranges={GreedRedRange}>
        Falloff: {falloff} / {falloff_max}
      </ProgressBar>
      <Box height="5px" />
    </Fragment>
  );
};

const ArmourPen = (props, context) => {
  const { data } = useBackend(context);
  const { penetration, penetration_max, armor_punch, punch_max } = data;
  return (
    <Fragment>
      <ProgressBar value={penetration / penetration_max} ranges={RedGreenRange}>
        Armour penetration: {penetration} / {penetration_max}
      </ProgressBar>
      <Box height="5px" />
      <ProgressBar value={armor_punch / punch_max} ranges={RedGreenRange}>
        Armour punch: {armor_punch} / {punch_max}
      </ProgressBar>
    </Fragment>
  );
};

const DamageTable = (props, context) => {
  const { data } = useBackend(context);
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
