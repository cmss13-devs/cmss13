import { useBackend } from '../backend';
import { Button, Section, ProgressBar, NoticeBox, Box } from '../components';
import { Window } from '../layouts';

export const SupplyDropConsole = (_props, context) => {
  const { act, data } = useBackend(context);

  const timeLeft = data.nextfiretime - data.worldtime;
  const timeLeftPct = timeLeft / data.launch_cooldown;

  const cantFire = (timeLeft < 0, data.loaded === null);

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        <Section
          title="Supply Pad Status"
          buttons={
            <Button
              icon="sync-alt"
              content="Update"
              onClick={() => act('refresh_pad')}
            />
          }>
          <NoticeBox info={1} textAlign="center">
            {data.loaded
              ? `Supply Pad Status :
                  ${data.crate_name} loaded.`
              : 'No crate loaded.'}
          </NoticeBox>
          {(timeLeft < 0 && (
            <NoticeBox success={1} textAlign="center">
              Ready to fire!
            </NoticeBox>
          )) || (
            <ProgressBar
              width="100%"
              value={timeLeftPct}
              ranges={{
                good: [-Infinity, 0.33],
                average: [0.33, 0.67],
                bad: [0.67, Infinity],
              }}>
              <Box textAlign="center">
                {Math.ceil(timeLeft / 10)} seconds until next launch
              </Box>
            </ProgressBar>
          )}
          <Button
            fontSize="20px"
            textAlign="center"
            disabled={!!cantFire}
            fluid={1}
            icon="paper-plane"
            color="good"
            content="Launch Supply Drop"
            onClick={() => act('send_beacon')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
