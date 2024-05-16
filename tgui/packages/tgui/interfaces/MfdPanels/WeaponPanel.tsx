import { range } from 'common/collections';

import { useBackend } from '../../backend';
import { Box, Icon, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { mfdState, useWeaponState } from './stateManagers';
import {
  getLastTargetName,
  lazeMapper,
  TargetLines,
  useTargetOffset,
} from './TargetAquisition';
import { LazeTarget } from './types';

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
}) => {
  const { data } = useBackend<EquipmentContext>();

  return (
    <Stack>
      <Stack.Item>
        <svg height="501" width="100">
          <text stroke="#00e94e" x={60} y={230} textAnchor="start">
            ACTIONS
          </text>
          {true && (
            <path
              fillOpacity="0"
              stroke="#00e94e"
              d="M 50 210 l -20 0 l -20 -180 l -40 0"
            />
          )}
          {false && (
            <path
              fillOpacity="0"
              stroke="#00e94e"
              d="M 50 220 l -25 0 l -15 -90 l -40 0"
            />
          )}
          {false && (
            <path
              fillOpacity="0"
              stroke="#00e94e"
              d="M 50 230 l -20 0 l -20 0 l -40 0"
            />
          )}

          {false && (
            <path
              fillOpacity="0"
              stroke="#00e94e"
              d="M 50 240 l -25 0 l -15 90 l -40 0"
            />
          )}
          {false && (
            <path
              fillOpacity="0"
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
        <svg width="50px" height="500px">
          <g transform="translate(-10)">
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
            <TargetLines panelId={props.panelId} />
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
  const weap = data.equipment_data.find((x) => x.mount_point === weaponState);
  const targets = range(targetOffset, targetOffset + 5).map((x) =>
    lazeMapper(x),
  );

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
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
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
      rightButtons={targets}
    >
      <Box className="NavigationMenu">
        {weap ? (
          <WeaponPanel equipment={weap} panelId={props.panelStateId} />
        ) : (
          <EmptyWeaponPanel />
        )}
      </Box>
    </MfdPanel>
  );
};
