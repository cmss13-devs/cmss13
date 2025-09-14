import { useBackend } from 'tgui/backend';
import { Box } from 'tgui/components';
import { ByondUi } from 'tgui/components';

import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import type { MapProps } from './types';

export const MapMfdPanel = (props: MfdProps) => {
  const { setPanelState } = mfdState(props.panelStateId);
  const { data } = useBackend<MapProps>();

  const rightButtons =
    data.zlevelMax > 1
      ? [
          {
            children: '⬆',
            onClick: () => {
              if (data.zlevel + 1 < data.zlevelMax) {
                data.zlevel++;
              }
            },
          },
          {
            children: '⬇',
            onClick: () => {
              if (data.zlevel - 1 >= 0) {
                data.zlevel--;
              }
            },
          },
        ]
      : [];

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}
      rightButtons={rightButtons}
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
        key={data.zlevel}
        params={{
          id: data.tactical_map_ref[data.zlevel],
          type: 'map',
        }}
        className="MapPanel"
      />
    </Box>
  );
};
