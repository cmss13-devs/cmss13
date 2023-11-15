import { range } from 'common/collections';
import { useBackend, useLocalState, useSharedState } from '../../backend';
import { Box, Icon, NumberInput, Stack } from '../../components';
import { MfdProps, MfdPanel } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import { dirMap, EquipmentContext, FiremissionContext, TargetContext } from './types';

const directionLookup = new Map<string, number>();
directionLookup['N-S'] = 2;
directionLookup['S-N'] = 1;
directionLookup['E-W'] = 8;
directionLookup['W-E'] = 4;

const useStrikeMode = (context) => {
  const [data, set] = useSharedState<string | undefined>(
    context,
    'strike-mode',
    undefined
  );
  return {
    strikeMode: data,
    setStrikeMode: set,
  };
};

const useLazeTarget = (context) => {
  const [data, set] = useSharedState<number | undefined>(
    context,
    'laze-target',
    undefined
  );
  return {
    selectedTarget: data,
    setSelectedTarget: set,
  };
};

const useStrikeDirection = (context) => {
  const [data, set] = useSharedState<string | undefined>(
    context,
    'strike-direction',
    undefined
  );
  return {
    strikeDirection: data,
    setStrikeDirection: set,
  };
};

const useWeaponSelectedState = (context) => {
  const [data, set] = useSharedState<number | undefined>(
    context,
    'target-weapon-select',
    undefined
  );
  return {
    weaponSelected: data,
    setWeaponSelected: set,
  };
};

const useTargetFiremissionSelect = (context) => {
  const [data, set] = useSharedState<number | undefined>(
    context,
    'target-firemission-select',
    undefined
  );
  return {
    firemissionSelected: data,
    setFiremissionSelected: set,
  };
};

const useTargetOffset = (context, panelId: string) => {
  const [data, set] = useLocalState(context, `${panelId}_targetOffset`, 0);
  return {
    targetOffset: data,
    setTargetOffset: set,
  };
};

const useTargetSubmenu = (context, panelId: string) => {
  const [data, set] = useSharedState<string | undefined>(
    context,
    `${panelId}_target_left`,
    undefined
  );
  return {
    leftButtonMode: data,
    setLeftButtonMode: set,
  };
};
const useFiremissionOffset = (context) => {
  const [data, set] = useSharedState<'NORTH' | 'SOUTH' | 'EAST' | 'WEST'>(
    context,
    'firemission-offset-dir',
    'NORTH'
  );
  return {
    fmOffsetDir: data,
    setFmOffsetDir: set,
  };
};

const useFiremissionOffsetValue = (context) => {
  const [data, set] = useSharedState<number>(
    context,
    'firemission-offset-value',
    0
  );
  return {
    fmOffsetValue: data,
    setFmOffsetValue: set,
  };
};

