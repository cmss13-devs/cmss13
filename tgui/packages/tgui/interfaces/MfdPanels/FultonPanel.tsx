import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { Box, Stack } from '../../components';
import { useBackend, useLocalState } from '../../backend';
import { mfdState, useEquipmentState } from './stateManagers';
import { range } from 'common/collections';
import { Icon } from '../../components';
import { FultonProps } from './types';

export const FultonMfdPanel = (props: MfdProps) => {
  const { data, act } = useBackend<FultonProps>();
  const [fulltonOffset, setFultonOffset] = useLocalState(
    `${props.panelStateId}_fultonoffset`,
    0
  );
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);

  const fultons = [...data.fulton_targets];
  const regex = /(\d+)/;

  const result = data.equipment_data.find(
    (x) => x.mount_point === equipmentState
  );

  const fulton_mapper = (x: number) => {
    const target = fultons.length > x ? fultons[x] : undefined;
    return {
      children: target ? (regex.exec(target) ?? [target])[0] : undefined,
      onClick: () =>
        act('fulton-target', {
          equipment_id: result?.mount_point,
          ref: target,
        }),
    };
  };

  const left_targets = range(fulltonOffset, fulltonOffset + 5).map(
    fulton_mapper
  );

  const right_targets = range(fulltonOffset + 5, fulltonOffset + 8).map(
    fulton_mapper
  );

  const all_targets = range(fulltonOffset, fulltonOffset + 8)
    .map((x) => fultons[x])
    .filter((x) => x !== undefined);

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={left_targets}
      rightButtons={[
        {
          children: <Icon name="arrow-up" />,
          onClick: () => {
            if (fulltonOffset > 0) {
              setFultonOffset(fulltonOffset - 1);
            }
          },
        },
        ...right_targets,
        {
          children: <Icon name="arrow-down" />,
          onClick: () => {
            if (fulltonOffset + 8 < data.fulton_targets.length) {
              setFultonOffset(fulltonOffset + 1);
            }
          },
        },
      ]}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}>
      <Box className="NavigationMenu">
        <Stack>
          <Stack.Item width="100px">
            <svg>
              {all_targets.length > 0 && (
                <path
                  fill-opacity="0"
                  stroke="#00e94e"
                  d="M 180 45 l -50 0 l -20 -15 l -150 0"
                />
              )}
              {all_targets.length > 1 && (
                <path
                  fill-opacity="0"
                  stroke="#00e94e"
                  d="M 180 75 l -50 0 l -20 55 l -150 0"
                />
              )}
              {all_targets.length > 2 && (
                <path
                  fill-opacity="0"
                  stroke="#00e94e"
                  d="M 180 110 l -50 0 l -20 120 l -150 0"
                />
              )}
              {all_targets.length > 3 && (
                <path
                  fill-opacity="0"
                  stroke="#00e94e"
                  d="M 180 140 l -50 0 l -20 190 l -150 0"
                />
              )}
              {all_targets.length > 4 && (
                <path
                  fill-opacity="0"
                  stroke="#00e94e"
                  d="M 180 175 l -50 0 l -20 255 l -150 0"
                />
              )}
            </svg>
          </Stack.Item>
          <Stack.Item>
            <Stack vertical width="300px" align="center">
              <Stack.Item>
                <h3>Active Fultons</h3>
              </Stack.Item>
              {all_targets.map((x) => (
                <Stack.Item key={x}>
                  <h4>{x}</h4>
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
          <Stack.Item width="100px">
            <svg>
              {all_targets.length > 5 && (
                <path
                  fill-opacity="0"
                  stroke="#00e94e"
                  d="M -100 205 l 50 0 l 20 -75 l 150 0"
                />
              )}
              {all_targets.length > 6 && (
                <path
                  fill-opacity="0"
                  stroke="#00e94e"
                  d="M -100 235 l 50 0 l 150 0"
                />
              )}
              {all_targets.length > 7 && (
                <path
                  fill-opacity="0"
                  stroke="#00e94e"
                  d="M -100 265 l 50 0 l 20 65 l 150 0"
                />
              )}
            </svg>
          </Stack.Item>
        </Stack>
      </Box>
    </MfdPanel>
  );
};
