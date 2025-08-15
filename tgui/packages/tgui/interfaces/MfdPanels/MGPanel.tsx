import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui/components';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState } from './stateManagers';
import type { EquipmentContext, MGSpec } from './types';
import { useSupportCooldown } from './WeaponPanel';

const MgPanel = (
  props: DropshipEquipment & {
    readonly isOnCooldown?: boolean;
    readonly remainingTime?: number;
  },
) => {
  const mgData = props.data as MGSpec;

  return (
    <Stack>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
      <Stack.Item>
        <Stack vertical width="300px" align="center">
          <Stack.Item>
            <h3>{props.name}</h3>
          </Stack.Item>
          {props.isOnCooldown && (
            <Stack.Item>
              <h3 style={{ color: '#ff8c00' }}>
                <Icon name="clock" /> Deployment Cooldown: {props.remainingTime}
                s
              </h3>
            </Stack.Item>
          )}
          <Stack.Item>
            <h3>
              Health: {mgData.health} / {mgData.health_max}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              Ammo: {mgData.rounds} / {mgData.max_rounds}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              Deploy Status: {mgData.deployed === 1 ? 'DEPLOYED' : 'UNDEPLOYED'}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              Auto-Deploy: {mgData.auto_deploy === 1 ? 'ENABLED' : 'DISABLED'}
            </h3>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
    </Stack>
  );
};

export const MgMfdPanel = (props: MfdProps) => {
  const { act, data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);
  const mg = data.equipment_data.find((x) => x.mount_point === equipmentState);

  const { isOnCooldown, remainingTime } = useSupportCooldown((mg as any) || {});

  const deployLabel = (mg?.data?.deployed ?? 0) === 1 ? 'RETRACT' : 'DEPLOY';

  const autoDeployLabel =
    (mg?.data?.auto_deploy ?? 0) === 1 ? 'AUTO-DEPLOY OFF' : 'AUTO-DEPLOY ON';

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      color={props.color}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
      ]}
      leftButtons={[
        {
          children: isOnCooldown
            ? `${deployLabel} (${remainingTime}s)`
            : deployLabel,
          disabled: isOnCooldown,
          onClick: () =>
            act('deploy-equipment', { equipment_id: mg?.mount_point }),
        },
        {
          children: autoDeployLabel,
          onClick: () => act('auto-deploy', { equipment_id: mg?.mount_point }),
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
        {mg && (
          <MgPanel
            {...mg}
            isOnCooldown={isOnCooldown}
            remainingTime={remainingTime}
          />
        )}
      </Box>
    </MfdPanel>
  );
};
