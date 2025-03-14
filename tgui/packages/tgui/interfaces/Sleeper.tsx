import { round } from 'common/math';
import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

const stats = [
  ['good', 'Alive'],
  ['average', 'Critical'],
  ['bad', 'DEAD'],
];

const damages = [
  ['Brute', 'bruteLoss'],
  ['Burn', 'fireLoss'],
  ['Toxin', 'toxLoss'],
  ['Oxygen', 'oxyLoss'],
];

const damageRange: Record<string, [number, number]> = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

const tempColors = [
  'bad',
  'average',
  'average',
  'good',
  'average',
  'average',
  'bad',
];

type HumanData = {
  pulse: number;
  bloodLevel: number;
  bloodMax: number;
  bloodPercent: number;
};

type OccupantData = {
  name: string;
  stat: number;
  health: number;
  maxHealth: number;
  minHealth: number;
  bruteLoss: number;
  oxyLoss: number;
  toxLoss: number;
  fireLoss: number;
  paralysis: number;
  hasBlood: BooleanLike;
  bodyTemperature: number;
  maxTemp: number;
  temperatureSuitability: number;
  btCelsius: number;
  btFaren: number;
  totalreagents: number;
  reagentswhenstarted: number;
} & Partial<HumanData>;

type ChemicalData = {
  title: string;
  id: string;
  commands: { chemical: string };
  occ_amount: number;
  pretty_amount: number;
  injectable: BooleanLike;
  overdosing: BooleanLike;
  od_warning: BooleanLike;
};

type Data = {
  connected: string | null;
  connected_operable: BooleanLike;
  amounts: number[];
  hasOccupant: BooleanLike;
  occupant: OccupantData;
  maxchem: number;
  minhealth: number;
  dialysis: BooleanLike;
  auto_eject_dead: BooleanLike;
  chemicals: ChemicalData[];
};

