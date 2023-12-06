import { MfdPanel, MfdProps } from './MultifunctionDisplay';
import { Box, Stack } from '../../components';
import { useBackend } from '../../backend';
import { mfdState, useEquipmentState } from './stateManagers';
import { EquipmentContext, SpotlightSpec } from './types';
import { DropshipEquipment } from '../DropshipWeaponsConsole';

const SpotPanel = (props: DropshipEquipment) => {
  const spotData = props.data as SpotlightSpec;
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
        </Stack>
      </Stack.Item>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
    </Stack>
  );
};

export const SpotlightMfdPanel = (props: MfdProps, context) => {
  const { act, data } = useBackend<EquipmentContext>(context);
  const { setPanelState } = mfdState(context, props.panelStateId);
  const { equipmentState } = useEquipmentState(context, props.panelStateId);
  const spotlight = data.equipment_data.find(
    (x) => x.mount_point === equipmentState
  );
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        { children: 'EQUIP', onClick: () => setPanelState('equipment') },
      ]}
      leftButtons={[
        {
          children: 'DEPLOY',
          onClick: () =>
            act('deploy-equipment', { equipment_id: spotlight?.mount_point }),
        },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}>
      <Box className="NavigationMenu">
        {spotlight && <SpotPanel {...spotlight} />}
      </Box>
    </MfdPanel>
  );
};
