import { useBackend } from 'tgui/backend';
import { Box } from 'tgui/components';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState, useWeaponState } from './stateManagers';
import type { EquipmentContext } from './types';

const equipment_xs = [140, 160, 320, 340, 180, 300, 240, 240, 240, 140, 340];
const equipment_ys = [120, 100, 100, 120, 100, 100, 260, 300, 340, 320, 320];

// Color mapping function
const getThemeColor = (color?: 'green' | 'yellow' | 'blue') => {
  switch (color) {
    case 'blue':
      return '#0080ff'; // hsl(200, 100%, 50%)
    case 'yellow':
      return '#ffcc00';
    case 'green':
    default:
      return '#00e94e';
  }
};

const DrawWeapon = (props: {
  readonly x: number;
  readonly y: number;
  readonly damaged?: boolean;
  readonly color?: 'green' | 'yellow' | 'blue';
}) => {
  const themeColor = getThemeColor(props.color);
  const color = props.damaged ? '#e90000' : themeColor;
  return (
    <>
      <path
        fillOpacity="1"
        fill={color}
        stroke={color}
        d={`M ${props.x + 5} ${props.y} l 0 20 l 10 0 l 0 -20 l -10 0`}
      />
      {props.damaged && (
        <text
          x={props.x + 10}
          y={props.y - 10}
          textAnchor="middle"
          fontWeight="bold"
          fill="#e90000"
        >
          ERR#R
        </text>
      )}
    </>
  );
};

const DrawEquipmentBox = (props: {
  readonly x: number;
  readonly y: number;
  readonly color?: 'green' | 'yellow' | 'blue';
}) => {
  const themeColor = getThemeColor(props.color);
  return (
    <path
      fillOpacity="1"
      fill={themeColor}
      stroke={themeColor}
      d={`M ${props.x} ${props.y} l 0 20 l 20 0 l 0 -20 l -20 0`}
    />
  );
};

const equipment_text_xs = [
  100, 120, 360, 380, 180, 320, 250, 250, 250, 100, 400,
];
const equipment_text_ys = [120, 60, 60, 120, 20, 20, 240, 280, 320, 320, 320];

const DrawWeaponText = (props: {
  readonly x: number;
  readonly y: number;
  readonly desc: string;
  readonly sub_desc?: string;
  readonly sub_desc_color?: string;
  readonly color?: 'green' | 'yellow' | 'blue';
}) => {
  const themeColor = getThemeColor(props.color);
  return (
    <text stroke={themeColor} x={props.x} y={props.y} textAnchor="middle">
      {props.desc.split(' ').map((x) => (
        <tspan x={props.x} dy="1.2em" key={x}>
          {x}
        </tspan>
      ))}

      {props.sub_desc && (
        <tspan
          x={props.x}
          dy="1.2em"
          stroke={props.sub_desc_color || themeColor}
        >
          {props.sub_desc}
        </tspan>
      )}
    </text>
  );
};

const DrawWeaponEquipment = (
  props: DropshipEquipment & { readonly color?: 'green' | 'yellow' | 'blue' },
) => {
  // Color coding for ammo status
  let ammoText: string;
  let ammoColor: string | undefined;

  if (props.shorthand === 'MSL') {
    ammoText = props.ammo_name?.split(' ')[0] ?? 'EMPTY';
    // Color code missiles based on whether they're loaded
    if (!props.ammo_name || props.ammo_name === 'EMPTY') {
      ammoColor = '#ff0000'; // Red for empty
    } else {
      ammoColor = '#00ff00'; // Green for loaded
    }
  } else {
    const currentAmmo = props.ammo ?? 0;
    const maxAmmo = props.max_ammo ?? 1;

    if (currentAmmo === 0) {
      ammoText = 'EMPTY';
      ammoColor = '#ff0000'; // Red
    } else {
      ammoText = currentAmmo.toString();
      const percentage = (currentAmmo / maxAmmo) * 100;

      if (percentage <= 25) {
        ammoColor = '#ff0000'; // Red for critical
      } else if (percentage <= 50) {
        ammoColor = '#ffff00'; // Yellow for low
      } else {
        ammoColor = '#00ff00'; // Green for moderate/high
      }
    }
  }

  return (
    <>
      <DrawWeapon
        key={props.mount_point}
        x={equipment_xs[props.mount_point - 1]}
        y={equipment_ys[props.mount_point - 1]}
        damaged={props.damaged}
        color={props.color}
      />
      <DrawWeaponText
        x={equipment_text_xs[props.mount_point - 1]}
        y={equipment_text_ys[props.mount_point - 1]}
        desc={props.shorthand}
        sub_desc={ammoText}
        sub_desc_color={ammoColor}
        color={props.color}
      />
    </>
  );
};

