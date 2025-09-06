import { range } from 'common/collections';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { ByondUi, Icon } from 'tgui/components';
import { Box } from 'tgui/components';

import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import { lazeMapper, useTargetOffset } from './TargetAquisition';
import type { CameraProps, LazeTarget } from './types';

interface CameraPanelContext extends CameraProps {
  available_cameras?: Array<{ name: string; ref: string }>;
  targets_data?: Array<LazeTarget>;
  camera_target_id?: string;
}

export const CameraMfdPanel = (props: MfdProps) => {
  const { act, data } = useBackend<CameraPanelContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const [cameraIndex, setCameraIndex] = useState(0);
  const { targetOffset, setTargetOffset } = useTargetOffset(props.panelStateId);

  const availableCameras = data.available_cameras || [];

  // Get current page of cameras (4 cameras per page for left buttons)
  const cameraPage = availableCameras.slice(cameraIndex, cameraIndex + 4);

  const targets = range(targetOffset, targetOffset + 5).map((x) =>
    lazeMapper(x),
  );

  const navigateCamerasUp = () => {
    if (cameraIndex > 0) {
      setCameraIndex(cameraIndex - 4);
    }
  };

  const navigateCamerasDown = () => {
    if (cameraIndex + 4 < availableCameras.length) {
      setCameraIndex(cameraIndex + 4);
    }
  };

  const leftButtons = [
    // Camera buttons
    {
      children: cameraPage[0]?.name,
      onClick: () => {
        if (cameraPage[0]) {
          act('switch_camera', {
            name: cameraPage[0].name,
          });
        }
      },
    },
    {
      children: cameraPage[1]?.name,
      onClick: () => {
        if (cameraPage[1]) {
          act('switch_camera', {
            name: cameraPage[1].name,
          });
        }
      },
    },
    {
      children: cameraPage[2]?.name,
      onClick: () => {
        if (cameraPage[2]) {
          act('switch_camera', {
            name: cameraPage[2].name,
          });
        }
      },
    },
    {
      children: cameraPage[3]?.name,
      onClick: () => {
        if (cameraPage[3]) {
          act('switch_camera', {
            name: cameraPage[3].name,
          });
        }
      },
    },
  ];

  const topButtons = [
    {
      children: cameraIndex > 0 ? 'CAM ▲' : undefined,
      onClick: navigateCamerasUp,
    },
    { children: 'NV-ON', onClick: () => act('nvg-enable') },
    { children: 'NV-OFF', onClick: () => act('nvg-disable') },
    {
      children: targetOffset > 0 ? <Icon name="arrow-up" /> : undefined,
      onClick: () => {
        if (targetOffset > 0) {
          setTargetOffset(targetOffset - 1);
        }
      },
    },
  ];

  const bottomButtons = [
    {
      children: cameraIndex + 4 < availableCameras.length ? 'CAM ▼' : undefined,
      onClick: navigateCamerasDown,
    },
    { children: 'EXIT', onClick: () => setPanelState('') },
    {},
    {
      children:
        targetOffset + 5 < (data.targets_data?.length || 0) ? (
          <Icon name="arrow-down" />
        ) : undefined,
      onClick: () => {
        if (targetOffset + 5 < (data.targets_data?.length || 0)) {
          setTargetOffset(targetOffset + 1);
        }
      },
    },
  ];

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      topButtons={topButtons}
      leftButtons={leftButtons}
      rightButtons={targets}
      bottomButtons={bottomButtons}
    >
      <CameraPanel />
    </MfdPanel>
  );
};

const CameraPanel = () => {
  const { data } = useBackend<CameraPanelContext>();

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