const leftButtonGenerator = (context, panelId: string) => {
  const { data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >(context);
  const { leftButtonMode, setLeftButtonMode } = useTargetSubmenu(
    context,
    panelId
  );
  const { strikeMode, setStrikeMode } = useStrikeMode(context);
  const { setStrikeDirection } = useStrikeDirection(context);
  const { firemissionSelected, setFiremissionSelected } =
    useTargetFiremissionSelect(context);
  const { setFmOffsetDir } = useFiremissionOffset(context);

  const { weaponSelected, setWeaponSelected } = useWeaponSelectedState(context);
  const weapons = data.equipment_data.filter((x) => x.is_weapon);
  if (leftButtonMode === undefined) {
    return [
      {
        children: 'STRIKE',
        onClick: () => setLeftButtonMode('STRIKE'),
      },
      {
        children: 'VECTOR',
        onClick: () => setLeftButtonMode('VECTOR'),
      },
      {
        children: 'OFFSET',
        onClick: () => setLeftButtonMode('OFFSET'),
      },
    ];
  }
  if (leftButtonMode === 'STRIKE') {
    if (strikeMode === 'weapon' && weaponSelected === undefined) {
      return weapons.map((x) => {
        return {
          children: x.shorthand,
          onClick: () => {
            setWeaponSelected(x.mount_point);
            setLeftButtonMode(undefined);
          },
        };
      });
    }
    if (strikeMode === 'firemission' && firemissionSelected === undefined) {
      return data.firemission_data.map((x) => {
        return {
          children: x.name,
          onClick: () => {
            setFiremissionSelected(x.mission_tag);
            setLeftButtonMode(undefined);
          },
        };
      });
    }
    return [
      { children: 'CANCEL', onClick: () => setLeftButtonMode(undefined) },
      {
        children: 'WEAPON',
        onClick: () => {
          setWeaponSelected(undefined);
          setStrikeMode('weapon');
        },
      },
      {
        children: 'F-MISS',
        onClick: () => {
          setFiremissionSelected(undefined);
          setStrikeMode('firemission');
        },
      },
    ];
  }
  if (leftButtonMode === 'VECTOR') {
    return [
      { children: 'CANCEL', onClick: () => setLeftButtonMode(undefined) },
      {
        children: 'N-S',
        onClick: () => {
          setStrikeDirection('N-S');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'S-N',
        onClick: () => {
          setStrikeDirection('S-N');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'W-E',
        onClick: () => {
          setStrikeDirection('W-E');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'E-W',
        onClick: () => {
          setStrikeDirection('E-W');
          setLeftButtonMode(undefined);
        },
      },
    ];
  }
  if (leftButtonMode === 'OFFSET') {
    return [
      { children: 'CANCEL', onClick: () => setLeftButtonMode(undefined) },
      {
        children: 'NORTH',
        onClick: () => {
          setFmOffsetDir('NORTH');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'SOUTH',
        onClick: () => {
          setFmOffsetDir('SOUTH');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'EAST',
        onClick: () => {
          setFmOffsetDir('EAST');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'WEST',
        onClick: () => {
          setFmOffsetDir('WEST');
          setLeftButtonMode(undefined);
        },
      },
    ];
  }
  return [];
};

const lazeMapper = (context) => {
  const { act, data } = useBackend<TargetContext>(context);
  const { setSelectedTarget } = useLazeTarget(context);
  const lazes = range(0, 5).map((x) =>
    x > data.targets_data.length ? undefined : data.targets_data[x]
  );
  return (index: number) => {
    const target = lazes.length > index ? lazes[index] : undefined;
    const label = target?.target_name.split(' ')[0] ?? '';
    const squad = label[0] ?? undefined;
    const number = label.split('-')[1] ?? undefined;
    return {
      children:
        squad !== undefined && number !== undefined
          ? `${squad}-${number}`
          : undefined,
      onClick: target
        ? () => {
          act('set-camera', { 'equipment_id': target.target_tag });
          setSelectedTarget(target.target_tag);
        }
        : () => {
          act('set-camera', { 'equipment_id': null });
          setSelectedTarget(undefined);
        },
    };
  };
};

export const TargetAquisitionMfdPanel = (props: MfdProps, context) => {
  const { panelStateId } = props;

  const { act, data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >(context);

  const { setPanelState } = mfdState(context, panelStateId);
  const { selectedTarget } = useLazeTarget(context);
  const { strikeMode } = useStrikeMode(context);
  const { strikeDirection } = useStrikeDirection(context);
  const { weaponSelected } = useWeaponSelectedState(context);
  const { firemissionSelected } = useTargetFiremissionSelect(context);
  const { targetOffset, setTargetOffset } = useTargetOffset(
    context,
    panelStateId
  );

  const { fmOffsetDir } = useFiremissionOffset(context);

  const { fmOffsetValue, setFmOffsetValue } =
    useFiremissionOffsetValue(context);

  const lazes = range(0, 5).map((x) =>
    x > data.targets_data.length ? undefined : data.targets_data[x]
  );

  const strikeConfigLabel =
    strikeMode === 'weapon'
      ? data.equipment_data.find((x) => x.mount_point === weaponSelected)?.name
      : firemissionSelected !== undefined
        ? data.firemission_data.find(
          (x) => x.mission_tag === firemissionSelected
        )?.name
        : 'NONE';

  const lazeIndex = lazes.findIndex((x) => x?.target_tag === selectedTarget);
  const strikeReady = strikeMode !== undefined && lazeIndex !== -1;

  const targets = range(targetOffset, targetOffset + 5).map(
    lazeMapper(context)
  );
  return (
    <MfdPanel
      panelStateId={panelStateId}
      topButtons={[
        {
          children: 'FIRE',
          onClick: () => {
            if (strikeMode === undefined) {
              return;
            }
            if (strikeMode === 'firemission') {
              act('firemission-execute', {
                tag: firemissionSelected,
                direction: strikeDirection
                  ? directionLookup[strikeDirection]
                  : 1,
                target_id: selectedTarget,
                offset_direction: dirMap(fmOffsetDir),
                offset_value: fmOffsetValue,
              });
            }
            if (strikeMode === 'weapon') {
              act('fire-weapon', { eqp_tag: weaponSelected });
            }
          },
        },
        {},
        {},
        {},
        {
          children: targetOffset > 0 ? <Icon name="arrow-up" /> : undefined,
          onClick: () => {
            if (targetOffset > 0) {
              setTargetOffset(targetOffset - 1);
            }
          },
        },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
        {},
        {},
        {},
        {
          children:
            targetOffset - 5 > lazes.length - 1 ? (
              <Icon name="arrow-down" />
            ) : undefined,
          onClick: () => {
            if (targetOffset - 5 < lazes.length - 1) {
              setTargetOffset(targetOffset + 1);
            }
          },
        },
      ]}
      leftButtons={leftButtonGenerator(context, panelStateId)}
      rightButtons={targets}>
      <Box className="NavigationMenu">
        <Stack>
          <Stack.Item width="50px">
            <svg width="50px" height="500px">
              <defs>
                <marker
                  id="arrowhead"
                  markerWidth="10"
                  markerHeight="7"
                  refX="0"
                  refY="3.5"
                  fill="#00e94e"
                  orient="auto">
                  <polygon points="0 0, 10 3.5, 0 7" />
                </marker>
              </defs>
              <path
                stroke="#00e94e"
                stroke-width="1"
                fillOpacity="0"
                d="M 0 0 l 50 50 l 0 400 l -50 50"
              />
            </svg>
          </Stack.Item>
          <Stack.Item width="400px">
            <Stack vertical align="center">
              <Stack.Item height="50px">
                <svg width="500px" height="50px">
                  <path
                    stroke="#00e94e"
                    stroke-width="1"
                    fillOpacity="0"
                    d="M -1 0 l 50 50 l 395 0 l 50 -50"
                  />
                </svg>
              </Stack.Item>
              <Stack.Item>
                <h1>Target Aquisition</h1>
              </Stack.Item>
              <Stack.Item>
                <h3>Strike mode: {strikeMode?.toUpperCase() ?? 'NONE'}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>Strike configuration {strikeConfigLabel}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Target selected{' '}
                  {lazes.find((x) => x?.target_tag === selectedTarget)
                    ?.target_name ?? 'NONE'}
                </h3>
              </Stack.Item>
              <Stack.Item>
                <h3>Attack Vector {strikeDirection ?? 'NONE'}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Offset {fmOffsetDir}{' '}
                  <NumberInput
                    value={fmOffsetValue}
                    onChange={(e, value) => {
                      if (value < 0) {
                        setFmOffsetValue(0);
                        return;
                      }
                      if (value > 12) {
                        setFmOffsetValue(12);
                        return;
                      }
                      setFmOffsetValue(value);
                    }}
                    width="40px"
                  />
                </h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Guidance computer {strikeReady ? 'READY' : 'INCOMPLETE'}
                </h3>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <svg width="50px" height="500px">
              <path
                stroke="#00e94e"
                stroke-width="1"
                fillOpacity="0"
                d="M 40 0 l -50 50 l 0 400 l 50 50"
              />
              <g transform="translate(-60)">
                {data.targets_data.length === 0 && (
                  <text
                    stroke="#00e94e"
                    x={-20}
                    y={210}
                    text-anchor="end"
                    transform="rotate(-90 20 210)"
                    fontSize="2em">
                    <tspan x={50} y={250} dy="1.2em">
                      NO TARGETS
                    </tspan>
                  </text>
                )}
                {data.targets_data.length > 0 && (
                  <text stroke="#00e94e" x={20} y={210} text-anchor="end">
                    <tspan x={40} dy="1.2em">
                      SELECT
                    </tspan>
                    <tspan x={40} dy="1.2em">
                      TARGETS
                    </tspan>
                  </text>
                )}
                {data.targets_data.length > 0 && (
                  <path
                    fill-opacity="0"
                    stroke="#00e94e"
                    d="M 50 210 l 20 0 l 20 -180 l 40 0"
                  />
                )}
                {data.targets_data.length > 1 && (
                  <path
                    fill-opacity="0"
                    stroke="#00e94e"
                    d="M 50 220 l 25 0 l 15 -90 l 40 0"
                  />
                )}
                {data.targets_data.length > 2 && (
                  <path
                    fill-opacity="0"
                    stroke="#00e94e"
                    d="M 50 230 l 20 0 l 20 0 l 40 0"
                  />
                )}

                {data.targets_data.length > 3 && (
                  <path
                    fill-opacity="0"
                    stroke="#00e94e"
                    d="M 50 240 l 25 0 l 15 90 l 40 0"
                  />
                )}
                {data.targets_data.length > 4 && (
                  <path
                    fill-opacity="0"
                    stroke="#00e94e"
                    d="M 50 250 l 20 0 l 20 180 l 40 0"
                  />
                )}
              </g>
            </svg>
          </Stack.Item>
        </Stack>
      </Box>
    </MfdPanel>
  );
};
