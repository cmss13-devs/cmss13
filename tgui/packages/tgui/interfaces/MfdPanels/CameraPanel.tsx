import { useBackend } from 'tgui/backend';
import { ByondUi } from 'tgui/components';
import { Box } from 'tgui/components';

import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import type { CameraProps } from './types';

export const CameraMfdPanel = (props: MfdProps) => {
  const { act } = useBackend();
  const { setPanelState } = mfdState(props.panelStateId);
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={[
        { children: 'NV-ON', onClick: () => act('nvg-enable') },
        { children: 'NV-OFF', onClick: () => act('nvg-disable') },
      ]}
      bottomButtons={[{ children: 'EXIT', onClick: () => setPanelState('') }]}
    >
      <CameraPanel />
    </MfdPanel>
  );
};

const CameraPanel = () => {
  const { data } = useBackend<CameraProps>();
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
