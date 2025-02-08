import { useBackend } from '../../backend';
import { Box, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdPanel, MfdProps } from './MultifunctionDisplay';
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
            <h3>{props.name}</h3>
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
    (x) => x.mount_point === equipmentState,
  );
  const deployLabel = paradrop?.data?.locked ? 'CLEAR' : 'LOCK';

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
            act('paradrop-lock', { equipment_id: paradrop?.mount_point }),
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
        {paradrop && <ParadropPanel {...paradrop} />}
      </Box>
    </MfdPanel>
  );
};
