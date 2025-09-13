import { range } from 'common/collections';
import React from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Icon, Stack } from 'tgui/components';

import type { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState } from './stateManagers';
import { lazeMapper, useTargetOffset } from './TargetAquisition';
import type { EquipmentContext, SpotlightSpec } from './types';
import { useSupportCooldown } from './WeaponPanel';

const SpotPanel = (
  props: DropshipEquipment & {
    readonly color?: 'green' | 'yellow' | 'blue';
    readonly isOnCooldown?: boolean;
    readonly remainingTime?: number;
  },
) => {
  const spotData = props.data as SpotlightSpec;

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

  const themeColor = getThemeColor(props.color);

  let statusText: React.ReactNode = null;
  if (props.isOnCooldown) {
    statusText = (
      <h3 style={{ color: '#ff8c00' }}>
        <Icon name="clock" /> Spotlight Cooldown: {props.remainingTime}s
      </h3>
    );
  } else if (spotData.deployed) {
    statusText = <h3 style={{ color: themeColor }}>Spotlight Active</h3>;
  } else {
    statusText = <h3 style={{ color: '#808080' }}>Spotlight Offline</h3>;
  }

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
          <Stack.Item>{statusText}</Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
    </Stack>
  );
};

export const SpotlightMfdPanel = (props: MfdProps) => {
  const { act, data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);
  const { targetOffset, setTargetOffset } = useTargetOffset(props.panelStateId);

  const spotlight = data.equipment_data.find(
    (x) => x.mount_point === equipmentState,
  );

  const { isOnCooldown, remainingTime } = useSupportCooldown(
    (spotlight as any) || {},
  );

  const spotData = spotlight?.data as SpotlightSpec;
  const deployLabel = spotData?.deployed ? 'DISABLE' : 'ENABLE';

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
          children: isOnCooldown
            ? `${deployLabel} (${remainingTime}s)`
            : deployLabel,
          disabled: isOnCooldown,
          onClick: () =>
            act('deploy-equipment', { equipment_id: spotlight?.mount_point }),
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
        {spotlight && (
          <SpotPanel
            {...spotlight}
            color={props.color}
            isOnCooldown={isOnCooldown}
            remainingTime={remainingTime}
          />
        )}
      </Box>
    </MfdPanel>
  );
};
