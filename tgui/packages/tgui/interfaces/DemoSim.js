import { useBackend } from '../backend';
import { Button, Section, ProgressBar, NoticeBox, Box } from '../components';
import { Window } from '../layouts';

export const DemoSim = (_props, context) => {
  const { act, data } = useBackend(context);

  const timeLeft = (data.nextdetonationtime - data.worldtime);
  const timeLeftPct = timeLeft / data.detonation_cooldown;

  const canDetonate = timeLeft < 0 && data.configuration && data.looking;

  return (
    <Window
      width={500}
      height={500}>
      <Window.Content scrollable>
        <Section title="Configuration status">
          {!!data.configuration && (
            <NoticeBox info>
              Configuration : detonating a {data.configuration}!
            </NoticeBox>
          ) || (
            <NoticeBox danger>
              No explosive configuration loaded!
            </NoticeBox>
          )}
          <NoticeBox info>
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
              <Box textAlign="center">
                {Math.ceil(timeLeft / 10)} seconds
                until the console`s processors finish cooling!
              </Box>
            </ProgressBar>
          )}
        </Section>
        <Section title="Processors status">
          {!data.looking && (
            <Button
              fontSize="20px"
              textAlign="center"
              fluid={1}
              icon="eye"
              color="good"
              content="watch"
              onClick={() => act('start_watching')}
            />
          ) || (
            <Button
              fontSize="20px"
              textAlign="center"
              fluid={1}
              icon="eye-slash"
              color="good"
              content="look away"
              onClick={() => act('stop_watching')}
            />
          )}
          <Button
            fontSize="20px"
            textAlign="center"
            disabled={!data.configuration}
            fluid={1}
            icon="sign-in-alt"
            color="good"
            content="Eject explosive"
            onClick={() => act('eject')}
          />
          <Button
            fontSize="20px"
            textAlign="center"
            fluid={1}
            icon="repeat"
            color="good"
            content="switch mode"
            onClick={() => act('switchmode')}
          />
          <Button.Confirm
            fontSize="20px"
            textAlign="center"
            disabled={!canDetonate}
            fluid={1}
            icon="bomb"
            color="good"
            content="Detonate explosive"
            confirmContent="Confirm?"
            onClick={() => act('detonate')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
