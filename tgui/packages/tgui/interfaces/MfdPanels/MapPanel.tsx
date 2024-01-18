import { useBackend } from '../../backend';
import { Box } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { ByondUi } from '../../components';
import { MapProps } from './types';
import { mfdState } from './stateManagers';

export const MapMfdPanel = (props: MfdProps, context) => {
  const { setPanelState } = mfdState(context, props.panelStateId);
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

const MapPanel = (_, context) => {
  const { data } = useBackend<MapProps>(context);
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
