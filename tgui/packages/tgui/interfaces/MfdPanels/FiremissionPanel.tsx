import { MfdPanel, MfdProps, usePanelState } from './MultifunctionDisplay';
import { Box, Input, Stack, Table } from '../../components';
import { useBackend, useLocalState } from '../../backend';
import { CasFiremission, CasFiremissionStage } from './types';
import { range } from 'common/collections';
import { TableRow, TableCell } from '../../components/Table';
import { DropshipProps } from '../DropshipWeaponsConsole';

const CreateFiremissionPanel = (props, context) => {
  const { act } = useBackend(context);
  const [fmName, setFmName] = useLocalState<string>(context, 'fmname', '');
  return (
    <Stack align="center">
      <Stack.Item>
        <h3>Create Fire Mission</h3>
      </Stack.Item>
      <Stack.Item>
        <Input value={fmName} onInput={(e, value) => setFmName(value)} />
      </Stack.Item>
    </Stack>
  );
};

interface FiremissionContext {
  firemission_data: Array<CasFiremission>;
}

const FiremissionList = (props, context) => {
  const { data } = useBackend<FiremissionContext>(context);
  return (
    <Stack align="center" vertical>
      <Stack.Item>
        <h3>Existing Fire Missions</h3>
      </Stack.Item>
      <Stack.Item>
        {data.firemission_data.map((x) => (
          <Stack.Item key={x.name}>{x.name}</Stack.Item>
        ))}
      </Stack.Item>
    </Stack>
  );
};

const FiremissionMfdHomePage = (props: MfdProps, context) => {
  const [selectedFm, setSelectedFm] = useLocalState<string | undefined>(
    context,
    `${props.panelStateId}_selected_fm`,
    undefined
  );
  const [fmName, setFmName] = useLocalState<string>(context, 'fmname', '');
  const { data, act } = useBackend<FiremissionContext>(context);
  const [panelState, setPanelState] = usePanelState(
    props.panelStateId,
    context
  );

  const firemission_mapper = (x: number) => {
    const firemission =
      data.firemission_data.length > x ? data.firemission_data[x] : undefined;
    return {
      children: firemission?.name,
      onClick: () => setSelectedFm(firemission?.name),
    };
  };

  const left_firemissions = range(0, 5).map(firemission_mapper);

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={left_firemissions}
      rightButtons={[
        fmName
          ? {
            children: 'SAVE',
            onClick: () =>
              act('firemission-create', {
                firemission_name: fmName,
                firemission_length: 12,
              }),
          }
          : {},
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}>
      <Box className="NavigationMenu">
        <Stack>
          <Stack.Item width="100px" />
          <Stack.Item width="300px">
            <Stack vertical align="center">
              <Stack.Item>
                <CreateFiremissionPanel />
              </Stack.Item>
              <Stack.Item>
                <FiremissionList />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item width="100px" />
        </Stack>
      </Box>
    </MfdPanel>
  );
};

interface GimbalInfo {
  min: number;
  max: number;
}

const FiremissionRecord = (
  props: CasFiremissionStage & { gimbal: GimbalInfo },
  context
) => {
  const { data, act } = useBackend<DropshipProps>(context);
  const weapon = data.equipment_data.find(
    (x) => x.mount_point === props.weapon
  );
  return (
    <>
      <TableCell>{weapon?.shorthand ?? 'unknown'}</TableCell>
      <TableCell>
        {weapon?.ammo} / {weapon?.max_ammo}
      </TableCell>
      <TableCell>
        {props.gimbal.min} to {props.gimbal.max}
      </TableCell>
      {props.offsets.map((x, i) => (
        <TableCell key={i}>{x}</TableCell>
      ))}
    </>
  );
};

const ViewFiremissionMfdPanel = (
  props: MfdProps & { firemission: CasFiremission },
  context
) => {
  const { data, act } = useBackend<FiremissionContext>(context);
  const [panelState, setPanelState] = usePanelState(
    props.panelStateId,
    context
  );
  const [selectedFm, setSelectedFm] = useLocalState<string | undefined>(
    context,
    `${props.panelStateId}_selected_fm`,
    undefined
  );

  const gimbals: GimbalInfo[] = [
    { min: 0, max: 6 },
    { min: 0, max: 6 },
    { min: -6, max: 0 },
    { min: -6, max: 0 },
  ];

  const firemission = props.firemission;
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        {
          children: 'DELETE',
          onClick: () => {
            act('firemission-delete', {
              firemission_name: firemission.mission_tag,
            });
            setSelectedFm(undefined);
          },
        },
        { children: 'F-MISS', onClick: () => setSelectedFm(undefined) },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
      ]}>
      <Box className="NavigationMenu">
        <Stack>
          <Stack.Item width="10px" />
          <Stack.Item width="480px">
            <Stack vertical align="center">
              <Stack.Item>
                <h3>{firemission.name}</h3>
              </Stack.Item>
              <Stack.Item>
                <Table>
                  <TableRow>
                    <TableCell>Weapon</TableCell>
                    <TableCell>Ammo</TableCell>
                    <TableCell>Gimbal</TableCell>
                    <TableCell>1</TableCell>
                    <TableCell>2</TableCell>
                    <TableCell>3</TableCell>
                    <TableCell>4</TableCell>
                    <TableCell>5</TableCell>
                    <TableCell>6</TableCell>
                    <TableCell>7</TableCell>
                    <TableCell>8</TableCell>
                    <TableCell>9</TableCell>
                    <TableCell>10</TableCell>
                    <TableCell>11</TableCell>
                    <TableCell>12</TableCell>
                  </TableRow>
                  {firemission.records
                    .sort((a, b) => (a.weapon < b.weapon ? -1 : 1))
                    .map((x, i) => (
                      <TableRow key={x.weapon}>
                        <FiremissionRecord {...x} gimbal={gimbals[i]} />
                      </TableRow>
                    ))}
                </Table>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item width="10px" />
        </Stack>
      </Box>
    </MfdPanel>
  );
};

export const FiremissionMfdPanel = (props: MfdProps, context) => {
  const { data, act } = useBackend<FiremissionContext>(context);
  const [selectedFm, setSelectedFm] = useLocalState<string | undefined>(
    context,
    `${props.panelStateId}_selected_fm`,
    undefined
  );
  const firemission = data.firemission_data.find((x) => x.name === selectedFm);
  if (firemission === undefined) {
    return <FiremissionMfdHomePage panelStateId={props.panelStateId} />;
  }
  return (
    <ViewFiremissionMfdPanel
      panelStateId={props.panelStateId}
      firemission={firemission}
    />
  );
};
