import { range } from 'common/collections';
import { useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui/components';

import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import {
  mfdState,
  useFiremissionXOffsetValue,
  useFiremissionYOffsetValue,
  useLazeTarget,
} from './stateManagers';
import type {
  CasFiremission,
  EquipmentContext,
  FiremissionContext,
  TargetContext,
} from './types';

const directionLookup = new Map<string, number>();
directionLookup['SOUTH'] = 2;
directionLookup['NORTH'] = 1;
directionLookup['WEST'] = 8;
directionLookup['EAST'] = 4;

const useStrikeMode = () => {
  const [data, set] = useSharedState<string | undefined>(
    'strike-mode',
    undefined,
  );
  return {
    strikeMode: data,
    setStrikeMode: set,
  };
};

const useStrikeDirection = () => {
  const [data, set] = useSharedState<string | undefined>(
    'strike-direction',
    undefined,
  );
  return {
    strikeDirection: data,
    setStrikeDirection: set,
  };
};

const useWeaponSelectedState = () => {
  const [data, set] = useSharedState<number | undefined>(
    'target-weapon-select',
    undefined,
  );
  return {
    weaponSelected: data,
    setWeaponSelected: set,
  };
};

const useTargetFiremissionSelect = () => {
  const [data, set] = useSharedState<CasFiremission | undefined>(
    'target-firemission-select',
    undefined,
  );
  return {
    firemissionSelected: data,
    setFiremissionSelected: set,
  };
};

export const useTargetOffset = (panelId: string) => {
  const [data, set] = useSharedState(`${panelId}_targetOffset`, 0); // This was originally localState
  return {
    targetOffset: data,
    setTargetOffset: set,
  };
};

const useTargetSubmenu = (panelId: string) => {
  const [data, set] = useSharedState<string | undefined>(
    `${panelId}_target_left`,
    undefined,
  );
  return {
    leftButtonMode: data,
    setLeftButtonMode: set,
  };
};

export const TargetLines = (props: { readonly panelId: string }) => {
  const { data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >();
  const { targetOffset } = useTargetOffset(props.panelId);
  return (
    <>
      {data.targets_data.length > targetOffset && (
        <path
          fillOpacity="0"
          stroke="#00e94e"
          d="M 50 210 l 20 0 l 20 -180 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 1 && (
        <path
          fillOpacity="0"
          stroke="#00e94e"
          d="M 50 220 l 25 0 l 15 -90 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 2 && (
        <path
          fillOpacity="0"
          stroke="#00e94e"
          d="M 50 230 l 20 0 l 20 0 l 40 0"
        />
      )}

      {data.targets_data.length > targetOffset + 3 && (
        <path
          fillOpacity="0"
          stroke="#00e94e"
          d="M 50 240 l 25 0 l 15 90 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 4 && (
        <path
          fillOpacity="0"
          stroke="#00e94e"
          d="M 50 250 l 20 0 l 20 180 l 40 0"
        />
      )}
    </>
  );
};

const leftButtonGenerator = (panelId: string, fmOffset: number) => {
  const { data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >();
  const { leftButtonMode, setLeftButtonMode } = useTargetSubmenu(panelId);
  const { strikeMode, setStrikeMode } = useStrikeMode();
  const { setStrikeDirection } = useStrikeDirection();
  const { firemissionSelected, setFiremissionSelected } =
    useTargetFiremissionSelect();
  const { weaponSelected, setWeaponSelected } = useWeaponSelectedState();
  const weapons = data.equipment_data.filter((x) => x.is_weapon);
  const firemission_mapper = (x: number) => {
    if (x === 0) {
      return {
        children: 'CANCEL',
        onClick: () => {
          setFiremissionSelected(undefined);
          setStrikeMode(undefined);
          setLeftButtonMode(undefined);
        },
      };
    }
    x -= 1;
    const firemission =
      data.firemission_data.length > x ? data.firemission_data[x] : undefined;
    return {
      children: firemission ? <div>FM {x + 1}</div> : undefined,
      onClick: () => {
        setFiremissionSelected(data.firemission_data[x]);
        setLeftButtonMode(undefined);
      },
    };
  };

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
      const cancelButton = [
        {
          children: 'CANCEL',
          onClick: () => {
            setFiremissionSelected(undefined);
            setStrikeMode(undefined);
            setLeftButtonMode(undefined);
          },
        },
      ];
      return cancelButton.concat(
        weapons.map((x) => {
          return {
            children: x.shorthand,
            onClick: () => {
              setWeaponSelected(x.eqp_tag);
              setLeftButtonMode(undefined);
            },
          };
        }),
      );
    }
    if (strikeMode === 'firemission' && firemissionSelected === undefined) {
      return range(fmOffset, fmOffset + 5).map(firemission_mapper);
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

export const lazeMapper = (offset) => {
  const { act, data } = useBackend<TargetContext>();
  const { setSelectedTarget } = useLazeTarget();

  const { fmXOffsetValue } = useFiremissionXOffsetValue();
  const { fmYOffsetValue } = useFiremissionYOffsetValue();

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
            target_id: target.target_tag,
            x_offset_value: fmXOffsetValue,
            y_offset_value: fmYOffsetValue,
          });
        }
      : () => {
          act('set-camera', { equipment_id: null });
          setSelectedTarget(undefined);
        },
  };
};

