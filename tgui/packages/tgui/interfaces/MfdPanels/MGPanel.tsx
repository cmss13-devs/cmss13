import { MfdPanel, MfdProps, usePanelState } from './MultifunctionDisplay';
import { Box, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { useBackend } from '../../backend';
import { useEquipmentState } from './SupportPanel';

interface EquipmentContext {
  equipment_data: Array<DropshipEquipment>;
}

const MgPanel = (props: DropshipEquipment, context) => {
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
          <Stack.Item>
            <h3>
              Health: {mgData.health} / {mgData.health_max}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>
              Ammo {mgData.rounds} / {mgData.max_rounds}
            </h3>
          </Stack.Item>
          <Stack.Item>
            <h3>{mgData.deployed === 1 ? 'DEPLOYED' : 'UNDEPLOYED'}</h3>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item width="100px">
        <svg />
      </Stack.Item>
    </Stack>
  );
};

export const MgMfdPanel = (props: MfdProps, context) => {
  const { act, data } = useBackend<EquipmentContext>(context);
  const [panelState, setPanelState] = usePanelState(
    props.panelStateId,
    context
  );
  const [equipmentState, setEquipmentState] = useEquipmentState(
    props.panelStateId,
    context
  );
  const mg = data.equipment_data.find((x) => x.mount_point === equipmentState);
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
            act('deploy-equipment', { equipment_id: mg?.mount_point }),
        },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}>
      <Box className="NavigationMenu">
        {mg ? <MgPanel {...mg} /> : undefined}
      </Box>
    </MfdPanel>
  );
};