const DrawMiscEquipment = (
  props: DropshipEquipment & { readonly color?: 'green' | 'yellow' | 'blue' },
) => {
  return (
    <>
      <DrawEquipmentBox
        key={props.mount_point}
        x={equipment_xs[props.mount_point - 1]}
        y={equipment_ys[props.mount_point - 1]}
        color={props.color}
      />
      <DrawWeaponText
        x={equipment_text_xs[props.mount_point - 1]}
        y={equipment_text_ys[props.mount_point - 1]}
        desc={props.shorthand ?? props.name}
        color={props.color}
      />
    </>
  );
};

const DrawEquipment = (props: {
  readonly color?: 'green' | 'yellow' | 'blue';
}) => {
  const { data } = useBackend<EquipmentContext>();
  return (
    <>
      {data.equipment_data.map((x) => {
        if (x.is_weapon) {
          return (
            <DrawWeaponEquipment
              key={x.mount_point}
              color={props.color}
              {...x}
            />
          );
        }
        return (
          <DrawMiscEquipment key={x.mount_point} color={props.color} {...x} />
        );
      })}
    </>
  );
};

const DrawDropshipOutline = (props: {
  readonly color?: 'green' | 'yellow' | 'blue';
}) => {
  const themeColor = getThemeColor(props.color);
  return (
    <>
      {/* cockpit */}
      <path
        fillOpacity="0"
        stroke={themeColor}
        d="M 200 120 l 0 -80 l 100 0 l 0 80 m -40 0 l 20 0 l 0 -60 l -60 0 l 0 60 l 20 0"
      />

      {/* left body */}
      <path
        fillOpacity="0"
        stroke={themeColor}
        d="M 200 120 L 160 120 L 160 280 L 180 280 L 180 400 L 220 400 L 220 380 L 200 380 L 200 260 L 180 260 L 180 140 L 240 140 L 240 120"
      />

      {/* left weapon */}
      <path
        fillOpacity="0"
        stroke={themeColor}
        d="M 160 140 l -20 0 l 0 40 l 20 0"
      />
      {/* left engine */}
      <path
        fillOpacity="0"
        stroke={themeColor}
        d="M 180 380 L 140 380 L 140 300 L 180 300"
      />

      {/* left tail */}
      <path
        fillOpacity="0"
        stroke={themeColor}
        d="M 200 400 l 0 40 l -40 0 l 0 20 l 60 0 l 0 -60"
      />

      {/* right body */}
      <path
        fillOpacity="0"
        stroke={themeColor}
        d="M 300 120 L 340 120 L 340 280 L 320 280 L 320 400 L 280 400 L 280 380 L 300 380 L 300 260 L 320 260 L 320 140 L 260 140 L 260 120"
      />
      {/* right weapon */}
      <path
        fillOpacity="0"
        stroke={themeColor}
        d="M 340 140 L 360 140 L 360 180 L 340 180"
      />

      {/* right engine */}
      <path
        className="dropshipImage"
        fillOpacity="0"
        stroke={themeColor}
        d="M 320 380 L 360 380 L 360 300 L 320 300"
      />

      {/* right tail */}
      <path
        fillOpacity="0"
        stroke={themeColor}
        d="M 300 400 L 300 440 L 340 440 L 340 460 L 280 460 L 280 400"
      />
    </>
  );
};
const DrawAirlocks = (props: {
  readonly color?: 'green' | 'yellow' | 'blue';
}) => {
  const themeColor = getThemeColor(props.color);
  return (
    <>
      {/* cockpit door */}
      <path
        fillOpacity="1"
        fill="url(#diagonalHatch)"
        stroke={themeColor}
        d="M 240 140 L 260 140 L 260 120 L 240 120 L 240 140"
      />
      {/* left airlock */}
      <path
        fill="url(#diagonalHatch)"
        stroke={themeColor}
        d="M 160 180 l 20 0 l 0 40 l -20 0 l 0 -40 "
      />
      {/* right airlock */}
      <path
        fill="url(#diagonalHatch)"
        stroke={themeColor}
        d="M 340 180 L 320 180 L 320 220 L 340 220 L 340 180 "
      />
      {/* rear ramp */}
      <path
        fill="url(#diagonalHatch)"
        stroke={themeColor}
        d="M 220 400 L 280 400 L 280 380 L 220 380 L 220 400"
      />
    </>
  );
};

