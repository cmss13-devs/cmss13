import { range } from 'common/collections';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Divider, Icon, Input, Stack } from 'tgui/components';

import type {
  DropshipEquipment,
  DropshipProps,
} from '../DropshipWeaponsConsole';
import { MfdPanel, type MfdProps } from './MultifunctionDisplay';
import {
  fmEditState,
  fmState,
  fmWeaponEditState,
  mfdState,
} from './stateManagers';
import type { CasFiremission, FiremissionContext } from './types';

const sortWeapons = (a: DropshipEquipment, b: DropshipEquipment) => {
  return (a?.mount_point ?? 0) < (b?.mount_point ?? 0) ? -1 : 1;
};

const CreateFiremissionPanel = (props: {
  readonly fmName: string;
  readonly setFmName: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { act } = useBackend();
  const { fmName, setFmName } = props;
  return (
    <Stack align="center" vertical>
      <Stack.Item>
        <h3>Create Fire Mission</h3>
      </Stack.Item>
      <Stack.Item>
        Firemission Name{' '}
        <Input
          value={fmName}
          onInput={(e, value) => setFmName(value)}
          onEnter={() => {
            if (fmName === '') {
              return;
            }
            act('firemission-create', {
              firemission_name: fmName,
              firemission_length: 12,
            });
            setFmName('');
          }}
        />
      </Stack.Item>
    </Stack>
  );
};

const FiremissionList = (props) => {
  const { data } = useBackend<FiremissionContext>();
  return (
    <Stack align="center" vertical>
      <Stack.Item>
        <h3>Existing Fire Missions</h3>
      </Stack.Item>
      <Stack.Item>
        {data.firemission_data.map((x, i) => (
          <Stack.Item key={x.name}>
            FM {i + 1}. {x.name}
          </Stack.Item>
        ))}
      </Stack.Item>
    </Stack>
  );
};

const FiremissionMfdHomePage = (props: MfdProps) => {
  const { setSelectedFm } = fmState(props.panelStateId);
  const [fmName, setFmName] = useState<string>('');
  const { data, act } = useBackend<FiremissionContext>();
  const { setPanelState } = mfdState(props.panelStateId);

  const firemission_mapper = (x: number) => {
    const firemission =
      data.firemission_data.length > x ? data.firemission_data[x] : undefined;
    return {
      children: firemission ? <div>FM {x + 1}</div> : undefined,
      onClick: () => setSelectedFm(firemission?.name),
    };
  };

  const [fmOffset, setFmOffset] = useState(0);

  const left_firemissions = range(fmOffset, fmOffset + 5).map(
    firemission_mapper,
  );
  const right_firemissions = range(fmOffset + 5, fmOffset + 10).map(
    firemission_mapper,
  );

  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={left_firemissions}
      rightButtons={right_firemissions}
      topButtons={[
        {},
        {},
        fmName
          ? {
              children: 'SAVE',
              onClick: () => {
                act('firemission-create', {
                  firemission_name: fmName,
                  firemission_length: 12,
                });
                setFmName('');
              },
            }
          : {},
        {},
        {
          children: fmOffset > 0 ? <Icon name="arrow-up" /> : undefined,
          onClick: () => {
            if (fmOffset > 0) {
              setFmOffset(fmOffset - 1);
            }
          },
        },
      ]}
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
            fmOffset + 10 < data.firemission_data?.length ? (
              <Icon name="arrow-down" />
            ) : undefined,
          onClick: () => {
            if (fmOffset + 10 < data.firemission_data?.length) {
              setFmOffset(fmOffset + 1);
            }
          },
        },
      ]}
    >
      <Box className="NavigationMenu">
        <Stack>
          <Stack.Item width="100px" />
          <Stack.Item width="300px">
            <Stack vertical align="center">
              <Stack.Item>
                <CreateFiremissionPanel fmName={fmName} setFmName={setFmName} />
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
  values: string[];
}

const ViewFiremissionMfdPanel = (
  props: MfdProps & { readonly firemission: CasFiremission },
) => {
  const { data, act } = useBackend<DropshipProps>();
  const { setPanelState } = mfdState(props.panelStateId);
  const { setSelectedFm } = fmState(props.panelStateId);
  const { editFm, setEditFm } = fmEditState(props.panelStateId);
  const { editFmWeapon, setEditFmWeapon } = fmWeaponEditState(
    props.panelStateId,
  );

  const rightButtons = [
    editFmWeapon === undefined
      ? {}
      : { children: 'BACK', onClick: () => setEditFmWeapon(undefined) },
    ...data.equipment_data
      .filter((x) => x.is_weapon === 1)
      .sort((a, b) => (a.mount_point < b.mount_point ? -1 : 1))
      .map((x) => {
        return {
          children: `${x.shorthand} ${x.mount_point}`,
          onClick: () => setEditFmWeapon(x.mount_point),
        };
      }),
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
          onClick: () => {
            setSelectedFm(undefined);
            setPanelState('');
          },
        },
      ]}
      rightButtons={editFm === true ? rightButtons : []}
    >
      <Box className="NavigationMenu">
        <Stack>
          <Stack.Item width="10px" />
          <Stack.Item width="480px">
            <Stack vertical align="center">
              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <h3>Firemission:</h3>
                  </Stack.Item>
                  <Stack.Item>
                    <h3>{firemission.name}</h3>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <FiremissionView
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

