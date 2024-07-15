import { useBackend } from '../../backend';
import { Box } from '../../components';
import { ByondUi } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import { MapProps } from './types';

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
      ]}
    >
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
        className="MapPanel"
      />
    </Box>
  );
};
