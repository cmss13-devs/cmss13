import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Icon } from 'tgui/components';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import type { AutoreloaderSpec } from './types';
import { useSupportCooldown } from './WeaponPanel';

export const AutoReloaderMfdPanel = (props: MfdProps) => {
  const { setPanelState } = mfdState(props.panelStateId);
  const { data, act } = useBackend<{
    equipment_data: Array<DropshipEquipment & Partial<AutoreloaderSpec>>;
    selected_weapon?: number | string;
  }>();
  const autoreloader = data.equipment_data?.find(
    (eq) => eq.shorthand === 'RMT',
  ) as
    | (DropshipEquipment &
        Partial<AutoreloaderSpec> & {
          selected_weapon?: DropshipEquipment;
          selected_ammo?: any;
        })
    | undefined;
  const weapons = data.equipment_data?.filter((eq) => eq.is_weapon);

  const { isOnCooldown, remainingTime } = useSupportCooldown(
    (autoreloader as any) || {},
  );

  // Local state for which weapon is being selected for ammo
  const [pendingWeapon, setPendingWeapon] = useState<number | undefined>(
    undefined,
  );

  // Use selected_weapon from backend if present
  const selectedWeapon = weapons?.find(
    (w) => w.eqp_tag === data.selected_weapon,
  );

  // Handler for weapon button click
  const handleWeaponClick = (eqp_tag: number) => {
    setPendingWeapon(eqp_tag);
  };

  // Handler for ammo button click
  const handleAmmoClick = (ammoRef: string) => {
    if (pendingWeapon !== undefined) {
      act('select-ammo', { eqp_tag: pendingWeapon, ammo_ref: ammoRef });
      setPendingWeapon(undefined);
    }
  };

  // Handler to cancel ammo selection
  const handleCancel = () => {
    setPendingWeapon(undefined);
  };

  // Only show weapons that do not have ammo_equipped (ammo property is null or 0)
  const selectableWeapons = weapons?.filter((w) => !w.ammo);

  // Separate weapons by mount point for left/right button mapping
  const leftWeapons =
    selectableWeapons?.filter(
      (w) => w.mount_point === 1 || w.mount_point === 2,
    ) || [];
  const rightWeapons =
    selectableWeapons?.filter(
      (w) => w.mount_point === 3 || w.mount_point === 4,
    ) || [];

  const leftButtons =
    pendingWeapon === undefined
      ? [
          // Mount point 2 first (left nose)
          ...leftWeapons
            .filter((weap) => weap.mount_point === 2)
            .map((weap) => ({
              children: weap.shorthand,
              onClick: () => handleWeaponClick(weap.eqp_tag),
            })),
          // Mount point 1 second (left wing)
          ...leftWeapons
            .filter((weap) => weap.mount_point === 1)
            .map((weap) => ({
              children: weap.shorthand,
              onClick: () => handleWeaponClick(weap.eqp_tag),
            })),
        ]
      : [
          ...(autoreloader?.stored_ammo?.map((ammo, idx) => ({
            children: `${ammo.name} (${ammo.ammo_count ?? 0}/${ammo.max_ammo_count ?? 0})`,
            onClick: () => handleAmmoClick(ammo.ref),
          })) || []),
          { children: 'CANCEL', onClick: handleCancel },
        ];

  const rightButtons =
    pendingWeapon === undefined
      ? [
          // Mount point 3 first (right wing)
          ...rightWeapons
            .filter((weap) => weap.mount_point === 3)
            .map((weap) => ({
              children: weap.shorthand,
              onClick: () => handleWeaponClick(weap.eqp_tag),
            })),
          // Mount point 4 second (right front)
          ...rightWeapons
            .filter((weap) => weap.mount_point === 4)
            .map((weap) => ({
              children: weap.shorthand,
              onClick: () => handleWeaponClick(weap.eqp_tag),
            })),
        ]
      : [];

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      leftButtons={leftButtons}
      rightButtons={rightButtons}
      topButtons={[
        {
          children: 'EQUIP',
          onClick: () => setPanelState('equipment'),
        },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}
    >
      <Box className="NavigationMenu">
        {autoreloader ? (
          <Box
            style={{
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'flex-start',
              height: '501px',
              width: '100%',
              padding: '8px',
              overflow: 'hidden',
            }}
          >
            {/* Top status bar */}
            <Box
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                width: '100%',
                marginBottom: '1px',
                fontSize: '1.0em',
                height: '40px',
                flexShrink: '0',
              }}
            >
              <Box style={{ textAlign: 'left', flexGrow: '1' }}>
                <div style={{ fontWeight: 'bold' }}>{autoreloader.name}</div>
                {isOnCooldown ? (
                  <div style={{ color: '#ff8c00' }}>
                    <Icon name="clock" /> Cooldown: {remainingTime}s
                  </div>
                ) : (
                  <div style={{ color: '#00e94e' }}>
                    <Icon name="check" /> Ready
                  </div>
                )}
              </Box>

              <Box
                style={{
                  textAlign: 'center',
                  flexGrow: '1',
                  marginLeft: '-30px',
                }}
              >
                <div
                  style={{
                    fontWeight: 'bold',
                    fontSize: '1.4em',
                    textDecoration: 'underline',
                  }}
                >
                  {pendingWeapon === undefined
                    ? 'SELECT WEAPON'
                    : 'SELECT AMMO'}
                </div>
                {pendingWeapon !== undefined && (
                  <div style={{ fontSize: '1.0em', color: '#ff8c00' }}>
                    For:{' '}
                    {weapons?.find((w) => w.eqp_tag === pendingWeapon)
                      ?.shorthand || 'Unknown'}
                  </div>
                )}
              </Box>

              <Box
                style={{
                  textAlign: 'right',
                  flexGrow: '1',
                  height: '40px',
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'flex-start',
                  minWidth: '170px',
                }}
              >
                <div style={{ fontWeight: 'bold', fontSize: '0.9em' }}>
                  Stored Ammo
                </div>
                <div style={{ fontSize: '0.8em', flexGrow: '1' }}>
                  {Array.isArray(autoreloader.stored_ammo) &&
                  autoreloader.stored_ammo.length > 0 ? (
                    autoreloader.stored_ammo.map((ammo, idx) => (
                      <div key={ammo.ref || idx} style={{ lineHeight: '1.1' }}>
                        {ammo.name}: {ammo.ammo_count ?? 0}/
                        {ammo.max_ammo_count ?? 0}
                      </div>
                    ))
                  ) : (
                    <div style={{ color: '#888' }}>Empty</div>
                  )}
                </div>
              </Box>
            </Box>

            {/* Center: Dropship outline with equipment */}
            <Box
              style={{
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'flex-start',
                flexGrow: '1',
                width: '100%',
                minHeight: '0',
              }}
            >
              <DropshipDiagram
                weapons={weapons || []}
                pendingWeapon={pendingWeapon}
                color={
                  props.color === 'blue'
                    ? '#5fb3f0'
                    : props.color === 'green'
                      ? '#00e94e'
                      : props.color === 'yellow'
                        ? '#ffff00'
                        : '#00e94e'
                }
                autoreloader={autoreloader}
              />
            </Box>

            {/* Bottom status */}
            {(autoreloader?.data?.selected_weapon ||
              autoreloader?.data?.selected_ammo) && (
              <Box
                style={{
                  display: 'flex',
                  justifyContent: 'center',
                  gap: '20px',
                  marginTop: '0px',
                  fontSize: '0.9em',
                }}
              >
                {autoreloader?.data?.selected_weapon && (
                  <div style={{ textAlign: 'center' }}>
                    <div style={{ fontWeight: 'bold' }}>Selected Weapon</div>
                    <div>
                      {weapons?.find(
                        (w) => w.eqp_tag === autoreloader.data.selected_weapon,
                      )?.name || autoreloader.data.selected_weapon}
                    </div>
                  </div>
                )}
                {autoreloader?.data?.selected_ammo && (
                  <div style={{ textAlign: 'center' }}>
                    <div style={{ fontWeight: 'bold' }}>Selected Ammo</div>
                    <div>
                      {autoreloader.data.selected_ammo.name ||
                        autoreloader.data.selected_ammo}
                    </div>
                  </div>
                )}
              </Box>
            )}
          </Box>
        ) : (
          <div>Nothing Listed</div>
        )}
      </Box>
    </MfdPanel>
  );
};

