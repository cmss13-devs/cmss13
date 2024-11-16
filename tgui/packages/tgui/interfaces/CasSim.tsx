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

interface CasSimData {
  configuration: any;
  dummy_mode: string;
  worldtime: number;
  nextdetonationtime: number;
  detonation_cooldown: number;
}

export const CasSim = () => {
  const { act, data } = useBackend<CasSimData>();
  const [simulationView, setSimulationView] = useState(false);

  const timeLeft = data.nextdetonationtime - data.worldtime;
  const timeLeftPct = timeLeft / data.detonation_cooldown;

  const canDetonate = timeLeft < 0 && data.configuration && simulationView;

  return (
    <Box className="CasSim">
      <Section title="Configuration status">
        {(!!data.configuration && (
          <NoticeBox info>
            Configuration : Executing {data.configuration}!
          </NoticeBox>
        )) || (
          <NoticeBox danger>No firemission configuration loaded!</NoticeBox>
        )}
        <NoticeBox info>Target dummy type : {data.dummy_mode}</NoticeBox>
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
            <Box textAlign="center">
              {Math.ceil(timeLeft / 10)} seconds until the console&apos;s
              processors finish cooling!
            </Box>
          </ProgressBar>
        )}
      </Section>
      <Section title="Cas Simulation Controls">
        <Stack>
          <Stack.Item grow>
            {(!simulationView && (
              <Button
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
              disabled={!data.configuration}
              fluid
              icon="sign-in-alt"
              color="good"
              onClick={() => act('switch_firemission')}
            >
              Switch firemission
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button.Confirm
              disabled={!canDetonate}
              fluid
              icon="bomb"
              color="good"
              confirmContent="Confirm?"
              onClick={() => act('execute_simulated_firemission')}
            >
              Execute firemission?
            </Button.Confirm>
          </Stack.Item>
        </Stack>
        <Stack />
      </Section>
    </Box>
  );
};
