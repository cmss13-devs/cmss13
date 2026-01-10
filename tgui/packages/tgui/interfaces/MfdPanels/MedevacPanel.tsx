import { range } from 'common/collections';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Divider, Flex, Stack } from 'tgui/components';
import { Icon } from 'tgui/components';

import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import { mfdState, useEquipmentState } from './stateManagers';
import type { MedevacContext, MedevacTargets } from './types';

const MedevacOccupant = (props: { readonly data: MedevacTargets }) => (
  <Box>
    <Flex justify="space-between" direction="horizontal">
      <Flex.Item grow>
        <Stack vertical>
          <Stack.Item>{props.data.occupant ?? 'Empty'}</Stack.Item>
          <Stack.Item>{props.data.area ?? 'Unknown'}</Stack.Item>
        </Stack>
      </Flex.Item>
      <Flex.Item grow>
        <Flex fill={1} justify="space-around">
          <Flex.Item>
            HP
            <br />
            {props.data.damage?.hp}
          </Flex.Item>
          <Flex.Item>
            Brute
            <br />
            {props.data.damage?.brute}
          </Flex.Item>
          <Flex.Item>
            Fire
            <br />
            {props.data.damage?.fire}
          </Flex.Item>
          <Flex.Item>
            Tox
            <br />
            {props.data.damage?.tox}
          </Flex.Item>
          <Flex.Item>
            Oxy
            <br /> {props.data.damage?.oxy}
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  </Box>
);

export const MedevacMfdPanel = (props: MfdProps) => {
  const { data, act } = useBackend<MedevacContext>();
  const [medevacOffset, setMedevacOffset] = useState(0);
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);

  const result = data.equipment_data.find(
    (x) => x.mount_point === equipmentState,
  );
  const medevacs = data.medevac_targets === null ? [] : data.medevac_targets;
  const medevac_mapper = (x: number) => {
    const target = medevacs.length > x ? medevacs[x] : undefined;
    return {
      children: target
        ? (target.occupant?.split(' ')[0] ?? 'Empty')
        : undefined,
      onClick: () =>
        act('medevac-target', {
          equipment_id: result?.mount_point,
          ref: target?.ref,
        }),
    };
  };

  const left_targets = range(medevacOffset, medevacOffset + 5).map(
    medevac_mapper,
  );

  const right_targets = range(medevacOffset + 5, medevacOffset + 8).map(
    medevac_mapper,
  );

  const all_targets = range(medevacOffset, medevacOffset + 8)
    .map((x) => data.medevac_targets[x])
    .filter((x) => x !== undefined);

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={left_targets}
      rightButtons={[
        {
          children: <Icon name="arrow-up" />,
          onClick: () => {
            if (medevacOffset > 0) {
              setMedevacOffset(medevacOffset - 1);
            }
          },
        },
        ...right_targets,
        {
          children: <Icon name="arrow-down" />,
          onClick: () => {
            if (medevacOffset + 8 < data.medevac_targets.length) {
              setMedevacOffset(medevacOffset + 1);
            }
          },
        },
      ]}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}
    >
      <Box className="NavigationMenu">
        <Flex justify="space-between">
          <Flex.Item>
            <svg width="60px">
              {all_targets.length > 0 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 50 l -20 0 l -20 -20 l -20 0"
                />
              )}
              {all_targets.length > 1 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 100 l -20 0 l -20 30 l -20 0"
                />
              )}
              {all_targets.length > 2 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 155 l -20 0 l -20 80 l -20 0"
                />
              )}
              {all_targets.length > 3 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 210 l -20 0 l -20 120 l -20 0"
                />
              )}
              {all_targets.length > 4 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 50 260 l -20 0 l -20 170 l -20 0"
                />
              )}
            </svg>
          </Flex.Item>
          <Flex.Item width="400px">
            <Stack vertical align="center">
              <Stack.Item>
                <h3>Medevac Requests</h3>
              </Stack.Item>
              {all_targets.map((x) => (
                <>
                  <Stack.Item key={x.occupant} width="100%" minHeight="32px">
                    <MedevacOccupant data={x} />
                  </Stack.Item>
                  <Divider />
                </>
              ))}
            </Stack>
          </Flex.Item>
          <Flex.Item>
            <svg width="60px">
              {all_targets.length > 5 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 0 310 l 20 0 l 20 -180 l 20 0"
                />
              )}
              {all_targets.length > 6 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 0 360 l 20 0 l 20 -130 l 20 0"
                />
              )}
              {all_targets.length > 7 && (
                <path
                  fillOpacity="0"
                  stroke="#00e94e"
                  d="M 0 410 l 20 0 l 20 -80 l 20 0"
                />
              )}
            </svg>
          </Flex.Item>
        </Flex>
      </Box>
    </MfdPanel>
  );
};
