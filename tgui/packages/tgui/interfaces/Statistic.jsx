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
    <Window title="Statistic" width={800} height={1600} resizable>
      <Window.Content scrollable>
        <Flex direction="column" height="100%">
          <Flex.Item>
            <Tabs fluid textAlign="center">
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
            <Flex direction="column" height="100%">
              <Flex.Item>
                <GetTab
                  selectedTab={selectedTab}
                  round={round}
                  medals={medals}
                />
              </Flex.Item>
            </Flex>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const GetTab = (props) => {
  const { data } = useBackend();
  const { factions } = data;
  const { selectedTab, round, medals } = props;

  switch (selectedTab) {
    case 'Round':
      return <RoundTab round={round} />;
    case 'Medals':
      return <MedalTab medals={medals} />;
    default:
      if (!factions[selectedTab]) return;
      return <StatTab faction={factions[selectedTab]} />;
  }
};

const RoundTab = (props) => {
  const { round } = props;
  if (!round) return <NoticeBox danger>Round statistic prepairing!</NoticeBox>;
  return (
    <>
      <Section title="Round Statistic">
        <Box
          direction="column"
          style={{
            padding: '12px 10px',
            border: '0.5px solid #4a4a4a',
          }}
        >
          <Box>Name: {round.name}</Box>
          <Box>Gamemode: {round.game_mode}</Box>
          <Box>Map: {round.map_name}</Box>
          {round.round_result ? <Box>Result: {round.round_result}</Box> : null}
          {round.real_time_start ? (
            <Box>Round Start: {round.real_time_start}</Box>
          ) : null}
          {round.real_time_end ? (
            <Box>Round Time End: {round.real_time_end}</Box>
          ) : null}
          {round.round_length ? (
            <Box>Round Length: {round.round_length}</Box>
          ) : null}
          {round.round_hijack_time ? (
            <Box>Hijack Time: {round.round_hijack_time}</Box>
          ) : null}
          <Box>Total Shots Fired: {round.total_projectiles_fired}</Box>
          <Box>Total Shots Hit: {round.total_projectiles_hit}</Box>
          <Box>
            Total Shots Hit (Human): {round.total_projectiles_hit_human}
          </Box>
          <Box>Total Shots Hit (Xeno): {round.total_projectiles_hit_xeno}</Box>
          <Box>Total Slashes: {round.total_slashes}</Box>
          <Box>Total Shots Hit (FF): {round.total_friendly_fire_instances}</Box>
          <Box>Total FF Kills: {round.total_friendly_kills}</Box>
          <Box>Total Huggers Applied: {round.total_huggers_applied}</Box>
          <Box>Total Larva Burst: {round.total_larva_burst}</Box>
          {round.end_round_player_population ? (
            <Box>Final Population: {round.end_round_player_population}</Box>
          ) : null}
          {round.participants_list.map((entry, index) => (
            <Box
              key={index}
              style={{
                padding: '12px 10px',
                border: '0.5px solid #4a4a4a',
              }}
            >
              <Box>{entry.name}:</Box>
              {entry.value.map((entry, index) => (
                <Box key={index}>
                  {entry.name}: {entry.value}
                </Box>
              ))}
            </Box>
          ))}
        </Box>
      </Section>
      {round.death_list.length ? (
        <KillView
          death_log_data={round.death_list}
          total_deaths={round.total_deaths}
        />
      ) : (
        <NoticeBox danger>No recorded kills!</NoticeBox>
      )}
    </>
  );
};

const MedalTab = (props) => {
  const { medals } = props;

  return (
    <Section title="Medals">
      {medals.map((entry, index) => (
        <Fragment key={index}>
          <Box
            style={{
              padding: '12px 10px',
              border: '0.5px solid #4a4a4a',
            }}
          >
            <Box>Round ID: {entry.round_id}</Box>
            <Box>Medal Type: {entry.medal_type}</Box>
            <Box>Recipient: {entry.recipient}</Box>
            <Box>Recipient Job: {entry.recipient_job}</Box>
            <Box>Citation: {entry.citation}</Box>
            <Box>Giver: {entry.giver}</Box>
          </Box>
          <Box height="10px" />
        </Fragment>
      ))}
    </Section>
  );
};

