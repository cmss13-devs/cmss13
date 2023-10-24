import { useBackend, useSharedState } from '../backend';
import { Window } from '../layouts';
import { Box, Divider, Flex, Stack } from '../components';
import { CasSim } from './CasSim';
import { range } from 'common/collections';
import { ButtonProps, FullButtonProps, mfddir, MfdPanel, MfdProps, usePanelState } from './MfdPanels/MultifunctionDisplay';
import { CameraMfdPanel } from './MfdPanels/CameraPanel';
import { EquipmentMfdPanel } from './MfdPanels/EquipmentPanel';
import { MapMfdPanel } from './MfdPanels/MapPanel';
import { WeaponMfdPanel } from './MfdPanels/WeaponPanel';
import { SupportMfdPanel } from './MfdPanels/SupportPanel';

interface DropshipProps {
  equipment_data: Array<DropshipEquipment>;
  medevac_targets: Array<MedevacTargets>;
  selected_eqp: number;
  tactical_map_ref?: string;
  camera_map_ref?: string;
  camera_target_id?: string;
  targets_data: Array<LazeTarget>;
}

type MedevacTargets = {
  area: string;
  occupant: string;
  ref: string;
  triage_card?: string;
  damage?: {
    hp: number;
    brute: number;
    oxy: number;
    tox: number;
    fire: number;
    undefib: number;
  };
};

type LazeTarget = {
  target_name: string;
  target_tag: number;
};

export type DropshipEquipment = {
  name: string;
  shorthand: string;
  eqp_tag: number;
  is_missile: 0 | 1;
  is_weapon: 0 | 1;
  is_interactable: 0 | 1;
  mount_point: number;
  ammo_name: string;
  ammo?: number;
  max_ammo?: number;
};

const xOffset = 40;
const yOffset = 0;
const xLookup = (index: number) => [0, 40, 80, 120][index] + xOffset;
const yLookup = (index: number) => [150, 20, 20, 150][index] + yOffset;
const OutlineColor = '#00e94e';
const OutlineWidth = '2';

type EquipmentPanelStates = undefined | string;

const useEquipmentState = (context) =>
  useSharedState<EquipmentPanelStates>(context, 'equipmentState', undefined);

const DrawShipOutline = () => {
  const drawLine = (pos0, pos1) => (
    <line
      x1={xLookup(pos0)}
      y1={yLookup(pos0)}
      x2={xLookup(pos1)}
      y2={yLookup(pos1)}
      stroke={OutlineColor}
      stroke-width={OutlineWidth}
    />
  );
  return (
    <>
      {drawLine(0, 1)}
      {drawLine(1, 2)}
      {drawLine(2, 3)}
    </>
  );
};

const DrawWeapon = (props: { weapon: DropshipEquipment }, context) => {
  const { data, act } = useBackend<DropshipProps>(context);
  const position = props.weapon.mount_point;
  const index = position - 1;
  const x = xLookup(index);
  const y = yLookup(index);
  return (
    <>
      <circle
        key={position}
        cx={x}
        cy={y}
        r={10}
        fill={data.selected_eqp === props.weapon.mount_point ? 'blue' : 'red'}
        onClick={() =>
          act('select_equipment', { 'equipment_id': props.weapon.eqp_tag })
        }
      />
      <text
        x={x + (index < 2 ? -25 : 25)}
        y={y}
        text-anchor="middle"
        fontWeight="bold"
        fill={OutlineColor}>
        {props.weapon.shorthand}
      </text>
    </>
  );
};

const WeaponStatsPanel = (
  props: { slot: number; weapon?: DropshipEquipment },
  context
) => {
  if (props.weapon === undefined) {
    return <EmptyWeaponStatsPanel slot={props.slot} />;
  }
  return (
    <Stack vertical className="PanelTextBox">
      <Stack.Item>{props.weapon.name ?? 'Empty'}</Stack.Item>
      {props.weapon.is_missile === 0 && props.weapon.ammo !== null && (
        <Stack.Item>
          Ammo: {props.weapon?.ammo ?? 'Empty'} /{' '}
          {props.weapon.max_ammo ?? 'Empty'}
        </Stack.Item>
      )}
      {props.weapon?.is_missile === 1 && (
        <Stack.Item>
          Loaded: <br />
          {props.weapon.ammo_name}
        </Stack.Item>
      )}
      {props.weapon?.ammo === null && <Stack.Item>Empty</Stack.Item>}
    </Stack>
  );
};

const EmptyWeaponStatsPanel = (props: { slot: number }) => {
  return (
    <Stack vertical className="PanelTextBox">
      <Stack.Item>Bay {props.slot} is empty</Stack.Item>
    </Stack>
  );
};

