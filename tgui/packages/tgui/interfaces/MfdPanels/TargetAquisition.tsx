import { range } from 'common/collections';
import { useEffect, useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui/components';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';
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

// Hook for firing cooldown countdown
const useFiringCooldown = (equipment?: DropshipEquipment) => {
  const { data } = useBackend<{ worldtime: number }>();
  const [, forceUpdate] = useState({});

  // Force re-render every second to update countdown
  useEffect(() => {
    const interval = setInterval(() => {
      forceUpdate({});
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  if (!equipment?.last_fired || !equipment?.firing_delay) {
    return { isOnCooldown: false, remainingTime: 0 };
  }

  const cooldownEndTime = equipment.last_fired + equipment.firing_delay;
  const currentTime = data.worldtime;
  const remainingTime = Math.max(
    0,
    Math.ceil((cooldownEndTime - currentTime) / 10),
  );

  return {
    isOnCooldown: remainingTime > 0,
    remainingTime: remainingTime,
  };
};

// Hook for checking if firemission is underway
const useFiremissionStatus = () => {
  const { data } = useBackend<FiremissionContext>();
  const [, forceUpdate] = useState({});

  // Force re-render every second to update status
  useEffect(() => {
    const interval = setInterval(() => {
      forceUpdate({});
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  // Check if firemission is currently executing
  const isFiremissionActive =
    data.firemission_state !== undefined && data.firemission_state !== 0; // 0 is FIRE_MISSION_STATE_IDLE

  return {
    isFiremissionActive,
  };
};

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

export const TargetLines = (props: {
  readonly panelId: string;
  readonly color?: string;
}) => {
  const { data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >();
  const { targetOffset } = useTargetOffset(props.panelId);

  const getColorHex = (color?: string) => {
    switch (color) {
      case 'blue':
        return '#5fb3f0';
      case 'yellow':
        return '#ffff00';
      case 'green':
        return '#00e94e';
      default:
        return '#00e94e';
    }
  };

  const strokeColor = getColorHex(props.color);

  return (
    <>
      {data.targets_data.length > targetOffset && (
        <path
          fillOpacity="0"
          stroke={strokeColor}
          d="M 50 210 l 20 0 l 20 -180 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 1 && (
        <path
          fillOpacity="0"
          stroke={strokeColor}
          d="M 50 220 l 25 0 l 15 -90 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 2 && (
        <path
          fillOpacity="0"
          stroke={strokeColor}
          d="M 50 230 l 20 0 l 20 0 l 40 0"
        />
      )}

      {data.targets_data.length > targetOffset + 3 && (
        <path
          fillOpacity="0"
          stroke={strokeColor}
          d="M 50 240 l 25 0 l 15 90 l 40 0"
        />
      )}
      {data.targets_data.length > targetOffset + 4 && (
        <path
          fillOpacity="0"
          stroke={strokeColor}
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

  const getColorHex = (color?: string) => {
    switch (color) {
      case 'blue':
        return '#5fb3f0';
      case 'yellow':
        return '#ffff00';
      case 'green':
        return '#00e94e';
      default:
        return '#00e94e';
    }
  };

  const themeColor = getColorHex(props.color);

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

  // Get weapon cooldown status
  const selectedWeapon = data.equipment_data?.find(
    (x) => x.eqp_tag === weaponSelected,
  );
  const { isOnCooldown } = useFiringCooldown(selectedWeapon);
  const { isFiremissionActive } = useFiremissionStatus();

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
      data.equipment_data.find((x) => x.eqp_tag === weaponSelected) &&
      !isOnCooldown) ||
      (strikeMode === 'firemission' &&
        firemissionSelected !== undefined &&
        !isFiremissionActive));

  // Determine button text and disabled state
  let fireButtonText = 'FIRE';
  let fireButtonDisabled = false;

  if (strikeMode === 'weapon' && isOnCooldown) {
    fireButtonText = 'COOLING';
    fireButtonDisabled = true;
  } else if (strikeMode === 'firemission' && isFiremissionActive) {
    fireButtonText = 'ACTIVE';
    fireButtonDisabled = true;
  } else if (!strikeReady) {
    fireButtonDisabled = true;
  }

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
      color={props.color}
      topButtons={[
        {
          children: fireButtonText,
          disabled: fireButtonDisabled,
          onClick: () => {
            if (strikeMode === undefined || fireButtonDisabled) {
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
                  fill={themeColor}
                  orient="auto"
                >
                  <polygon points="0 0, 10 3.5, 0 7" />
                </marker>
              </defs>
              <path
                stroke={themeColor}
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
                    stroke={themeColor}
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
              {firemissionSelected !== undefined && (
                <Stack.Item>
                  <h3>
                    Firemission Length:{' '}
                    {firemissionSelected?.mission_length ?? 'N/A'}
                  </h3>
                </Stack.Item>
              )}
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
                  Target Durability Reading:{' '}
                  <span
                    style={{
                      color: (data as any).offset_antiair_active
                        ? '#FF0000'
                        : (data as any).offset_chaff_active
                          ? '#FFD700'
                          : typeof data.offset_ceiling_protection_tier ===
                              'number'
                            ? data.offset_ceiling_protection_tier >= 1 &&
                              data.offset_ceiling_protection_tier < 2
                              ? '#FFD700'
                              : data.offset_ceiling_protection_tier >= 2 &&
                                  data.offset_ceiling_protection_tier < 4
                                ? '#FF0000'
                                : '#00FF00'
                            : undefined,
                      fontWeight: 'bold',
                      fontSize: '1em',
                    }}
                  >
                    {(() => {
                      if ((data as any).offset_antiair_active) {
                        return 'WARNING: DANGER';
                      }
                      if ((data as any).offset_chaff_active) {
                        return 'ERROR: Signal Obstructed';
                      }
                      if (
                        data.offset_ceiling_protection_tier === undefined ||
                        data.offset_ceiling_protection_tier === null
                      ) {
                        return 'N/A';
                      }
                      const tier = Math.floor(
                        Number(data.offset_ceiling_protection_tier),
                      );
                      if (tier < 1) {
                        return 'All Weapons Clear';
                      } else if (tier >= 1 && tier < 2) {
                        return 'Firemission Required';
                      } else if (tier >= 2) {
                        return 'Bunker Buster Required';
                      }
                      return 'N/A';
                    })()}
                  </span>
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
                stroke={themeColor}
                strokeWidth="1"
                fillOpacity="0"
                d="M 40 0 l -50 50 l 0 400 l 50 50"
              />
              <g transform="translate(-60)">
                {data.targets_data.length === 0 && (
                  <text
                    stroke={themeColor}
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
                  <text stroke={themeColor} x={20} y={190} textAnchor="end">
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
                <TargetLines panelId={props.panelStateId} color={props.color} />
              </g>
            </svg>
          </Stack.Item>
        </Stack>
      </Box>
    </MfdPanel>
  );
};

// Bellygun Target Acquisition Panel
export const BellygunnTargetAquisitionMfdPanel = (props: MfdProps) => {
  const { panelStateId } = props;

  const getColorHex = (color?: string) => {
    switch (color) {
      case 'blue':
        return '#5fb3f0';
      case 'yellow':
        return '#ffff00';
      case 'green':
        return '#00e94e';
      default:
        return '#00e94e';
    }
  };

  const themeColor = getColorHex(props.color);

  const { act, data } = useBackend<
    EquipmentContext & FiremissionContext & TargetContext
  >();

  const { setPanelState } = mfdState(panelStateId);
  const { selectedTarget, setSelectedTarget } = useLazeTarget();
  const { targetOffset, setTargetOffset } = useTargetOffset(panelStateId);

  // Get the primary weapon for Bellygun
  const weapons = data.equipment_data?.filter((x) => x.is_weapon) || [];
  const primaryWeapon = weapons.length > 0 ? weapons[0] : undefined;

  // Get weapon cooldown status
  const {
    isOnCooldown: isWeaponOnCooldown,
    remainingTime: weaponCooldownTime,
  } = useFiringCooldown(primaryWeapon);

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
      color={props.color}
      topButtons={[
        {
          children: isWeaponOnCooldown
            ? `COOLDOWN ${weaponCooldownTime}s`
            : 'FIRE',
          disabled:
            !selectedTarget ||
            !primaryWeapon ||
            isWeaponOnCooldown ||
            !primaryWeapon?.ammo ||
            primaryWeapon.ammo <= 0,
          onClick: () => {
            if (
              selectedTarget &&
              primaryWeapon &&
              !isWeaponOnCooldown &&
              primaryWeapon.ammo &&
              primaryWeapon.ammo > 0
            ) {
              act('fire-weapon', { eqp_tag: primaryWeapon.eqp_tag });
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
      leftButtons={[]}
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
                  fill={themeColor}
                  orient="auto"
                >
                  <polygon points="0 0, 10 3.5, 0 7" />
                </marker>
              </defs>
              <path
                stroke={themeColor}
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
                    stroke={themeColor}
                    strokeWidth="1"
                    fillOpacity="0"
                    d="M -1 0 l 50 50 l 395 0 l 50 -50"
                  />
                </svg>
              </Stack.Item>
              <Stack.Item>
                <h1>Target Aquisition</h1>
              </Stack.Item>
              {primaryWeapon && (
                <>
                  <Stack.Item>
                    <h3>{primaryWeapon.name}</h3>
                  </Stack.Item>
                  <Stack.Item>
                    <h3>{primaryWeapon.ammo_name}</h3>
                  </Stack.Item>
                  <Stack.Item>
                    <h3>
                      Ammo {primaryWeapon.ammo} / {primaryWeapon.max_ammo}
                    </h3>
                  </Stack.Item>
                  {isWeaponOnCooldown && (
                    <Stack.Item>
                      <h3 style={{ color: '#ff8c00' }}>
                        <Icon name="clock" /> Cooldown: {weaponCooldownTime}s
                      </h3>
                    </Stack.Item>
                  )}
                  {!isWeaponOnCooldown && (
                    <Stack.Item>
                      <h3 style={{ color: themeColor }}>
                        <Icon name="crosshairs" /> Ready to Fire
                      </h3>
                    </Stack.Item>
                  )}
                </>
              )}
              <Stack.Item className="TargetText">
                <h3>
                  Target selected:{' '}
                  {data.targets_data.find(
                    (x) => x?.target_tag === selectedTarget,
                  )?.target_name ?? 'NONE'}
                </h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Target Durability Reading:{' '}
                  <span
                    style={{
                      color: (data as any).offset_antiair_active
                        ? '#FF0000'
                        : (data as any).offset_chaff_active
                          ? '#FFD700'
                          : typeof data.offset_ceiling_protection_tier ===
                              'number'
                            ? data.offset_ceiling_protection_tier >= 1 &&
                              data.offset_ceiling_protection_tier < 2
                              ? '#FFD700'
                              : data.offset_ceiling_protection_tier >= 2 &&
                                  data.offset_ceiling_protection_tier < 4
                                ? '#FF0000'
                                : '#00FF00'
                            : undefined,
                      fontWeight: 'bold',
                      fontSize: '1em',
                    }}
                  >
                    {(() => {
                      if ((data as any).offset_antiair_active) {
                        return 'WARNING: DANGER';
                      }
                      if ((data as any).offset_chaff_active) {
                        return 'ERROR: Signal Obstructed';
                      }
                      if (
                        data.offset_ceiling_protection_tier === undefined ||
                        data.offset_ceiling_protection_tier === null
                      ) {
                        return 'N/A';
                      }
                      const tier = Math.floor(
                        Number(data.offset_ceiling_protection_tier),
                      );
                      if (tier < 1) {
                        return 'All Weapons Clear';
                      } else if (tier >= 1 && tier < 2) {
                        return 'Firemission Required';
                      } else if (tier >= 2) {
                        return 'Bunker Buster Required';
                      }
                      return 'N/A';
                    })()}
                  </span>
                </h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Weapon Status:{' '}
                  {selectedTarget &&
                  primaryWeapon &&
                  !isWeaponOnCooldown &&
                  primaryWeapon.ammo &&
                  primaryWeapon.ammo > 0
                    ? 'READY'
                    : !primaryWeapon?.ammo || primaryWeapon.ammo <= 0
                      ? 'NO AMMO'
                      : 'NOT READY'}
                </h3>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <svg width="50px" height="500px">
              <path
                stroke={themeColor}
                strokeWidth="1"
                fillOpacity="0"
                d="M 40 0 l -50 50 l 0 400 l 50 50"
              />
              <g transform="translate(-60)">
                {data.targets_data.length === 0 && (
                  <text
                    stroke={themeColor}
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
                  <text stroke={themeColor} x={20} y={190} textAnchor="end">
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
                <TargetLines panelId={props.panelStateId} color={props.color} />
              </g>
            </svg>
          </Stack.Item>
        </Stack>
      </Box>
    </MfdPanel>
  );
};
