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
              {data.configuration} loaded!
            </NoticeBox>
          ) || (
            <NoticeBox danger>
              No warhead loaded!
            </NoticeBox>
          )}
          <NoticeBox info>
            Currently spawning {data.dummy_mode}
          </NoticeBox>
        </Section>
        <Section title="Processors status">
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
                until the cannon can be chambered!
              </Box>
            </ProgressBar>
          )}
          {!data.looking && (
            <Button
              fontSize="20px"
              textAlign="center"
              fluid={1}
              icon="sign-in-alt"
              color="good"
              content="watch"
              onClick={() => act('start_watching')}
            />
          ) || (
            <Button
              fontSize="20px"
              textAlign="center"
              fluid={1}
              icon="sign-in-alt"
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
            icon="sign-in-alt"
            color="good"
            content="switch mode"
            onClick={() => act('switchmode')}
          />
          <Button.Confirm
            fontSize="20px"
            textAlign="center"
            disabled={!canDetonate}
            fluid={1}
            icon="sign-in-alt"
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
