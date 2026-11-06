import { type BooleanLike, classes } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Box, LabeledList, ProgressBar, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

import { blastPower } from './DropshipAmmoStats/blast';
import { fireTiles } from './DropshipAmmoStats/fire';

const higherIsBetter: Record<string, [number, number]> = {
  bad: [-Infinity, 0.25],
  average: [0.25, 0.5],
  good: [0.5, Infinity],
};

const lowerIsBetter: Record<string, [number, number]> = {
  good: [-Infinity, 0.25],
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

const StatBar = (props: {
  readonly value: number;
  readonly max: number;
  readonly text: string;
  readonly lowerBetter?: boolean;
  readonly neutral?: boolean;
  readonly unavailable?: boolean;
}) => (
  <ProgressBar
    value={props.unavailable ? 0 : Math.min(props.value / props.max, 1)}
    color={props.unavailable ? 'grey' : props.neutral ? 'blue' : undefined}
    ranges={
      props.unavailable || props.neutral
        ? undefined
        : props.lowerBetter
          ? lowerIsBetter
          : higherIsBetter
    }
  >
    {props.text}
  </ProgressBar>
);

type Data = {
  name: string;
  desc: string;
  icon: string | null;
  explosion_damage: number;
  explosion_falloff: number;
  exponential: BooleanLike;
  travel_time: number;
  fire_mission_delay: number;
  accuracy: number;
  max_inaccuracy: number;
  sentry: BooleanLike;
  incendiary_range: number;
  incendiary_damage: number;
  incendiary_ignite: number;
  incendiary_duration: number;
  incendiary_contact_damage: number;
  spread_range: number;
  spread_count: number;
  impact_damage: number;
  impact_blast: number;
  penetration: number;
  impact_kind: string;
  random_fire: BooleanLike;
  additional_effects: string;
};

export const DropshipAmmoStats = () => {
  const { data } = useBackend<Data>();
  const {
    name,
    desc,
    icon,
    explosion_damage: damage,
    explosion_falloff: falloff,
    exponential,
    travel_time,
    fire_mission_delay,
    accuracy,
    max_inaccuracy,
    sentry,
    incendiary_range,
    incendiary_damage,
    incendiary_ignite,
    incendiary_duration,
    incendiary_contact_damage,
    spread_range,
    spread_count,
    impact_damage,
    impact_blast,
    penetration,
    impact_kind,
    random_fire,
    additional_effects,
  } = data;
  let radius = 1;
  while (
    radius < 30 &&
    blastPower(radius, 0, damage, falloff, !!exponential) > 0
  ) {
    radius++;
  }
  radius = Math.max(radius, spread_range + 1, incendiary_range + 1);
  const flames = fireTiles(random_fire ? 0 : incendiary_range);
  const size = radius * 2 + 1;
  return (
    <Window width={650} height={780}>
      <Window.Content scrollable>
        <Section>
          <Box textAlign="center" bold mb={1}>
            {name}
          </Box>
          {icon && (
            <Box textAlign="center" mb={1}>
              <span
                className={classes(['Icon', 'dropshipammolineart128x96', icon])}
              />
            </Box>
          )}
          <Box textAlign="center">{desc}</Box>
        </Section>
        <Section title="Ammo Info">
          <LabeledList>
            {(damage > 0 || impact_damage > 0 || penetration > 0) && (
              <tr>
                <th
                  className="LabeledList__cell"
                  colSpan={2}
                  style={{
                    textAlign: 'left',
                    paddingBottom: '8px',
                    color: 'white',
                  }}
                >
                  <b>Explosive</b>
                </th>
              </tr>
            )}
            {damage > 0 && (
              <>
                <LabeledList.Item labelColor="white" label="Explosion Damage">
                  <StatBar
                    value={damage}
                    max={450}
                    unavailable={!damage}
                    text={
                      damage ? `${damage} blast power` : 'No explosive blast'
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item labelColor="white" label="Explosion Fall Off">
                  <StatBar
                    value={falloff}
                    max={100}
                    lowerBetter
                    unavailable={!damage}
                    text={
                      damage
                        ? `${falloff} — ${exponential ? 'Exponential' : 'Linear'}`
                        : 'Not applicable'
                    }
                  />
                </LabeledList.Item>
              </>
            )}
            {impact_damage > 0 ? (
              <LabeledList.Item labelColor="white" label="Impact Damage">
                <StatBar
                  value={impact_damage}
                  max={225}
                  unavailable={!impact_damage}
                  text={
                    impact_damage
                      ? `${impact_damage} damage`
                      : 'No separate direct impact damage'
                  }
                />
                {!!impact_damage && <Box color="label">{impact_kind}</Box>}
                {impact_blast > 0 && (
                  <Box color="label">{impact_blast} localized blast power</Box>
                )}
              </LabeledList.Item>
            ) : null}
            {penetration > 0 && (
              <LabeledList.Item labelColor="white" label="Armor Penetration">
                <StatBar
                  value={penetration}
                  max={40}
                  text={`${penetration} / 40`}
                />
              </LabeledList.Item>
            )}
            {(damage > 0 || impact_damage > 0 || penetration > 0) &&
              (incendiary_ignite > 0 || incendiary_damage > 0) && (
                <LabeledList.Divider size={2} />
              )}
            {(incendiary_ignite > 0 || incendiary_damage > 0) && (
              <tr>
                <th
                  className="LabeledList__cell"
                  colSpan={2}
                  style={{
                    textAlign: 'left',
                    paddingBottom: '8px',
                    color: 'white',
                  }}
                >
                  <b>Incendiary</b>
                </th>
              </tr>
            )}
            {impact_damage <= 0 && incendiary_ignite > 0 && (
              <LabeledList.Item labelColor="white" label="Incendiary Ignite">
                <StatBar
                  value={incendiary_ignite}
                  max={225}
                  text={incendiary_ignite + ' burn on ignition'}
                />
              </LabeledList.Item>
            )}
            {incendiary_damage > 0 && (
              <>
                <LabeledList.Item labelColor="white" label="Incendiary Damage">
                  <StatBar
                    value={incendiary_damage}
                    max={75}
                    text={`${incendiary_damage} burn over time`}
                  />
                </LabeledList.Item>
                <LabeledList.Item
                  labelColor="white"
                  label="Incendiary Contact Damage"
                >
                  <StatBar
                    value={incendiary_contact_damage}
                    max={37}
                    text={`${incendiary_contact_damage} burn on contact`}
                  />
                </LabeledList.Item>
                <LabeledList.Item labelColor="white" label="Incendiary Range">
                  <StatBar
                    value={incendiary_range}
                    max={6}
                    neutral
                    text={`${incendiary_range} tiles`}
                  />
                  <Box color="label" />
                </LabeledList.Item>
                <LabeledList.Item
                  labelColor="white"
                  label="Incendiary Duration"
                >
                  <StatBar
                    value={incendiary_duration}
                    max={60}
                    neutral
                    text={incendiary_duration + ' seconds'}
                  />
                </LabeledList.Item>
              </>
            )}
            {(damage > 0 ||
              impact_damage > 0 ||
              penetration > 0 ||
              incendiary_ignite > 0 ||
              incendiary_damage > 0) && <LabeledList.Divider size={2} />}
            <tr>
              <th
                className="LabeledList__cell"
                colSpan={2}
                style={{
                  textAlign: 'left',
                  paddingBottom: '8px',
                  color: 'white',
                }}
              >
                <b>Performance</b>
              </th>
            </tr>
            {spread_count > 0 && (
              <>
                <LabeledList.Item labelColor="white" label="Spread">
                  <StatBar
                    value={spread_range}
                    max={3}
                    neutral
                    text={`${spread_range} tile radius (${spread_range * 2 + 1} × ${spread_range * 2 + 1})`}
                  />
                </LabeledList.Item>
                <LabeledList.Item labelColor="white" label="Coverage">
                  <StatBar
                    value={spread_count}
                    max={40}
                    neutral
                    text={`${spread_count} tiles impacted per firing`}
                  />
                </LabeledList.Item>
              </>
            )}
            {additional_effects && (
              <LabeledList.Item labelColor="white" label="Additional Effects">
                {additional_effects}
              </LabeledList.Item>
            )}
            <LabeledList.Item labelColor="white" label="Suborbital Travel Time">
              <StatBar
                value={sentry ? 5 : travel_time}
                max={10}
                lowerBetter
                text={`${sentry ? 5 : travel_time} seconds`}
              />
            </LabeledList.Item>
            {fire_mission_delay > 0 && (
              <LabeledList.Item labelColor="white" label="Fire Mission Delay">
                <StatBar
                  value={fire_mission_delay}
                  max={4}
                  lowerBetter
                  unavailable={!fire_mission_delay}
                  text={
                    fire_mission_delay
                      ? `${fire_mission_delay} steps between shots`
                      : 'Cannot be used in fire missions'
                  }
                />
              </LabeledList.Item>
            )}
            <LabeledList.Item labelColor="white" label="Guided Accuracy">
              <StatBar
                value={accuracy}
                max={6}
                lowerBetter
                text={`${accuracy} tiles from signal`}
              />
            </LabeledList.Item>
            <LabeledList.Item labelColor="white" label="Unguided Accuracy">
              <Box mt={0.5}>
                <StatBar
                  value={max_inaccuracy}
                  max={6}
                  lowerBetter
                  text={`${max_inaccuracy} tiles from signal's last location`}
                />
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(damage > 0 || spread_count > 0 || incendiary_range > 0) && (
          <Section title={damage > 0 ? 'Explosion area' : 'Spread area'}>
            {damage > 0 || spread_count > 0 || incendiary_range > 0 ? (
              <svg
                width="100%"
                height="390"
                viewBox={`0 0 ${size * 20} ${size * 20}`}
                role="img"
                aria-label="Blast, spread, and incendiary coverage by tile"
              >
                {Array.from({ length: size * size }, (_, index) => {
                  const x = (index % size) - radius;
                  const y = Math.floor(index / size) - radius;
                  const power = blastPower(
                    x,
                    y,
                    damage,
                    falloff,
                    !!exponential,
                  );
                  const inSpread =
                    spread_count > 0 &&
                    Math.max(Math.abs(x), Math.abs(y)) <= spread_range;
                  const inFire = random_fire
                    ? inSpread
                    : flames.has(`${x},${y}`);
                  return (
                    <g key={index}>
                      <rect
                        x={(x + radius) * 20}
                        y={(y + radius) * 20}
                        width={19}
                        height={19}
                        fill={
                          power > 0
                            ? `hsl(${(power / damage) * 55}, 90%, ${20 + (power / damage) * 40}%)`
                            : inSpread
                              ? '#287bb5'
                              : '#242424'
                        }
                      >
                        <title>{`Offset (${x}, ${y}): ${Math.round(power * 10) / 10} blast power${inSpread ? '; possible impact' : ''}${inFire ? '; incendiary coverage' : ''}`}</title>
                      </rect>
                      {inFire && (
                        <rect
                          x={(x + radius) * 20 + 4}
                          y={(y + radius) * 20 + 4}
                          width={11}
                          height={11}
                          fill="#ed64d5"
                          fillOpacity={0.65}
                          pointerEvents="none"
                        />
                      )}
                    </g>
                  );
                })}
                <text
                  x={radius * 20 + 9.5}
                  y={radius * 20 + 15}
                  textAnchor="middle"
                  fill="black"
                  fontSize={17}
                >
                  +
                </text>
              </svg>
            ) : (
              <Box>This ammunition has no explosive blast.</Box>
            )}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
