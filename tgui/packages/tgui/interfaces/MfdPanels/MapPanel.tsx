import { useBackend } from '../../backend';
import { Box } from '../../components';
import { ByondUi } from '../../components';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import { MapProps } from './types';

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
        params={{
          id: data.tactical_map_ref[data.zlevel],
          type: 'map',
        }}
        className="MapPanel"
      />
    </Box>
  );
};
