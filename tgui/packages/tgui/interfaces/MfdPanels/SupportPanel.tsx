import { useBackend, useSharedState } from '../../backend';
import { MfdPanel, MfdProps, usePanelState } from './MultifunctionDisplay';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MedevacMfdPanel } from './MedevacPanel';
import { FultonMfdPanel } from './FultonPanel';
import { Box } from '../../components';
import { SentryMfdPanel } from './SentryPanel';
import { MgMfdPanel } from './MGPanel';
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

  const [panelState, setPanelState] = usePanelState(
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
  if (result.shorthand === 'Fulton') {
    return <FultonMfdPanel panelStateId={props.panelStateId} />;
  }
  if (result.shorthand === 'Sentry') {
    return <SentryMfdPanel panelStateId={props.panelStateId} />;
  }
  if (result.shorthand === 'MG') {
    return <MgMfdPanel panelStateId={props.panelStateId} />;
  }
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}>
      <Box className="NavigationMenu">
        <center>
          <h3>Component {result.shorthand} not found</h3>
          <h3>Is this authorised equipment?</h3>
          <h3>
            Contact your local WY representative for further upgrade options
          </h3>
        </center>
      </Box>
    </MfdPanel>
  );
};
