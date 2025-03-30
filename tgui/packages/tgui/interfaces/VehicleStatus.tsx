import type { BooleanLike } from 'common/react';
import { Fragment } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Collapsible,
  Divider,
  Flex,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  resistance_data: { name: string; pct: number }[];
  integrity: number;
  door_locked: BooleanLike;
  total_passenger_slots: number;
  total_taken_slots: number;
  passenger_categories_data: { name: string; taken: number; total: number }[];
  hardpoint_data: {
    name: String;
    health: number | null;
    uses_ammo: BooleanLike;
    current_rounds?: number;
    max_rounds?: number;
    mags?: number;
    max_mags?: number;
    fpw: BooleanLike;
  }[];
};

export const VehicleStatus = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    resistance_data,
    integrity,
    door_locked,
    total_passenger_slots,
    total_taken_slots,
    passenger_categories_data,
    hardpoint_data,
  } = data;

  const height = 150 + hardpoint_data.length * 80;

  return (
    <Window width={400} height={height}>
      <Window.Content>
        <Section>
          {integrity >= 0 ? (
            <ProgressBar
              value={integrity}
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
          <Box height="5px" />
          {door_locked ? (
            <NoticeBox danger>Door locks: enabled.</NoticeBox>
          ) : (
            <NoticeBox info>Door locks: disabled.</NoticeBox>
          )}
          <Collapsible title="Current armour resistances">
            <ResistanceView />
          </Collapsible>
          <Collapsible title="Passengers">
            <Box>
              Total passenger capacity: {total_taken_slots}/
              {total_passenger_slots}
            </Box>
            <PassengersView />
          </Collapsible>
        </Section>
        <Section title="Hardpoints">
          <HardpointsView />
        </Section>
      </Window.Content>
    </Window>
  );
};

const ResistanceView = (props) => {
  const { act, data } = useBackend<Data>();
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
  const { act, data } = useBackend<Data>();
  const { hardpoint_data } = data;
  return hardpoint_data.map((hardpoint, index) => (
    <Fragment key={index}>
      {index !== 0 ? <Divider /> : null}
      <Box>{hardpoint.name}</Box>
      <Box width="3px" />
      {hardpoint.fpw ? null : hardpoint.health! >= 0 ? (
        <ProgressBar
          value={hardpoint.health!}
          ranges={{
            good: [0.7, Infinity],
            average: [0.2, 0.7],
            bad: [-Infinity, 0.2],
          }}
        >
          Hardpoint integrity: {hardpoint.health}%
        </ProgressBar>
      ) : (
        <NoticeBox danger>Hardpoint destroyed!</NoticeBox>
      )}
      <Box height="3px" />
      {hardpoint.uses_ammo ? (
        <Flex direction="row">
          <ProgressBar
            value={hardpoint.current_rounds! / hardpoint.max_rounds!}
            width={hardpoint.fpw ? '100%' : '49%'}
          >
            Ammo: {hardpoint.current_rounds} / {hardpoint.max_rounds}
          </ProgressBar>
          {hardpoint.fpw ? null : (
            <>
              <Box width="3px" />
              <ProgressBar
                value={hardpoint.mags! / hardpoint.max_mags!}
                width="49%"
              >
                Mags: {hardpoint.mags} / {hardpoint.max_mags}
              </ProgressBar>
            </>
          )}
        </Flex>
      ) : null}
    </Fragment>
  ));
};

const PassengersView = (props) => {
  const { act, data } = useBackend<Data>();
  const { passenger_categories_data } = data;
  return passenger_categories_data.map((cat, index) => (
    <Fragment key={index}>
      <Box>
        {cat.name}: {cat.taken}/{cat.total}
      </Box>
      <Box width="3px" />
    </Fragment>
  ));
};