export const getLastTargetName = (data) => {
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

export const TargetAquisitionMfdPanel = (props: MfdProps) => {
  const { panelStateId } = props;

  const { act, data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >();

  const { setPanelState } = mfdState(panelStateId);
  const { selectedTarget, setSelectedTarget } = useLazeTarget();
  const { strikeMode } = useStrikeMode();
  const { strikeDirection } = useStrikeDirection();
  const { weaponSelected } = useWeaponSelectedState();
  const { firemissionSelected } = useTargetFiremissionSelect();
  const { targetOffset, setTargetOffset } = useTargetOffset(panelStateId);
  const [fmOffset, setFmOffset] = useState(0);
  const { leftButtonMode } = useTargetSubmenu(props.panelStateId);

  const { fmXOffsetValue } = useFiremissionXOffsetValue();
  const { fmYOffsetValue } = useFiremissionYOffsetValue();

  const strikeConfigLabel =
    strikeMode === 'weapon'
      ? data.equipment_data.find((x) => x.eqp_tag === weaponSelected)?.name
      : firemissionSelected !== undefined
        ? data.firemission_data.find(
            (x) => x.mission_tag === firemissionSelected.mission_tag,
          )?.name
        : 'NONE';

  const strikeReady =
    selectedTarget !== undefined &&
    strikeDirection !== undefined &&
    ((strikeMode === 'weapon' &&
      weaponSelected !== undefined &&
      data.equipment_data.find((x) => x.eqp_tag === weaponSelected)) ||
      (strikeMode === 'firemission' && firemissionSelected !== undefined));

  const targets = range(targetOffset, targetOffset + 5).map((x) =>
    lazeMapper(x),
  );

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
        {
          children:
            leftButtonMode === 'STRIKE' &&
            strikeMode === 'firemission' &&
            firemissionSelected === undefined &&
            fmOffset > 0 ? (
              <Icon name="arrow-up" />
            ) : undefined,
          onClick: () => {
            if (fmOffset > 0) {
              setFmOffset(fmOffset - 1);
            }
          },
        },
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
        {
          children:
            leftButtonMode === 'STRIKE' &&
            strikeMode === 'firemission' &&
            firemissionSelected === undefined &&
            fmOffset + 4 < data.firemission_data?.length ? (
              <Icon name="arrow-down" />
            ) : undefined,
          onClick: () => {
            if (fmOffset + 4 < data.firemission_data?.length) {
              setFmOffset(fmOffset + 1);
            }
          },
        },
        {},
        {},
        {
          children:
            targetOffset + 5 < data.targets_data?.length ? (
              <Icon name="arrow-down" />
            ) : undefined,
          onClick: () => {
            if (targetOffset + 5 < data.targets_data?.length) {
              setTargetOffset(targetOffset + 1);
            }
          },
        },
      ]}
      leftButtons={leftButtonGenerator(panelStateId, fmOffset)}
      rightButtons={targets}
    >
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
                  orient="auto"
                >
                  <polygon points="0 0, 10 3.5, 0 7" />
                </marker>
              </defs>
              <path
                stroke="#00e94e"
                strokeWidth="1"
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
                    strokeWidth="1"
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
                  {data.targets_data.find(
                    (x) => x?.target_tag === selectedTarget,
                  )?.target_name ?? 'NONE'}
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
                strokeWidth="1"
                fillOpacity="0"
                d="M 40 0 l -50 50 l 0 400 l 50 50"
              />
              <g transform="translate(-60)">
                {data.targets_data.length === 0 && (
                  <text
                    stroke="#00e94e"
                    x={-20}
                    y={210}
                    textAnchor="end"
                    transform="rotate(-90 20 210)"
                    fontSize="2em"
                  >
                    <tspan x={50} y={250} dy="1.2em">
                      NO TARGETS
                    </tspan>
                  </text>
                )}
                {data.targets_data.length > 0 && (
                  <text stroke="#00e94e" x={20} y={190} textAnchor="end">
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
                          {getLastTargetName(data)}
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
