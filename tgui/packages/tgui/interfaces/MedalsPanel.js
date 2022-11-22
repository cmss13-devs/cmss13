import { useBackend, useLocalState } from '../backend';
import { Tabs, Section, Button, Fragment, Stack, Flex } from '../components';
import { Window } from '../layouts';

const PAGES = [
  {
    title: 'USCM',
    component: () => MedalsPage,
    color: 'blue',
    icon: 'medal',
  },
  {
    title: 'Hive',
    component: () => MedalsPage,
    color: 'purple',
    icon: 'star',
  },
];

export const MedalsPanel = (props, context) => {
  const { data } = useBackend(context);
  const { uscm_awards, uscm_award_ckeys, xeno_awards, xeno_award_ckeys } = data;

  const [pageIndex, setPageIndex] = useLocalState(context, 'pageIndex', 1);

  const PageComponent = PAGES[pageIndex].component();

  return (
    <Window
      width={600}
      height={400}
      theme={pageIndex === 0 ? 'ntos' : 'hive_status'}
      resizable>
      <Window.Content scrollable>
        <Stack direction="column" fill>
          <Stack.Item basis="content" grow={0} pb={1}>
            <Tabs>
              {PAGES.map((page, i) => {
                if (page.canAccess && !page.canAccess(data)) {
                  return;
                }

                return (
                  <Tabs.Tab
                    key={i}
                    color={page.color}
                    selected={i === pageIndex}
                    icon={page.icon}
                    onClick={() => setPageIndex(i)}>
                    {page.title}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Stack.Item>
          <Stack.Item mx={0}>
            <PageComponent
              awards={pageIndex === 0 ? uscm_awards : xeno_awards}
              ckeys={pageIndex === 0 ? uscm_award_ckeys : xeno_award_ckeys}
              isMarineMedal={pageIndex === 0}
            />
          </Stack.Item>
          <Stack.Item grow={1} mx={0}>
            <Section fill />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MedalsPage = (props, context) => {
  const { act } = useBackend(context);
  const { awards, ckeys, isMarineMedal } = props;

  return (
    <Section
      title={isMarineMedal ? 'Medal Awards' : 'Royal Jellies'}
      buttons={
        <Fragment>
          <Button
            icon="clock"
            content="Refresh"
            ml={0.5}
            onClick={() => act('refresh')}
          />
          <Button
            icon="plus"
            color="green"
            content={isMarineMedal ? 'Add a medal' : 'Add a jelly'}
            align="center"
            width={8.5}
            ml={0.5}
            onClick={() => act(isMarineMedal ? 'add_medal' : 'add_jelly')}
          />
        </Fragment>
      }>
      <Fragment>
        {Object.keys(awards).map((recipient_name, recipient_index) => (
          <Section
            title={recipient_name + ckeys[recipient_name]}
            key={recipient_index}
            m={1}>
            {Object(awards[recipient_name]).map((medal, medalIndex) => (
              <Flex
                direction="row"
                key={medalIndex}
                backgroundColor={
                  medalIndex % 2 === 1 ? 'rgba(255,255,255,0.1)' : ''
                }>
                <Flex.Item grow={1} align="center" m={1} p={0.2}>
                  A {medal}
                </Flex.Item>
                <Flex.Item grow={0} basis="content" mr={0.5} mt={0.5}>
                  <Button.Confirm
                    icon="trash"
                    color="white"
                    content="Rescind"
                    confirmColor="bad"
                    width={6.5}
                    textAlign="center"
                    verticalAlignContent="bottom"
                    onClick={() =>
                      act(isMarineMedal ? 'delete_medal' : 'delete_jelly', {
                        recipient: recipient_name,
                        index: medalIndex,
                      })
                    }
                  />
                </Flex.Item>
              </Flex>
            ))}
          </Section>
        ))}
      </Fragment>
    </Section>
  );
};
