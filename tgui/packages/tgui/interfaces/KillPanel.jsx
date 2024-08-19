import { Fragment } from 'react';

import { useBackend } from '../backend';
import { Box, Collapsible, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const KillPanel = (props) => {
  const { act, data } = useBackend();
  const { death_data } = data;

  const real_data = death_data['death_stats_list'];

  return (
    <Window width={300} height={600}>
      <Window.Content scrollable>
        <Section>
          {death_data ? (
            <KillView />
          ) : (
            <NoticeBox danger>No recorded kills!</NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const KillView = (props) => {
  const { act, data } = useBackend();
  const { death_data } = data;

  const real_data = death_data['death_stats_list'];

  return real_data.map((entry, index) => (
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
  ));
};
