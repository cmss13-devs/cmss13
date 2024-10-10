import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Collapsible,
  Divider,
  Flex,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const Walker = (props) => {
  const { act, data } = useBackend();
  const { integrity, hardpoint_data } = data;

  const height = 150 + hardpoint_data.length * 80;

  return (
    <Window width={400} height={height}>
      <Window.Content>
        <Section>
          {integrity >= 0 ? (
            <ProgressBar
              value={integrity / 100}
              ranges={{
                good: [0.7, Infinity],
                average: [0.2, 0.7],
                bad: [-Infinity, 0.2],
              }}
            >
              Hull integrity: {integrity}%
            </ProgressBar>
          ) : (
            <NoticeBox danger>Hull destroyed!</NoticeBox>
          )}
        </Section>
        <Box height="5px" />
        <Collapsible title="Current armour resistances">
          <ResistanceView />
        </Collapsible>
        <Section title="Hardpoints">
          <HardpointsView />
        </Section>
      </Window.Content>
    </Window>
  );
};

const ResistanceView = (props) => {
  const { act, data } = useBackend();
  const { resistance_data, integrity } = data;
  return resistance_data.map((resistance, index) => (
    <Fragment key={index}>
      <Box>
        {resistance.name}: {resistance.pct * 100}%
      </Box>
      <Box width="3px" />
    </Fragment>
  ));
};

const HardpointsView = (props) => {
  const { act, data } = useBackend();
  const { hardpoint_data } = data;
  return hardpoint_data.map((hardpoint, index) => (
    <Fragment key={index}>
      {index !== 0 ? <Divider /> : null}
      <Box>{hardpoint.name}</Box>
      <Box>At {hardpoint.position}</Box>
      <Box height="3px" />
      <Flex direction="row">
        <ProgressBar
          value={hardpoint.current_rounds / hardpoint.max_rounds}
          width={'49%'}
        >
          Ammo: {hardpoint.current_rounds} / {hardpoint.max_rounds}
        </ProgressBar>
      </Flex>
    </Fragment>
  ));
};
