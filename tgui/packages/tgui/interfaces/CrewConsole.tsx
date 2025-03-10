import { sortBy } from 'common/collections';
import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Section, Table } from 'tgui/components';
import { COLORS } from 'tgui/constants';
import { Window } from 'tgui/layouts';

const HEALTH_COLOR_BY_LEVEL = [
  '#17d568',
  '#c4cf2d',
  '#e67e22',
  '#ed5100',
  '#e74c3c',
  '#ed2814',
];

const HEALTH_ICON_BY_LEVEL = [
  'heart',
  'heart',
  'heart',
  'heart',
  'heartbeat',
  'skull',
];

const jobIsHead = (jobId) => jobId % 10 === 0;

const jobToColor = (jobId) => {
  if (jobId >= 0 && jobId < 10) {
    return COLORS.shipDeps.highcom;
  }
  if (jobId >= 10 && jobId < 20) {
    return COLORS.department.captain;
  }
  if (jobId >= 20 && jobId < 30) {
    return COLORS.shipDeps.command;
  }
  if (jobId >= 30 && jobId < 40) {
    return COLORS.shipDeps.security;
  }
  if (jobId >= 40 && jobId < 50) {
    return COLORS.shipDeps.medsci;
  }
  if (jobId >= 50 && jobId < 60) {
    return COLORS.shipDeps.engineering;
  }
  if (jobId >= 60 && jobId < 70) {
    return COLORS.shipDeps.cargo;
  }
  if (jobId >= 70 && jobId < 80) {
    return COLORS.shipDeps.alpha;
  }
  if (jobId >= 80 && jobId < 90) {
    return COLORS.shipDeps.bravo;
  }
  if (jobId >= 90 && jobId < 100) {
    return COLORS.shipDeps.charlie;
  }
  if (jobId >= 100 && jobId < 110) {
    return COLORS.shipDeps.delta;
  }
  if (jobId >= 110 && jobId < 120) {
    return COLORS.shipDeps.echo;
  }
  if (jobId >= 120 && jobId < 130) {
    return COLORS.shipDeps.foxtrot;
  }
  if (jobId >= 130 && jobId < 140) {
    return COLORS.shipDeps.raiders;
  }
  if (jobId >= 200 && jobId < 230) {
    return COLORS.department.centcom;
  }
  return COLORS.department.other;
};

const healthToAttribute = (oxy, tox, burn, brute, attributeList) => {
  const healthSum = oxy + tox + burn + brute;
  const level = Math.min(Math.max(Math.ceil(healthSum / 25), 0), 5);
  return attributeList[level];
};

const HealthStat = (props) => {
  const { type, value } = props;
  return (
    <Box inline width={2} color={COLORS.damageType[type]} textAlign="center">
      {value}
    </Box>
  );
};

type SensorData = {
  ref: string;
  name: string;
  ijob: number;
  assignment?: string | null;
  life_status: BooleanLike;
  oxydam?: number;
  toxdam?: number;
  burndam?: number;
  brutedam?: number;
  side?: string;
  area?: string;
  can_track: BooleanLike;
};

type Data = { sensors: SensorData[]; link_allowed: number };

export const CrewConsole = () => {
  return (
    <Window title="Crew Monitor" width={600} height={600}>
      <Window.Content scrollable>
        <Section minHeight="540px">
          <CrewTable />
        </Section>
      </Window.Content>
    </Window>
  );
};

const CrewTable = (props) => {
  const { act, data } = useBackend<Data>();
  const sensors = sortBy(data.sensors ?? [], (s) => s.ijob);
  return (
    <Table>
      <Table.Row>
        <Table.Cell bold>Name</Table.Cell>
        <Table.Cell bold collapsing />
        <Table.Cell bold collapsing textAlign="center">
          Vitals
        </Table.Cell>
        <Table.Cell bold textAlign="center">
          Position
        </Table.Cell>
        {!!data.link_allowed && (
          <Table.Cell bold collapsing textAlign="center">
            Tracking
          </Table.Cell>
        )}
      </Table.Row>
      {sensors.map((sensor) => (
        <CrewTableEntry sensor_data={sensor} key={sensor.ref} />
      ))}
    </Table>
  );
};

const CrewTableEntry = (props: { readonly sensor_data: SensorData }) => {
  const { act, data } = useBackend<Data>();
  const { link_allowed } = data;
  const { sensor_data } = props;
  const {
    name,
    assignment,
    ijob,
    life_status,
    oxydam,
    toxdam,
    burndam,
    brutedam,
    area,
    can_track,
    side,
  } = sensor_data;

  return (
    <Table.Row>
      <Table.Cell bold={jobIsHead(ijob)} color={jobToColor(ijob)}>
        {name}
        {assignment !== undefined ? ` (${assignment})` : ''}
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        {oxydam !== undefined ? (
          <Icon
            name={healthToAttribute(
              oxydam,
              toxdam,
              burndam,
              brutedam,
              HEALTH_ICON_BY_LEVEL,
            )}
            color={healthToAttribute(
              oxydam,
              toxdam,
              burndam,
              brutedam,
              HEALTH_COLOR_BY_LEVEL,
            )}
            size={1}
          />
        ) : life_status ? (
          <Icon name="heart" color="#17d568" size={1} />
        ) : (
          <Icon name="skull" color="#801308" size={1} />
        )}
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        {oxydam !== undefined ? (
          <Box inline>
            <HealthStat type="oxy" value={oxydam} />
            {'/'}
            <HealthStat type="toxin" value={toxdam} />
            {'/'}
            <HealthStat type="burn" value={burndam} />
            {'/'}
            <HealthStat type="brute" value={brutedam} />
          </Box>
        ) : life_status ? (
          'Alive'
        ) : (
          'Dead'
        )}
      </Table.Cell>
      <Table.Cell
        color={
          side !== undefined
            ? COLORS.damageType['oxy']
            : COLORS.damageType['brute']
        }
      >
        {area !== undefined ? (
          area
        ) : (
          <Icon name="question" color="#ffffff" size={1} />
        )}
      </Table.Cell>
      {!!link_allowed && (
        <Table.Cell collapsing>
          <Button
            disabled={!can_track}
            onClick={() =>
              act('select_person', {
                name: name,
              })
            }
          >
            Track
          </Button>
        </Table.Cell>
      )}
    </Table.Row>
  );
};
