import { useBackend } from '../backend';
import { Button, Section, Flex, NoticeBox } from '../components';
import { Window } from '../layouts';

export const CommandTablet = (_props, context) => {
  const { act, data } = useBackend(context);

  const evacstatus = data.evac_status;

  const AlertLevel = data.alert_level;

  const canAnnounce = (
    data.endtime < data.worldtime);

  const canEvac = (
    evacstatus === 0,
    AlertLevel >= 2);

  return (
    <Window
      width={350}
      height={350}>
      <Window.Content scrollable>
        <Section title="Command">
          <Flex height="100%" direction="column">
            <Flex.Item>
              {!canAnnounce && (
                <Button color="bad" warning={1} fluid={1} icon="bullhorn">
                  Announcement on cooldown
                  : {Math.ceil((data.endtime - data.worldtime)/10)} secs
                </Button>
              )}
              {!!canAnnounce && (
                <Button
                  fluid={1}
                  icon="bullhorn"
                  title="Make an announcement"
                  content="Make an announcement"
                  onClick={() => act('announce')}
                  disabled={!canAnnounce} />
              )}
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid={1}
                icon="medal"
                title="Give a medal"
                content="Give a medal"
                onClick={() => act('award')} />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid={1}
                icon="globe-africa"
                title="View tactical map"
                content="View tactical map"
                onClick={() => act('mapview')} />
            </Flex.Item>
            {data.faction === "USCM" && (
              <Section title="Evacuation">
                {AlertLevel < 2 && (
                  <NoticeBox color="bad" warning={1} textAlign="center">
                    The ship must be under red alert in order to enact
                    evacuation procedures.
                  </NoticeBox>
                )}
                {evacstatus === 0 && (
                  <Flex.Item>
                    <Button.Confirm
                      fluid={1}
                      icon="door-open"
                      content={"Initiate Evacuation"}
                      confirmColor="bad"
                      confirmContent="Confirm?"
                      confirmIcon="question"
                      onClick={() => act('evacuation_start')}
                      disabled={!canEvac} />
                  </Flex.Item>
                )}
                {evacstatus === 1 && (
                  <NoticeBox color="good" info={1} textAlign="center">
                    Evacuation ongoing.
                  </NoticeBox>
                )}
                {evacstatus === 2 && (
                  <NoticeBox color="good" info={1} textAlign="center">
                    Escape pods launching.
                  </NoticeBox>
                )}
                {evacstatus === 3 && (
                  <NoticeBox color="good" success={1} textAlign="center">
                    Evacuation complete.
                  </NoticeBox>
                )}
              </Section>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
