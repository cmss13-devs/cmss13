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
  const [editFm, setEditFm] = useLocalState<boolean>(
    context,
    `${props.panelStateId}_edit_fm`,
    false
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
        editFm
          ? { children: 'VIEW', onClick: () => setEditFm(false) }
          : { children: 'EDIT', onClick: () => setEditFm(true) },
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
            <Stack align="center">
              <Stack.Item>
                <h3>{firemission.name}</h3>
              </Stack.Item>
              <Stack.Item>
                <AltFiremissionTable
                  panelStateId={props.panelStateId}
                  fm={firemission}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item width="10px" />
        </Stack>
      </Box>
    </MfdPanel>
  );
};

const AltFiremissionTable = (props: MfdProps & { fm: CasFiremission }) => {
  return (
    <Table>
      <FMWeaponData fm={props.fm} />
      <FMOffsetData panelStateId={props.panelStateId} fm={props.fm} />
    </Table>
  );
};

const OffsetControl = (
  props: MfdProps & {
    fm: CasFiremission;
    weaponId?: number;
    currentValue: string | number;
    available: boolean;
    offsetIndex: number;
  },
  context
) => {
  const { data, act } = useBackend<DropshipProps & FiremissionContext>(context);

  const { fm, weaponId, currentValue, offsetIndex } = props;

  const OffsetController = (props: { value: string | number }) => {
    return (
      <Box
        onClick={() => {
          act('firemission-edit', {
            tag: `${fm.mission_tag}`,
            weapon_id: `${weaponId}`,
            offset_id: `${offsetIndex}`,
            offset_value: `${props.value}`,
          });
        }}>
        {currentValue === props.value && '['}
        {props.value}
        {currentValue === props.value && ']'}
      </Box>
    );
  };
  const [editFm] = useLocalState<boolean>(
    context,
    `${props.panelStateId}_edit_fm`,
    false
  );

  const gimbals: GimbalInfo[] = [
    { min: -6, max: 0 },
    { min: -6, max: 0 },
    { min: 0, max: 6 },
    { min: 0, max: 6 },
  ];

  const gimbalHigh = range(
    gimbals[(props.weaponId ?? 1) - 1].min,
    gimbals[(props.weaponId ?? 1) - 1].max + 1
  );

  if (!props.available) {
    return <TableCell>-</TableCell>;
  }

  return (
    <TableCell>
      {!editFm && currentValue}
      {editFm && (
        <Table>
          <TableRow>
            {[6, 5, 4, 3].map((x) => (
              <TableCell key={x}>
                <OffsetController value={gimbalHigh[x]} />
              </TableCell>
            ))}
          </TableRow>
          <TableRow>
            {[2, 1, 0].map((x) => (
              <TableCell key={x}>
                <OffsetController value={gimbalHigh[x]} />
              </TableCell>
            ))}
            <TableCell>
              <OffsetController value="-" />
            </TableCell>
          </TableRow>
        </Table>
      )}
    </TableCell>
  );
};

const FMOffsetData = (props: MfdProps & { fm: CasFiremission }, context) => {
  const { data } = useBackend<DropshipProps & FiremissionContext>(context);
  const weaponData = props.fm.records.map((x) =>
    data.equipment_data.find((y) => y.mount_point === x.weapon)
  );
  const offsetMap = new Array<Array<string>>();
  const availableMap = new Array<Array<boolean>>();
  offsetMap.fill([], 0, 12);
  props.fm.records
    .sort((a, b) => (a.weapon < b.weapon ? -1 : 1))
    .forEach((x, offsetIndex) => {
      const fm_delay = weaponData.find(
        (y) => y?.mount_point === x.weapon
      )?.firemission_delay;
      x.offsets.forEach((y, i) => {
        if (!offsetMap[i]) {
          offsetMap[i] = [];
          availableMap[i] = [];
        }
        offsetMap[i].push(y);
        if (!fm_delay) {
          availableMap[i].push(true);
          return;
        }
        const backCounter = range(Math.max(i - fm_delay, 0), i);
        if (backCounter.length === 0) {
          availableMap[i].push(true);
          return;
        }
        const canFire = backCounter.reduce((prev, curr, currentIndex, arr) => {
          if (!prev) {
            return -1;
          }
          const indexer = arr[currentIndex];
          if (offsetMap[indexer][offsetIndex] !== '-') {
            return -1;
          }
          return 1;
        });
        availableMap[i].push(canFire === 1);
      });
    });
  const weapMap = props.fm.records
    .map((x) => x.weapon)
    .sort((a, b) => (a < b ? -1 : 1));
  return (
    <>
      {offsetMap.map((x, i) => (
        <TableRow key={i}>
          <TableCell>{i + 1}</TableCell>
          {weapMap.map((y, j) => {
            return (
              <OffsetControl
                key={y}
                panelStateId={props.panelStateId}
                fm={props.fm}
                weaponId={y}
                currentValue={x[j]}
                offsetIndex={i}
                available={availableMap[i][j]}
              />
            );
          })}
        </TableRow>
      ))}
    </>
  );
};

const FMWeaponData = (props: { fm: CasFiremission }, context) => {
  const { data } = useBackend<DropshipProps>(context);

  const weaponData = props.fm.records.map((x) =>
    data.equipment_data.find((y) => y.mount_point === x.weapon)
  );

  return (
    <TableRow>
      <TableCell>Weapon</TableCell>
      {weaponData
        .sort((a, b) =>
          (a?.mount_point ?? 0) < (b?.mount_point ?? 0) ? -1 : 1
        )
        .map((x) => {
          return (
            <TableCell key={x?.mount_point}>
              {x?.shorthand} {x?.mount_point}
            </TableCell>
          );
        })}
    </TableRow>
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
