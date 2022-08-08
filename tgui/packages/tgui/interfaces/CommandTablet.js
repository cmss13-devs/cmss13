import { useBackend } from '../backend';
import { Button, Section, ProgressBar } from '../components';
import { Window } from '../layouts';

export const CommandTablet = (_props, context) => {
  const { act, data } = useBackend(context);

  const evacstatus = data.evac_status;

  const timeLeft = data.cooldown_message;
  const timeLeftPct = 100 - (timeLeft / data.cooldown_message);

  const canAnnounce = (
    timeLeft === 0);

  const canEvac = (
    evacstatus === 0);

  return (
    <Window
      width={350}
      height={350}>
      <Window.Content scrollable>
        <Section>
          <Section>
            <Button
              icon="bullhorn"
              title="Make Announcement"
              content="Make an announcement"
              onClick={() => act('announce')}
              disabled={!canAnnounce} />
            <ProgressBar
              width="50%"
              value={timeLeftPct}
              ranges={{
                bad: [-Infinity, 0.33],
                average: [0.33, 0.67],
                good: [0.67, Infinity],
              }}>
              {Math.ceil(timeLeft / 10)} secs
            </ProgressBar>
          </Section>
          <Section>
            <Button
              icon="medal"
              title="Give Award"
              content="Give an award"
              onClick={() => act('award')} />
          </Section>
          <Section>
            <Button
              icon="globe-europe"
              title="Open Tacmap"
              content="View Tacmap"
              onClick={() => act('mapview')} />
          </Section>
          {!!canEvac && (
            <Section>
              <Button
                ml={1}
                icon="door-open"
                content={"Initiate Evacuation"}
                onClick={() => act('evacuation_start')} />
            </Section>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
