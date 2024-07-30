import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

interface DemoSimData {
  configuration: any;
  dummy_mode: string;
  worldtime: number;
  nextdetonationtime: number;
  detonation_cooldown: number;
}

export const DemoSim = () => {
  const { act, data } = useBackend<DemoSimData>();
  const [simulationView, setSimulationView] = useState(false);

  const timeLeft = data.nextdetonationtime - data.worldtime;
  const timeLeftPct = timeLeft / data.detonation_cooldown;

  const canDetonate = timeLeft < 0 && data.configuration && simulationView;

  return (
    <Window width={550} height={300}>
      <Window.Content scrollable>
        <Section title="Configuration status">
          {(!!data.configuration && (
            <NoticeBox info fontSize="15px">
              Configuration : detonating {data.configuration}!
            </NoticeBox>
          )) || (
            <NoticeBox danger fontSize="15px">
              No explosive configuration loaded!
            </NoticeBox>
          )}
          <NoticeBox info fontSize="15px">
            Target dummy type : {data.dummy_mode}
          </NoticeBox>
          {timeLeft > 0 && (
            <ProgressBar
              width="100%"
              value={timeLeftPct}
              ranges={{
                good: [-Infinity, 0.33],
                average: [0.33, 0.67],
                bad: [0.67, Infinity],
              }}
            >
              <Box textAlign="center" fontSize="15px">
                {Math.ceil(timeLeft / 10)} seconds until the console&apos;s
                processors finish cooling!
              </Box>
            </ProgressBar>
          )}
        </Section>
        <Section title="Detonation controls">
          <Stack>
            <Stack.Item grow>
              {(!simulationView && (
                <Button
                  fontSize="16px"
                  fluid
                  icon="eye"
                  color="good"
                  onClick={() => {
                    act('start_watching');
                    setSimulationView(true);
                  }}
                >
                  Enter simulation
                </Button>
              )) || (
                <Button
                  fontSize="16px"
                  fluid
                  icon="eye-slash"
                  color="good"
                  onClick={() => {
                    act('stop_watching');
                    setSimulationView(false);
                  }}
                >
                  Exit simulation
                </Button>
              )}
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="16px"
                fluid
                icon="repeat"
                color="good"
                onClick={() => act('switchmode')}
              >
                Switch dummy type
              </Button>
            </Stack.Item>
          </Stack>
          <Stack>
            <Stack.Item grow>
              <Button
                fontSize="16px"
                disabled={!data.configuration}
                fluid
                icon="sign-in-alt"
                color="good"
                onClick={() => act('eject')}
              >
                Eject explosive
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button.Confirm
                fontSize="16px"
                disabled={!canDetonate}
                fluid
                icon="bomb"
                color="good"
                confirmContent="Confirm?"
                onClick={() => act('detonate')}
              >
                Detonate explosive
              </Button.Confirm>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
