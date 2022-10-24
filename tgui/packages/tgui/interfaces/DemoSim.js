import { useBackend } from '../backend';
import {
  Button,
  Section,
  ProgressBar,
  NoticeBox,
  Box,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const DemoSim = (_props, context) => {
  const { act, data } = useBackend(context);

  const timeLeft = data.nextdetonationtime - data.worldtime;
  const timeLeftPct = timeLeft / data.detonation_cooldown;

  const canDetonate = timeLeft < 0 && data.configuration && data.looking;

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
              }}>
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
              {(!data.looking && (
                <Button
                  fontSize="16px"
                  fluid={1}
                  icon="eye"
                  color="good"
                  content="Enter simulation"
                  onClick={() => act('start_watching')}
                />
              )) || (
                <Button
                  fontSize="16px"
                  fluid={1}
                  icon="eye-slash"
                  color="good"
                  content="Exit simulation"
                  onClick={() => act('stop_watching')}
                />
              )}
            </Stack.Item>
            <Stack.Item grow>
              <Button
                fontSize="16px"
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
                fontSize="16px"
                disabled={!data.configuration}
                fluid={1}
                icon="sign-in-alt"
                color="good"
                content="Eject explosive"
                onClick={() => act('eject')}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button.Confirm
                fontSize="16px"
                disabled={!canDetonate}
                fluid={1}
                icon="bomb"
                color="good"
                content="Detonate explosive"
                confirmContent="Confirm?"
                onClick={() => act('detonate')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
