import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, ProgressBar, NoticeBox, Stack } from '../components';

interface CasSimData {
  configuration: any;
  dummy_mode: string;
  worldtime: number;
  nextdetonationtime: number;
  detonation_cooldown: number;
}

export const CasSim = () => {
  const { act, data } = useBackend<CasSimData>();
  const [simulationView, setSimulationView] = useLocalState(
    'simulation_view',
    false
  );

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
            }}>
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
                fluid={1}
                icon="eye"
                color="good"
                content="Enter simulation"
                onClick={() => {
                  act('start_watching');
                  setSimulationView(true);
                }}
              />
            )) || (
              <Button
                fluid={1}
                icon="eye-slash"
                color="good"
                content="Exit simulation"
                onClick={() => {
                  act('stop_watching');
                  setSimulationView(false);
                }}
              />
            )}
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid={1}
              icon="repeat"
              color="good"
              content="Switch dummy type"
              onClick={() => act('switchmode')}
            />
          </Stack.Item>
        </Stack>
        <Stack>
          <Stack.Item grow>
            <Button
              disabled={!data.configuration}
              fluid={1}
              icon="sign-in-alt"
              color="good"
              content="Switch firemission"
              onClick={() => act('switch_firemission')}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button.Confirm
              disabled={!canDetonate}
              fluid={1}
              icon="bomb"
              color="good"
              content="Execute firemission?"
              confirmContent="Confirm?"
              onClick={() => act('execute_simulated_firemission')}
            />
          </Stack.Item>
        </Stack>
        <Stack />
      </Section>
    </Box>
  );
};
