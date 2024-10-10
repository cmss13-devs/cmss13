import { useState } from 'react';

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
    <Window
      title="Statistic"
      width={1200}
      height={800}
      resizable
      minWidth={200}
      minHeight={400}
      theme={'crtblue'}
    >
      <Window.Content scrollable className="StatisticMenu">
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
          <Box className="TilesInititalizator">
            <GetTab selectedTab={selectedTab} round={round} medals={medals} />
          </Box>
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
        <NoticeBox danger className="TilesMediumItem">
          Round statistic preparing!
        </NoticeBox>
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
    <Section title="Round Statistic" className="TilesMediumItem">
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
      <StatItem label="Total Shots Hit" value={round.total_projectiles_hit} />
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
      <StatItem label="Total FF Kills" value={round.total_friendly_kills} />
      <StatItem
        label="Total Huggers Applied"
        value={round.total_huggers_applied}
      />
      <StatItem label="Total Larva Burst" value={round.total_larva_burst} />
      {round.end_round_player_population ? (
        <StatItem
          label="Final Population"
          value={round.end_round_player_population}
        />
      ) : null}
      {round.participants_list.map((entry, index) => (
        <Collapsible title={entry.name} key={index}>
          {entry.value.map((sub_entry, sub_index) => (
            <StatItem
              key={sub_index}
              label={sub_entry.name}
              value={sub_entry.value}
            />
          ))}
        </Collapsible>
      ))}
    </Section>
    {round.death_list.length ? (
      <DeathsView
        death_log_data={round.death_list}
        total_deaths={round.total_deaths}
      />
    ) : (
      <NoticeBox danger className="TilesMediumItem">
        No recorded kills!
      </NoticeBox>
    )}
  </>
);

const MedalTab = ({ medals }) =>
  medals.map((entry, index) => (
    <Section
      key={index}
      title={`${entry.medal_type} for ${entry.citation}`}
      className="TilesMediumItem"
    >
      <StatItem label="Round ID" value={entry.round_id} />
      <StatItem label="Recipient" value={entry.recipient} />
      <StatItem label="Recipient Job" value={entry.recipient_job} />
      <StatItem label="Giver" value={entry.giver} />
    </Section>
  ));

const StatTab = ({ faction }) => {
  const {
    total_statistics,
    top_statistics,
    nemesis,
    total_deaths,
    death_list,
    statistics_list,
  } = faction;

  return (
    <>
      {total_statistics.length ? (
        <Section title="Overall" className="TilesMediumItem">
          {total_statistics.map((entry, stat_idx) => (
            <StatItem key={stat_idx} label={entry.name} value={entry.value} />
          ))}
        </Section>
      ) : (
        <NoticeBox danger className="TilesMediumItem">
          No recorded statistic!
        </NoticeBox>
      )}

      {top_statistics.length
        ? top_statistics.map((entry, index) => (
            <Section
              key={index}
              title={`TOP ${entry.name}`}
              className="TilesMediumItem"
            >
              {entry.statistics.length
                ? entry.statistics.map((stat, statIndex) => (
                    <StatItem
                      key={statIndex}
                      label={stat.name}
                      value={stat.value}
                    />
                  ))
                : null}
            </Section>
          ))
        : null}

      {nemesis.name ? (
        <Section title="Nemesis" className="TilesMediumItem">
          <StatItem label={nemesis.name} value={nemesis.value} />
        </Section>
      ) : (
        <NoticeBox danger className="TilesMediumItem">
          No recorded nemesis!
        </NoticeBox>
      )}

      {death_list.length ? (
        <DeathsView death_log_data={death_list} total_deaths={total_deaths} />
      ) : (
        <NoticeBox danger className="TilesMediumItem">
          No recorded deaths!
        </NoticeBox>
      )}

      {statistics_list.length
        ? statistics_list.map((entry, index) =>
            entry.value.length
              ? entry.value.map((sub_entry, sub_index) => (
                  <Section
                    key={sub_index}
                    title={sub_entry.name}
                    className="TilesMediumItem"
                  >
                    {sub_entry.statistics.length ? (
                      <>
                        <span className="TilesTitleItem">Statistics</span>
                        {sub_entry.statistics.map((stat, stat_idx) => (
                          <StatItem
                            key={stat_idx}
                            label={stat.name}
                            value={stat.value}
                          />
                        ))}
                      </>
                    ) : null}
                    {sub_entry.top_statistics.length ? (
                      <>
                        <span className="TilesTitleItem">Top Statistics</span>
                        {sub_entry.top_statistics.map((stat, stat_idx) => (
                          <StatItem
                            key={stat_idx}
                            label={stat.name}
                            value={stat.value}
                          />
                        ))}
                      </>
                    ) : null}
                  </Section>
                ))
              : null,
          )
        : null}
    </>
  );
};

const DeathsView = ({ death_log_data, total_deaths }) => (
  <Section title={`Total Deaths: ${total_deaths}`} className="TilesBigItem">
    <Box className="TilesInititalizator">
      {death_log_data.map((entry, index) => (
        <Section
          key={index}
          title={`${entry.mob_name}  (${entry.time_of_death})`}
          className="TilesSmallItem"
        >
          <StatItem label="Mob" value={entry.mob_name} />
          {entry.job_name && <StatItem label="Job" value={entry.job_name} />}
          <StatItem label="Area" value={entry.area_name} />
          <StatItem label="Cause" value={entry.cause_name} />
          <StatItem label="Time" value={entry.time_of_death} />
          <StatItem label="Lifespan" value={entry.total_time_alive} />
          <StatItem label="Damage taken" value={entry.total_damage_taken} />
          <StatItem
            label="Coords"
            value={`${entry.x}, ${entry.y}, ${entry.z}`}
          />
        </Section>
      ))}
    </Box>
  </Section>
);

const StatItem = ({ label, value }) => (
  <Box className="TilesStatItem">
    <span className="TilesStatLabel">{label}:</span> {value}
  </Box>
);
