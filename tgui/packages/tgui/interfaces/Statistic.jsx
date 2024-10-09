import { Fragment, useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Collapsible,
  Flex,
  NoticeBox,
  Section,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const Statistic = () => {
  const { data } = useBackend();
  const [selectedTab, setSelectedTab] = useState('Round');

  const { data_tabs, round, medals } = data;

  return (
    <Window title="Statistic" width={1200} height={800} resizable>
      <Window.Content scrollable className="Statistic">
        <Flex direction="column" height="100%">
          <Flex.Item>
            <Tabs fluid textAlign="center" className="tabs-horizontal">
              {data_tabs.map((tab) => (
                <Tabs.Tab
                  key={tab}
                  selected={tab === selectedTab}
                  onClick={() => setSelectedTab(tab)}
                >
                  {tab}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Flex.Item>
          <Flex.Item grow={1}>
            <div className="tiles-container">
              <GetTab selectedTab={selectedTab} round={round} medals={medals} />
            </div>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const GetTab = ({ selectedTab, round, medals }) => {
  const { data } = useBackend();
  const { factions } = data;

  switch (selectedTab) {
    case 'Round':
      return round ? (
        <RoundTab round={round} />
      ) : (
        <NoticeBox danger>Round statistic preparing!</NoticeBox>
      );
    case 'Medals':
      return <MedalTab medals={medals} />;
    default:
      return factions[selectedTab] ? (
        <StatTab faction={factions[selectedTab]} />
      ) : null;
  }
};

const RoundTab = ({ round }) => (
  <>
    <SectionContainer title="Round Statistic">
      <div className="tiles-container">
        <Box className="tile">
          <div className="inner-statistics">
            <StatItem label="Name" value={round.name} />
            <StatItem label="Gamemode" value={round.game_mode} />
            <StatItem label="Map" value={round.map_name} />
            {round.round_result ? (
              <StatItem label="Result" value={round.round_result} />
            ) : null}
            {round.real_time_start ? (
              <StatItem label="Round Start" value={round.real_time_start} />
            ) : null}
            {round.real_time_end ? (
              <StatItem label="Round End" value={round.real_time_end} />
            ) : null}
            {round.round_length ? (
              <StatItem label="Round Length" value={round.round_length} />
            ) : null}
            {round.round_hijack_time ? (
              <StatItem label="Hijack Time" value={round.round_hijack_time} />
            ) : null}
            <StatItem
              label="Total Shots Fired"
              value={round.total_projectiles_fired}
            />
            <StatItem
              label="Total Shots Hit"
              value={round.total_projectiles_hit}
            />
            <StatItem
              label="Total Shots Hit (Human)"
              value={round.total_projectiles_hit_human}
            />
            <StatItem
              label="Total Shots Hit (Xeno)"
              value={round.total_projectiles_hit_xeno}
            />
            <StatItem label="Total Slashes" value={round.total_slashes} />
            <StatItem
              label="Total Shots Hit (FF)"
              value={round.total_friendly_fire_instances}
            />
            <StatItem
              label="Total FF Kills"
              value={round.total_friendly_kills}
            />
            <StatItem
              label="Total Huggers Applied"
              value={round.total_huggers_applied}
            />
            <StatItem
              label="Total Larva Burst"
              value={round.total_larva_burst}
            />
            {round.end_round_player_population ? (
              <StatItem
                label="Final Population"
                value={round.end_round_player_population}
              />
            ) : null}
          </div>
          {round.participants_list.map((entry, index) => (
            <Collapsible key={index} title={entry.name}>
              <div className="tiles-container">
                <div className="inner-statistics">
                  {entry.value.map((sub_entry, sub_index) => (
                    <StatItem
                      key={sub_index}
                      label={sub_entry.name}
                      value={sub_entry.value}
                    />
                  ))}
                </div>
              </div>
            </Collapsible>
          ))}
        </Box>
      </div>
    </SectionContainer>
    {round.death_list.length ? (
      <DeathsView
        death_log_data={round.death_list}
        total_deaths={round.total_deaths}
      />
    ) : (
      <NoticeBox danger>No recorded kills!</NoticeBox>
    )}
  </>
);

const MedalTab = ({ medals }) => (
  <SectionContainer title="Medals">
    <div className="tiles-container">
      <Box className="tile">
        {medals.map((entry, index) => (
          <Box className="inner-statistics" key={index}>
            <StatItem label="Round ID" value={entry.round_id} />
            <StatItem label="Medal Type" value={entry.medal_type} />
            <StatItem label="Recipient" value={entry.recipient} />
            <StatItem label="Recipient Job" value={entry.recipient_job} />
            <StatItem label="Citation" value={entry.citation} />
            <StatItem label="Giver" value={entry.giver} />
          </Box>
        ))}
      </Box>
    </div>
  </SectionContainer>
);

const StatTab = ({ faction }) => {
  const {
    total_statistics,
    top_statistics,
    nemesis,
    total_deaths,
    death_list,
    statistics_list_tabs,
    statistics_list,
  } = faction;

  return (
    <>
      {total_statistics.length ? (
        <SectionContainer title="Statistics">
          <div className="tiles-container">
            <Box className="tile">
              <div className="inner-statistics">
                {total_statistics.map((entry, stat_idx) => (
                  <StatItem
                    key={stat_idx}
                    label={entry.name}
                    value={entry.value}
                  />
                ))}
              </div>
            </Box>
          </div>
        </SectionContainer>
      ) : (
        <NoticeBox danger>No recorded statistic!</NoticeBox>
      )}
      {top_statistics.length ? (
        <SectionContainer title="Top Statistics">
          <div className="tiles-container">
            {top_statistics.map((entry, index) => (
              <Box className="tile" key={index}>
                <div className="inner-statistics">
                  <span className="tile-title">{entry.name}</span>
                  {entry.statistics.length
                    ? entry.statistics.map((stat, statIndex) => (
                        <StatItem
                          key={statIndex}
                          label={stat.name}
                          value={stat.value}
                        />
                      ))
                    : null}
                </div>
              </Box>
            ))}
          </div>
        </SectionContainer>
      ) : null}
      {nemesis.name ? (
        <SectionContainer title="Nemesis">
          <div className="tiles-container">
            <Box className="tile">
              <div className="inner-statistics">
                <StatItem label={nemesis.name} value={nemesis.value} />
              </div>
            </Box>
          </div>
        </SectionContainer>
      ) : (
        <NoticeBox danger>No recorded nemesis!</NoticeBox>
      )}
      {death_list.length ? (
        <DeathsView death_log_data={death_list} total_deaths={total_deaths} />
      ) : (
        <NoticeBox danger>No recorded deaths!</NoticeBox>
      )}
      {statistics_list.length ? (
        <SectionContainer title="Additional Statistics">
          <div className="tiles-container">
            {statistics_list.map((entry, index) => (
              <Collapsible key={index} title={entry.name}>
                {entry.value.length ? (
                  <div className="tiles-container">
                    {entry.value.map((sub_entry, sub_index) => (
                      <Box className="tile" key={sub_index}>
                        <span className="tile-title">{sub_entry.name}</span>
                        {sub_entry.statistics.length ? (
                          <div className="inner-statistics">
                            <span className="inner-title">Statistics</span>
                            {sub_entry.statistics.map((stat, stat_idx) => (
                              <StatItem
                                key={stat_idx}
                                label={stat.name}
                                value={stat.value}
                              />
                            ))}
                          </div>
                        ) : null}
                        {sub_entry.top_statistics.length ? (
                          <div className="inner-statistics">
                            <span className="inner-title">Top Statistics</span>
                            {sub_entry.top_statistics.map((stat, stat_idx) => (
                              <StatItem
                                key={stat_idx}
                                label={stat.name}
                                value={stat.value}
                              />
                            ))}
                          </div>
                        ) : null}
                      </Box>
                    ))}
                  </div>
                ) : null}
              </Collapsible>
            ))}
          </div>
        </SectionContainer>
      ) : null}
    </>
  );
};

const DeathsView = ({ death_log_data, total_deaths }) => (
  <SectionContainer title={`Total Deaths: ${total_deaths}`}>
    <div className="tiles-container">
      <Collapsible title={`Total Deaths: ${total_deaths}`}>
        <div className="tiles-container">
          {death_log_data.map((entry, index) => (
            <Collapsible
              key={index}
              title={`${entry.mob_name}  (${entry.time_of_death})`}
            >
              <Box className="tile">
                <div className="tiles-container">
                  <div className="inner-statistics">
                    <StatItem label="Mob" value={entry.mob_name} />
                    {entry.job_name ? (
                      <StatItem label="Job" value={entry.job_name} />
                    ) : null}
                    <StatItem label="Area" value={entry.area_name} />
                    <StatItem label="Cause" value={entry.cause_name} />
                    <StatItem label="Time" value={entry.time_of_death} />
                    <StatItem label="Lifespan" value={entry.total_time_alive} />
                    <StatItem
                      label="Damage taken"
                      value={entry.total_damage_taken}
                    />
                    <StatItem
                      label="Coords"
                      value={`${entry.x}, ${entry.y}, ${entry.z}`}
                    />
                  </div>
                </div>
              </Box>
            </Collapsible>
          ))}
        </div>
      </Collapsible>
    </div>
  </SectionContainer>
);

const StatItem = ({ label, value }) => (
  <Box className="stat-item">
    <span className="stat-label">{label}:</span> {value}
  </Box>
);

const SectionContainer = ({ title, children }) => (
  <Section title={title}>
    <div className="section-content">{children}</div>
  </Section>
);
