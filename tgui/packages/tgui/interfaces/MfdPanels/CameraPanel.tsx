import { useBackend } from '../../backend';
import { ByondUi } from '../../components';
import { Box } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import { CameraProps } from './types';

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
