import { useBackend } from '../../backend';
import { Box } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState, useWeaponState } from './stateManagers';
import { EquipmentContext } from './types';

const equipment_xs = [140, 160, 320, 340, 180, 300, 240, 240, 240, 140, 340];
const equipment_ys = [120, 100, 100, 120, 100, 100, 260, 300, 340, 320, 320];

const DrawWeapon = (props: { readonly x: number; readonly y: number }) => {
  return (
    <path
      fillOpacity="1"
      fill="#00e94e"
      stroke="#00e94e"
      d={`M ${props.x + 5} ${props.y} l 0 20 l 10 0 l 0 -20 l -10 0`}
    />
  );
};

const DrawEquipmentBox = (props: {
  readonly x: number;
  readonly y: number;
}) => {
  return (
    <path
      fillOpacity="1"
      fill="#00e94e"
      stroke="#00e94e"
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
}) => {
  return (
    <text stroke="#00e94e" x={props.x} y={props.y} textAnchor="middle">
      {props.desc.split(' ').map((x) => (
        <tspan x={props.x} dy="1.2em" key={x}>
          {x}
        </tspan>
      ))}

      {props.sub_desc && (
        <tspan x={props.x} dy="1.2em">
          {props.sub_desc}
        </tspan>
      )}
    </text>
  );
};

const DrawWeaponEquipment = (props: DropshipEquipment) => {
  return (
    <>
      <DrawWeapon
        key={props.mount_point}
        x={equipment_xs[props.mount_point - 1]}
        y={equipment_ys[props.mount_point - 1]}
      />
      <DrawWeaponText
        x={equipment_text_xs[props.mount_point - 1]}
        y={equipment_text_ys[props.mount_point - 1]}
        desc={props.shorthand}
        sub_desc={`${
          props.shorthand === 'MSL'
            ? props.ammo_name?.split(' ')[0] ?? 'Empty'
            : props.ammo ?? 0
        }`}
      />
    </>
  );
};

const DrawMiscEquipment = (props: DropshipEquipment) => {
  return (
    <>
      <DrawEquipmentBox
        key={props.mount_point}
        x={equipment_xs[props.mount_point - 1]}
        y={equipment_ys[props.mount_point - 1]}
      />
      <DrawWeaponText
        x={equipment_text_xs[props.mount_point - 1]}
        y={equipment_text_ys[props.mount_point - 1]}
        desc={props.shorthand ?? props.name}
      />
    </>
  );
};

const DrawEquipment = (props) => {
  const { data } = useBackend<EquipmentContext>();
  return (
    <>
      {data.equipment_data.map((x) => {
        if (x.is_weapon) {
          return <DrawWeaponEquipment key={x.mount_point} {...x} />;
        }
        return <DrawMiscEquipment key={x.mount_point} {...x} />;
      })}
    </>
  );
};

