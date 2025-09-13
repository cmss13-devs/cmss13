import { useBackend } from 'tgui/backend';
import { Box, Divider, Flex, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { Dpad } from './common/Dpad';
import { CameraMfdPanel } from './MfdPanels/CameraPanel';
import { EquipmentMfdPanel } from './MfdPanels/EquipmentPanel';
import { MapMfdPanel } from './MfdPanels/MapPanel';
import { MfdPanel, type MfdProps } from './MfdPanels/MultifunctionDisplay';
import { mfdState } from './MfdPanels/stateManagers';
import { otherMfdState } from './MfdPanels/stateManagers';
import { useWeaponState } from './MfdPanels/stateManagers';
import {
  BellygunnTargetAquisitionMfdPanel,
  TargetAquisitionMfdPanel,
} from './MfdPanels/TargetAquisition';
import type { EquipmentContext } from './MfdPanels/types';
import { WeaponMfdPanel } from './MfdPanels/WeaponPanel';

export interface DropshipProps {
  equipment_data: Array<DropshipEquipment>;
  medevac_targets: Array<MedevacTargets>;
  fulton_targets: Array<string>;
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
  ceiling_protection_tier?: number;
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
  burst?: number;
  max_ammo?: number;
  firemission_delay?: number;
  last_fired?: number;
  firing_delay?: number;
  data?: any;
  stored_ammo_1_name: string;
  stored_ammo_1_count?: number;
  stored_ammo_1_max?: number;
  stored_ammo_2_name: string;
  stored_ammo_2_count?: number;
  stored_ammo_2_max?: number;
};

const xOffset = 40;
const yOffset = 0;
const xLookup = (index: number) => [0, 40, 80, 120][index] + xOffset;
const yLookup = (index: number) => [150, 20, 20, 150][index] + yOffset;
const OutlineColor = '#00e94e';
const OutlineWidth = '2';

const DrawShipOutline = () => {
  const drawLine = (pos0, pos1) => (
    <line
      x1={xLookup(pos0)}
      y1={yLookup(pos0)}
      x2={xLookup(pos1)}
      y2={yLookup(pos1)}
      stroke={OutlineColor}
      strokeWidth={OutlineWidth}
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

const DrawWeapon = (props: { readonly weapon: DropshipEquipment }) => {
  const { data, act } = useBackend<DropshipProps>();
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
          act('select_equipment', { equipment_id: props.weapon.eqp_tag })
        }
      />
      <text
        x={x + (index < 2 ? -25 : 25)}
        y={y}
        textAnchor="middle"
        fontWeight="bold"
        fill={OutlineColor}
      >
        {props.weapon.shorthand}
      </text>
    </>
  );
};

const WeaponStatsPanel = (props: {
  readonly slot: number;
  readonly weapon?: DropshipEquipment;
}) => {
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

const EmptyWeaponStatsPanel = (props: { readonly slot: number }) => {
  return (
    <Stack vertical className="PanelTextBox">
      <Stack.Item>Bay {props.slot} is empty</Stack.Item>
    </Stack>
  );
};

const DropshipGunnerPanel = (props: {
  readonly equipment: Array<DropshipEquipment>;
}) => {
  const weapons = props.equipment.filter((x) => x.is_weapon === 1);
  const support = props.equipment.filter((x) => x.is_weapon === 0);
  return (
    <Box className="WeaponPanel">
      <Stack>
        <Stack.Item>
          <Flex
            className="WeaponPanelLeft"
            direction="column"
            justify="space-around"
          >
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
            justify="space-around"
          >
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

const LcdPanel = (props) => {
  const { data } = useBackend<DropshipProps>();
  return (
    <Box className="NavigationMenu">
      <DropshipGunnerPanel equipment={data.equipment_data} />
    </Box>
  );
};

const WeaponsMfdPanel = (props) => {
  return (
    <MfdPanel panelStateId={props.panelStateId} color={props.color}>
      <LcdPanel />
    </MfdPanel>
  );
};

const BaseMfdPanel = (props: MfdProps) => {
  const { data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { setWeaponState } = useWeaponState(props.panelStateId);
  const { otherPanelState } = otherMfdState(props.otherPanelStateId);

  const firstWeapon = data.equipment_data[0];

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      topButtons={[
        {
          children: 'TARGETS',
          onClick: () => setPanelState('target-aquisition'),
        },
        {},
        {},
      ]}
      bottomButtons={[
        {},
        {
          children: otherPanelState !== 'map' ? 'MAPS' : undefined,
          onClick: () => setPanelState('map'),
        },
        {
          children: otherPanelState !== 'camera' ? 'CAMS' : undefined,
          onClick: () => setPanelState('camera'),
        },
      ]}
    >
      <Box className="NavigationMenu">
        <div className="welcome-page">
          <h1>U.S.C.M.</h1>
          <h1>Dropship Gunner Control System</h1>
          <h3>UA Northbridge</h3>
          <h3>V 1.02</h3>
        </div>
      </Box>
    </MfdPanel>
  );
};

const PrimaryPanel = (props: MfdProps) => {
  const { panelState } = mfdState(props.panelStateId);
  switch (panelState) {
    case 'camera':
      return <CameraMfdPanel {...props} />;
    case 'equipment':
      return <EquipmentMfdPanel {...props} />;
    case 'map':
      return <MapMfdPanel {...props} />;
    case 'weapons':
      return <WeaponsMfdPanel {...props} />;
    case 'target-aquisition':
      // Use simplified version for weapons console
      return props.consoleType === 'weapons' ? (
        <BellygunnTargetAquisitionMfdPanel {...props} />
      ) : (
        <TargetAquisitionMfdPanel {...props} />
      );
    case 'weapon':
      return <WeaponMfdPanel {...props} />;
    default:
      return <BaseMfdPanel {...props} />;
  }
};

export const DropshipGunnerConsole = () => {
  return (
    <Window height={700} width={1420} theme="yellow">
      <Window.Content>
        <Box className="GunnerConsoleBackground">
          <Stack className="GunnerConsole">
            <Stack.Item>
              <PrimaryPanel
                panelStateId="left-screen"
                otherPanelStateId="right-screen"
                color="yellow"
                consoleType="weapons"
              />
            </Stack.Item>
            <Stack.Item>
              <Stack vertical>
                <Stack.Item height="20px" />
                <Stack.Item>
                  <Dpad panelStateId="left-screen" />
                </Stack.Item>
                <Stack.Item height="10px" />
                <Stack.Item className="DLabel">
                  Offset
                  <br />
                  Calibration
                </Stack.Item>
                <Stack.Item height="280px" />
              </Stack>
            </Stack.Item>

            <Stack.Item>
              <PrimaryPanel
                panelStateId="right-screen"
                otherPanelStateId="left-screen"
                color="yellow"
                consoleType="weapons"
              />
            </Stack.Item>
          </Stack>
        </Box>
      </Window.Content>
    </Window>
  );
};
