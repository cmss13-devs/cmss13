import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Flex, Section, Stack, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

const PAGES = [
  {
    title: 'USCM',
    color: 'blue',
    icon: 'medal',
  },
  {
    title: 'Hive',
    color: 'purple',
    icon: 'star',
  },
];

type Data = {
  uscm_awards: Record<string, string>;
  xeno_awards: Record<string, string>;
  uscm_award_ckeys: Record<string, string>;
  xeno_award_ckeys: Record<string, string>;
};

export const MedalsPanel = (props) => {
  const { data } = useBackend<Data>();
  const { uscm_awards, uscm_award_ckeys, xeno_awards, xeno_award_ckeys } = data;

  const [pageIndex, setPageIndex] = useState(1);

  return (
    <Window
      width={600}
      height={400}
      theme={pageIndex === 0 ? 'ntos' : 'hive_status'}
    >
      <Window.Content scrollable>
        <Stack direction="column" fill>
          <Stack.Item basis="content" grow={0} pb={1}>
            <Tabs>
              {PAGES.map((page, i) => {
                return (
                  <Tabs.Tab
                    key={i}
                    color={page.color}
                    selected={i === pageIndex}
                    icon={page.icon}
                    onClick={() => setPageIndex(i)}
                  >
                    {page.title}
                  </Tabs.Tab>
                );
              })}
            </Tabs>
          </Stack.Item>
          <Stack.Item mx={0}>
            <MedalsPage
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

const MedalsPage = (props: {
  readonly awards: Record<string, string>;
  readonly ckeys: Record<string, string>;
  readonly isMarineMedal: boolean;
}) => {
  const { act } = useBackend();
  const { awards, ckeys, isMarineMedal } = props;

  return (
    <Section
      title={isMarineMedal ? 'Medal Awards' : 'Royal Jellies'}
      buttons={
        <>
          <Button icon="clock" ml={0.5} onClick={() => act('refresh')}>
            Refresh
          </Button>
          <Button
            icon="plus"
            color="green"
            align="center"
            width={8.5}
            ml={0.5}
            onClick={() => act(isMarineMedal ? 'add_medal' : 'add_jelly')}
          >
            {isMarineMedal ? 'Add a medal' : 'Add a jelly'}
          </Button>
        </>
      }
    >
      <>
        {Object.keys(awards).map((recipient_name, recipient_index) => (
          <Section
            title={recipient_name + ckeys[recipient_name]}
            key={recipient_index}
            m={1}
          >
            {Object(awards[recipient_name]).map((medal, medalIndex) => (
              <Flex
                direction="row"
                key={medalIndex}
                backgroundColor={
                  medalIndex % 2 === 1 ? 'rgba(255,255,255,0.1)' : ''
                }
              >
                <Flex.Item grow={1} align="center" m={1} p={0.2}>
                  A {medal}
                </Flex.Item>
                <Flex.Item grow={0} basis="content" mr={0.5} mt={0.5}>
                  <Button.Confirm
                    icon="trash"
                    color="white"
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
                  >
                    Rescind
                  </Button.Confirm>
                </Flex.Item>
              </Flex>
            ))}
          </Section>
        ))}
      </>
    </Section>
  );
};
