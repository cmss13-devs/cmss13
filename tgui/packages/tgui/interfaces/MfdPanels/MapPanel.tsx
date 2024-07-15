import { useBackend } from '../../backend';
import { Box } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { ByondUi } from '../../components';
import { MapProps } from './types';
import { mfdState } from './stateManagers';

export const MapMfdPanel = (props: MfdProps) => {
  const { setPanelState } = mfdState(props.panelStateId);
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}>
      <MapPanel />
    </MfdPanel>
  );
};

const MapPanel = () => {
  const { data } = useBackend<MapProps>();
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
