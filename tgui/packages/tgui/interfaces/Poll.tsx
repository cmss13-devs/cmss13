import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Button,
  Collapsible,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type PollType = {
  id: number;
  question: string;
  expiry: string;
  answers: { [id: string]: string };
};

type ConcludedPoll = {
  id: number;
  question: string;
  answers: { [answer: string]: number };
};

type PollData = {
  polls: PollType[];
  concluded_polls: ConcludedPoll[];
  voted_polls: number[];
  is_poll_maker: BooleanLike;
};

export const Poll = () => {
  const { act, data } = useBackend<PollData>();

  const { polls, is_poll_maker, concluded_polls } = data;

  return (
    <Window>
      <Window.Content scrollable>
        {!!is_poll_maker && (
          <Section title="BuildAPoll">
            <Button onClick={() => act('create')}>Create New Poll</Button>
          </Section>
        )}
        {polls.map((poll) => (
          <RenderPoll poll={poll} key={poll.id} />
        ))}
        {polls.length === 0 && (
          <Section title="No Polls">No polls are available to vote in.</Section>
        )}
        <Section title="Concluded Polls">
          {concluded_polls.map((concludedPoll) => (
            <RenderConcludedPoll poll={concludedPoll} key={concludedPoll.id} />
          ))}
          {concluded_polls.length === 0 && (
            <>No polls have been concluded and are available to view.</>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const RenderConcludedPoll = (props: { readonly poll: ConcludedPoll }) => {
  const { poll } = props;

  const total = Object.values(poll.answers).reduce(
    (prev, current) => prev + current,
    0,
  );

  const { act, data } = useBackend<PollData>();

  const { is_poll_maker } = data;

  return (
    <Collapsible
      title={poll.question}
      buttons={
        is_poll_maker && (
          <Button onClick={() => act('delete', { poll_id: poll.id })}>
            Delete
          </Button>
        )
      }
    >
      <Stack vertical>
        {Object.keys(poll.answers).map((answer) => (
          <Stack.Item key={answer}>
            <ProgressBar
              value={poll.answers[answer]}
              minValue={0}
              maxValue={total}
            >
              {answer} ({poll.answers[answer]} vote
              {poll.answers[answer] === 1 ? '' : 's'})
            </ProgressBar>
          </Stack.Item>
        ))}
      </Stack>
    </Collapsible>
  );
};

const RenderPoll = (props: { readonly poll: PollType }) => {
  const { poll } = props;

  const { act, data } = useBackend<PollData>();
  const { voted_polls, is_poll_maker } = data;

  const votedIn =
    Object.keys(poll.answers).filter((value) =>
      voted_polls.includes(Number.parseInt(value, 10)),
    ).length > 0;

  return (
    <Section
      key={poll.id}
      title={`${poll.question}${votedIn ? ' (Voted)' : ''}`}
    >
      <Stack vertical>
        {is_poll_maker && (
          <Stack.Item>
            <Button onClick={() => act('delete', { poll_id: poll.id })}>
              Delete
            </Button>
            <Button onClick={() => act('add-answer', { poll_id: poll.id })}>
              Add Answer
            </Button>
            <Button onClick={() => act('edit-time', { poll_id: poll.id })}>
              Change Time
            </Button>
          </Stack.Item>
        )}
        <Stack.Item style={{ color: '#999999' }}>
          Finishes {poll.expiry}
        </Stack.Item>
        {Object.keys(poll.answers).map((answerId) => (
          <Stack.Item key={answerId}>
            <Button
              onClick={() =>
                act('vote', { poll_id: poll.id, answer_id: answerId })
              }
              disabled={voted_polls.includes(Number.parseInt(answerId, 10))}
              fluid
            >
              {poll.answers[answerId]}
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