const FiremissionView = (props: MfdProps & { readonly fm: CasFiremission }) => {
  const { data } = useBackend<DropshipProps & FiremissionContext>();

  const { editFm } = fmEditState(props.panelStateId);

  const { editFmWeapon } = fmWeaponEditState(props.panelStateId);

  const weaponData = props.fm.records
    .map((x) => data.equipment_data.find((y) => y.mount_point === x.weapon))
    .filter((x) => x !== undefined)
    .sort(sortWeapons) as Array<DropshipEquipment>;

  const selectedWeapon = weaponData.find((x) => x.mount_point === editFmWeapon);
  const displayDetail = editFm;
  return (
    <Stack>
      <Stack.Item>
        <Stack vertical>
          <Stack.Item className="FireMissionTitle">Weapon</Stack.Item>
          <Stack.Item className="FireMissionTitle">Ammunition</Stack.Item>
          {!displayDetail && (
            <>
              <Stack.Item className="FireMissionTitle">Consumption</Stack.Item>
              <Stack.Item className="FireMissionTitle" />
            </>
          )}
          {displayDetail && (
            <>
              <Stack.Item className="FireMissionTitle">Gimbals</Stack.Item>
              <Stack.Item className="FireMissionTitle">Fire Delay</Stack.Item>
              <Stack.Item className="FireMissionTitle">Offset</Stack.Item>
            </>
          )}

          <Stack.Item>
            <Divider />
          </Stack.Item>
          {range(1, 13).map((x) => (
            <Stack.Item className="FireMissionTitle" key={x}>
              {x}
            </Stack.Item>
          ))}
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Divider vertical />
        <Divider vertical />
      </Stack.Item>
      {!editFm &&
        weaponData.map((x) => (
          <Stack.Item key={x.mount_point}>
            <FMOffsetStack
              displayDetail={displayDetail}
              fm={props.fm}
              panelStateId={props.panelStateId}
              equipment={x}
            />
          </Stack.Item>
        ))}
      {editFm && selectedWeapon === undefined && (
        <Stack.Item>Select weapon on right panel</Stack.Item>
      )}
      {editFm && selectedWeapon && (
        <Stack.Item key={selectedWeapon.mount_point}>
          <FMOffsetStack
            displayDetail={displayDetail}
            fm={props.fm}
            panelStateId={props.panelStateId}
            equipment={selectedWeapon}
          />
        </Stack.Item>
      )}
    </Stack>
  );
};

const gimbals: GimbalInfo[] = [
  { min: -1, max: -1, values: [] },
  { min: -6, max: 0, values: ['-6', '-5', '-4', '-3', '-2', '-1', '0', '-'] },
  { min: -6, max: 0, values: ['-6', '-5', '-4', '-3', '-2', '-1', '0', '-'] },
  { min: 0, max: 6, values: ['-', '0', '1', '2', '3', '4', '5', '6'] },
  { min: 0, max: 6, values: ['-', '0', '1', '2', '3', '4', '5', '6'] },
];

const OffsetOverview = (
  props: MfdProps & {
    readonly fm: CasFiremission;
    readonly equipment: DropshipEquipment;
  },
) => {
  const weaponFm = props.fm.records.find(
    (x) => x.weapon === props.equipment.mount_point,
  );
  if (weaponFm === undefined) {
    return <>error</>;
  }
  const ammoConsumption = weaponFm.offsets
    .map((x) => (x !== '-' ? (props.equipment.burst ?? 0) : 0))
    .reduce((accumulator, currentValue) => accumulator + currentValue, 0);
  return (
    <>
      <Stack.Item className="FireMissionOffsetLabel">
        {props.equipment.shorthand} {props.equipment.mount_point}
      </Stack.Item>
      <Stack.Item className="FireMissionOffsetLabel">
        {props.equipment.ammo} / {props.equipment.max_ammo}
      </Stack.Item>
      <Stack.Item className="FireMissionOffsetLabel">
        {ammoConsumption}
      </Stack.Item>
    </>
  );
};

const OffsetDetailed = (
  props: MfdProps & {
    readonly fm: CasFiremission;
    readonly equipment: DropshipEquipment;
  },
) => {
  const availableGimbals = gimbals[props.equipment.mount_point] ?? gimbals[0];
  const weaponFm = props.fm.records.find(
    (x) => x.weapon === props.equipment.mount_point,
  );
  if (weaponFm === undefined) {
    return <>error</>;
  }
  const ammoConsumption = weaponFm.offsets
    .map((x) => (x === '-' ? 0 : props.equipment.burst))
    .reduce(
      (accumulator, currentValue) => (accumulator ?? 0) + (currentValue ?? 0),
      0,
    );
  return (
    <>
      <Stack.Item className="FireMissionOffsetLabel">
        {props.equipment.shorthand} {props.equipment.mount_point}
      </Stack.Item>
      <Stack.Item className="FireMissionOffsetLabel">
        {props.equipment.ammo} / {props.equipment.max_ammo} using{' '}
        {ammoConsumption} per run.
      </Stack.Item>
      <Stack.Item className="FireMissionOffsetLabel">
        {availableGimbals.min} to {availableGimbals.max}
      </Stack.Item>
      <Stack.Item className="FireMissionOffsetLabel">
        {(props.equipment.firemission_delay ?? 0) - 1}
      </Stack.Item>
    </>
  );
};

