import { range } from 'common/collections';
import { useBackend, useLocalState, useSharedState } from '../../backend';
import { Box, Icon, NumberInput, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdProps, MfdPanel } from './MultifunctionDisplay';
import { mfdState } from './stateManagers';
import { FiremissionContext, LazeTarget } from './types';

interface EquipmentContext {
  equipment_data: Array<DropshipEquipment>;
  targets_data: Array<LazeTarget>;
}

const directionLookup = new Map<string, number>();
directionLookup['N-S'] = 2;
directionLookup['S-N'] = 1;
directionLookup['E-W'] = 8;
directionLookup['W-E'] = 4;

const dirMap = (dir) => {
  switch (dir) {
    case 'NORTH':
      return 1;
    case 'SOUTH':
      return 2;
    case 'EAST':
      return 4;
    case 'WEST':
      return 8;
  }
};

export const TargetAquisitionMfdPanel = (props: MfdProps, context) => {
  const { setPanelState } = mfdState(context, props.panelStateId);
  const [selectedTarget, setSelectedTarget] = useSharedState<
    number | undefined
  >(context, 'laze-target', undefined);
  const [strikeMode, setStrikeMode] = useSharedState<string | undefined>(
    context,
    'strike-mode',
    undefined
  );
  const [strikeDirection, setStrikeDirection] = useSharedState<
    string | undefined
  >(context, 'strike-direction', undefined);

  const [weaponSelected, setWeaponSelected] = useSharedState<
    number | undefined
  >(context, 'target-weapon-select', undefined);

  const [firemissionSelected, setFiremissionSelected] = useSharedState<
    number | undefined
  >(context, 'target-firemission-select', undefined);

  const [fmOffsetDir, setFmOffsetDir] = useSharedState<
    'NORTH' | 'SOUTH' | 'EAST' | 'WEST'
  >(context, 'firemission-offset-dir', 'NORTH');

  const [fmOffsetValue, setFmOffsetValue] = useSharedState<number>(
    context,
    'firemission-offset-value',
    0
  );

  const [leftButtonMode, setLeftButtonMode] = useSharedState<
    string | undefined
  >(context, 'target_left', undefined);

  const { act, data } = useBackend<EquipmentContext & FiremissionContext>(
    context
  );

  const lazes = range(0, 5).map((x) =>
    x > data.targets_data.length ? undefined : data.targets_data[x]
  );
  const lazeMapper = (index: number) => {
    const target = lazes.length > index ? lazes[index] : undefined;
    const label = target?.target_name.split(' ')[0] ?? '';
    const squad = label[0] ?? '';
    const number = label.split('-')[1] ?? '';
    return {
      children: `${squad}-${number}`,
      onClick: target
        ? () => {
          act('set-camera', { 'equipment_id': target.target_tag });
          setSelectedTarget(target.target_tag);
        }
        : () => {
          act('set-camera', { 'equipment_id': null });
          setSelectedTarget(undefined);
        },
    };
  };

  const weapons = data.equipment_data.filter((x) => x.is_weapon);

  const leftButtonGenerator = () => {
    if (leftButtonMode === undefined) {
      return [
        {
          children: 'STRIKE',
          onClick: () => setLeftButtonMode('STRIKE'),
        },
        {
          children: 'VECTOR',
          onClick: () => setLeftButtonMode('VECTOR'),
        },
        {
          children: 'OFFSET',
          onClick: () => setLeftButtonMode('OFFSET'),
        },
      ];
    }
    if (leftButtonMode === 'STRIKE') {
      if (strikeMode === 'weapon' && weaponSelected === undefined) {
        return weapons.map((x) => {
          return {
            children: x.shorthand,
            onClick: () => {
              setWeaponSelected(x.mount_point);
              setLeftButtonMode(undefined);
            },
          };
        });
      }
      if (strikeMode === 'firemission' && firemissionSelected === undefined) {
        return data.firemission_data.map((x) => {
          return {
            children: x.name,
            onClick: () => {
              setFiremissionSelected(x.mission_tag);
              setLeftButtonMode(undefined);
            },
          };
        });
      }
      return [
        { children: 'CANCEL', onClick: () => setLeftButtonMode(undefined) },
        {
          children: 'WEAPON',
          onClick: () => {
            setWeaponSelected(undefined);
            setStrikeMode('weapon');
          },
        },
        {
          children: 'F-MISS',
          onClick: () => {
            setFiremissionSelected(undefined);
            setStrikeMode('firemission');
          },
        },
      ];
    }
    if (leftButtonMode === 'VECTOR') {
      return [
        { children: 'CANCEL', onClick: () => setLeftButtonMode(undefined) },
        {
          children: 'N-S',
          onClick: () => {
            setStrikeDirection('N-S');
            setLeftButtonMode(undefined);
          },
        },
        {
          children: 'S-N',
          onClick: () => {
            setStrikeDirection('S-N');
            setLeftButtonMode(undefined);
          },
        },
        {
          children: 'W-E',
          onClick: () => {
            setStrikeDirection('W-E');
            setLeftButtonMode(undefined);
          },
        },
        {
          children: 'E-W',
          onClick: () => {
            setStrikeDirection('E-W');
            setLeftButtonMode(undefined);
          },
        },
      ];
    }
    if (leftButtonMode === 'OFFSET') {
      return [
        { children: 'CANCEL', onClick: () => setLeftButtonMode(undefined) },
        {
          children: 'NORTH',
          onClick: () => {
            setFmOffsetDir('NORTH');
            setLeftButtonMode(undefined);
          },
        },
        {
          children: 'SOUTH',
          onClick: () => {
            setFmOffsetDir('SOUTH');
            setLeftButtonMode(undefined);
          },
        },
        {
          children: 'EAST',
          onClick: () => {
            setFmOffsetDir('EAST');
            setLeftButtonMode(undefined);
          },
        },
        {
          children: 'WEST',
          onClick: () => {
            setFmOffsetDir('WEST');
            setLeftButtonMode(undefined);
          },
        },
      ];
    }
    return [];
  };

  const strikeConfigLabel =
    strikeMode === 'weapon'
      ? data.equipment_data.find((x) => x.mount_point === weaponSelected)?.name
      : firemissionSelected !== undefined
        ? data.firemission_data.find(
          (x) => x.mission_tag === firemissionSelected
        )?.name
        : 'NONE';

  const lazeIndex = lazes.findIndex((x) => x?.target_tag === selectedTarget);
  const strikeReady = strikeMode !== undefined && lazeIndex !== -1;

  const [targetOffset, setTargetOffset] = useLocalState(
    context,
    `${props.panelStateId}_targetOffset`,
    0
  );

  const targets = range(targetOffset, targetOffset + 5).map(lazeMapper);
  // lazes.map((x, i) => lazeMapper(i))
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        {
          children: 'FIRE',
          onClick: () => {
            if (strikeMode === undefined) {
              return;
            }
            if (strikeMode === 'firemission') {
              act('firemission-execute', {
                tag: firemissionSelected,
                direction: strikeDirection
                  ? directionLookup[strikeDirection]
                  : 1,
                target_id: selectedTarget,
                offset_direction: dirMap(fmOffsetDir),
                offset_value: fmOffsetValue,
              });
            }
            if (strikeMode === 'weapon') {
              act('fire-weapon', { eqp_tag: weaponSelected });
            }
          },
        },
        {},
        {},
        {},
        {
          children: <Icon name="arrow-up" />,
          onClick: () => {
            if (targetOffset > 0) {
              setTargetOffset(targetOffset - 1);
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
          children: <Icon name="arrow-down" />,
          onClick: () => {
            if (targetOffset < lazes.length - 1) {
              setTargetOffset(targetOffset + 1);
            }
          },
        },
      ]}
      leftButtons={leftButtonGenerator()}
      rightButtons={targets}>
      <Box className="NavigationMenu">
        <Stack>
          <Stack.Item width="50px">
            <svg width="50px" height="500px">
              <defs>
                <marker
                  id="arrowhead"
                  markerWidth="10"
                  markerHeight="7"
                  refX="0"
                  refY="3.5"
                  fill="#00e94e"
                  orient="auto">
                  <polygon points="0 0, 10 3.5, 0 7" />
                </marker>
              </defs>
              <path
                stroke="#00e94e"
                stroke-width="1"
                fillOpacity="0"
                d="M 0 0 l 50 50 l 0 400 l -50 50"
              />
            </svg>
          </Stack.Item>
          <Stack.Item width="400px">
            <Stack vertical align="center">
              <Stack.Item height="50px">
                <svg width="500px" height="50px">
                  <path
                    stroke="#00e94e"
                    stroke-width="1"
                    fillOpacity="0"
                    d="M -1 0 l 50 50 l 395 0 l 50 -50"
                  />
                </svg>
              </Stack.Item>
              <Stack.Item>
                <h1>Target Aquisition</h1>
              </Stack.Item>
              <Stack.Item>
                <h3>Strike mode: {strikeMode?.toUpperCase() ?? 'NONE'}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>Strike configuration {strikeConfigLabel}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Target selected{' '}
                  {lazes.find((x) => x?.target_tag === selectedTarget)
                    ?.target_name ?? 'NONE'}
                </h3>
              </Stack.Item>
              <Stack.Item>
                <h3>Attack Vector {strikeDirection ?? 'NONE'}</h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Offset {fmOffsetDir}{' '}
                  <NumberInput
                    value={fmOffsetValue}
                    onChange={(e, value) => {
                      if (value < 0) {
                        setFmOffsetValue(0);
                        return;
                      }
                      if (value > 12) {
                        setFmOffsetValue(12);
                        return;
                      }
                      setFmOffsetValue(value);
                    }}
                    width="40px"
                  />
                </h3>
              </Stack.Item>
              <Stack.Item>
                <h3>
                  Guidance computer {strikeReady ? 'READY' : 'INCOMPLETE'}
                </h3>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <svg width="50px" height="500px">
              <path
                stroke="#00e94e"
                stroke-width="1"
                fillOpacity="0"
                d="M 40 0 l -50 50 l 0 400 l 50 50"
              />
            </svg>
          </Stack.Item>
        </Stack>
      </Box>
    </MfdPanel>
  );
};

const StrikeArrow = (props: { yoffset: number }, context) => {
  return (
    <line
      x1="35"
      y1={props.yoffset}
      x2="10"
      y2={props.yoffset}
      stroke="#00e94e"
      stroke-width="2"
      marker-end="url(#arrowhead)"
    />
  );
};

const LazeArrow = (props: { yoffset: number }, context) => {
  return (
    <line
      x1="10"
      y1={props.yoffset}
      x2="40"
      y2={props.yoffset}
      stroke="#00e94e"
      stroke-width="2"
      marker-end="url(#arrowhead)"
    />
  );
};

const DirArrow = (props: { xoffset: number }, context) => {
  return (
    <line
      x1={props.xoffset}
      y1="40"
      x2={props.xoffset}
      y2="10"
      stroke="#00e94e"
      stroke-width="2"
      marker-end="url(#arrowhead)"
    />
  );
};
