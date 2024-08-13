import { Fragment } from 'react';

import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Collapsible,
  Flex,
  NoticeBox,
  Section,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const Statistic = (props, context) => {
  const { act, data } = useBackend(context);
  const [selectedTab, setSelectedTab] = useLocalState(
    context,
    'selectedTab',
    0,
  );

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
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const GetTab = (props, context) => {
  const { act, data } = useBackend(context);
  const { factions } = data;
  const { selectedTab, round, medals } = props;

  switch (selectedTab) {
    case 'Round':
      return (
        <Box>
          {round ? (
            <Section title="Round Statistic">
              <Box
                direction="column"
                style={{
                  padding: '12px 10px 12px 10px',
                  border: '0.5px solid #4a4a4a',
                }}
              >
                <Box>Name: {round.name}</Box>
                <Box>Gamemode: {round.game_mode}</Box>
                <Box>Map: {round.map_name}</Box>
                <Box>Result: {round.round_result}</Box>
                <Box>Round Start: {round.real_time_start}</Box>
                <Box>Round Time End: {round.real_time_end}</Box>
                <Box>Round Length: {round.round_length}</Box>
                {round.round_hijack_time ? (
                  <Box>Hijack Time: {round.round_hijack_time}</Box>
                ) : null}
                <Box>Total Shots Fired: {round.total_projectiles_fired}</Box>
                <Box>Total Shots Hit: {round.total_projectiles_hit}</Box>
                <Box>
                  Total Shots Hit (Human): {round.total_projectiles_hit_human}
                </Box>
                <Box>
                  Total Shots Hit (Xeno): {round.total_projectiles_hit_xeno}
                </Box>
                <Box>Total Slashes: {round.total_slashes}</Box>
                <Box>
                  Total Shots Hit (FF): {round.total_friendly_fire_instances}
                </Box>
                <Box>Total FF Kills: {round.total_friendly_kills}</Box>
                <Box>Total Huggers Applied: {round.total_huggers_applied}</Box>
                <Box>Total Larva Burst: {round.total_larva_burst}</Box>
                {round.end_round_player_population ? (
                  <Box>
                    Final Population: {round.end_round_player_population}
                  </Box>
                ) : null}
                <Box>Total Deaths: {round.total_deaths}</Box>
                {round.Participants ? (
                  <>
                    <Box height="6px" />
                    <Box>
                      Participants:
                      {round.Participants.map((entry, index) => (
                        <Fragment key={index}>
                          <Box
                            style={{
                              padding: '6px 5px 6px 5px',
                              border: '0.5px solid #4a4a4a',
                            }}
                          >
                            <Box>
                              {entry.name}: {entry.value}
                            </Box>
                          </Box>
                          <Box height="6px" />
                        </Fragment>
                      ))}
                    </Box>
                  </>
                ) : null}
                {round.hijack_participants ? (
                  <>
                    <Box height="6px" />
                    <Box>
                      Hijack Participants:
                      {round.hijack_participants.map((entry, index) => (
                        <Fragment key={index}>
                          <Box
                            style={{
                              padding: '6px 5px 6px 5px',
                              border: '0.5px solid #4a4a4a',
                            }}
                          >
                            <Box>
                              {entry.name}: {entry.value}
                            </Box>
                          </Box>
                          <Box height="6px" />
                        </Fragment>
                      ))}
                    </Box>
                  </>
                ) : null}
                {round.final_participants ? (
                  <>
                    <Box height="6px" />
                    <Box>
                      Final Participants:
                      {round.final_participants.map((entry, index) => (
                        <Fragment key={index}>
                          <Box
                            style={{
                              padding: '6px 5px 6px 5px',
                              border: '0.5px solid #4a4a4a',
                            }}
                          >
                            <Box>
                              {entry.name}: {entry.value}
                            </Box>
                          </Box>
                          <Box height="6px" />
                        </Fragment>
                      ))}
                    </Box>
                  </>
                ) : null}
              </Box>
            </Section>
          ) : (
            <NoticeBox danger>Round statistic prepairing!</NoticeBox>
          )}
          {round?.death_list ? (
            <KillView real_data={round.death_list} />
          ) : (
            <NoticeBox danger>No recorded kills!</NoticeBox>
          )}
        </Box>
      );
    case 'Medals':
      return (
        <Section title="Medals">
          {medals.map((entry, index) => (
            <Fragment key={index}>
              <Box
                style={{
                  padding: '12px 10px 12px 10px',
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
    default:
      if (!factions[selectedTab]) return;
      return <StatTab faction={factions[selectedTab]} />;
  }
};

const StatTab = (props, context) => {
  const { faction } = props;
  return (
    <Box>
      {faction.statistics.length ? (
        <>
          <Section title="Statistics">
            {faction.statistics.map((entry, index) => (
              <Fragment key={index}>
                <Box>
                  {entry.name}: {entry.value}
                </Box>
                <Box height="6px" />
              </Fragment>
            ))}
          </Section>
          <Box height="12px" />
        </>
      ) : null}
      {faction.top_statistics.length ? (
        <>
          <Section title="Top Statistics">
            {faction.top_statistics.map((entry, index) => (
              <Fragment key={index}>
                <Box
                  style={{
                    padding: '12px 10px 12px 10px',
                    border: '0.5px solid #4a4a4a',
                  }}
                >
                  <Box>{entry.name}</Box>
                  {entry.statistics.length ? (
                    <>
                      <Box height="6px" />
                      {entry.statistics.map((entry, index) => (
                        <Fragment key={index}>
                          <Box>
                            {entry.name}: {entry.value}
                          </Box>
                          <Box height="3px" />
                        </Fragment>
                      ))}
                    </>
                  ) : null}
                </Box>
                <Box height="12px" />
              </Fragment>
            ))}
          </Section>
          <Box height="12px" />
        </>
      ) : null}
      {faction.nemesis.length ? (
        <>
          <Section title="Nemesis">
            <Box>
              {faction.nemesis.name}: {faction.nemesis.value}
            </Box>
          </Section>
          <Box height="12px" />
        </>
      ) : null}
      {faction.death_list.length ? (
        <KillView real_data={faction.death_list} />
      ) : (
        <NoticeBox danger>No recorded deaths!</NoticeBox>
      )}
      <Box height="12px" />
      <>
        {faction.statistics_list.length ? (
          <Section title="Additional Statistics">
            {faction.statistics_list.map((entry, index) => (
              <Collapsible key={index} title={entry.name}>
                {entry.value.length ? (
                  <>
                    {entry.value.map((entry, index) => (
                      <Fragment key={index}>
                        <Box
                          direction="column"
                          style={{
                            padding: '12px 10px 12px 10px',
                            border: '0.5px solid #4a4a4a',
                          }}
                        >
                          <Box>{entry.name}</Box>
                          {entry.statistics.length ? (
                            <Box>
                              Statistics
                              <Box height="3px" />
                              {entry.statistics.map((entry, index) => (
                                <Fragment key={index}>
                                  <Box>
                                    {entry.name}: {entry.value}
                                  </Box>
                                </Fragment>
                              ))}
                            </Box>
                          ) : null}
                          <Box height="6px" />
                          {entry.top_statistics.length ? (
                            <Box>
                              Top Statistics
                              <Box height="3px" />
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
                        <Box height="6px" />
                      </Fragment>
                    ))}
                    <Box height="6px" />
                  </>
                ) : null}
              </Collapsible>
            ))}
          </Section>
        ) : null}
        <Box height="6px" />
      </>
    </Box>
  );
};

const KillView = (props, context) => {
  const { real_data } = props;
  return (
    <Section>
      <Collapsible title="Death Logs">
        {real_data.map((entry, index) => (
          <Collapsible
            key={index}
            title={entry.mob_name + ' (' + entry.time_of_death + ')'}
          >
            <Box>Mob: {entry.mob_name}</Box>
            {entry.job_name ? (
              <>
                <Box height="3px" />
                <Box>Job: {entry.job_name}</Box>
              </>
            ) : null}
            <Box height="3px" />
            <Box>Area: {entry.area_name}</Box>
            <Box height="3px" />
            <Box>Cause: {entry.cause_name}</Box>
            <Box height="3px" />
            <Box>Time: {entry.time_of_death}</Box>
            <Box height="3px" />
            <Box>Lifespan: {entry.total_time_alive}</Box>
            <Box height="3px" />
            <Box>Damage taken: {entry.total_damage_taken}</Box>
            <Box height="3px" />
            <Box>
              Coords: {entry.x}, {entry.y}, {entry.z}
            </Box>
          </Collapsible>
        ))}
      </Collapsible>
    </Section>
  );
};
