import { range } from 'common/collections';
import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { useSharedState } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui/components';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState, useLazeTarget, useWeaponState } from './stateManagers';
import {
  getLastTargetName,
  lazeMapper,
  TargetLines,
  useTargetOffset,
} from './TargetAquisition';
import type { LazeTarget } from './types';

// Hook for firing cooldown countdown
const useFiringCooldown = (equipment: DropshipEquipment) => {
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

// Hook for support equipment cooldown countdown
export const useSupportCooldown = (equipment: DropshipEquipment) => {
  const { data } = useBackend<{ worldtime: number }>();
  const [, forceUpdate] = useState({});

  // Force re-render every second to update countdown
  useEffect(() => {
    const interval = setInterval(() => {
      forceUpdate({});
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  // Check for different types of cooldowns
  const cooldownValue =
    equipment?.medevac_cooldown ||
    equipment?.system_cooldown ||
    equipment?.deployment_cooldown ||
    equipment?.spotlights_cooldown ||
    equipment?.fulton_cooldown ||
    equipment?.reload_cooldown;

  if (!cooldownValue) {
    return { isOnCooldown: false, remainingTime: 0 };
  }

  const currentTime = data.worldtime;
  const remainingTime = Math.max(
    0,
    Math.ceil((cooldownValue - currentTime) / 10),
  );

  return {
    isOnCooldown: remainingTime > 0,
    remainingTime: remainingTime,
  };
};

// Quick Mode
const useQuickMode = (panelId: string) => {
  const [data, set] = useSharedState<boolean>(
    `${panelId}_weapon_quick_mode`,
    false,
  );
  return {
    quickMode: data,
    setQuickMode: set,
  };
};

const EmptyWeaponPanel = (props) => {
  return <div>Nothing Listed</div>;
};
interface EquipmentContext {
  equipment_data: Array<DropshipEquipment>;
  targets_data: Array<LazeTarget>;
}

const WeaponPanel = (props: {
  readonly panelId: string;
  readonly equipment: DropshipEquipment;
  readonly color?: string;
  readonly quickMode?: boolean;
  readonly allWeapons?: DropshipEquipment[];
}) => {
  const { data } = useBackend<EquipmentContext>();
  const ammoReadout =
    props.equipment.ammo === null || props.equipment.ammo === undefined
      ? 'DEPLETED'
      : props.equipment.ammo + ' / ' + props.equipment.max_ammo;
  const { isOnCooldown, remainingTime } = useFiringCooldown(props.equipment);
  const { selectedTarget } = useLazeTarget();

  // Get the selected target data for ceiling protection tier
  const selectedTargetData =
    selectedTarget !== undefined && data.targets_data
      ? data.targets_data.find((target) => target.target_tag === selectedTarget)
      : undefined;

  // Helper function to get ammo color based on percentage
  const getAmmoColor = (currentAmmo: number, maxAmmo: number) => {
    const percentage = (currentAmmo / maxAmmo) * 100;
    if (percentage <= 25) return '#FF0000'; // Red
    if (percentage <= 50) return '#FFFF00'; // Yellow
    return '#00e94e'; // Green
  };

  // Helper function to render colored ammo text
  const renderAmmoText = (weapon) => {
    if (
      weapon.ammo === null ||
      weapon.ammo === undefined ||
      weapon.ammo === 0
    ) {
      return (
        <span style={{ color: '#FF0000', fontSize: '1.1em' }}>DEPLETED</span>
      );
    }
    const ammoColor = getAmmoColor(weapon.ammo, weapon.max_ammo);
    return (
      <span style={{ color: ammoColor, fontSize: '1.1em' }}>
        {`${weapon.ammo}/${weapon.max_ammo}`}
      </span>
    );
  };

  return (
    <Stack>
      <Stack.Item>
        <svg height="501" width="100" overflow="visible">
          <text
            stroke={props.color || '#00e94e'}
            x={60}
            y={230}
            textAnchor="start"
          >
            {props.quickMode ? 'FIRE' : 'ACTIONS'}
          </text>
          {(props.quickMode ? props.allWeapons?.[1] : true) && (
            <path
              fillOpacity="0"
              stroke={props.color || '#00e94e'}
              d="M 50 210 l -20 0 l -20 -180 l -40 0"
            />
          )}
          {(props.quickMode ? props.allWeapons?.[0] : false) && (
            <path
              fillOpacity="0"
              stroke={props.color || '#00e94e'}
              d="M 50 220 l -25 0 l -15 -90 l -40 0"
            />
          )}
          {false && (
            <path
              fillOpacity="0"
              stroke={props.color || '#00e94e'}
              d="M 50 230 l -20 0 l -20 0 l -40 0"
            />
          )}

          {false && (
            <path
              fillOpacity="0"
              stroke={props.color || '#00e94e'}
              d="M 50 240 l -25 0 l -15 90 l -40 0"
            />
          )}
          {false && (
            <path
              fillOpacity="0"
              stroke={props.color || '#00e94e'}
              d="M 50 250 l -20 0 l -20 180 l -40 0"
            />
          )}
        </svg>
      </Stack.Item>
      <Stack.Item>
        <Box width="300px">
          {props.quickMode ? (
            <Stack vertical className="WeaponsDesc">
              <Stack.Item>
                <h2 style={{ color: '#00e94e', textAlign: 'center' }}>
                  WEAPONS FREE
                </h2>
              </Stack.Item>
              <Stack.Item>
                <h3 style={{ textAlign: 'center', color: '#ffcc00' }}>
                  LEFT WEAPONS
                </h3>
              </Stack.Item>
              {/* Left weapons: weap2, weap1 */}
              {props.allWeapons
                ?.filter((w) => w.mount_point === 2)
                .map((weapon) => (
                  <Stack.Item key={weapon.mount_point}>
                    <h3>
                      {weapon.name}: {renderAmmoText(weapon)}
                    </h3>
                  </Stack.Item>
                ))}
              {props.allWeapons
                ?.filter((w) => w.mount_point === 1)
                .map((weapon) => (
                  <Stack.Item key={weapon.mount_point}>
                    <h3>
                      {weapon.name}: {renderAmmoText(weapon)}
                    </h3>
                  </Stack.Item>
                ))}
              <Stack.Item>
                <h3 style={{ textAlign: 'center', color: '#ffcc00' }}>
                  RIGHT WEAPONS
                </h3>
              </Stack.Item>
              {/* Right weapons: weap3, weap4 */}
              {props.allWeapons
                ?.filter((w) => w.mount_point === 3)
                .map((weapon) => (
                  <Stack.Item key={weapon.mount_point}>
                    <h3>
                      {weapon.name}: {renderAmmoText(weapon)}
                    </h3>
                  </Stack.Item>
                ))}
              {props.allWeapons
                ?.filter((w) => w.mount_point === 4)
                .map((weapon) => (
                  <Stack.Item key={weapon.mount_point}>
                    <h3>
                      {weapon.name}: {renderAmmoText(weapon)}
                    </h3>
                  </Stack.Item>
                ))}
            </Stack>
          ) : (
            <Stack vertical className="WeaponsDesc">
              <Stack.Item>
                <h3>{props.equipment.name}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>{props.equipment.ammo_name}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>Ammo {renderAmmoText(props.equipment)}</h3>
              </Stack.Item>
              {isOnCooldown && (
                <Stack.Item>
                  <h3 style={{ color: '#ff8c00' }}>
                    <Icon name="clock" /> Cooldown: {remainingTime}s
                  </h3>
                </Stack.Item>
              )}
              {!isOnCooldown && props.equipment.is_weapon === 1 && (
                <Stack.Item>
                  <h3 style={{ color: '#00e94e' }}>
                    <Icon name="crosshairs" /> Ready to Fire
                  </h3>
                </Stack.Item>
              )}
              {selectedTargetData && (
                <Stack.Item>
                  <h3>
                    Target Durability:{' '}
                    <span
                      style={{
                        color:
                          typeof selectedTargetData.ceiling_protection_tier ===
                          'number'
                            ? selectedTargetData.ceiling_protection_tier >= 1 &&
                              selectedTargetData.ceiling_protection_tier < 2
                              ? '#FFD700'
                              : selectedTargetData.ceiling_protection_tier >=
                                    2 &&
                                  selectedTargetData.ceiling_protection_tier < 4
                                ? '#FF0000'
                                : '#00FF00'
                            : undefined,
                        fontWeight: 'bold',
                        fontSize: '0.9em',
                      }}
                    >
                      {(() => {
                        if (
                          selectedTargetData.ceiling_protection_tier ===
                            undefined ||
                          selectedTargetData.ceiling_protection_tier === null
                        ) {
                          return 'N/A';
                        }
                        const tier = Math.floor(
                          Number(selectedTargetData.ceiling_protection_tier),
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
              )}
            </Stack>
          )}
        </Box>
      </Stack.Item>
      <Stack.Item>
        <svg width="50px" height="500px" overflow="visible">
          <g transform="translate(-10)">
            {!props.quickMode && data.targets_data.length === 0 && (
              <text
                stroke={props.color || '#00e94e'}
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
            {!props.quickMode && data.targets_data.length > 0 && (
              <text
                stroke={props.color || '#00e94e'}
                x={20}
                y={190}
                textAnchor="end"
              >
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
            {props.quickMode && (
              <text
                stroke={props.color || '#00e94e'}
                x={40}
                y={230}
                textAnchor="middle"
              >
                FIRE
              </text>
            )}
            {props.quickMode ? (
              <>
                {props.allWeapons?.[2] && (
                  <path
                    fillOpacity="0"
                    stroke={props.color || '#00e94e'}
                    d="M 50 210 l 20 0 l 20 -180 l 40 0"
                  />
                )}
                {props.allWeapons?.[3] && (
                  <path
                    fillOpacity="0"
                    stroke={props.color || '#00e94e'}
                    d="M 50 220 l 25 0 l 15 -90 l 40 0"
                  />
                )}
              </>
            ) : (
              <TargetLines panelId={props.panelId} color={props.color} />
            )}
          </g>
        </svg>
      </Stack.Item>
    </Stack>
  );
};

export const WeaponMfdPanel = (props: MfdProps) => {
  const { setPanelState } = mfdState(props.panelStateId);
  const { weaponState } = useWeaponState(props.panelStateId);
  const { data, act } = useBackend<EquipmentContext>();
  const { targetOffset, setTargetOffset } = useTargetOffset(props.panelStateId);
  const { quickMode, setQuickMode } = useQuickMode(props.panelStateId);
  const { selectedTarget } = useLazeTarget();

  const weap = data.equipment_data.find((x) => x.mount_point === weaponState);
  const { isOnCooldown } = useFiringCooldown(weap || ({} as DropshipEquipment));
  const targets = range(targetOffset, targetOffset + 5).map((x) =>
    lazeMapper(x),
  );

  // Find equipment by mount points
  const weap1 = data.equipment_data.find((x) => x.mount_point === 1);
  const weap2 = data.equipment_data.find((x) => x.mount_point === 2);
  const weap3 = data.equipment_data.find((x) => x.mount_point === 3);
  const weap4 = data.equipment_data.find((x) => x.mount_point === 4);

  // Get all weapons for display
  const allWeapons = [weap1, weap2, weap3, weap4].filter(
    Boolean,
  ) as DropshipEquipment[];

  const cooldown1 = useFiringCooldown(weap1 || ({} as DropshipEquipment));
  const cooldown2 = useFiringCooldown(weap2 || ({} as DropshipEquipment));
  const cooldown3 = useFiringCooldown(weap3 || ({} as DropshipEquipment));
  const cooldown4 = useFiringCooldown(weap4 || ({} as DropshipEquipment));

  // Generate weapon button for quick mode
  const generateWeaponButton = (weapon, cooldown) => {
    if (!weapon || !weapon.is_weapon) return {};

    const hasAmmo =
      weapon.ammo !== null && weapon.ammo !== undefined && weapon.ammo > 0;

    return {
      children: cooldown.isOnCooldown
        ? `${weapon.shorthand} COOL`
        : hasAmmo
          ? weapon.shorthand
          : `${weapon.shorthand} EMPTY`,
      disabled: cooldown.isOnCooldown || !selectedTarget || !hasAmmo,
      onClick: () => act('fire-weapon', { eqp_tag: weapon.eqp_tag }),
    };
  };

  const hasAmmo =
    weap && weap.ammo !== null && weap.ammo !== undefined && weap.ammo > 0;

  const leftButtons = quickMode
    ? [
        generateWeaponButton(weap2, cooldown2),
        generateWeaponButton(weap1, cooldown1),
        {},
        {},
        {},
      ]
    : [
        {
          children: isOnCooldown ? 'COOLING' : !hasAmmo ? 'EMPTY' : 'FIRE',
          disabled: isOnCooldown || !hasAmmo,
          onClick: () => act('fire-weapon', { eqp_tag: weap?.eqp_tag }),
        },
      ];

  const rightButtons = quickMode
    ? [
        generateWeaponButton(weap3, cooldown3),
        generateWeaponButton(weap4, cooldown4),
        {},
        {},
        {},
      ]
    : targets;

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      leftButtons={leftButtons}
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
      topButtons={[
        {
          children: 'EQUIP',
          onClick: () => setPanelState('equipment'),
        },
        {},
        {
          children: 'QUICK',
          onClick: () => setQuickMode(!quickMode),
        },
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
      rightButtons={rightButtons}
    >
      <Box className="NavigationMenu">
        {weap ? (
          <WeaponPanel
            equipment={weap}
            panelId={props.panelStateId}
            color={props.color}
            quickMode={quickMode}
            allWeapons={allWeapons}
          />
        ) : (
          <EmptyWeaponPanel />
        )}
      </Box>
    </MfdPanel>
  );
};