const EquipmentPanel = (props: {
  readonly color?: 'green' | 'yellow' | 'blue';
}) => {
  const themeColor = getThemeColor(props.color);
  return (
    <Box className="NavigationMenu">
      <svg height="501" width="501" overflow="visible">
        <defs>
          <pattern
            id="diagonalHatch"
            patternUnits="userSpaceOnUse"
            width="4"
            height="4"
          >
            <path
              stroke={themeColor}
              strokeWidth="1"
              d="M-1,1 l2,-2 M 0,4 l4,-4 M3,5 l2,-2"
            />
          </pattern>
          <pattern
            id="smallGrid"
            width="20"
            height="20"
            patternUnits="userSpaceOnUse"
          >
            <path
              d="M 20 0 L 0 0 0 20"
              fill="none"
              stroke="gray"
              strokeWidth="0.5"
            />
          </pattern>
          <pattern
            id="grid"
            width="100"
            height="100"
            patternUnits="userSpaceOnUse"
          >
            <rect width="100" height="100" fill="url(#smallGrid)" />
            <path
              d="M 100 0 L 0 0 0 100"
              fill="none"
              stroke="gray"
              strokeWidth="1"
            />
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#grid)" />
        <DrawDropshipOutline color={props.color} />
        <DrawEquipment color={props.color} />
        <ShipOutline />
        <DrawAirlocks color={props.color} />
      </svg>
    </Box>
  );
};

const ShipOutline = () => {
  return <line x1={140} y1={140} x2={280} y2={280} />;
};

export const EquipmentMfdPanel = (props: MfdProps) => {
  const { data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);

  const { setWeaponState } = useWeaponState(props.panelStateId);

  const { setEquipmentState } = useEquipmentState(props.panelStateId);

  const equipmentData = data.equipment_data || [];

  const weap1 = equipmentData.find((x) => x.mount_point === 1);
  const weap2 = equipmentData.find((x) => x.mount_point === 2);
  const weap3 = equipmentData.find((x) => x.mount_point === 3);
  const weap4 = equipmentData.find((x) => x.mount_point === 4);
  const support1 = equipmentData.find((x) => x.mount_point === 7);
  const support2 = equipmentData.find((x) => x.mount_point === 8);
  const support3 = equipmentData.find((x) => x.mount_point === 9);

  const elec1 = equipmentData.find((x) => x.mount_point === 5);
  const elec2 = equipmentData.find((x) => x.mount_point === 6);

  const generateWeaponButton = (equip: DropshipEquipment) => {
    // Check if weapon has ammo
    const hasAmmo =
      equip.ammo !== null && equip.ammo !== undefined && equip.ammo > 0;

    return {
      children: equip.shorthand,
      borderColor: hasAmmo ? undefined : '#ff0000',
      onClick: () => {
        setWeaponState(equip.mount_point);
        setPanelState('weapon');
      },
    };
  };

  const generateEquipmentButton = (equip: DropshipEquipment) => {
    return {
      children: equip.shorthand,
      onClick: () => {
        setEquipmentState(equip.mount_point);
        setPanelState('support');
      },
    };
  };

  const generateButton = (equip: DropshipEquipment) => {
    // Hide weapon mount point equipment in camera console
    if (
      props.color === 'blue' &&
      equip.mount_point >= 1 &&
      equip.mount_point <= 4 &&
      equip.is_weapon &&
      equip.shorthand !== 'Sentry' &&
      equip.shorthand !== 'MG'
    ) {
      return {};
    }

    return equip.is_weapon
      ? generateWeaponButton(equip)
      : generateEquipmentButton(equip);
  };

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      leftButtons={[
        weap2 ? generateButton(weap2) : {},
        weap1 ? generateButton(weap1) : {},
        elec1 ? generateButton(elec1) : {},
        support1 ? generateButton(support1) : {},
        support2 ? generateButton(support2) : {},
      ]}
      rightButtons={[
        weap3 ? generateButton(weap3) : {},
        weap4 ? generateButton(weap4) : {},
        elec2 ? generateButton(elec2) : {},
        support3 ? generateButton(support3) : {},
        {},
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}
    >
      <EquipmentPanel color={props.color} />
    </MfdPanel>
  );
};