const FMOffsetError = (
  props: MfdProps & {
    readonly fm: CasFiremission;
    readonly equipment: DropshipEquipment;
    readonly displayDetail?: boolean;
  },
) => {
  return (
    <Stack vertical className="FireMissionStack">
      {props.displayDetail ? (
        <OffsetDetailed
          fm={props.fm}
          panelStateId={props.panelStateId}
          equipment={props.equipment}
        />
      ) : (
        <OffsetOverview
          fm={props.fm}
          panelStateId={props.panelStateId}
          equipment={props.equipment}
        />
      )}
      <Stack.Item height="25px" />
      <Divider />
      <Stack.Item className="FireMissionError">
        Unable to set firemission offsets.
        <br />
        Offsets depend on ammunition.
        <br />
        Load ammunition to adjust.
      </Stack.Item>
    </Stack>
  );
};

const FMOffsetStack = (
  props: MfdProps & {
    readonly fm: CasFiremission;
    readonly equipment: DropshipEquipment;
    readonly displayDetail?: boolean;
  },
) => {
  const { fm } = props;
  const { act } = useBackend<DropshipProps & FiremissionContext>();
  const offsets = props.fm.records.find(
    (x) => x.weapon === props.equipment.mount_point,
  )?.offsets;

  const { editFm } = fmEditState(props.panelStateId);
  const availableGimbals = gimbals[props.equipment.mount_point] ?? gimbals[0];

  const firemissionOffsets = props.equipment.firemission_delay ?? 0;

  if (firemissionOffsets === 0) {
    return <FMOffsetError {...props} />;
  }

  const availableMap = range(0, 13).map((_) => true);
  offsets?.forEach((x, index) => {
    if (x === undefined || x === '-') {
      return;
    }
    // if offset is 0 then not allowed on strike.
    if (firemissionOffsets === 0) {
      range(0, availableMap.length - 1).forEach(
        (value) => (availableMap[value] = false),
      );
      return;
    }
    const indexMin = Math.max(index - firemissionOffsets + 1, 0);
    const indexMax = Math.max(
      Math.min(index + firemissionOffsets, availableMap.length - 1),
      indexMin,
    );
    range(indexMin, indexMax).forEach((value) => (availableMap[value] = false));
  });

  return (
    <Stack vertical className="FireMissionStack">
      {props.displayDetail ? (
        <OffsetDetailed
          fm={props.fm}
          panelStateId={props.panelStateId}
          equipment={props.equipment}
        />
      ) : (
        <OffsetOverview
          fm={props.fm}
          panelStateId={props.panelStateId}
          equipment={props.equipment}
        />
      )}
      <Stack.Item>
        <Stack height="20px">
          {editFm &&
            availableGimbals.values.map((x) => (
              <Stack.Item key={x} className="FireMissionOffset">
                {x === '-' ? 'UNSET' : x}
              </Stack.Item>
            ))}
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Divider />
      </Stack.Item>
      {editFm === false &&
        offsets &&
        offsets.map((x, i) => (
          <Stack.Item key={i} className="FireMissionOffsetLabel">
            {x}
          </Stack.Item>
        ))}

      {editFm === true &&
        offsets &&
        offsets.map((x, i) => {
          if (availableMap[i] === false && x === '-') {
            return (
              <Stack.Item key={i}>
                <Box className="FiremissionBadStep">WEAPON BUSY</Box>
              </Stack.Item>
            );
          }
          if (props.equipment.firemission_delay === 0) {
            return (
              <Stack.Item key={i}>
                <Box className="FiremissionBadStep">
                  Ammo unusable for firemissions
                </Box>
              </Stack.Item>
            );
          }
          return (
            <Stack.Item key={i}>
              <Stack>
                {availableGimbals.values.map((y) => {
                  const is_selected = x.toString() === y;
                  return (
                    <Stack.Item
                      key={y}
                      className="FireMissionOffset"
                      textAlign="center"
                    >
                      <Button
                        className={is_selected ? 'SelectedButton' : undefined}
                        onClick={(e) => {
                          act('button_push');
                          act('firemission-edit', {
                            tag: `${fm.mission_tag}`,
                            weapon_id: `${props.equipment.mount_point}`,
                            offset_id: `${i}`,
                            offset_value: `${y}`,
                          });
                        }}
                      >
                        {is_selected && '['}
                        {y}
                        {is_selected && ']'}
                      </Button>
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Stack.Item>
          );
        })}
    </Stack>
  );
};

export const FiremissionMfdPanel = (props: MfdProps) => {
  const { data, act } = useBackend<FiremissionContext>();
  const { selectedFm } = fmState(props.panelStateId);
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