// --- Dropship Outline Drawing ---

const equipment_xs = [138, 158, 318, 338];
const equipment_ys = [61, 41, 41, 61];

const DrawWeapon = ({
  x,
  y,
  weapon,
  isPending,
  color,
  autoreloader,
  allWeapons,
}: {
  readonly x: number;
  readonly y: number;
  readonly weapon?: DropshipEquipment;
  readonly isPending?: boolean;
  readonly color: string;
  readonly autoreloader?: any;
  readonly allWeapons?: DropshipEquipment[];
}) => {
  const isReadyToReload =
    weapon &&
    !weapon.ammo && // Not already loaded
    !isPending && // Not currently being selected
    autoreloader?.data?.selected_weapon &&
    autoreloader?.data?.selected_ammo &&
    // Match by unique eqp_tag to distinguish between identical weapons
    autoreloader?.data?.selected_weapon === weapon.eqp_tag;

  let weaponColor = color; // Default color

  // Check states in priority order (most important first)
  if (isReadyToReload) {
    weaponColor = '#00ffff'; // Cyan for ready to reload (highest priority)
  } else if (weapon?.ammo) {
    weaponColor = '#00e94e'; // Green for loaded weapons
  } else if (isPending) {
    weaponColor = '#ff8c00'; // Orange for pending weapon
  } else if (weapon && !weapon.ammo) {
    weaponColor = '#ffff00'; // Yellow for empty weapons
  }

  // Only render if there's a weapon installed
  if (!weapon) {
    return null;
  }

  return (
    <>
      {/* Weapon base */}
      <path
        fillOpacity="1"
        fill={weaponColor}
        stroke={weaponColor}
        d={`M ${x + 5} ${y} l 0 20 l 10 0 l 0 -20 l -10 0`}
      />
      {/* Weapon label */}
      <text
        x={x + 10}
        y={y - 5}
        textAnchor="middle"
        fontWeight="bold"
        fontSize="12"
        fill={weaponColor}
      >
        {weapon.shorthand}
      </text>
      {/* Ammo status */}
      {weapon.ammo && (
        <text
          x={x + 10}
          y={y + 35}
          textAnchor="middle"
          fontSize="12"
          fill={weaponColor}
        >
          {weapon.ammo}/{weapon.max_ammo}
        </text>
      )}
      {/* Pending indicator */}
      {isPending && (
        <text
          x={x + 10}
          y={y + 35}
          textAnchor="middle"
          fontWeight="bold"
          fontSize="12"
          fill="#ff8c00"
        >
          SELECT
        </text>
      )}
      {/* Ready to reload indicator */}
      {isReadyToReload && (
        <text
          x={x + 10}
          y={y + 35}
          textAnchor="middle"
          fontWeight="bold"
          fontSize="12"
          fill="#00ffff"
        >
          READY
        </text>
      )}
    </>
  );
};

