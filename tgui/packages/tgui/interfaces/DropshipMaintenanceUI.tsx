import { classes } from 'common/react';
import { Fragment, useEffect, useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import { Box, Flex, ProgressBar, Section, Stack, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { TimedCallback } from './common/TimedCallback';

// Data types for dropship maintenance UI
type RepairStep = string;
interface Malfunction {
  id: string;
  steps: RepairStep[];
  mount_point?: number;
  original_mount_point?: number;
  equipment_name?: string;
  effect_name?: string;
  completed_steps?: number;
  effect_description?: string;
  effect_duration?: number;
  time_applied?: number;
  time_applied_text?: string;
  shuttle_name?: string;
  shuttle_id?: string;
  debuffs?: string[];
}
interface DropshipMaintenanceData {
  repair_list: Malfunction[];
  current_time?: number;
}

const MalfunctionList = ({
  repair_list,
}: {
  readonly repair_list: Malfunction[];
}) => (
  <Box className="MalfunctionList">
    <Stack vertical>
      {repair_list.length === 0 && (
        <Stack.Item>
          <span>No malfunctions detected.</span>
        </Stack.Item>
      )}
      {repair_list.map((malf) => (
        <Stack.Item key={malf.id}>
          <Box className="MalfunctionBox">
            <b>{malf.id}</b>
            <ul>
              {malf.steps.map((step, i) => (
                <li key={i}>{step}</li>
              ))}
            </ul>
          </Box>
        </Stack.Item>
      ))}
    </Stack>
  </Box>
);

const EmptyDisplay = () => {
  return (
    <Box className="EmptyDisplay">
      <Stack vertical>
        <Stack.Item>
          <span>No equipment detected.</span>
        </Stack.Item>
        <Stack.Item>
          <span>
            Connect the Aircraft Maintenance Tuner with the laptop to link the
            encryption data. Then scan the damaged equipment with the Aircraft
            Maintenance Tuner to continue.
          </span>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

// --- Dropship Outline Drawing ---

const equipment_xs = [140, 160, 320, 340, 180, 300, 240, 240, 240, 140, 340];
const equipment_ys = [120, 100, 100, 120, 100, 100, 260, 300, 340, 320, 320];
const equipment_text_xs = [
  100, 120, 360, 380, 180, 320, 250, 250, 250, 100, 400,
];
const equipment_text_ys = [120, 60, 60, 120, 20, 20, 240, 280, 320, 320, 320];

const DrawWeapon = ({
  x,
  y,
  damaged,
  uninstalled,
}: {
  readonly x: number;
  readonly y: number;
  readonly damaged?: boolean;
  readonly uninstalled?: boolean;
}) => {
  let color = '#00e94e'; // Default green for normal equipment
  if (uninstalled) {
    color = '#ff8c00'; // Orange for uninstalled equipment
  } else if (damaged) {
    color = '#e90000'; // Red for damaged equipment
  }

  return (
    <>
      <path
        fillOpacity="1"
        fill={color}
        stroke={color}
        d={`M ${x + 5} ${y} l 0 20 l 10 0 l 0 -20 l -10 0`}
      />
      {damaged && !uninstalled && (
        <text
          x={x + 10}
          y={y - 10}
          textAnchor="middle"
          fontWeight="bold"
          fill="#e90000"
        >
          ERR#R
        </text>
      )}
      {uninstalled && (
        <text
          x={x + 10}
          y={y - 10}
          textAnchor="middle"
          fontWeight="bold"
          fill="#ff8c00"
        >
          UNINST
        </text>
      )}
    </>
  );
};

const DrawEquipmentBox = ({
  x,
  y,
}: {
  readonly x: number;
  readonly y: number;
}) => (
  <path
    fillOpacity="1"
    fill="#00e94e"
    stroke="#00e94e"
    d={`M ${x} ${y} l 0 20 l 20 0 l 0 -20 l -20 0`}
  />
);

const DrawWeaponText = ({
  x,
  y,
  desc,
  sub_desc,
}: {
  readonly x: number;
  readonly y: number;
  readonly desc: string;
  readonly sub_desc?: string;
}) => (
  <text stroke="#00e94e" x={x} y={y} textAnchor="middle">
    {desc.split(' ').map((xw, idx) => (
      <tspan x={x} dy="1.2em" key={xw + idx}>
        {xw}
      </tspan>
    ))}
    {sub_desc && (
      <tspan x={x} dy="1.2em">
        {sub_desc}
      </tspan>
    )}
  </text>
);

const DrawDropshipOutline = () => (
  <>
    {/* cockpit */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 200 120 l 0 -80 l 100 0 l 0 80 m -40 0 l 20 0 l 0 -60 l -60 0 l 0 60 l 20 0"
    />
    {/* left body */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 200 120 L 160 120 L 160 280 L 180 280 L 180 400 L 220 400 L 220 380 L 200 380 L 200 260 L 180 260 L 180 140 L 240 140 L 240 120"
    />
    {/* left weapon */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 160 140 l -20 0 l 0 40 l 20 0"
    />
    {/* left engine */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 180 380 L 140 380 L 140 300 L 180 300"
    />
    {/* left tail */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 200 400 l 0 40 l -40 0 l 0 20 l 60 0 l 0 -60"
    />
    {/* right body */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 300 120 L 340 120 L 340 280 L 320 280 L 320 400 L 280 400 L 280 380 L 300 380 L 300 260 L 320 260 L 320 140 L 260 140 L 260 120"
    />
    {/* right weapon */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 340 140 L 360 140 L 360 180 L 340 180"
    />
    {/* right engine */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 320 380 L 360 380 L 360 300 L 320 300"
    />
    {/* right tail */}
    <path
      fillOpacity="0"
      stroke="#00e94e"
      d="M 300 400 L 300 440 L 340 440 L 340 460 L 280 460 L 280 400"
    />
  </>
);

const DrawAirlocks = () => (
  <>
    <defs>
      <pattern
        id="diagonalHatch"
        patternUnits="userSpaceOnUse"
        width="4"
        height="4"
      >
        <path
          stroke="#00e94e"
          strokeWidth="1"
          d="M-1,1 l2,-2 M 0,4 l4,-4 M3,5 l2,-2"
        />
      </pattern>
    </defs>
    {/* cockpit door */}
    <path
      fillOpacity="1"
      fill="url(#diagonalHatch)"
      stroke="#00e94e"
      d="M 240 140 L 260 140 L 260 120 L 240 120 L 240 140"
    />
    {/* left airlock */}
    <path
      fill="url(#diagonalHatch)"
      stroke="#00e94e"
      d="M 160 180 l 20 0 l 0 40 l -20 0 l 0 -40 "
    />
    {/* right airlock */}
    <path
      fill="url(#diagonalHatch)"
      stroke="#00e94e"
      d="M 340 180 L 320 180 L 320 220 L 340 220 L 340 180 "
    />
    {/* rear ramp */}
    <path
      fill="url(#diagonalHatch)"
      stroke="#00e94e"
      d="M 220 400 L 280 400 L 280 380 L 220 380 L 220 400"
    />
  </>
);

const DrawEquipment = ({
  damagedMounts,
  repair_list,
}: {
  readonly damagedMounts: number[];
  readonly repair_list: Malfunction[];
}) => {
  // Get all mount points that have equipment
  const equipmentMounts = repair_list
    .map((malf) => malf.original_mount_point || malf.mount_point)
    .filter((x) => typeof x === 'number');

  // Get uninstalled mount points
  const uninstalledMounts = repair_list
    .filter((malf) => malf.original_mount_point && !malf.mount_point)
    .map((malf) => malf.original_mount_point!)
    .filter((x) => typeof x === 'number');

  // Create a mapping of mount points to scan numbers
  const mountToScanNumber: { [key: number]: number } = {};

  // Group by shuttle and assign per-shuttle scan numbers
  const equipmentByShuttle: { [shuttleName: string]: Malfunction[] } = {};
  repair_list.forEach((malf) => {
    const shuttleName = malf.shuttle_name || 'Unknown Shuttle';
    if (!equipmentByShuttle[shuttleName]) {
      equipmentByShuttle[shuttleName] = [];
    }
    equipmentByShuttle[shuttleName].push(malf);
  });

  // Assign per-shuttle scan numbers to mount points
  Object.keys(equipmentByShuttle).forEach((shuttleName) => {
    equipmentByShuttle[shuttleName].forEach((malf, index) => {
      const mountPoint = malf.original_mount_point || malf.mount_point;
      if (mountPoint) {
        mountToScanNumber[mountPoint] = index + 1; // Per-shuttle scan number
      }
    });
  });

  return (
    <>
      {equipment_xs.map((x, i) => {
        const mountPoint = i + 1;
        // Only draw equipment if this mount point has equipment
        if (equipmentMounts.includes(mountPoint)) {
          const scanNumber = mountToScanNumber[mountPoint];
          return (
            <g key={i}>
              <DrawWeapon
                x={x}
                y={equipment_ys[i]}
                damaged={damagedMounts.includes(mountPoint)}
                uninstalled={uninstalledMounts.includes(mountPoint)}
              />
              {/* Add scan number label */}
              {scanNumber && (
                <text
                  x={x + 15}
                  y={equipment_ys[i] + 35}
                  textAnchor="middle"
                  stroke="#00e94e"
                  fill="#00e94e"
                  fontSize="16"
                  fontWeight="bold"
                >
                  {scanNumber}
                </text>
              )}
            </g>
          );
        }
        return null;
      })}
    </>
  );
};

const DropshipDiagram = ({
  damagedMounts,
  repair_list,
  shuttleName,
}: {
  readonly damagedMounts: number[];
  readonly repair_list: Malfunction[];
  readonly shuttleName?: string;
}) => {
  return (
    <Box className="DropshipDiagram" style={{ margin: 'auto', width: '500px' }}>
      {/* Show shuttle name header if provided */}
      {shuttleName && (
        <Box
          style={{
            textAlign: 'center',
            marginBottom: '10px',
            color: '#00e94e',
            fontSize: '1.2rem',
            fontWeight: 'bold',
          }}
        >
          {shuttleName}
        </Box>
      )}
      <svg height="400" width="500">
        <DrawDropshipOutline />
        <DrawEquipment
          damagedMounts={damagedMounts}
          repair_list={repair_list}
        />
        <DrawAirlocks />
      </svg>
    </Box>
  );
};

// Mount point names
const getMountPointDescription = (mountPoint: number): string => {
  const mountDescriptions: { [key: number]: string } = {
    1: 'Port Wing',
    2: 'Port Fore',
    3: 'Starboard Fore',
    4: 'Starboard Wing',
    5: 'Electronic Left',
    6: 'Electronic Right',
    7: 'Crew Compartment Bottom',
    8: 'Crew Compartment Mid',
    9: 'Crew Compartment Top',
    10: 'Left Engine',
    11: 'Right Engine',
  };
  return mountDescriptions[mountPoint] || `Mount ${mountPoint}`;
};

const formatTimeFromDeciseconds = (deciseconds: number): string => {
  const totalSeconds = Math.floor(deciseconds / 10);
  const hours = Math.floor(totalSeconds / 3600);
  const minutes = Math.floor((totalSeconds % 3600) / 60);
  const seconds = totalSeconds % 60;

  return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
};

const DynamicCountdown = ({
  initialDuration,
  timeApplied,
  currentWorldTime,
}: {
  readonly initialDuration: number;
  readonly timeApplied: number;
  readonly currentWorldTime: number;
}) => {
  const [elapsedTicks, setElapsedTicks] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setElapsedTicks((prev) => prev + 1);
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  if (!currentWorldTime || !timeApplied) {
    return <span>{formatTimeFromDeciseconds(initialDuration)}</span>;
  }

  // Calculate elapsed time since the effect was applied
  const elapsedSinceApplication = currentWorldTime - timeApplied + elapsedTicks;
  const remainingDuration = Math.max(
    0,
    initialDuration - elapsedSinceApplication,
  );

  if (remainingDuration <= 0) {
    return (
      <span style={{ color: '#e90000', fontWeight: 'bold' }}>EXPIRED</span>
    );
  }

  return <span>{formatTimeFromDeciseconds(remainingDuration)}</span>;
};

const RepairStepsList = ({
  steps,
  completed,
}: {
  readonly steps: string[];
  readonly completed: number;
}) => (
  <Box>
    {steps.map((step, i) => (
      <Box key={i}>
        <Box style={{ marginBottom: '8px' }}>
          <span
            style={{
              color: i < completed ? '#00e94e' : '#ff8c00',
              fontWeight: i < completed ? 'bold' : undefined,
              textDecoration: i < completed ? 'line-through' : undefined,
            }}
          >
            {step}
          </span>
        </Box>
        {i < steps.length - 1 && (
          <Box
            style={{
              borderBottom: '3px dotted #00e94e',
              marginBottom: '8px',
              width: '100%',
            }}
          />
        )}
      </Box>
    ))}
  </Box>
);

const RepairStepsListAllTab = ({
  steps,
  completed,
}: {
  readonly steps: string[];
  readonly completed: number;
}) => (
  <Box>
    {steps.map((step, i) => (
      <Box key={i}>
        <Box
          style={{
            display: 'flex',
            justifyContent: 'center',
            marginBottom: '8px',
          }}
        >
          <Box style={{ textAlign: 'left' }}>
            <span
              style={{
                color: i < completed ? '#00e94e' : '#ff8c00',
                fontWeight: i < completed ? 'bold' : undefined,
                textDecoration: i < completed ? 'line-through' : undefined,
              }}
            >
              {step}
            </span>
          </Box>
        </Box>
        {i < steps.length - 1 && (
          <Box
            style={{
              borderBottom: '3px dotted #00e94e',
              marginBottom: '8px',
              width: '100%',
            }}
          />
        )}
      </Box>
    ))}
  </Box>
);

// Maintenance display for all malfunctions
const MaintenanceDisplay = ({
  repair_list,
}: {
  readonly repair_list: Malfunction[];
}) => {
  // Group equipment by shuttle
  const equipmentByShuttle: { [shuttleName: string]: Malfunction[] } = {};
  repair_list.forEach((malf) => {
    const shuttleName = malf.shuttle_name || 'Unknown Shuttle';
    if (!equipmentByShuttle[shuttleName]) {
      equipmentByShuttle[shuttleName] = [];
    }
    equipmentByShuttle[shuttleName].push(malf);
  });

  const shuttleNames = Object.keys(equipmentByShuttle);

  return (
    <Flex
      direction="column"
      className="GunFlex"
      align="stretch"
      justify="center"
    >
      {shuttleNames.map((shuttleName, shuttleIndex) => {
        const shuttleEquipment = equipmentByShuttle[shuttleName];
        return (
          <Fragment key={shuttleName}>
            {/* Shuttle Header */}
            {shuttleNames.length > 1 && (
              <Flex.Item
                style={{
                  marginTop: shuttleIndex > 0 ? '30px' : '0',
                  marginBottom: '10px',
                }}
              >
                <Box
                  className="EngagedBox"
                  style={{
                    backgroundColor: 'rgba(0, 233, 78, 0.2)',
                    textAlign: 'center',
                  }}
                >
                  <span style={{ fontSize: '1.2rem', fontWeight: 'bold' }}>
                    === {shuttleName} ===
                  </span>
                </Box>
              </Flex.Item>
            )}

            {shuttleEquipment.map((malf, equipmentIndex) => {
              const completed =
                typeof malf.completed_steps === 'number'
                  ? malf.completed_steps
                  : 0;
              const scanNumber = equipmentIndex + 1; // Per-shuttle numbering
              return (
                <Fragment key={malf.id}>
                  {/* Equipment Name */}
                  <Flex.Item
                    style={{
                      marginTop:
                        equipmentIndex > 0 || shuttleIndex > 0 ? '20px' : '0',
                    }}
                  >
                    <Box
                      className="EngagedBox"
                      style={{ backgroundColor: 'rgba(0, 233, 78, 0.1)' }}
                    >
                      <span>
                        <b>
                          {scanNumber}. {malf.equipment_name || malf.id}
                        </b>
                        {shuttleNames.length === 1 && malf.shuttle_name && (
                          <span style={{ color: '#00e94e', marginLeft: '8px' }}>
                            [{malf.shuttle_name}]
                          </span>
                        )}
                      </span>
                    </Box>
                  </Flex.Item>

                  {/* Mount Point Location */}
                  {(malf.original_mount_point || malf.mount_point) && (
                    <Flex.Item>
                      <Box className="EngagedBox">
                        <span>
                          <i>
                            {getMountPointDescription(
                              malf.original_mount_point || malf.mount_point!,
                            )}
                          </i>
                          {malf.mount_point &&
                            malf.original_mount_point &&
                            malf.mount_point !== malf.original_mount_point &&
                            ` (moved from ${getMountPointDescription(malf.original_mount_point)})`}
                          {!malf.mount_point && malf.original_mount_point && (
                            <>
                              {' '}
                              <span style={{ color: '#ff8c00' }}>
                                (uninstalled)
                              </span>
                            </>
                          )}
                        </span>
                      </Box>
                    </Flex.Item>
                  )}

                  {/* Effect Name */}
                  {malf.effect_name && (
                    <Flex.Item>
                      <Box className="EngagedBox">
                        <span>{malf.effect_name}</span>
                      </Box>
                    </Flex.Item>
                  )}

                  {/* Repair Steps */}
                  <Flex.Item>
                    <Box className="EngagedBox">
                      <Flex direction="column" align="stretch">
                        <Flex.Item>
                          <span>
                            <b>Repair Steps:</b>
                          </span>
                        </Flex.Item>
                        <Flex.Item>
                          <Box
                            style={{
                              borderBottom: '2px solid #00e94e',
                              marginBottom: '12px',
                              marginTop: '4px',
                            }}
                          />
                        </Flex.Item>
                        <Flex.Item>
                          <RepairStepsListAllTab
                            steps={malf.steps}
                            completed={completed}
                          />
                        </Flex.Item>
                      </Flex>
                    </Box>
                  </Flex.Item>
                </Fragment>
              );
            })}
          </Fragment>
        );
      })}
    </Flex>
  );
};

const ScanDetailView = ({
  scanTab,
  currentWorldTime,
}: {
  readonly scanTab: {
    scanNumber: number;
    malfunction: Malfunction;
    shuttleName: string;
  };
  readonly currentWorldTime: number;
}) => {
  const { malfunction } = scanTab;
  const completed =
    typeof malfunction.completed_steps === 'number'
      ? malfunction.completed_steps
      : 0;

  return (
    <Stack vertical>
      <Stack.Item
        className="TitleBox"
        style={{ backgroundColor: 'rgba(0, 233, 78, 0.1)' }}
      >
        <Stack vertical className="TitleContainer">
          <Stack.Item className="TitleText">
            <span style={{ fontSize: '1.8rem', fontWeight: 'bold' }}>
              {scanTab.shuttleName} Scan #{scanTab.scanNumber}:{' '}
              {malfunction.equipment_name || malfunction.id}
            </span>
          </Stack.Item>
          <Stack.Item className="TitleText">
            <Stack>
              <Stack.Item>
                <span style={{ fontSize: '1.6rem' }}>
                  EQUIPMENT MAINTENANCE SYSTEM
                </span>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item>
        <Flex
          direction="column"
          className="GunFlex PerScanDetail"
          align="stretch"
          justify="center"
        >
          {/* Equipment Name */}
          <Flex.Item>
            <Box className="EngagedBox PerScanDetail">
              <span>
                <b>Equipment Name:</b>{' '}
                <span className="value">
                  {malfunction.equipment_name || malfunction.id}
                </span>
              </span>
            </Box>
          </Flex.Item>

          {/* Shuttle Name */}
          {malfunction.shuttle_name && (
            <Flex.Item>
              <Box className="EngagedBox PerScanDetail">
                <span>
                  <b>Dropship:</b>{' '}
                  <span className="value">{malfunction.shuttle_name}</span>
                </span>
              </Box>
            </Flex.Item>
          )}

          {/* Mount Point Location */}
          {(malfunction.original_mount_point || malfunction.mount_point) && (
            <Flex.Item>
              <Box className="EngagedBox PerScanDetail">
                <span>
                  <b>Mount Point Location:</b>{' '}
                  <span className="value">
                    <i>
                      {getMountPointDescription(
                        malfunction.original_mount_point ||
                          malfunction.mount_point!,
                      )}
                    </i>
                    {malfunction.mount_point &&
                      malfunction.original_mount_point &&
                      malfunction.mount_point !==
                        malfunction.original_mount_point &&
                      ` (moved from ${getMountPointDescription(malfunction.original_mount_point)})`}
                    {!malfunction.mount_point &&
                      malfunction.original_mount_point && (
                        <>
                          {' '}
                          <span style={{ color: '#ff8c00' }}>
                            (uninstalled)
                          </span>
                        </>
                      )}
                  </span>
                </span>
              </Box>
            </Flex.Item>
          )}

          {/* Antiair Effect */}
          {malfunction.effect_name && (
            <Flex.Item>
              <Box className="EngagedBox PerScanDetail">
                <span>
                  <b>Damage Analysis:</b>{' '}
                  <span className="value">{malfunction.effect_name}</span>
                </span>
              </Box>
            </Flex.Item>
          )}

          {/* Antiair Effect Debuffs */}
          {malfunction.debuffs && malfunction.debuffs.length > 0 && (
            <Flex.Item>
              <Box className="EngagedBox PerScanDetail">
                <Flex direction="column" align="stretch">
                  <Flex.Item>
                    <span>
                      <b>Structural Integrity:</b>
                    </span>
                  </Flex.Item>
                  {malfunction.debuffs.map((debuff, index) => (
                    <Flex.Item key={index}>
                      <span style={{ color: '#ff8c00', marginLeft: '10px' }}>
                        {debuff}
                      </span>
                    </Flex.Item>
                  ))}
                </Flex>
              </Box>
            </Flex.Item>
          )}

          {/* Antiair Effect Duration */}
          {malfunction.effect_duration && (
            <Flex.Item>
              <Box className="EngagedBox PerScanDetail">
                <span>
                  <b>Time Until Compromise:</b>{' '}
                  <DynamicCountdown
                    initialDuration={malfunction.effect_duration}
                    timeApplied={malfunction.time_applied || 0}
                    currentWorldTime={currentWorldTime}
                  />
                </span>
              </Box>
            </Flex.Item>
          )}

          {/* Time AntiAir Effect was Applied */}
          {malfunction.time_applied_text && (
            <Flex.Item>
              <Box className="EngagedBox PerScanDetail">
                <span>
                  <b>Damage Recorded at:</b> {malfunction.time_applied_text}
                </span>
              </Box>
            </Flex.Item>
          )}

          {/* Repair Steps */}
          <Flex.Item>
            <Box className="EngagedBox PerScanDetail">
              <Flex direction="column" align="stretch">
                <Flex.Item>
                  <span>
                    <b>Repair Steps:</b>
                  </span>
                </Flex.Item>
                <Flex.Item>
                  <Box
                    style={{
                      borderBottom: '2px solid #00e94e',
                      marginBottom: '12px',
                      marginTop: '4px',
                    }}
                  />
                </Flex.Item>
                <Flex.Item>
                  <RepairStepsList
                    steps={malfunction.steps}
                    completed={completed}
                  />
                </Flex.Item>
              </Flex>
            </Box>
          </Flex.Item>
        </Flex>
      </Stack.Item>
    </Stack>
  );
};

// Each malfunction gets its own tab, numbered by scan order per shuttle
const getMalfunctionTabs = (
  repair_list: Malfunction[],
): Array<{
  scanNumber: number;
  malfunction: Malfunction;
  shuttleName: string;
}> => {
  // Group by shuttle and assign per-shuttle scan numbers
  const equipmentByShuttle: { [shuttleName: string]: Malfunction[] } = {};
  repair_list.forEach((malf) => {
    const shuttleName = malf.shuttle_name || 'Unknown Shuttle';
    if (!equipmentByShuttle[shuttleName]) {
      equipmentByShuttle[shuttleName] = [];
    }
    equipmentByShuttle[shuttleName].push(malf);
  });

  const tabs: Array<{
    scanNumber: number;
    malfunction: Malfunction;
    shuttleName: string;
  }> = [];
  Object.keys(equipmentByShuttle).forEach((shuttleName) => {
    equipmentByShuttle[shuttleName].forEach((malfunction, index) => {
      tabs.push({
        scanNumber: index + 1, // Per-shuttle numbering
        malfunction,
        shuttleName,
      });
    });
  });

  return tabs;
};

// Tab menu for individual scan selection
const ScanTabMenu = (props: {
  readonly scanTabs: Array<{
    scanNumber: number;
    malfunction: Malfunction;
    shuttleName: string;
  }>;
  readonly selected?: number;
  readonly setSelected: (d: number | undefined) => void;
}) => {
  return (
    <Tabs fill>
      {props.scanTabs.map((scanTab, index) => (
        <Tabs.Tab
          key={scanTab.malfunction.id}
          selected={props.selected === index}
          onClick={() => {
            props.setSelected(index);
          }}
        >
          {scanTab.shuttleName.charAt(0)}
          {scanTab.scanNumber}
        </Tabs.Tab>
      ))}
      <Tabs.Tab
        selected={props.selected === undefined}
        onClick={() => {
          props.setSelected(undefined);
        }}
      >
        All
      </Tabs.Tab>
    </Tabs>
  );
};

const MaintenanceList = ({
  repair_list,
}: {
  readonly repair_list: Malfunction[];
}) => {
  if (repair_list.length === 0) {
    return (
      <Stack vertical>
        <Stack.Item>
          <span>No malfunctions detected.</span>
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Stack vertical>
      <Stack.Item align="center">
        <Stack vertical className={classes(['RepairCard', 'RepairBox'])}>
          <Stack.Item align="center">
            <MaintenanceDisplay repair_list={repair_list} />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const PowerLevel = () => {
  const { data } = useBackend<
    DropshipMaintenanceData & {
      screen_state: number;
      electrical?: { charge: number; max_charge: number };
    }
  >();

  if (!data.electrical) return null;
  return (
    <ProgressBar
      minValue={0}
      maxValue={data.electrical.max_charge}
      value={data.electrical.charge}
      style={{ color: 'black' }}
    >
      {((data.electrical.charge / data.electrical.max_charge) * 100).toFixed(2)}{' '}
      %
    </ProgressBar>
  );
};

export const DropshipMaintenanceUI = () => {
  const { data, act } = useBackend<
    DropshipMaintenanceData & {
      screen_state: number;
      electrical?: { charge: number; max_charge: number };
    }
  >();
  const { repair_list, screen_state } = data;

  const hasRepairs = repair_list && repair_list.length > 0;
  const scanTabs = hasRepairs ? getMalfunctionTabs(repair_list) : [];

  const [selectedScan, setSelectedScan] = useSharedState<undefined | number>(
    'selectedScan',
    scanTabs.length > 0 ? undefined : undefined,
  );

  const validSelection =
    scanTabs.length === 0 ? false : (selectedScan ?? 0) < scanTabs.length;

  // Collect damaged mount points from repair_list
  const damagedMounts = (repair_list || [])
    .map((malf) => malf.original_mount_point || malf.mount_point)
    .filter((x) => typeof x === 'number');

  // Group equipment by shuttle
  const equipmentByShuttle: { [shuttleName: string]: Malfunction[] } = {};
  (repair_list || []).forEach((malf) => {
    const shuttleName = malf.shuttle_name || 'Unknown Shuttle';
    if (!equipmentByShuttle[shuttleName]) {
      equipmentByShuttle[shuttleName] = [];
    }
    equipmentByShuttle[shuttleName].push(malf);
  });

  const shuttleNames = Object.keys(equipmentByShuttle);

  return (
    <Window theme="crtgreen" height={700} width={700}>
      <Window.Content className="DropshipMaintenance">
        <Stack vertical fill>
          {data.electrical && hasRepairs && (
            <Stack.Item>
              <Flex justify="space-between" align-items="center">
                <Flex.Item>
                  <ScanTabMenu
                    scanTabs={scanTabs}
                    selected={selectedScan}
                    setSelected={setSelectedScan}
                  />
                </Flex.Item>
                <Flex.Item align="center">
                  <PowerLevel />
                </Flex.Item>
              </Flex>
            </Stack.Item>
          )}
          <Stack.Item grow>
            {data.screen_state === 0 && (
              <Box>
                <TimedCallback
                  time={1.5}
                  callback={() => act('screen-state', { state: 1 })}
                />
                <Box className="TopPanelSlide" />
                <Box className="BottomPanelSlide" />
              </Box>
            )}
            {screen_state === 1 && hasRepairs && (
              <>
                {/* All tab view - current layout with dropship diagram */}
                {selectedScan === undefined && (
                  <Section scrollable fill>
                    <Flex
                      direction="row"
                      align="stretch"
                      justify="space-between"
                    >
                      {/* Left side: Repair information */}
                      <Flex.Item basis="45%">
                        <MaintenanceList repair_list={repair_list} />
                      </Flex.Item>

                      {/* Center dividing line */}
                      <Flex.Item
                        basis="2%"
                        style={{ display: 'flex', alignItems: 'stretch' }}
                      >
                        <Box
                          style={{
                            width: '2px',
                            backgroundColor: '#00e94e',
                            margin: '0 auto',
                            height: '100%',
                          }}
                        />
                      </Flex.Item>

                      {/* Right side: Dropship diagram(s) */}
                      <Flex.Item basis="53%">
                        {shuttleNames.length === 1 ? (
                          // Single shuttle - show one diagram
                          <DropshipDiagram
                            damagedMounts={damagedMounts}
                            repair_list={repair_list}
                            shuttleName={shuttleNames[0]}
                          />
                        ) : (
                          // Multiple shuttles - show stacked diagrams
                          <Stack vertical>
                            {shuttleNames.map((shuttleName) => {
                              const shuttleEquipment =
                                equipmentByShuttle[shuttleName];
                              const shuttleDamagedMounts = shuttleEquipment
                                .map(
                                  (malf) =>
                                    malf.original_mount_point ||
                                    malf.mount_point,
                                )
                                .filter((x) => typeof x === 'number');
                              return (
                                <Stack.Item
                                  key={shuttleName}
                                  style={{ marginBottom: '20px' }}
                                >
                                  <DropshipDiagram
                                    damagedMounts={shuttleDamagedMounts}
                                    repair_list={shuttleEquipment}
                                    shuttleName={shuttleName}
                                  />
                                </Stack.Item>
                              );
                            })}
                          </Stack>
                        )}
                      </Flex.Item>
                    </Flex>
                  </Section>
                )}

                {/* Individual scan tab view */}
                {selectedScan !== undefined && validSelection && (
                  <Section scrollable fill>
                    <ScanDetailView
                      scanTab={scanTabs[selectedScan]}
                      currentWorldTime={data.current_time || 0}
                    />
                  </Section>
                )}
              </>
            )}
            {screen_state === 1 && !hasRepairs && <EmptyDisplay />}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
