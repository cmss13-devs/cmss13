import { MfdProps, MfdPanel } from './MultifunctionDisplay';
import { ByondUi } from '../../components';
import { useBackend } from '../../backend';
import { Box } from '../../components';
import { mfdState } from './stateManagers';
import { CameraProps } from './types';

export const CameraMfdPanel = (props: MfdProps, context) => {
  const { act } = useBackend(context);
  const { setPanelState } = mfdState(context, props.panelStateId);
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        { children: 'nvgon', onClick: () => act('nvg-enable') },
        { children: 'nvgoff', onClick: () => act('nvg-disable') },
      ]}
      bottomButtons={[{ children: 'EXIT', onClick: () => setPanelState('') }]}>
      <CameraPanel />
    </MfdPanel>
  );
};

const CameraPanel = (_, context) => {
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