const DrawDropshipOutline = ({ color }: { readonly color: string }) => (
  <>
    {/* cockpit */}
    <path
      fillOpacity="0"
      stroke={color}
      d="M 197 61 l 0 -80 l 100 0 l 0 80 m -40 0 l 20 0 l 0 -60 l -60 0 l 0 60 l 20 0"
    />
    {/* left body */}
    <path
      fillOpacity="0"
      stroke={color}
      d="M 197 61 L 157 61 L 157 221 L 177 221 L 177 341 L 217 341 L 217 321 L 197 321 L 197 201 L 177 201 L 177 81 L 237 81 L 237 61"
    />
    {/* left weapon */}
    <path fillOpacity="0" stroke={color} d="M 157 81 l -20 0 l 0 40 l 20 0" />
    {/* left engine */}
    <path
      fillOpacity="0"
      stroke={color}
      d="M 177 321 L 137 321 L 137 241 L 177 241"
    />
    {/* left tail */}
    <path
      fillOpacity="0"
      stroke={color}
      d="M 197 341 l 0 40 l -40 0 l 0 20 l 60 0 l 0 -60"
    />
    {/* right body */}
    <path
      fillOpacity="0"
      stroke={color}
      d="M 297 61 L 337 61 L 337 221 L 317 221 L 317 341 L 277 341 L 277 321 L 297 321 L 297 201 L 317 201 L 317 81 L 257 81 L 257 61"
    />
    {/* right weapon */}
    <path
      fillOpacity="0"
      stroke={color}
      d="M 337 81 L 357 81 L 357 121 L 337 121"
    />
    {/* right engine */}
    <path
      fillOpacity="0"
      stroke={color}
      d="M 317 321 L 357 321 L 357 241 L 317 241"
    />
    {/* right tail */}
    <path
      fillOpacity="0"
      stroke={color}
      d="M 297 341 L 297 381 L 337 381 L 337 401 L 277 401 L 277 341"
    />
    {/* Side labels */}
    <text
      x={86}
      y={101}
      textAnchor="middle"
      fontSize="16"
      fontWeight="bold"
      fill={color}
    >
      PORT
    </text>
    <text
      x={406}
      y={101}
      textAnchor="middle"
      fontSize="16"
      fontWeight="bold"
      fill={color}
    >
      STARBOARD
    </text>
  </>
);

