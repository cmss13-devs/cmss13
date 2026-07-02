import { range } from 'common/collections';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui/components';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState } from './stateManagers';
import { lazeMapper, useTargetOffset } from './TargetAquisition';
import type { EquipmentContext, ParadropSpec } from './types';
import { useSupportCooldown } from './WeaponPanel';

const ParadropPanel = (
  props: DropshipEquipment & {
    readonly isOnCooldown?: boolean;
    readonly remainingTime?: number;
  },
) => {
  const { isOnCooldown, remainingTime, ...equipment } = props;
  const paradropData = equipment.data as ParadropSpec;
  return (
    <Stack>
      <Stack.Item width="100px">
        <svg overflow="visible" />
      </Stack.Item>
      <Stack.Item>
        <Stack vertical width="300px" align="center">
          <Stack.Item>
            <h3>{equipment.name}</h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              {paradropData.signal
                ? 'Locked to ' + paradropData.signal + '.'
                : 'No locked target found.'}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              {paradropData.locked
                ? 'Paradropping available.'
                : 'Paradropping not available.'}
            </h3>
          </Stack.Item>
          {isOnCooldown && (
            <Stack.Item>
              <h3 style={{ color: '#ff8c00' }}>
                <Icon name="clock" /> Cooldown: {remainingTime}s
              </h3>
            </Stack.Item>
          )}
          {!isOnCooldown && equipment && (
            <Stack.Item>
              <h3 style={{ color: '#00e94e' }}>
                <Icon name="crosshairs" /> Ready to Deploy
              </h3>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>
      <Stack.Item width="100px">
        <svg overflow="visible" />
      </Stack.Item>
    </Stack>
  );
};

export const ParadropMfdPanel = (props: MfdProps) => {
  const { act, data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);
  const { targetOffset, setTargetOffset } = useTargetOffset(props.panelStateId);
  const paradrop = data.equipment_data.find(
    (x) => x.mount_point === equipmentState,
  );

  const { isOnCooldown, remainingTime } = useSupportCooldown(
    (paradrop as any) || {},
  );

  const deployLabel = paradrop?.data?.locked
    ? 'CLEAR'
    : isOnCooldown
      ? 'COOLING'
      : 'LOCK';

  const targets = range(targetOffset, targetOffset + 5).map((x) =>
    lazeMapper(x),
  );

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
        {},
        {},
        {},
        {
          children: targetOffset > 0 ? <Icon name="arrow-up" /> : undefined,
          onClick: () => {
            if (targetOffset > 0) setTargetOffset(targetOffset - 1);
          },
        },
      ]}
      leftButtons={[
        {
          children: deployLabel,
          disabled: isOnCooldown,
          borderColor: paradrop?.data?.locked ? '#ff0000' : undefined,
          onClick: () =>
            act('paradrop-lock', { equipment_id: paradrop?.mount_point }),
        },
      ]}
      rightButtons={targets}
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
            targetOffset + 5 < (data.targets_data?.length || 0) ? (
              <Icon name="arrow-down" />
            ) : undefined,
          onClick: () => {
            if (targetOffset + 5 < (data.targets_data?.length || 0)) {
              setTargetOffset(targetOffset + 1);
            }
          },
        },
      ]}
    >
      <Box className="NavigationMenu">
        {paradrop && (
          <ParadropPanel
            {...paradrop}
            isOnCooldown={isOnCooldown}
            remainingTime={remainingTime}
          />
        )}
      </Box>
    </MfdPanel>
  );
};
