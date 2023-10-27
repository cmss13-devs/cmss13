import { range } from 'common/collections';
import { useBackend, useSharedState } from '../../backend';
import { Box, Stack } from '../../components';
import { DropshipEquipment } from '../DropshipWeaponsConsole';
import { MfdProps, MfdPanel, usePanelState } from './MultifunctionDisplay';
import { CasFiremission, LazeTarget } from './types';

interface EquipmentContext {
  equipment_data: Array<DropshipEquipment>;
  targets_data: Array<LazeTarget>;
}

interface FiremissionContext {
  firemission_data: Array<CasFiremission>;
}

export const TargetAquisitionMfdPanel = (props: MfdProps, context) => {
  const [_, setPanelState] = usePanelState(props.panelStateId, context);
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

  const { act, data } = useBackend<EquipmentContext & FiremissionContext>(
    context
  );

  const lazes = range(0, 5).map((x) =>
    x > data.targets_data.length ? undefined : data.targets_data[x]
  );
  const lazeMapper = (index: number) => {
    const target = lazes.length > index ? lazes[index] : undefined;
    return {
      children: target?.target_name.split(' ')[0],
      onClick: target
        ? () => {
          act('set-camera', { 'equipment_id': target.target_tag });
          setSelectedTarget(target.target_tag);
        }
        : undefined,
    };
  };

  const weapons = data.equipment_data.filter((x) => x.is_weapon);

  const leftButtonGenerator = () => {
    if (strikeMode === 'weapon' && weaponSelected === undefined) {
      return weapons.map((x) => {
        return {
          children: x.shorthand,
          onClick: () => setWeaponSelected(x.mount_point),
        };
      });
    }
    if (strikeMode === 'firemission' && firemissionSelected === undefined) {
      return data.firemission_data.map((x) => {
        return {
          children: x.name,
          onClick: () => setFiremissionSelected(x.mission_tag),
        };
      });
    }
    return [
      {},
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
  };

  const strikeConfigLabel =
    weaponSelected !== undefined
      ? data.equipment_data.find((x) => x.mount_point === weaponSelected)?.name
      : firemissionSelected !== undefined
        ? data.firemission_data.find(
          (x) => x.mission_tag === firemissionSelected
        )?.name
        : 'NONE';

  const lazeIndex = lazes.findIndex((x) => x?.target_tag === selectedTarget);
  const strikeReady = strikeMode !== undefined && lazeIndex !== -1;
  return (
    <MfdPanel
      panelStateId={props.panelStateId}
      topButtons={[
        {
          children: 'FIRE',
        },
        { children: 'N-S', onClick: () => setStrikeDirection('N-S') },
        { children: 'S-N', onClick: () => setStrikeDirection('S-N') },
        { children: 'W-E', onClick: () => setStrikeDirection('W-E') },
        { children: 'E-W', onClick: () => setStrikeDirection('E-W') },
      ]}
      bottomButtons={[
        {
          children: 'EXIT',
          onClick: () => setPanelState(''),
        },
        {},
      ]}
      leftButtons={leftButtonGenerator()}
      rightButtons={lazes.map((x, i) => lazeMapper(i))}>
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
              {lazeIndex === -1 && (
                <text stroke="#00e94e" text-anchor="middle" x={0} y={0}>
                  SELECT TARGET
                </text>
              )}
              {strikeMode === 'weapon' && <StrikeArrow yoffset={130} />}
              {strikeMode === 'firemission' && <StrikeArrow yoffset={230} />}
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
                  {strikeReady && <DirArrow xoffset={40} />}
                  {strikeReady && <DirArrow xoffset={60} />}
                  {strikeDirection === 'N-S' && <DirArrow xoffset={150} />}
                  {strikeDirection === 'S-N' && <DirArrow xoffset={250} />}
                  {strikeDirection === 'W-E' && <DirArrow xoffset={350} />}
                  {strikeDirection === 'E-W' && <DirArrow xoffset={450} />}
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
                  Guidance computer {strikeReady ? 'READY' : 'INCOMPLETE'}
                </h3>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
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
                d="M 40 0 l -50 50 l 0 400 l 50 50"
              />
              {lazeIndex === -1 && (
                <text stroke="#00e94e" text-anchor="middle" x={0} y={0}>
                  SELECT TARGET
                </text>
              )}
              {lazeIndex === 0 && <LazeArrow yoffset={30} />}
              {lazeIndex === 1 && <LazeArrow yoffset={30} />}
              {lazeIndex === 2 && <LazeArrow yoffset={30} />}
              {lazeIndex === 3 && <LazeArrow yoffset={30} />}
              {lazeIndex === 4 && <LazeArrow yoffset={30} />}
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
