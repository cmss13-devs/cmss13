import { useBackend } from 'tgui/backend';
import { Box } from 'tgui/components';
import { ByondUi } from 'tgui/components';

import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import type { MapProps } from './types';

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
