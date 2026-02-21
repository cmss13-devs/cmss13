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
  readonly fmLength: string;
  readonly setFmLength: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { act } = useBackend();
  const { fmName, setFmName, fmLength, setFmLength } = props;

  const handleCreate = () => {
    const parsedLength = parseInt(fmLength, 10);
    if (fmName === '' || isNaN(parsedLength) || parsedLength <= 0) {
      return;
    }

    act('firemission-create', {
      firemission_name: fmName,
      firemission_length: parsedLength,
    });

    setFmName('');
    setFmLength('');
  };

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
          onEnter={handleCreate}
        />
      </Stack.Item>
      <Stack.Item>
        Input FM Length{' '}
        <Input
          value={fmLength}
          type="number"
          onInput={(e, value) => setFmLength(value)}
          onEnter={handleCreate}
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
  const [fmLength, setFmLength] = useState<string>('');
  const { data, act } = useBackend<FiremissionContext>();
  const { setPanelState } = mfdState(props.panelStateId);

  const firemission_mapper = (x: number) => {
    const firemission =
      data.firemission_data.length > x ? data.firemission_data[x] : undefined;
    return {
      children: firemission ? (
        <div>
          {firemission.name.length > 7
            ? firemission.name.substring(0, 7) + '...'
            : firemission.name}
        </div>
      ) : undefined,
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
        fmName && fmLength
          ? {
              children: 'SAVE',
              onClick: () => {
                const parsedLength = parseInt(fmLength, 10);
                if (isNaN(parsedLength) || parsedLength <= 0) {
                  return;
                }

                act('firemission-create', {
                  firemission_name: fmName,
                  firemission_length: parsedLength,
                });
                setFmName('');
                setFmLength('');
              },
            }
          : {},

        {},
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
                <CreateFiremissionPanel
                  fmName={fmName}
                  setFmName={setFmName}
                  fmLength={fmLength}
                  setFmLength={setFmLength}
                />
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
  const [showGrid, setShowGrid] = useState(false);

  // Add scroll state for steps
  const [stepScroll, setStepScroll] = useState(0);
  // Grid scroll state
  const [gridStepScroll, setGridStepScroll] = useState(0);
  const visibleSteps = 12;
  const visibleGridSteps = 12;
  // Find the first weapon with offsets to determine step count
  const firstOffsets = props.firemission.records[0]?.offsets;
  const stepCount = firstOffsets ? firstOffsets.length : 12;

  const leftButtons = showGrid
    ? [
        {
          children: <Icon name="arrow-up" />,
          disabled: gridStepScroll <= 0,
          onClick: () => setGridStepScroll(Math.max(0, gridStepScroll - 1)),
        },
        {
          children: <Icon name="arrow-down" />,
          disabled: gridStepScroll + visibleGridSteps >= stepCount + 3,
          onClick: () =>
            setGridStepScroll(Math.min(stepCount - 1, gridStepScroll + 1)),
        },
      ]
    : [
        {
          children: <Icon name="arrow-up" />,
          disabled: stepScroll <= 0,
          onClick: () => setStepScroll(Math.max(0, stepScroll - 1)),
        },
        {
          children: <Icon name="arrow-down" />,
          disabled: stepScroll + visibleSteps >= stepCount,
          onClick: () =>
            setStepScroll(Math.min(stepCount - visibleSteps, stepScroll + 1)),
        },
      ];

  const rightButtons = [
    editFmWeapon === undefined
      ? {}
      : {
          children: 'BACK',
          onClick: () => {
            setEditFmWeapon(undefined);
            setShowGrid(false);
          },
        },
    ...data.equipment_data
      .filter((x) => x.is_weapon === 1)
      .sort((a, b) => {
        // Custom sort order for visual QoL, L1, L2, R1, R2
        const getDisplayOrder = (mountPoint: number) => {
          switch (mountPoint) {
            case 2:
              return 1;
            case 1:
              return 2;
            case 3:
              return 3;
            case 4:
              return 4;
            default:
              return mountPoint;
          }
        };
        return getDisplayOrder(a.mount_point) - getDisplayOrder(b.mount_point);
      })
      .map((weapon) => {
        // Determine the position label
        let positionLabel = '';
        switch (weapon.mount_point) {
          case 1:
            positionLabel = 'L2';
            break;
          case 2:
            positionLabel = 'L1';
            break;
          case 3:
            positionLabel = 'R1';
            break;
          case 4:
            positionLabel = 'R2';
            break;
          default:
            positionLabel = weapon.mount_point.toString();
            break;
        }

        return {
          children: `${weapon.shorthand} ${positionLabel}`,
          borderColor:
            editFmWeapon === weapon.mount_point ? '#ff0000' : undefined,
          onClick: () => {
            setEditFmWeapon(weapon.mount_point);
            setShowGrid(false);
          },
        };
      }),
  ];

  const firemission = props.firemission;
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      leftButtons={leftButtons}
      topButtons={[
        {
          children: 'DELETE',
          onClick: () => {
            act('firemission-delete', {
              firemission_name: firemission.mission_tag,
            });
            setSelectedFm(undefined);
            setShowGrid(false);
          },
        },
        {
          children: 'F-MISS',
          onClick: () => {
            setSelectedFm(undefined);
            setShowGrid(false);
          },
        },
        editFm
          ? {
              children: 'VIEW',
              onClick: () => {
                setEditFm(false);
                setShowGrid(false);
              },
            }
          : {
              children: 'EDIT',
              onClick: () => {
                setEditFm(true);
                setShowGrid(false);
              },
            },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => {
            setSelectedFm(undefined);
            setPanelState('');
          },
        },
        {},
        {
          children: 'GRID',
          borderColor: showGrid ? '#ff0000' : undefined,
          onClick: () => setShowGrid(!showGrid),
        },
        {},
        {},
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
                <Stack>
                  <Stack.Item>
                    <h4>Length:</h4>
                  </Stack.Item>
                  <Stack.Item>
                    <h4>{firemission.mission_length}</h4>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item width="100%">
                {showGrid ? (
                  <FiremissionGridView
                    panelStateId={props.panelStateId}
                    fm={firemission}
                    stepScroll={gridStepScroll}
                    visibleSteps={visibleGridSteps}
                  />
                ) : (
                  <FiremissionView
                    panelStateId={props.panelStateId}
                    fm={firemission}
                    stepScroll={stepScroll}
                    setStepScroll={setStepScroll}
                    visibleSteps={visibleSteps}
                  />
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item width="10px" />
        </Stack>
      </Box>
    </MfdPanel>
  );
};

const FiremissionGridView = (
  props: MfdProps & {
    readonly fm: CasFiremission;
    readonly stepScroll: number;
    readonly visibleSteps: number;
  },
) => {
  const { data } = useBackend<DropshipProps & FiremissionContext>();

  // Get weapon data
  const weaponData = data.equipment_data
    .filter((x) => x.is_weapon === 1)
    .sort((a, b) => (a.mount_point < b.mount_point ? -1 : 1));

  // Create a grid based on actual firing steps and offset range
  const missionLength = props.fm.mission_length;
  const offsetRange = 13; // -6 to +6 = 13 total positions
  const centerOffset = 6; // Center position

  // Get the actual number of firing steps from the first record's offsets
  const actualSteps =
    props.fm.records.length > 0 ? props.fm.records[0].offsets.length : 12;

  const { stepScroll, visibleSteps } = props;
  const endStep = Math.min(stepScroll + visibleSteps, actualSteps);

  // Get weapon symbols and colors
  const getWeaponDisplay = (
    equipment: DropshipEquipment,
    weaponIndex: number,
  ) => {
    const positionLabel = getMountPointLabel(equipment, weaponData);

    // L1/L2 = green, R1/R2 = yellow
    const isLeft = positionLabel.startsWith('L');
    const color = isLeft ? '#00eb4e' : '#ffff00'; // green for left, yellow for right

    // Mount points 2 and 3 = front (filled dot), Mount points 1 and 4 = back (open circle)
    const isFront = equipment.mount_point === 2 || equipment.mount_point === 3;
    const symbol = isFront ? '●' : '○'; // filled dot for front, open circle for back weapon mounts

    return { symbol, color, label: positionLabel };
  };

  // Build the grid data
  const gridData: Array<
    Array<Array<{ symbol: string; color: string; label: string; tile: number }>>
  > = Array(actualSteps)
    .fill(null)
    .map(() =>
      Array(offsetRange)
        .fill(null)
        .map(() => []),
    );

  const tallyStep = actualSteps / missionLength; // How many shots before moving to next tile
  let nextStep = tallyStep; // When to move to next tile
  let currentTile = 0; // Track which tile the dropship is on

  // Populate grid with weapon fire positions
  props.fm.records.forEach((record) => {
    const equipment = weaponData.find((w) => w.mount_point === record.weapon);
    if (!equipment) return;

    const weaponIndex = weaponData.findIndex(
      (w) => w.mount_point === record.weapon,
    );
    const display = getWeaponDisplay(equipment, weaponIndex);

    // Reset movement tracking for each weapon
    let weaponNextStep = tallyStep;
    let weaponCurrentTile = 0;

    record.offsets.forEach((offset, step) => {
      if (offset !== '-' && offset !== null && step < actualSteps) {
        // Update tile position based on movement pattern
        if (step + 1 > weaponNextStep) {
          weaponCurrentTile++;
          weaponNextStep += tallyStep;
        }

        const offsetNum = parseInt(offset.toString(), 10);
        if (!isNaN(offsetNum)) {
          const gridX = offsetNum + centerOffset;
          if (gridX >= 0 && gridX < offsetRange) {
            gridData[step][gridX].push({
              ...display,
              tile: weaponCurrentTile,
            });
          }
        }
      }
    });
  });

  return (
    <Stack vertical>
      <Stack.Item textAlign="center">
        <h3>Firemission Grid</h3>
      </Stack.Item>
      <Stack.Item>
        <Box
          backgroundColor="rgba(0, 235, 78, 0.03)"
          style={{
            padding: '10px',
            border: '2px solid #00eb4e',
            borderRadius: '4px',
            fontFamily: 'monospace',
            fontSize: '12px',
            color: '#00eb4e',
          }}
        >
          {/* Grid header with offset numbers */}
          <Stack>
            <Stack.Item width="40px" textAlign="center">
              <strong>Step</strong>
            </Stack.Item>
            {Array.from({ length: offsetRange }, (_, i) => {
              const offset = i - centerOffset;
              return (
                <Stack.Item key={i} width="25px" textAlign="center">
                  <strong
                    style={{
                      color: offset === 0 ? '#00eb4e' : 'rgba(0, 235, 78, 0.6)',
                    }}
                  >
                    {offset}
                  </strong>
                </Stack.Item>
              );
            })}
          </Stack>

          {/* Grid rows */}
          {gridData
            .slice(stepScroll, endStep)
            .reverse()
            .map((row, index) => {
              const step = endStep - 1 - index;
              // Calculate which tile this step fires from
              let stepTile = 0;
              let stepNextTile = tallyStep;
              while (step + 1 > stepNextTile) {
                stepTile++;
                stepNextTile += tallyStep;
              }

              // Check if this step starts a new tile
              let prevStepTile = 0;
              let prevStepNextTile = tallyStep;
              const prevStep = step - 1;
              while (prevStep >= 0 && prevStep + 1 > prevStepNextTile) {
                prevStepTile++;
                prevStepNextTile += tallyStep;
              }
              const isNewTile =
                step > 0 && stepTile !== prevStepTile && tallyStep > 1;

              return (
                <div key={step}>
                  {/* Tile transition marker */}
                  {isNewTile && (
                    <Stack style={{ marginTop: '2px', marginBottom: '0px' }}>
                      <Stack.Item width="40px" textAlign="center">
                        <strong style={{ color: '#ffff00', fontSize: '12px' }}>
                          T{stepTile + 1}
                        </strong>
                      </Stack.Item>
                      <Stack.Item grow>
                        <hr
                          style={{
                            border: '1px solid rgba(255, 255, 0, 0.5)',
                            margin: '0px',
                            height: '1px',
                          }}
                        />
                      </Stack.Item>
                    </Stack>
                  )}

                  {/* Step row */}
                  <Stack>
                    <Stack.Item width="40px" textAlign="center">
                      <strong style={{ color: '#00eb4e' }}>{step + 1}</strong>
                    </Stack.Item>
                    {row.map((cell, offset) => (
                      <Stack.Item
                        key={offset}
                        width="25px"
                        textAlign="center"
                        style={{
                          backgroundColor:
                            offset === centerOffset
                              ? 'rgba(0, 235, 78, 0.15)'
                              : 'transparent',
                          border: '1px solid rgba(0, 235, 78, 1.0)',
                          height: '20px',
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                        }}
                      >
                        {cell.length > 0 && (
                          <span
                            style={{
                              color: '#00eb4e',
                              fontSize: '10px',
                              display: 'flex',
                              flexDirection: 'column',
                              alignItems: 'center',
                              justifyContent: 'center',
                              lineHeight: '1',
                            }}
                          >
                            <span style={{ display: 'flex' }}>
                              {cell.map((weapon, idx) => (
                                <span
                                  key={idx}
                                  style={{
                                    color: weapon.color,
                                    fontSize: '12px',
                                    fontWeight: 'bold',
                                    marginRight:
                                      idx < cell.length - 1 ? '1px' : '0px',
                                  }}
                                  title={`${weapon.label} - Step ${step + 1}`}
                                >
                                  {weapon.symbol}
                                </span>
                              ))}
                            </span>
                            {cell.length > 1 && (
                              <span
                                style={{
                                  fontSize: '8px',
                                  color: 'rgba(0, 235, 78, 0.8)',
                                }}
                              >
                                {cell.length}
                              </span>
                            )}
                          </span>
                        )}
                      </Stack.Item>
                    ))}
                  </Stack>
                </div>
              );
            })}
          {/* Legend */}
          <Stack.Item
            style={{ marginTop: '10px', fontSize: '10px', color: '#00eb4e' }}
          >
            <Stack>
              <Stack.Item
                style={{
                  width: '100%',
                  textAlign: 'center',
                  marginBottom: '8px',
                  fontSize: '12px',
                }}
              >
                Mission Length: {missionLength} tiles | Steps: {actualSteps} |
                Showing: {stepScroll + 1}-{endStep}
              </Stack.Item>
            </Stack>

            <Stack style={{ justifyContent: 'center', alignItems: 'center' }}>
              {/* Left weapons */}
              <Stack.Item>
                <span style={{ color: '#00eb4e', fontWeight: 'bold' }}>
                  ● ○
                </span>{' '}
                L1/L2
              </Stack.Item>
              <Stack.Item style={{ margin: '0 15px', height: '20px' }}>
                <Divider vertical />
              </Stack.Item>

              {/* Center symbols */}
              <Stack.Item>
                <span style={{ color: '#00eb4e', fontWeight: 'bold' }}>●</span>{' '}
                Front{' '}
                <span style={{ color: '#00eb4e', fontWeight: 'bold' }}>○</span>{' '}
                Back
              </Stack.Item>

              <Stack.Item style={{ margin: '0 15px', height: '20px' }}>
                <Divider vertical />
              </Stack.Item>

              {/* Right weapons */}
              <Stack.Item>
                <span style={{ color: '#ffff00', fontWeight: 'bold' }}>
                  ● ○
                </span>{' '}
                R1/R2
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Box>
      </Stack.Item>
    </Stack>
  );
};

const FiremissionView = (
  props: MfdProps & {
    readonly fm: CasFiremission;
    readonly stepScroll: number;
    readonly setStepScroll: (n: number) => void;
    readonly visibleSteps: number;
  },
) => {
  const { data } = useBackend<DropshipProps & FiremissionContext>();
  const { editFm } = fmEditState(props.panelStateId);
  const { editFmWeapon } = fmWeaponEditState(props.panelStateId);
  const weaponData = props.fm.records
    .map((x) => data.equipment_data.find((y) => y.mount_point === x.weapon))
    .filter((x) => x !== undefined)
    .sort(sortWeapons) as Array<DropshipEquipment>;
  const selectedWeapon = weaponData.find((x) => x.mount_point === editFmWeapon);
  const displayDetail = editFm;
  // Find the first weapon with offsets to determine step count
  const firstOffsets = props.fm.records[0]?.offsets;
  const stepCount = firstOffsets ? firstOffsets.length : 12;
  const { stepScroll, setStepScroll, visibleSteps } = props;

  const offsetsForWeapon = (weapon: DropshipEquipment) => {
    const weaponFm = props.fm.records.find(
      (x) => x.weapon === weapon.mount_point,
    );
    if (!weaponFm) {
      return [];
    }
    return weaponFm.offsets.map((offset) => {
      const numOffset = parseInt(offset, 10);
      return isNaN(numOffset) ? offset : numOffset;
    });
  };

  return (
    <Stack>
      <Stack.Item style={{ marginTop: '-15px' }}>
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
          {/* Step header and offsets */}
          <Stack>
            <Stack vertical>
              {range(
                stepScroll + 1,
                Math.min(stepScroll + visibleSteps, stepCount) + 1,
              ).map((x) => (
                <Stack.Item className="FireMissionTitle" key={x}>
                  {x}
                </Stack.Item>
              ))}
            </Stack>
            <Stack.Item>
              <Divider vertical />
              <Divider vertical />
            </Stack.Item>
            {/* Render offsets for each weapon vertically, aligned with step numbers */}
            {!editFm &&
              weaponData.map((x) => (
                <Stack vertical key={x.mount_point}>
                  {offsetsForWeapon(x)
                    .slice(stepScroll, stepScroll + visibleSteps)
                    .map((val, i) => (
                      <Stack.Item
                        key={i + stepScroll}
                        className="FireMissionOffsetLabel"
                      >
                        {val}
                      </Stack.Item>
                    ))}
                </Stack>
              ))}
            {editFm && selectedWeapon === undefined && (
              <Stack.Item>Select weapon on right panel</Stack.Item>
            )}
            {editFm && selectedWeapon && (
              <Stack vertical key={selectedWeapon.mount_point}>
                {offsetsForWeapon(selectedWeapon)
                  .slice(stepScroll, stepScroll + visibleSteps)
                  .map((val, i) => (
                    <Stack.Item
                      key={i + stepScroll}
                      className="FireMissionOffsetLabel"
                    >
                      {val}
                    </Stack.Item>
                  ))}
              </Stack>
            )}
          </Stack>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Divider vertical />
        <Divider vertical />
      </Stack.Item>
      {!editFm &&
        weaponData.map((x) => (
          <Stack.Item key={x.mount_point} grow>
            <FMOffsetStack
              displayDetail={displayDetail}
              fm={props.fm}
              panelStateId={props.panelStateId}
              equipment={x}
              stepScroll={stepScroll}
              visibleSteps={visibleSteps}
            />
          </Stack.Item>
        ))}
      {editFm && selectedWeapon === undefined && (
        <Stack.Item grow>
          <Stack vertical className="FireMissionStack">
            <Stack.Item height="130px" />
            <Divider />
            <Stack.Item>Select weapon on right panel</Stack.Item>
          </Stack>
        </Stack.Item>
      )}
      {editFm && selectedWeapon && (
        <Stack.Item grow key={selectedWeapon.mount_point}>
          <FMOffsetStack
            displayDetail={displayDetail}
            fm={props.fm}
            panelStateId={props.panelStateId}
            equipment={selectedWeapon}
            stepScroll={stepScroll}
            visibleSteps={visibleSteps}
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

const getMountPointLabel = (
  equipment: DropshipEquipment,
  weaponData: DropshipEquipment[],
) => {
  // Base designation on actual mount point
  switch (equipment.mount_point) {
    case 1:
      return 'L2';
    case 2:
      return 'L1';
    case 3:
      return 'R1';
    case 4:
      return 'R2';
    default:
      return equipment.mount_point.toString();
  }
};

const OffsetOverview = (
  props: MfdProps & {
    readonly fm: CasFiremission;
    readonly equipment: DropshipEquipment;
  },
) => {
  const { data } = useBackend<DropshipProps & FiremissionContext>();
  const weaponData = data.equipment_data
    .filter((x) => x.is_weapon === 1)
    .sort((a, b) => (a.mount_point < b.mount_point ? -1 : 1));
  const positionLabel = getMountPointLabel(props.equipment, weaponData);

  const weaponFm = props.fm.records.find(
    (x) => x.weapon === props.equipment.mount_point,
  );
  if (weaponFm === undefined) {
    return <>error</>;
  }
  const ammoConsumption = weaponFm.offsets
    .map((x) => (x !== '-' ? (props.equipment.burst ?? 0) : 0))
    .reduce((accumulator, currentValue) => accumulator + currentValue, 0);
  const ammoReadout =
    props.equipment.ammo === null || props.equipment.ammo === undefined
      ? 'DEPLETED'
      : props.equipment.ammo + '/' + props.equipment.max_ammo;
  return (
    <>
      <Stack.Item className="FireMissionOffsetLabel">
        {props.equipment.shorthand} {positionLabel}
      </Stack.Item>
      <Stack.Item className="FireMissionOffsetLabel">{ammoReadout}</Stack.Item>
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
  const { data } = useBackend<DropshipProps & FiremissionContext>();
  const weaponData = data.equipment_data
    .filter((x) => x.is_weapon === 1)
    .sort((a, b) => (a.mount_point < b.mount_point ? -1 : 1));
  const positionLabel = getMountPointLabel(props.equipment, weaponData);

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
  const ammoReadout =
    props.equipment.ammo === null || props.equipment.ammo === undefined
      ? 'DEPLETED'
      : props.equipment.ammo +
        '/' +
        props.equipment.max_ammo +
        ' using ' +
        ammoConsumption +
        ' per run';
  return (
    <>
      <Stack.Item className="FireMissionOffsetLabel">
        {props.equipment.shorthand} {positionLabel}
      </Stack.Item>
      <Stack.Item className="FireMissionOffsetLabel">{ammoReadout}</Stack.Item>
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
      <Stack.Item height="26px" />
      <Divider />
      <Stack.Item className="FireMissionError" width="100%">
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
    readonly stepScroll?: number;
    readonly visibleSteps?: number;
  },
) => {
  const { fm, stepScroll = 0, visibleSteps = 12 } = props;
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
  const availableMap = offsets ? range(0, offsets.length).map((_) => true) : [];
  offsets?.forEach((x, index) => {
    if (x === undefined || x === '-') {
      return;
    }
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
        <Stack height="1px">
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
        offsets.slice(stepScroll, stepScroll + visibleSteps).map((x, i) => (
          <Stack.Item key={i + stepScroll} className="FireMissionOffsetLabel">
            {x}
          </Stack.Item>
        ))}
      {editFm === true &&
        offsets &&
        offsets.slice(stepScroll, stepScroll + visibleSteps).map((x, i) => {
          if (availableMap[i + stepScroll] === false && x === '-') {
            return (
              <Stack.Item key={i + stepScroll}>
                <Box className="FiremissionBadStep">WEAPON BUSY</Box>
              </Stack.Item>
            );
          }
          if (props.equipment.firemission_delay === 0) {
            return (
              <Stack.Item key={i + stepScroll}>
                <Box className="FiremissionBadStep">
                  Ammo unusable for firemissions
                </Box>
              </Stack.Item>
            );
          }
          return (
            <Stack.Item key={i + stepScroll}>
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
                            offset_id: `${i + stepScroll}`,
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