const StatTab = (props) => {
  const { faction } = props;
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
    <Box>
      {total_statistics.length ? (
        <Section title="Statistics">
          <Box
            style={{
              padding: '12px 10px',
              border: '0.5px solid #4a4a4a',
            }}
          >
            {total_statistics.map((entry, index) => (
              <Box key={index}>
                {entry.name}: {entry.value}
              </Box>
            ))}
          </Box>
        </Section>
      ) : (
        <NoticeBox danger>No recorded statistic!</NoticeBox>
      )}
      <Box height="12px" />
      {top_statistics.length ? (
        <>
          <Section title="Top Statistics">
            {top_statistics.map((entry, index) => (
              <Fragment key={index}>
                <Box
                  style={{
                    padding: '12px 10px',
                    border: '0.5px solid #4a4a4a',
                  }}
                >
                  <span className="reallybig">{entry.name}</span>
                  {entry.statistics.length
                    ? entry.statistics.map((entry, index) => (
                        <Box key={index}>
                          {entry.name}: {entry.value}
                        </Box>
                      ))
                    : null}
                </Box>
                <Box height="12px" />
              </Fragment>
            ))}
          </Section>
          <Box height="12px" />
        </>
      ) : null}
      {nemesis.name ? (
        <Section title="Nemesis">
          <Box>
            <span className="reallybig">
              {nemesis.name}: {nemesis.value}
            </span>
          </Box>
        </Section>
      ) : (
        <NoticeBox danger>No recorded nemesis!</NoticeBox>
      )}
      <Box height="12px" />
      {death_list.length ? (
        <KillView death_log_data={death_list} total_deaths={total_deaths} />
      ) : (
        <NoticeBox danger>No recorded deaths!</NoticeBox>
      )}
      <Box height="12px" />
      {statistics_list.length ? (
        <Section title="Additional Statistics">
          {statistics_list.map((entry, index) => (
            <Collapsible key={index} title={entry.name}>
              {entry.value.length ? (
                <>
                  {entry.value.map((entry, index) => (
                    <Fragment key={index}>
                      <Box
                        direction="column"
                        style={{
                          padding: '12px 10px',
                          border: '0.5px solid #4a4a4a',
                        }}
                      >
                        <span className="reallybig">{entry.name}</span>
                        {entry.statistics.length ? (
                          <Box>
                            <Box height="8px" />
                            <span className="big">Statistics</span>
                            <Box height="4px" />
                            {entry.statistics.map((entry, index) => (
                              <Fragment key={index}>
                                <Box>
                                  {entry.name}: {entry.value}
                                </Box>
                              </Fragment>
                            ))}
                          </Box>
                        ) : null}
                        <Box height="8px" />
                        {entry.top_statistics.length ? (
                          <Box>
                            <Box height="8px" />
                            <span className="big">Top Statistics</span>
                            <Box height="4px" />
                            {entry.top_statistics.map((entry, index) => (
                              <Fragment key={index}>
                                <Box>
                                  {entry.name}: {entry.value}
                                </Box>
                              </Fragment>
                            ))}
                          </Box>
                        ) : null}
                      </Box>
                      <Box height="8px" />
                    </Fragment>
                  ))}
                  <Box height="8px" />
                </>
              ) : null}
            </Collapsible>
          ))}
        </Section>
      ) : null}
    </Box>
  );
};

const KillView = (props) => {
  const { death_log_data, total_deaths } = props;
  return (
    <Section>
      <Collapsible title={`Total Deaths: ${total_deaths}`}>
        {death_log_data.map((entry, index) => (
          <Box
            key={index}
            style={{
              padding: '12px 10px',
            }}
          >
            <Collapsible title={`${entry.mob_name}  (${entry.time_of_death})`}>
              <Box
                style={{
                  padding: '12px 10px',
                  border: '0.5px solid #4a4a4a',
                }}
              >
                <Box>Mob: {entry.mob_name}</Box>
                {entry.job_name ? (
                  <>
                    <Box height="4px" />
                    <Box>Job: {entry.job_name}</Box>
                  </>
                ) : null}
                <Box height="4px" />
                <Box>Area: {entry.area_name}</Box>
                <Box height="4px" />
                <Box>Cause: {entry.cause_name}</Box>
                <Box height="4px" />
                <Box>Time: {entry.time_of_death}</Box>
                <Box height="4px" />
                <Box>Lifespan: {entry.total_time_alive}</Box>
                <Box height="4px" />
                <Box>Damage taken: {entry.total_damage_taken}</Box>
                <Box height="4px" />
                <Box>
                  Coords: {entry.x}, {entry.y}, {entry.z}
                </Box>
              </Box>
            </Collapsible>
          </Box>
        ))}
      </Collapsible>
    </Section>
  );
};