export const Sleeper = (props) => {
  const { act, data } = useBackend<Data>();
  const { hasOccupant } = data;
  const body = hasOccupant ? <SleeperMain /> : <SleeperEmpty />;
  const windowHeight = hasOccupant ? 850 : 150;
  return (
    <Window width={500} height={windowHeight}>
      <Window.Content className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};

const SleeperMain = (props) => {
  return (
    <>
      <SleeperDialysis />
      <SleeperOccupant />
      <SleeperDamage />
      <SleeperChemicals />
    </>
  );
};

const SleeperOccupant = (props) => {
  const { act, data } = useBackend<Data>();
  const { occupant, auto_eject_dead } = data;
  return (
    <Section
      title="Occupant"
      buttons={
        <>
          <Box color="label" inline>
            Auto-eject if dead:&nbsp;
          </Box>
          <Button
            icon={auto_eject_dead ? 'toggle-on' : 'toggle-off'}
            selected={auto_eject_dead}
            onClick={() =>
              act('auto_eject_dead_' + (auto_eject_dead ? 'off' : 'on'))
            }
          >
            {auto_eject_dead ? 'On' : 'Off'}
          </Button>
          <Button icon="user-slash" onClick={() => act('ejectify')}>
            Eject
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
        <LabeledList.Item label="Health">
          <ProgressBar
            value={occupant.health / occupant.maxHealth}
            ranges={{
              good: [0.5, Infinity],
              average: [0, 0.5],
              bad: [-Infinity, 0],
            }}
          >
            {round(occupant.health, 0)}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Status" color={stats[occupant.stat][0]}>
          {stats[occupant.stat][1]}
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <ProgressBar
            value={occupant.bodyTemperature / occupant.maxTemp}
            color={tempColors[occupant.temperatureSuitability + 3]}
          >
            {round(occupant.btCelsius, 0)}&deg;C,
            {round(occupant.btFaren, 0)}&deg;F
          </ProgressBar>
        </LabeledList.Item>
        {!!occupant.hasBlood && (
          <>
            <LabeledList.Item label="Blood Level">
              <ProgressBar
                value={occupant.bloodLevel! / occupant.bloodMax!}
                ranges={{
                  bad: [-Infinity, 0.6],
                  average: [0.6, 0.9],
                  good: [0.6, Infinity],
                }}
              >
                {occupant.bloodPercent}%, {occupant.bloodLevel}cl
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Pulse" verticalAlign="middle">
              {occupant.pulse} BPM
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};

const SleeperDamage = (props) => {
  const { data } = useBackend<Data>();
  const { occupant } = data;
  return (
    <Section title="Occupant Damage">
      <LabeledList>
        {damages.map((d, i) => (
          <LabeledList.Item key={i} label={d[0]}>
            <ProgressBar
              key={i}
              value={occupant[d[1]] / 100}
              ranges={damageRange}
            >
              {round(occupant[d[1]], 0)}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const SleeperDialysis = (props) => {
  const { act, data } = useBackend<Data>();
  const { hasOccupant, dialysis, occupant } = data;
  const canDialysis = dialysis;
  const dialysisDisabled = !hasOccupant || !occupant.totalreagents;
  return (
    <Section
      title="Dialysis"
      buttons={
        <Button
          disabled={dialysisDisabled}
          selected={canDialysis}
          icon={canDialysis ? 'toggle-on' : 'toggle-off'}
          onClick={() => act('togglefilter')}
        >
          {canDialysis ? 'Active' : 'Inactive'}
        </Button>
      }
    >
      {!occupant.totalreagents && (
        <NoticeBox danger>Occupant has no chemicals to remove!</NoticeBox>
      )}
      {(canDialysis && (
        <ProgressBar
          value={occupant.totalreagents / occupant.reagentswhenstarted}
          title="Reagents left/Reagents when dialysis was started"
        >
          {occupant.totalreagents}/{occupant.reagentswhenstarted}
        </ProgressBar>
      )) ||
        (!dialysisDisabled && <NoticeBox info>Dialysis inactive!</NoticeBox>)}
    </Section>
  );
};

const SleeperChemicals = (props) => {
  const { act, data } = useBackend<Data>();
  const { occupant, chemicals, maxchem, amounts } = data;
  return (
    <Section title="Occupant Chemicals">
      {chemicals.map((chem, i) => {
        let barColor = '';
        let odWarning;
        if (chem.overdosing) {
          barColor = 'bad';
          odWarning = (
            <Box color="bad">
              <Icon name="exclamation-circle" />
              &nbsp; Overdosing!
            </Box>
          );
        } else if (chem.od_warning) {
          barColor = 'average';
          odWarning = (
            <Box color="average">
              <Icon name="exclamation-triangle" />
              &nbsp; Close to overdosing
            </Box>
          );
        }
        return (
          <Box key={i} backgroundColor="rgba(0, 0, 0, 0.33)" mb="0.5rem">
            <Section
              title={chem.title}
              mx="0"
              lineHeight="18px"
              buttons={odWarning}
            >
              <Flex align="flex-start">
                <ProgressBar
                  value={chem.occ_amount / maxchem}
                  color={barColor}
                  title="Amount of chemicals currently inside the occupant / Total amount injectable by this machine"
                  mr="0.5rem"
                >
                  {chem.pretty_amount}/{maxchem}u
                </ProgressBar>
                {amounts.map((a, i) => (
                  <Button
                    key={i}
                    disabled={
                      !chem.injectable ||
                      chem.occ_amount + a > maxchem ||
                      occupant.stat === 2
                    }
                    icon="syringe"
                    tooltip={
                      'Inject ' +
                      a +
                      'u of ' +
                      chem.title +
                      ' into the occupant'
                    }
                    mb="0"
                    height="19px"
                    onClick={() =>
                      act('chemical', {
                        chemid: chem.id,
                        amount: a,
                      })
                    }
                  >
                    {'Inject ' + a + 'u'}
                  </Button>
                ))}
              </Flex>
            </Section>
          </Box>
        );
      })}
    </Section>
  );
};

const SleeperEmpty = (props) => {
  return (
    <Section textAlign="center">
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No occupant detected.
        </Flex.Item>
      </Flex>
    </Section>
  );
};
