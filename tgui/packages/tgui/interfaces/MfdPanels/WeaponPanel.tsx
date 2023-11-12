import { range } from 'common/collections';
import { useBackend } from '../../backend';
import { Box, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdProps, MfdPanel } from './MultifunctionDisplay';
import { mfdState, useWeaponState } from './stateManagers';
import { LazeTarget } from './types';

const EmptyWeaponPanel = (props, context) => {
  return <div>Nothing Listed</div>;
};
interface EquipmentContext {
  equipment_data: Array<DropshipEquipment>;
  targets_data: Array<LazeTarget>;
}

const getLazeButtonProps = (context) => {
  const { act, data } = useBackend<EquipmentContext>(context);
  const lazes = range(0, 5).map((x) =>
    x > data.targets_data.length ? undefined : data.targets_data[x]
  );
  const get_laze = (index: number) => {
    const laze = lazes.find((_, i) => i === index);
    if (laze === undefined) {
      return {
        children: '',
        onClick: () => act('set-camera', { equipment_id: null }),
      };
    }
    return {
      children: laze?.target_name.split(' ')[0] ?? 'NONE',
      onClick: laze
        ? () => act('set-camera', { 'equipment_id': laze.target_tag })
        : undefined,
    };
  };
  return [get_laze(0), get_laze(1), get_laze(2), get_laze(3), get_laze(4)];
};

const WeaponPanel = (props: { equipment: DropshipEquipment }, context) => {
  return (
    <Stack>
      <Stack.Item>
        <svg height="501" width="100">
          <text stroke="#00e94e" x={60} y={230} text-anchor="start">
            ACTIONS
          </text>
          {false && (
            <path
              fill-opacity="0"
              stroke="#00e94e"
              d="M 50 210 l -20 0 l -20 -180 l -40 0"
            />
          )}
          {false && (
            <path
              fill-opacity="0"
              stroke="#00e94e"
              d="M 50 220 l -25 0 l -15 -90 l -40 0"
            />
          )}
          {false && (
            <path
              fill-opacity="0"
              stroke="#00e94e"
              d="M 50 230 l -20 0 l -20 0 l -40 0"
            />
          )}

          {false && (
            <path
              fill-opacity="0"
              stroke="#00e94e"
              d="M 50 240 l -25 0 l -15 90 l -40 0"
            />
          )}
          {false && (
            <path
              fill-opacity="0"
              stroke="#00e94e"
              d="M 50 250 l -20 0 l -20 180 l -40 0"
            />
          )}
        </svg>
      </Stack.Item>
      <Stack.Item>
        <Box width="300px">
          <Stack vertical className="WeaponsDesc">
            <Stack.Item>
              <h3>{props.equipment.name}</h3>
            </Stack.Item>
            <Stack.Item>
              <h3>{props.equipment.ammo_name}</h3>
            </Stack.Item>
            <Stack.Item>
              <h3>
                Ammo {props.equipment.ammo} / {props.equipment.max_ammo}
              </h3>
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      <Stack.Item>
        <svg height="501" width="100">
          <text stroke="#00e94e" x={20} y={210} text-anchor="end">
            <tspan x={40} dy="1.2em">
              SELECT
            </tspan>
            <tspan x={40} dy="1.2em">
              TARGETS
            </tspan>
          </text>
          <path
            fill-opacity="0"
            stroke="#00e94e"
            d="M 50 210 l 20 0 l 20 -180 l 40 0"
          />
          <path
            fill-opacity="0"
            stroke="#00e94e"
            d="M 50 220 l 25 0 l 15 -90 l 40 0"
          />
          <path
            fill-opacity="0"
            stroke="#00e94e"
            d="M 50 230 l 20 0 l 20 0 l 40 0"
          />

          <path
            fill-opacity="0"
            stroke="#00e94e"
            d="M 50 240 l 25 0 l 15 90 l 40 0"
          />
          <path
            fill-opacity="0"
            stroke="#00e94e"
            d="M 50 250 l 20 0 l 20 180 l 40 0"
          />
        </svg>
      </Stack.Item>
    </Stack>
  );
};

export const WeaponMfdPanel = (props: MfdProps, context) => {
  const { setPanelState } = mfdState(context, props.panelStateId);
  const { weaponState } = useWeaponState(context, props.panelStateId);
  const { data, act } = useBackend<EquipmentContext>(context);
  const weap = data.equipment_data.find((x) => x.mount_point === weaponState);

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={[
        {
          children: 'FIRE',
          onClick: () => act('fire-weapon', { eqp_tag: weap?.eqp_tag }),
        },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
        {},
      ]}
      topButtons={[
        {
          children: 'EQUIP',
          onClick: () => setPanelState('equipment'),
        },
      ]}
      rightButtons={getLazeButtonProps(context)}>
      <Box className="NavigationMenu">
        {weap ? <WeaponPanel equipment={weap} /> : <EmptyWeaponPanel />}
      </Box>
    </MfdPanel>
  );
};
