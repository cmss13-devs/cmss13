import { range } from 'common/collections';
import { useBackend, useLocalState, useSharedState } from '../../backend';
import { Box, Icon, Stack } from '../../components';
import { MfdProps, MfdPanel } from './MultifunctionDisplay';
import { mfdState, useFiremissionXOffsetValue, useFiremissionYOffsetValue, useLazeTarget } from './stateManagers';
import { CasFiremission, EquipmentContext, FiremissionContext, TargetContext } from './types';

const directionLookup = new Map<string, number>();
directionLookup['SOUTH'] = 2;
directionLookup['NORTH'] = 1;
directionLookup['WEST'] = 8;
directionLookup['EAST'] = 4;

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
  const [data, set] = useSharedState<CasFiremission | undefined>(
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

const TargetLines = (props: { panelId: string }, context) => {
  const { data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >(context);
  const { targetOffset } = useTargetOffset(context, props.panelId);
  return (
    <>
      {data.targets_data.length > targetOffset && (
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 50 210 l 20 0 l 20 -180 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 1 && (
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 50 220 l 25 0 l 15 -90 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 2 && (
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 50 230 l 20 0 l 20 0 l 40 0"
        />
      )}

      {data.targets_data.length > targetOffset + 3 && (
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 50 240 l 25 0 l 15 90 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 4 && (
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 50 250 l 20 0 l 20 180 l 40 0"
        />
      )}
    </>
  );
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
            setFiremissionSelected(x);
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
        children: 'SOUTH',
        onClick: () => {
          setStrikeDirection('SOUTH');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'NORTH',
        onClick: () => {
          setStrikeDirection('NORTH');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'EAST',
        onClick: () => {
          setStrikeDirection('EAST');
          setLeftButtonMode(undefined);
        },
      },
      {
        children: 'WEST',
        onClick: () => {
          setStrikeDirection('WEST');
          setLeftButtonMode(undefined);
        },
      },
    ];
  }

  return [];
};

const lazeMapper = (context, offset) => {
  const { act, data } = useBackend<TargetContext>(context);
  const { setSelectedTarget } = useLazeTarget(context);

  const { fmXOffsetValue } = useFiremissionXOffsetValue(context);
  const { fmYOffsetValue } = useFiremissionYOffsetValue(context);

  const target =
    data.targets_data.length > offset ? data.targets_data[offset] : undefined;
  const isDebug = target?.target_name.includes('debug');

  const buttomLabel = () => {
    if (isDebug) {
      return 'd-' + target?.target_name.split(' ')[3];
    }
    const label = target?.target_name.split(' ')[0] ?? '';
    const squad = label[0] ?? undefined;
    const number = label.split('-')[1] ?? undefined;
    return squad !== undefined && number !== undefined
      ? `${squad}-${number}`
      : target?.target_name;
  };

  return {
    children: buttomLabel(),
    onClick: target
      ? () => {
        setSelectedTarget(target.target_tag);
        act('firemission-dual-offset-camera', {
          'target_id': target.target_tag,
          'x_offset_value': fmXOffsetValue,
          'y_offset_value': fmYOffsetValue,
        });
      }
      : () => {
        act('set-camera', { 'equipment_id': null });
        setSelectedTarget(undefined);
      },
  };
};

export const TargetAquisitionMfdPanel = (props: MfdProps, context) => {
  const { panelStateId } = props;

  const { act, data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >(context);

  const { setPanelState } = mfdState(context, panelStateId);
  const { selectedTarget, setSelectedTarget } = useLazeTarget(context);
  const { strikeMode } = useStrikeMode(context);
  const { strikeDirection } = useStrikeDirection(context);
  const { weaponSelected } = useWeaponSelectedState(context);
  const { firemissionSelected } = useTargetFiremissionSelect(context);
  const { targetOffset, setTargetOffset } = useTargetOffset(
    context,
    panelStateId
  );

  const { fmXOffsetValue } = useFiremissionXOffsetValue(context);
  const { fmYOffsetValue } = useFiremissionYOffsetValue(context);

  const lazes = range(0, 5).map((x) =>
    x > data.targets_data.length ? undefined : data.targets_data[x]
  );

  const strikeConfigLabel =
    strikeMode === 'weapon'
      ? data.equipment_data.find((x) => x.mount_point === weaponSelected)?.name
      : firemissionSelected !== undefined
        ? data.firemission_data.find(
          (x) => x.mission_tag === firemissionSelected.mission_tag
        )?.name
        : 'NONE';

  const lazeIndex = lazes.findIndex((x) => x?.target_tag === selectedTarget);
  const strikeReady = strikeMode !== undefined && lazeIndex !== -1;

  const targets = range(targetOffset, targetOffset + 5).map((x) =>
    lazeMapper(context, x)
  );

  const getLastName = () => {
    const target = data.targets_data[data.targets_data.length - 1] ?? undefined;
    const isDebug = target?.target_name.includes('debug');
    if (isDebug) {
      return 'debug ' + target.target_name.split(' ')[3];
    }
    const label = target?.target_name.split(' ')[0] ?? '';
    const squad = label[0] ?? undefined;
    const number = label.split('-')[1] ?? undefined;

    return squad !== undefined && number !== undefined
      ? `${squad}-${number}`
      : target?.target_name;
  };

  if (
    selectedTarget &&
    data.targets_data.find((x) => `${x.target_tag}` === `${selectedTarget}`) ===
      undefined
  ) {
    setSelectedTarget(undefined);
  }

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
                tag: firemissionSelected?.mission_tag,
                direction: strikeDirection
                  ? directionLookup[strikeDirection]
                  : 1,
                target_id: selectedTarget,
                offset_x_value: fmXOffsetValue,
                offset_y_value: fmYOffsetValue,
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
            targetOffset < lazes.length ? (
              <Icon name="arrow-down" />
            ) : undefined,
          onClick: () => {
            if (targetOffset < lazes.length) {
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
              <Stack.Item className="TargetText">
                <h3>
                  Target selected:{' '}
                  {lazes.find((x) => x?.target_tag === selectedTarget)
                    ?.target_name ?? 'NONE'}
                </h3>
              </Stack.Item>
              <Stack.Item>
                <h3>Attack Vector {strikeDirection ?? 'NONE'}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Offset {fmXOffsetValue},{fmYOffsetValue}
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
                  <text stroke="#00e94e" x={20} y={190} text-anchor="end">
                    <tspan x={40} dy="1.2em">
                      SELECT
                    </tspan>
                    <tspan x={40} dy="1.2em">
                      TARGETS
                    </tspan>
                    <tspan x={40} dy="1.2em">
                      {Math.min(5, data.targets_data.length)} of{' '}
                      {data.targets_data.length}
                    </tspan>
                    {data.targets_data.length > 0 && (
                      <>
                        <tspan x={40} dy="1.2em">
                          LATEST
                        </tspan>
                        <tspan x={40} dy="1.2em">
                          {getLastName()}
                        </tspan>
                      </>
                    )}
                  </text>
                )}
                <TargetLines panelId={props.panelStateId} />
              </g>
            </svg>
          </Stack.Item>
        </Stack>
      </Box>
    </MfdPanel>
  );
};