const DrawDropshipOutline = () => {
  return (
    <>
      {/* cockpit */}
      <path
        fillOpacity="0"
        stroke="#00e94e"
        d="M 200 120 l 0 -80 l 100 0 l 0 80 m -40 0 l 20 0 l 0 -60 l -60 0 l 0 60 l 20 0"
      />

      {/* left body */}
      <path
        fillOpacity="0"
        stroke="#00e94e"
        d="M 200 120 L 160 120 L 160 280 L 180 280 L 180 400 L 220 400 L 220 380 L 200 380 L 200 260 L 180 260 L 180 140 L 240 140 L 240 120"
      />

      {/* left weapon */}
      <path
        fillOpacity="0"
        stroke="#00e94e"
        d="M 160 140 l -20 0 l 0 40 l 20 0"
      />
      {/* left engine */}
      <path
        fillOpacity="0"
        stroke="#00e94e"
        d="M 180 380 L 140 380 L 140 300 L 180 300"
      />

      {/* left tail */}
      <path
        fillOpacity="0"
        stroke="#00e94e"
        d="M 200 400 l 0 40 l -40 0 l 0 20 l 60 0 l 0 -60"
      />

      {/* right body */}
      <path
        fillOpacity="0"
        stroke="#00e94e"
        d="M 300 120 L 340 120 L 340 280 L 320 280 L 320 400 L 280 400 L 280 380 L 300 380 L 300 260 L 320 260 L 320 140 L 260 140 L 260 120"
      />
      {/* right weapon */}
      <path
        fillOpacity="0"
        stroke="#00e94e"
        d="M 340 140 L 360 140 L 360 180 L 340 180"
      />

      {/* right engine */}
      <path
        className="dropshipImage"
        fillOpacity="0"
        stroke="#00e94e"
        d="M 320 380 L 360 380 L 360 300 L 320 300"
      />

      {/* right tail */}
      <path
        fillOpacity="0"
        stroke="#00e94e"
        d="M 300 400 L 300 440 L 340 440 L 340 460 L 280 460 L 280 400"
      />
    </>
  );
};
const DrawAirlocks = () => {
  return (
    <>
      {/* cockpit door */}
      <path
        fillOpacity="1"
        fill="url(#diagonalHatch)"
        stroke="#00e94e"
        d="M 240 140 L 260 140 L 260 120 L 240 120 L 240 140"
      />
      {/* left airlock */}
      <path
        fill="url(#diagonalHatch)"
        stroke="#00e94e"
        d="M 160 180 l 20 0 l 0 40 l -20 0 l 0 -40 "
      />
      {/* right airlock */}
      <path
        fill="url(#diagonalHatch)"
        stroke="#00e94e"
        d="M 340 180 L 320 180 L 320 220 L 340 220 L 340 180 "
      />
      {/* rear ramp */}
      <path
        fill="url(#diagonalHatch)"
        stroke="#00e94e"
        d="M 220 400 L 280 400 L 280 380 L 220 380 L 220 400"
      />
    </>
  );
};

const EquipmentPanel = () => {
  return (
    <Box className="NavigationMenu">
      <svg height="501" width="501">
        <defs>
          <pattern
            id="diagonalHatch"
            patternUnits="userSpaceOnUse"
            width="4"
            height="4"
          >
            <path
              stroke="#00e94e"
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
        <DrawDropshipOutline />
        <DrawEquipment />
        <ShipOutline />
        <DrawAirlocks />
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

  const weap1 = data.equipment_data.find((x) => x.mount_point === 1);
  const weap2 = data.equipment_data.find((x) => x.mount_point === 2);
  const weap3 = data.equipment_data.find((x) => x.mount_point === 3);
  const weap4 = data.equipment_data.find((x) => x.mount_point === 4);
  const support1 = data.equipment_data.find((x) => x.mount_point === 7);
  const support2 = data.equipment_data.find((x) => x.mount_point === 8);
  const support3 = data.equipment_data.find((x) => x.mount_point === 9);

  const elec1 = data.equipment_data.find((x) => x.mount_point === 5);
  const elec2 = data.equipment_data.find((x) => x.mount_point === 6);

  const generateWeaponButton = (equip: DropshipEquipment) => {
    return {
      children: equip.shorthand,
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
    return equip.is_weapon
      ? generateWeaponButton(equip)
      : generateEquipmentButton(equip);
  };

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={[
        weap2 ? generateButton(weap2) : {},
        weap1 ? generateButton(weap1) : {},
        support1 ? generateButton(support1) : {},
        support2 ? generateButton(support2) : {},
        support3 ? generateButton(support3) : {},
      ]}
      rightButtons={[
        weap3 ? generateButton(weap3) : {},
        weap4 ? generateButton(weap4) : {},
        elec1 ? generateButton(elec1) : {},
        elec2 ? generateButton(elec2) : {},
        {},
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}
    >
      <EquipmentPanel />
    </MfdPanel>
  );
};
