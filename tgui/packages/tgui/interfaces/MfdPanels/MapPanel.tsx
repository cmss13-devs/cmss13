import { useBackend } from 'tgui/backend';
import { Box, ByondUi } from 'tgui/components';

import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import type { MapProps } from './types';

export const MapMfdPanel = (props: MfdProps) => {
  const { setPanelState } = mfdState(props.panelStateId);
  const { data, act } = useBackend<MapProps>();

  // Backend provides zlevel: 0 for single-level maps, 2 for multi-level maps
  const zlevel = data.zlevel ?? 0;

  const rightButtons =
    data.zlevelMax > 1
      ? [
          {
            children: '+ Up',
            onClick: () => {
              if (zlevel < data.zlevelMax) {
                // Update frontend data immediately so the key changes
                data.zlevel = zlevel + 1;
                act('change_zlevel', { zlevel: zlevel + 1 });
              }
            },
          },
          {
            children: '- Down',
            onClick: () => {
              // For single-level maps (zlevel 0), don't allow going down
              // For multi-level maps, minimum is zlevel 1
              const minZlevel = data.zlevelMax <= 1 ? 0 : 1;
              if (zlevel > minZlevel) {
                // Update frontend data immediately so the key changes
                data.zlevel = zlevel - 1;
                act('change_zlevel', { zlevel: zlevel - 1 });
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
      <MapPanel zlevel={zlevel} mapRefs={data.tactical_map_ref} />
    </MfdPanel>
  );
};

const MapPanel = (props: {
  readonly zlevel?: number;
  readonly mapRefs?: string[];
}) => {
  // Use the zlevel from props (backend provides correct value), fallback to 0 for safety
  const zlevel = props.zlevel ?? 0;
  const mapRefs = props.mapRefs ?? [];

  // For single-level maps: zlevel 0 maps to index 0
  // For multi-level maps: zlevel 1+ maps to index (zlevel-1)
  // But we need to determine if this is single or multi-level
  const isSingleLevel = mapRefs.length <= 1;
  const mapIndex = isSingleLevel ? 0 : zlevel - 1;

  // Don't render if we don't have map data
  if (!mapRefs || mapRefs.length === 0) {
    return (
      <Box className="NavigationMenu">
        <div>No map references available</div>
      </Box>
    );
  }

  // Check if the calculated index is valid
  if (mapIndex < 0 || mapIndex >= mapRefs.length || !mapRefs[mapIndex]) {
    return (
      <Box className="NavigationMenu">
        <div>
          Invalid map index: zlevel {zlevel} (index {mapIndex}) - Available: 0
          to {mapRefs.length - 1}
        </div>
      </Box>
    );
  }

  return (
    <Box className="NavigationMenu">
      <ByondUi
        key={`map_${zlevel}_${mapRefs[mapIndex]}`}
        params={{
          id: mapRefs[mapIndex],
          type: 'map',
          'background-color': 'none',
        }}
        className="MapPanel"
      />
    </Box>
  );
};