const DrawAirlocks = ({ color }: { readonly color: string }) => (
  <>
    {/* cockpit door */}
    <path
      fillOpacity="1"
      fill="url(#autoreloaderDiagonalHatch)"
      stroke={color}
      d="M 237 81 L 257 81 L 257 61 L 237 61 L 237 81"
    />
    {/* left airlock */}
    <path
      fillOpacity="1"
      fill="url(#autoreloaderDiagonalHatch)"
      stroke={color}
      d="M 157 121 l 20 0 l 0 40 l -20 0 l 0 -40 "
    />
    {/* right airlock */}
    <path
      fillOpacity="1"
      fill="url(#autoreloaderDiagonalHatch)"
      stroke={color}
      d="M 337 121 L 317 121 L 317 161 L 337 161 L 337 121 "
    />
    {/* rear ramp */}
    <path
      fillOpacity="1"
      fill="url(#autoreloaderDiagonalHatch)"
      stroke={color}
      d="M 217 341 L 277 341 L 277 321 L 217 321 L 217 341"
    />
  </>
);

const DrawEquipment = ({
  weapons,
  pendingWeapon,
  color,
  autoreloader,
}: {
  readonly weapons: DropshipEquipment[];
  readonly pendingWeapon?: number;
  readonly color: string;
  readonly autoreloader?: any;
}) => {
  return (
    <>
      {equipment_xs.map((x, i) => {
        const mountPoint = i + 1;
        const weapon = weapons.find((w) => w.mount_point === mountPoint);
        const isPending = weapon && weapon.eqp_tag === pendingWeapon;

        return (
          <DrawWeapon
            key={i}
            x={x}
            y={equipment_ys[i]}
            weapon={weapon}
            isPending={isPending}
            color={color}
            autoreloader={autoreloader}
            allWeapons={weapons}
          />
        );
      })}
    </>
  );
};

const DropshipDiagram = ({
  weapons,
  pendingWeapon,
  color,
  autoreloader,
}: {
  readonly weapons: DropshipEquipment[];
  readonly pendingWeapon?: number;
  readonly color: string;
  readonly autoreloader?: any;
}) => {
  return (
    <Box style={{ margin: 'auto' }}>
      <svg height="420" width="500">
        <defs>
          <pattern
            id="autoreloaderDiagonalHatch"
            patternUnits="userSpaceOnUse"
            width="4"
            height="4"
          >
            <path
              stroke={color}
              strokeWidth="1"
              d="M-1,1 l2,-2 M 0,4 l4,-4 M3,5 l2,-2"
            />
          </pattern>
        </defs>
        <DrawDropshipOutline color={color} />
        <DrawAirlocks color={color} />
        <DrawEquipment
          weapons={weapons}
          pendingWeapon={pendingWeapon}
          color={color}
          autoreloader={autoreloader}
        />
      </svg>
    </Box>
  );
};
