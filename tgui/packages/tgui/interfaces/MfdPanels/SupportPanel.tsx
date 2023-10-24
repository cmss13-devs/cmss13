import { useBackend, useSharedState } from '../../backend';
import { MfdProps } from './MultifunctionDisplay';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MedevacMfdPanel } from './MedevacPanel';

export const useEquipmentState = (panelId: string, context) =>
  useSharedState<number | undefined>(
    context,
    `${panelId}_equipmentstate`,
    undefined
  );

interface EquipmentContext {
  equipment_data: Array<DropshipEquipment>;
}

export const SupportMfdPanel = (props: MfdProps, context) => {
  const [equipmentState, setEquipmentState] = useEquipmentState(
    props.panelStateId,
    context
  );

  const { data } = useBackend<EquipmentContext>(context);
  const result = data.equipment_data.find(
    (x) => x.mount_point === equipmentState
  );
  if (!result) {
    return 5;
  }
  if (result.shorthand === 'Medevac') {
    return <MedevacMfdPanel panelStateId={props.panelStateId} />;
  }
  return <div>6</div>;
};
