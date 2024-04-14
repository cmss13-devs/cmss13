import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { Box, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { useBackend } from '../../backend';
import { mfdState, useEquipmentState } from './stateManagers';
import { EquipmentContext, ParadropSpec } from './types';

const ParadropPanel = (props: DropshipEquipment) => {
  const paradropData = props.data as ParadropSpec;
  return (
    <Stack>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
      <Stack.Item>
        <Stack vertical width="300px" align="center">
          <Stack.Item>
            <h3>Paradrop System</h3>
          </Stack.Item>
          {paradropData.signal && (
            <Stack.Item>
              <h3>Locked to: {paradropData.signal}</h3>
              <h3>Paradrop available.</h3>
            </Stack.Item>
          )}
          {!paradropData.signal && (
            <Stack.Item>
              <h3>No signal locked, paradrop system unavailable.</h3>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
    </Stack>
  );
};

export const ParadropMfdPanel = (props: MfdProps) => {
  const { act, data } = useBackend<EquipmentContext>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { equipmentState } = useEquipmentState(props.panelStateId);
  const paradrop = data.equipment_data.find(
    (x) => x.mount_point === equipmentState
  );
  const deployLabel = (paradrop?.data?.locked ?? 0) === 1 ? 'CLEAR' : 'LOCK';

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
      ]}
      leftButtons={[
        {
          children: deployLabel,
          onClick: () => act('paradrop-lock'),
        },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}>
      <Box className="NavigationMenu">
        {paradrop && <ParadropPanel {...paradrop} />}
      </Box>
    </MfdPanel>
  );
};
