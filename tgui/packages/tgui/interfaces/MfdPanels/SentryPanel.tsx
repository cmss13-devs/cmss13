import { useBackend } from 'tgui/backend';
import { Box, Stack } from 'tgui/components';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState } from './stateManagers';
import type { EquipmentContext, SentrySpec } from './types';

const SentryPanel = (props: DropshipEquipment) => {
  const sentryData = props.data as SentrySpec;
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
          <Stack.Item>
            <h3>
              Health: {sentryData.health} / {sentryData.health_max}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              Ammo: {sentryData.rounds} / {sentryData.max_rounds}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              Deploy Status:{' '}
              {sentryData.deployed === 1 ? 'DEPLOYED' : 'UNDEPLOYED'}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              Sentry Status:{' '}
              {sentryData.engaged === 1
                ? 'ENGAGED'
                : sentryData.deployed === 1
                  ? 'STANDBY'
                  : 'OFFLINE'}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              Auto-Deploy:{' '}
              {sentryData.auto_deploy === 1 ? 'ENABLED' : 'DISABLED'}
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

export const SentryMfdPanel = (props: MfdProps) => {
  const { act, data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);
  const sentry = data.equipment_data.find(
    (x) => x.mount_point === equipmentState,
  );
  const deployLabel =
    (sentry?.data?.deployed ?? 0) === 1 ? 'RETRACT' : 'DEPLOY';

  const autoDeployLabel =
    (sentry?.data?.auto_deploy ?? 0) === 1
      ? 'AUTO-DEPLOY OFF'
      : 'AUTO-DEPLOY ON';

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
      ]}
      leftButtons={[
        {
          children: deployLabel,
          onClick: () =>
            act('deploy-equipment', { equipment_id: sentry?.mount_point }),
        },
        {
          children: sentry?.data?.camera_available ? 'CAMERA' : undefined,
          onClick: () =>
            act('set-camera-sentry', { equipment_id: sentry?.mount_point }),
        },
        {
          children: autoDeployLabel,
          onClick: () =>
            act('auto-deploy', { equipment_id: sentry?.mount_point }),
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
        {sentry && <SentryPanel {...sentry} />}
      </Box>
    </MfdPanel>
  );
};
