import { useBackend } from '../../backend';
import { Box } from '../../components';
import { MfdPanel, MfdProps, usePanelState } from './MultifunctionDisplay';
import { ByondUi } from '../../components';

interface MapProps {
  tactical_map_ref: string;
}

export const MapMfdPanel = (props: MfdProps, context) => {
  const [panelState, setPanelState] = usePanelState(
    props.panelStateId,
    context
  );
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

const MapPanel = (props, context) => {
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