const DropshipWeaponsPanel = (
  props: { equipment: Array<DropshipEquipment> },
  context
) => {
  const weapons = props.equipment.filter((x) => x.is_weapon === 1);
  const support = props.equipment.filter((x) => x.is_weapon === 0);
  return (
    <Box className="WeaponPanel">
      <Stack>
        <Stack.Item>
          <Flex
            className="WeaponPanelLeft"
            direction="column"
            justify="space-around">
            <Flex.Item>
              <WeaponStatsPanel
                slot={2}
                weapon={weapons.find((x) => x.mount_point === 2)}
              />
            </Flex.Item>
            <Flex.Item>
              <Divider />
            </Flex.Item>
            <Flex.Item>
              <WeaponStatsPanel
                slot={1}
                weapon={weapons.find((x) => x.mount_point === 1)}
              />
            </Flex.Item>
          </Flex>
        </Stack.Item>
        <Stack.Item>
          <Stack className="WeaponSelectionPanel" vertical>
            <Stack.Item>
              <svg height="200" width="200">
                <DrawShipOutline />
                {weapons.map((x) => (
                  <DrawWeapon key={x.mount_point} weapon={x} />
                ))}
              </svg>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                {support.map((x) => (
                  <Stack.Item key={x.name}>{x.name}</Stack.Item>
                ))}
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Flex
            className="WeaponPanelRight"
            direction="column"
            justify="space-around">
            <Flex.Item>
              <WeaponStatsPanel
                slot={3}
                weapon={weapons.find((x) => x.mount_point === 3)}
              />
            </Flex.Item>
            <Flex.Item>
              <Divider />
            </Flex.Item>
            <Flex.Item>
              <WeaponStatsPanel
                slot={4}
                weapon={weapons.find((x) => x.mount_point === 4)}
              />
            </Flex.Item>
          </Flex>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const LcdPanel = (props, context) => {
  const { data } = useBackend<DropshipProps>(context);
  return (
    <Box className="NavigationMenu">
      <DropshipWeaponsPanel equipment={data.equipment_data} />
    </Box>
  );
};

const FiremissionSimulationPanel = (props, context) => {
  return (
    <Box className="NavigationMenu">
      <CasSim />
    </Box>
  );
};

const getGunButtonProps: (context: any) => Array<ButtonProps> = (context) => {
  const { act, data } = useBackend<DropshipProps>(context);
  const get_gun = (mount_point) =>
    data.equipment_data.find((x) => x.mount_point === mount_point);

  const guns = range(1, 5).map((x) => get_gun(x));
  const getGunProps = (index: number) => {
    const value: ButtonProps = {
      children: guns[index]?.shorthand ?? '',
      onClick: () => {
        act('fire-weapon', { 'eqp_tag': guns[0]?.eqp_tag });
      },
    };
    return value;
  };
  return [
    { children: 'WEAPON' },
    getGunProps(0),
    getGunProps(1),
    getGunProps(2),
    getGunProps(3),
  ];
};

const getEquipmentButtonProps: (context: any) => Array<ButtonProps> = (
  context
) => {
  const { data } = useBackend<DropshipProps>(context);
  const [equipmentPanel, setEquipmentPanel] = useEquipmentState(context);
  const equips = data.equipment_data.filter((x) => x.eqp_tag === 1);

  const equipment = range(1, 5).map((x) => equips.pop());
  const getEquipmentProps = (index: number) => {
    const value: ButtonProps = {
      children: equipment[index]?.shorthand ?? '',
      onClick: () => {
        const target = equipment[index];
        target && setEquipmentPanel(target.name);
      },
    };
    return value;
  };
  return [
    { children: 'EQUIP', onClick: () => setEquipmentPanel(undefined) },
    getEquipmentProps(0),
    getEquipmentProps(1),
    getEquipmentProps(2),
    getEquipmentProps(3),
  ];
};

const getLazeButtonProps = (context) => {
  const { act, data } = useBackend<DropshipProps>(context);
  const lazes = range(0, 3).map((x) =>
    x > data.targets_data.length ? undefined : data.targets_data[x]
  );
  const get_laze = (index: number) => {
    const laze = lazes.find((_, i) => i === index);
    if (laze === undefined) {
      return { children: 'NONE' };
    }
    return {
      children: laze?.target_name.split(' ')[0] ?? 'NONE',
      onClick: laze
        ? () => act('set-camera', { 'equipment_id': laze.target_tag })
        : undefined,
    };
  };
  return [
    { children: 'SIGNALS' },
    get_laze(0),
    get_laze(1),
    get_laze(2),
    get_laze(3),
  ];
};

const getEquipmentRightProps = (context) => {
  const [equipmentPanel] = useEquipmentState(context);
  switch (equipmentPanel) {
    default:
      return getMedevacRightProps(context);
  }
};

const getMedevacRightProps = (context) => {
  const { act, data } = useBackend<DropshipProps>(context);
  const get_medevac = (index: number) => {
    const target = data.medevac_targets.find((_, i) => i === index);
    if (!target) {
      return undefined;
    }

    const names = target.occupant.split(' ');
    return {
      children: `${names[names.length - 1]} ${names[0][0]}.`,
      onClick: () =>
        act('equipment_interact', {
          'equipment': 'medevac',
          'ref': target.ref,
        }),
    };
  };
  return [
    { children: 'WOUNDED' },
    get_medevac(0),
    get_medevac(1),
    get_medevac(2),
    get_medevac(3),
  ];
};

const getRightButtons = (context) => {
  const [panelState] = usePanelState('', context);
  const dir: mfddir = 'right';
  const getProps = () => {
    switch (panelState) {
      case 'equipment':
        return getEquipmentRightProps(context);
      default:
        return getLazeButtonProps(context);
    }
  };

  return getProps().map((x) => {
    const value: FullButtonProps = {
      location: dir,
      ...x,
    };
    return value;
  });
};

const EquipmentOverview = (_, context) => {
  return <div>hi</div>;
};

const MedevacOverview = (_, context) => {
  const { data } = useBackend<DropshipProps>(context);
  return (
    <Stack vertical>
      {data.medevac_targets.map((x) => (
        <Stack.Item key={x.occupant}>
          <MedevacOccupant data={x} />
        </Stack.Item>
      ))}
    </Stack>
  );
};

const MedevacOccupant = (props: { data: MedevacTargets }, context) => {
  return (
    <Box className="Test">
      <Flex justify="space-between">
        <Flex.Item grow>
          <Box>ECG mockup to show if the patient is alive or not</Box>
        </Flex.Item>
        <Flex.Item grow className="Test">
          <Stack vertical>
            <Stack.Item>{props.data.occupant}</Stack.Item>
            <Stack.Item>{props.data.area}</Stack.Item>
            <Stack.Item>a pin on a minimap</Stack.Item>
          </Stack>
        </Flex.Item>
        <Flex.Item grow>
          <Flex fill justify="space-around">
            <Flex.Item>
              HP
              <br />
              {props.data.damage?.hp}
            </Flex.Item>
            <Flex.Item>
              Brute
              <br />
              {props.data.damage?.brute}
            </Flex.Item>
            <Flex.Item>
              Fire
              <br />
              {props.data.damage?.fire}
            </Flex.Item>
            <Flex.Item>
              Tox
              <br />
              {props.data.damage?.tox}
            </Flex.Item>
            <Flex.Item>
              Oxy
              <br /> {props.data.damage?.oxy}
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
    </Box>
  );
};

const EquipmentPanel = (props, context) => {
  const [equipmentPanel] = useEquipmentState(context);
  const Selector = () => {
    switch (equipmentPanel) {
      case 'medevac system':
        return <MedevacOverview />;
      default:
        return <EquipmentOverview />;
    }
  };
  return (
    <Box className="NavigationMenu">
      <Selector />
    </Box>
  );
};

const FiremissionsMfdPanel = (props: MfdProps, context) => {
  const [panelState, setPanelState] = usePanelState(
    props.panelStateId,
    context
  );
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      bottomButtons={[
        {
          children: 'BACK',
          onClick: () => setPanelState(''),
        },
      ]}>
      <FiremissionSimulationPanel />
    </MfdPanel>
  );
};

const WeaponsMfdPanel = (props, context) => {
  return (
    <MfdPanel panelStateId={props.panelStateId}>
      <LcdPanel />
    </MfdPanel>
  );
};

const BaseMfdPanel = (props: MfdProps, context) => {
  const [panelState, setPanelState] = usePanelState(
    props.panelStateId,
    context
  );

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
        {},
        {
          children: 'F-MISS',
          onClick: () => setPanelState('firemissions'),
        },
      ]}
      bottomButtons={[
        {},
        { children: 'MAPS', onClick: () => setPanelState('map') },
        { children: 'CAMS', onClick: () => setPanelState('camera') },
      ]}>
      <Box className="NavigationMenu">
        <div className="welcome-page">
          <h1>USCM Dropship Weapons Control System</h1>
          <h3>UA Northbridge</h3>
          <h3>V 0.1</h3>
        </div>
      </Box>
    </MfdPanel>
  );
};

const PrimaryPanel = (props: MfdProps, context) => {
  const [panelState] = usePanelState(props.panelStateId, context);
  switch (panelState) {
    case 'camera':
      return <CameraMfdPanel {...props} />;
    case 'equipment':
      return <EquipmentMfdPanel {...props} />;
    case 'map':
      return <MapMfdPanel {...props} />;
    case 'weapons':
      return <WeaponsMfdPanel {...props} />;
    case 'firemissions':
      return <FiremissionsMfdPanel {...props} />;
    case 'weapon':
      return <WeaponMfdPanel {...props} />;
    case 'support':
      return <SupportMfdPanel {...props} />;
    default:
      return <BaseMfdPanel {...props} />;
  }
};

export const DropshipWeaponsConsole = (_, context) => {
  const { data } = useBackend<DropshipProps>(context);
  return (
    <Window height={700} width={1300}>
      <Window.Content>
        <Stack horizontal className="WeaponsConsole">
          <Stack.Item>
            <PrimaryPanel panelStateId="left-screen" />
          </Stack.Item>
          <Stack.Item>
            <PrimaryPanel panelStateId="right-screen" />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
