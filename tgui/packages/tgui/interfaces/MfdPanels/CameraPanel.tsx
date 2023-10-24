import { MfdProps, MfdPanel, usePanelState } from './MultifunctionDisplay';
import { ByondUi } from '../../components';
import { useBackend } from '../../backend';
import { Box } from '../../components';

export const CameraMfdPanel = (props: MfdProps, context) => {
  const { act } = useBackend<CameraProps>(context);
  const [_, setPanelState] = usePanelState(props.panelStateId, context);
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      bottomButtons={[{ children: 'EXIT', onClick: () => setPanelState('') }]}>
      <CameraPanel />
    </MfdPanel>
  );
};

interface CameraProps {
  camera_map_ref?: string;
}

const CameraPanel = (props, context) => {
  const { data } = useBackend<CameraProps>(context);
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
