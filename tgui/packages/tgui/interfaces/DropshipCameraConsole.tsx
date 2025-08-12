import { Box, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { CameraMfdPanel } from './MfdPanels/CameraPanel';
import { EquipmentMfdPanel } from './MfdPanels/EquipmentPanel';
import { MapMfdPanel } from './MfdPanels/MapPanel';
import { MfdPanel, type MfdProps } from './MfdPanels/MultifunctionDisplay';
import { mfdState } from './MfdPanels/stateManagers';
import { otherMfdState } from './MfdPanels/stateManagers';
import { SupportMfdPanel } from './MfdPanels/SupportPanel';
import { WeaponMfdPanel } from './MfdPanels/WeaponPanel';

export interface DropshipCameraProps {
  equipment_data: Array<DropshipEquipment>;
  tactical_map_ref?: string;
  camera_map_ref?: string;
  camera_target_id?: string;
  targets_data: Array<LazeTarget>;
  selected_eqp?: number;
}

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
  burst?: number;
  max_ammo?: number;
  firemission_delay?: number;
  last_fired?: number;
  firing_delay?: number;
  data?: any;
  stored_ammo?: Array<{
    name: string;
    ammo_count: number;
    max_ammo_count: number;
    ammo_name: string;
    ref: string;
  }>;
  icon_state?: string;
  damaged?: boolean;
};

const BaseMfdPanel = (props: MfdProps) => {
  const { setPanelState } = mfdState(props.panelStateId);
  const { otherPanelState } = otherMfdState(props.otherPanelStateId);

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
        {},
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
          <h1>Dropship Camera Control System</h1>
          <h3>UA Northbridge</h3>
          <h3>V 1.01</h3>
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
    case 'weapon':
      return <WeaponMfdPanel {...props} />;
    case 'support':
      return <SupportMfdPanel {...props} />;
    default:
      return <BaseMfdPanel {...props} />;
  }
};

export const DropshipCameraConsole = () => {
  return (
    <Window height={700} width={1420}>
      <Window.Content>
        <Box className="CameraConsoleBackground">
          <Stack className="CameraConsole">
            <Stack.Item>
              <PrimaryPanel
                panelStateId="left-screen"
                otherPanelStateId="right-screen"
                color="blue"
                consoleType="camera"
              />
            </Stack.Item>
            <Stack.Item>
              <Stack vertical>
                <Stack.Item height="20px" />
                <Stack.Item height="100px" width="107px" />{' '}
                <Stack.Item height="10px" />
                <Stack.Item className="DLabel">
                  Camera
                  <br />
                  Control
                </Stack.Item>
                <Stack.Item height="280px" />
              </Stack>
            </Stack.Item>

            <Stack.Item>
              <PrimaryPanel
                panelStateId="right-screen"
                otherPanelStateId="left-screen"
                color="blue"
                consoleType="camera"
              />
            </Stack.Item>
          </Stack>
        </Box>
      </Window.Content>
    </Window>
  );
};
