import type { BooleanLike } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, Section, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';
const PAGES = [
  {
    title: 'Vote',
    component: () => MainMenu,
    color: 'white',
    icon: 'square',
    canAccess: (data) => !!data.vote_in_progress,
  },
  {
    title: 'Start a vote',
    component: () => StartVote,
    color: 'red',
    icon: 'gavel',
  },
  {
    title: 'Settings',
    component: () => SettingsMenu,
    color: 'orange',
    icon: 'cog',
    canAccess: (data) => !!data.is_admin,
  },
];

type VoteEntry = {
  name: string;
  color: string;
  icon: string;
  variable_required?: string;
  adminOnly?: BooleanLike;
};

type Data = {
  possible_vote_types: {
    restart: VoteEntry;
    gamemode: VoteEntry;
    shipmap: VoteEntry;
    groundmap: VoteEntry;
    custom: VoteEntry;
  };
  vote_has_voted: BooleanLike;
  is_admin: BooleanLike;
  vote_in_progress: string | null;
  can_restart_vote: BooleanLike;
  can_gamemode_vote: BooleanLike;
  vote_choices: string[];
  vote_title: string;
};

export const VoteMenu = (props) => {
  const { data } = useBackend();

  const [pageIndex, setPageIndex] = useState(0);

  const PageComponent = PAGES[pageIndex].component();

  return (
    <Window width={400} height={350}>
      <Window.Content scrollable>
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
                onClick={() => setPageIndex(i)}
              >
                {page.title}
              </Tabs.Tab>
            );
          })}
        </Tabs>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const MainMenu = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    vote_in_progress,
    vote_choices,
    vote_title,
    is_admin,
    vote_has_voted,
  } = data;

  return (
    <Flex direction="column">
      <Flex.Item grow={1}>
        <Section title={vote_title} fill>
          {(!!vote_in_progress && (
            <Flex wrap="wrap">
              {Object.keys(vote_choices).map((key) => (
                <Flex.Item basis="100%" mt={1} key={key}>
                  <Flex align="center">
                    <Flex.Item grow={1}>
                      <Box
                        height="100%"
                        fontSize="110%"
                        textAlign="center"
                        className="VoteMenu__Textbox"
                      >
                        {key}
                      </Box>
                    </Flex.Item>
                    <Flex.Item pl={1}>
                      <Button
                        color="good"
                        textAlign="center"
                        onClick={() => act('vote', { voted_for: key })}
                      >
                        Vote
                      </Button>
                    </Flex.Item>
                    {!!(vote_has_voted || is_admin) && (
                      <Flex.Item>
                        <Box height="100%" pl={1} fontSize="110%" nowrap>
                          {vote_choices[key]} votes
                        </Box>
                      </Flex.Item>
                    )}
                  </Flex>
                </Flex.Item>
              ))}
              {!!is_admin && (
                <Button.Confirm
                  width="100%"
                  icon="stop-circle"
                  color="teal"
                  mt={1}
                  onClick={() => act('cancel')}
                >
                  Cancel Current Vote
                </Button.Confirm>
              )}
            </Flex>
          )) || (
            <Box fontSize="150%" textAlign="center" height="100%">
              No vote in progress
            </Box>
          )}
        </Section>
      </Flex.Item>
    </Flex>
  );
};

const StartVote = (props) => {
  const { act, data } = useBackend<Data>();
  const { possible_vote_types, is_admin, vote_in_progress } = data;

  return (
    <Section>
      <Flex wrap="wrap" justify="space-evenly">
        {Object.keys(possible_vote_types).map((key) => {
          const element = possible_vote_types[key];
          const canUseElement =
            !vote_in_progress &&
            (is_admin ||
              (!element.admin_only &&
                (!element.variable_required ||
                  data[element.variable_required])));
          return (
            <Flex.Item key={key} basis="100%" mb="1%" height="30px">
              <Button
                pt={1}
                pb={1}
                textAlign="center"
                width="100%"
                height="100%"
                icon={element.icon}
                color={element.color}
                disabled={!canUseElement}
                onClick={() => act('initiate_vote', { vote_type: key })}
              >
                {element.name}
              </Button>
            </Flex.Item>
          );
        })}
      </Flex>
    </Section>
  );
};

const SettingsMenu = (props) => {
  const { act, data } = useBackend<Data>();
  const { can_restart_vote, can_gamemode_vote } = data;

  return (
    <Section>
      <Flex>
        <Flex.Item color="label" grow={1}>
          Restart Votes:
        </Flex.Item>
        <Flex.Item align="right">
          <Button
            icon={can_restart_vote ? 'lock-open' : 'lock'}
            color={can_restart_vote ? 'good' : 'bad'}
            onClick={() => act('toggle_restart')}
            tooltip="Controls whether players can make restart votes."
            tooltipPosition="left"
          >
            {can_restart_vote ? 'Unlocked' : 'Locked'}
          </Button>
        </Flex.Item>
      </Flex>
      <Flex mt={1}>
        <Flex.Item color="label" grow={1}>
          Gamemode Votes:
        </Flex.Item>
        <Flex.Item>
          <Button
            icon={can_gamemode_vote ? 'lock-open' : 'lock'}
            color={can_gamemode_vote ? 'good' : 'bad'}
            onClick={() => act('toggle_gamemode')}
            tooltip="Controls whether players can make gamemode votes."
            tooltipPosition="left"
          >
            {can_gamemode_vote ? 'Unlocked' : 'Locked'}
          </Button>
        </Flex.Item>
      </Flex>
    </Section>
  );
};
