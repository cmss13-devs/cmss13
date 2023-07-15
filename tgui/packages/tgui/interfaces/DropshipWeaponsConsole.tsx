import { useBackend, useSharedState } from '../backend';
import { Window } from '../layouts';
import { Box, Button, Divider, Flex, Stack } from '../components';
import { CasSim } from './CasSim';
import { ByondUi } from '../components';
import { range } from 'common/collections';
import { FullButtonProps, HorizontalPanel, mfddir, MfdPanel } from './MultifunctionDisplay';

interface DropshipProps {
  equipment_data: Array<DropshipEquipment>;
  selected_eqp: number;
  tactical_map_ref?: string;
  camera_map_ref?: string;
  targets_data: Array<LazeTarget>;
}

type LazeTarget = {
  target_name: string;
  target_tag: number;
};

type DropshipEquipment = {
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

type PanelStates = 'equipment' | 'firemissions' | 'map' | 'camera';

const usePanelState = (context) =>
  useSharedState<PanelStates>(context, 'panelstate', 'equipment');

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

const DropshipEquipmentPanel = (
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
      <DropshipEquipmentPanel equipment={data.equipment_data} />
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

const MapPanel = (props, context) => {
  const { data } = useBackend<DropshipProps>(context);
  return (
    <Box className="NavigationMenu">
      <ByondUi
        params={{
          id: data.tactical_map_ref,
          type: 'map',
        }}
        class="MapPanel"
      />
    </Box>
  );
};

const CameraPanel = (props, context) => {
  const { act, data } = useBackend<DropshipProps>(context);
  return (
    <Box className="NavigationMenu">
      <ByondUi
        className="CameraPanel"
        params={{
          id: data.camera_map_ref,
          type: 'map',
        }}
      />
    </Box>
  );
};

const ControlPanel = (props, context) => {
  const [panelState, setPanelState] = usePanelState(context);

  const PanelButton = (props: { state: PanelStates; label: string }) => {
    return (
      <Button onClick={() => setPanelState(props.state)}>
        {panelState === props.state && '> '}
        {props.label}
      </Button>
    );
  };

  return (
    <Box className="NavigationMenu">
      <Stack vertical>
        <Stack.Item>
          <PanelButton state="equipment" label="Equipment" />
        </Stack.Item>
        <Stack.Item>
          <PanelButton state="firemissions" label="Firemissions" />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const TopPanel = (props, context) => {
  return (
    <HorizontalPanel
      buttons={[
        { children: 'L' },
        { children: 'LC' },
        { children: 'C' },
        { children: 'RC' },
        { children: 'R' },
      ]}
    />
  );
};

const BottomPanel = (props, context) => {
  const [panelState, setPanelState] = usePanelState(context);

  return (
    <HorizontalPanel
      buttons={[
        {
          children: 'WEAP',
          onClick: () => setPanelState('equipment'),
        },
        {
          children: 'FIREM',
          onClick: () => setPanelState('firemissions'),
        },
        { children: 'EQUIP' },
        { children: 'MAP', onClick: () => setPanelState('map') },
        { children: 'CAMERA', onClick: () => setPanelState('camera') },
      ]}
    />
  );
};

const getLeftButtons: (context: any) => Array<FullButtonProps> = (context) => {
  const { act, data } = useBackend<DropshipProps>(context);
  const get_gun = (mount_point) =>
    data.equipment_data.find((x) => x.mount_point === mount_point);

  const guns = range(1, 5).map((x) => get_gun(x));
  const dir: mfddir = 'left';
  const get_gun_index = (index: number) => {
    const value: FullButtonProps = {
      location: dir,
      children: guns[index]?.shorthand ?? 'EMPTY',
      onClick: () => {
        act('fire-weapon', { 'eqp_tag': guns[0]?.eqp_tag });
      },
    };
    return value;
  };
  return [
    { location: dir, children: 'WEAPON' },
    get_gun_index(0),
    get_gun_index(1),
    get_gun_index(2),
    get_gun_index(3),
  ];
};

const getRightButtons = (context) => {
  const { act, data } = useBackend<DropshipProps>(context);
  const lazes = range(0, 3).map((x) =>
    x > data.targets_data.length ? undefined : data.targets_data[x]
  );
  const dir: mfddir = 'right';
  const get_laze = (index: number) => {
    const laze = lazes.find((_, i) => i === index);
    if (laze === undefined) {
      return { location: dir, children: 'NONE' };
    } else {
      return {
        location: dir,
        children: laze?.target_name.split(' ')[0] ?? 'NONE',
        onClick: laze
          ? () => act('set-camera', { 'equipment_id': laze.target_tag })
          : undefined,
      };
    }
  };
  return [
    { location: dir, children: 'SIGNALS' },
    get_laze(0),
    get_laze(1),
    get_laze(2),
    get_laze(3),
  ];
};

const RenderScreen = (props, context) => {
  const [panelState] = usePanelState(context);
  switch (panelState) {
    case 'equipment':
      return <LcdPanel />;
    case 'firemissions':
      return <FiremissionSimulationPanel />;
    case 'map':
      return <MapPanel />;
    case 'camera':
      return <CameraPanel />;
    default:
      return <Box className="NavigationMenu" />;
  }
};

const PrimaryPanel = (props, context) => {
  const [panelState, setPanelState] = usePanelState(context);
  return (
    <MfdPanel
      buttons={[
        { location: 'top', children: 'L' },
        { location: 'top', children: 'LC' },
        { location: 'top', children: 'C' },
        { location: 'top', children: 'RC' },
        { location: 'top', children: 'R' },
        {
          location: 'bottom',
          children: 'WEAP',
          onClick: () => setPanelState('equipment'),
        },
        {
          location: 'bottom',
          children: 'FIREM',
          onClick: () => setPanelState('firemissions'),
        },
        { location: 'bottom', children: 'EQUIP' },
        {
          location: 'bottom',
          children: 'MAP',
          onClick: () => setPanelState('map'),
        },
        {
          location: 'bottom',
          children: 'CAMERA',
          onClick: () => setPanelState('camera'),
        },
        ...getLeftButtons(context),
        ...getRightButtons(context),
      ]}>
      <RenderScreen />
    </MfdPanel>
  );
};

const SecondaryPanel = (props, context) => {
  return (
    <Stack>
      <Stack.Item>
        <Button>Fire</Button>
      </Stack.Item>
      <Stack.Item>
        <Button>Day/night</Button>
      </Stack.Item>
      <Stack.Item>
        <Button>Master/Safe</Button>
      </Stack.Item>
    </Stack>
  );
};

export const DropshipWeaponsConsole = (_, context) => {
  const { data } = useBackend<DropshipProps>(context);
  return (
    <Window height={1024} width={1024}>
      <Window.Content>
        <Stack vertical className="WeaponsConsole">
          <Stack.Item>
            <PrimaryPanel />
          </Stack.Item>
          <Stack>
            <SecondaryPanel />
          </Stack>
        </Stack>
      </Window.Content>
    </Window>
  );
};
