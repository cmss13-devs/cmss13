import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const FaxMachine = () => {
  const { act, data } = useBackend();
  const { idcard } = data;
  const body = idcard ? <FaxMain /> : <FaxEmpty />;
  const windowWidth = idcard ? 600 : 400;
  const windowHeight = idcard ? 340 : 215;

  return (
    <Window width={windowWidth} height={windowHeight} theme="weyland">
      <Window.Content>{body}</Window.Content>
    </Window>
  );
};

const FaxMain = (props) => {
  const { data } = useBackend();
  const { machine_id_tag, awake_responder, highcom_dept } = data;
  return (
    <>
      <FaxId />
      <FaxSelect />
      <NoticeBox color="grey" textAlign="center">
        The machine identification is {machine_id_tag}.
      </NoticeBox>
      {!!highcom_dept && (
        <NoticeBox
          color={awake_responder ? 'orange' : 'grey'}
          textAlign="center"
        >
          A designated communications operator is
          {awake_responder ? ' currently' : ' not currently'} awake.
          <br />
          Message responses
          {awake_responder ? ' are likely to be swift.' : ' may be delayed.'}
        </NoticeBox>
      )}
    </>
  );
};

const FaxId = (props) => {
  const { act, data } = useBackend();
  const { department, network, idcard, authenticated } = data;
  return (
    <Section title="Authentication">
      <NoticeBox color="grey" textAlign="center">
        This machine is currently operating on the {network}
        <br />
        and is sending from the {department} department.
      </NoticeBox>
      <Stack>
        <Stack.Item>
          <Button icon="eject" mb="0" onClick={() => act('ejectid')}>
            {idcard}
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button
            icon="sign-in-alt"
            fluid
            selected={authenticated}
            onClick={() => act(authenticated ? 'logout' : 'auth')}
          >
            {authenticated ? 'Log Out' : 'Log In'}
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FaxSelect = (props) => {
  const { act, data } = useBackend();
  const {
    paper,
    paper_name,
    authenticated,
    target_department,
    worldtime,
    nextfaxtime,
    faxcooldown,
  } = data;

  const timeLeft = nextfaxtime - worldtime;

  return (
    <Section title="Department selection">
      <Stack>
        <Stack.Item>
          <Button
            icon="list"
            disabled={!authenticated}
            onClick={() => act('select')}
          >
            Select department to send to
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button icon="building" fluid disabled={!authenticated}>
            {'Currently sending to : ' + target_department + '.'}
          </Button>
        </Stack.Item>
      </Stack>
      <Box width="600px" height="5px" />
      <Stack>
        <Stack.Item>
          <Button
            icon="eject"
            fluid
            onClick={() => act(paper ? 'ejectpaper' : 'insertpaper')}
            color={paper ? 'default' : 'grey'}
          >
            {paper ? 'Currently sending : ' + paper_name : 'No paper loaded!'}
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          {(timeLeft < 0 && (
            <Button
              icon="paper-plane"
              fluid
              onClick={() => act('send')}
              disabled={timeLeft > 0 || !paper || !authenticated}
            >
              {paper ? 'Send' : 'No paper loaded!'}
            </Button>
          )) || (
            <Button icon="window-close" fluid disabled={1}>
              {'Transmitters realigning, ' + timeLeft / 10 + ' seconds left.'}
            </Button>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FaxEmpty = (props) => {
  const { act, data } = useBackend();
  const { paper, paper_name } = data;
  return (
    <Section textAlign="center" fill>
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="red">
          <Icon name="times-circle" mb="0.5rem" size="5" color="red" />
          <br />
          No ID card detected.
          <br />
          {paper && (
            <Button
              icon="eject"
              onClick={() => act('ejectpaper')}
              disabled={!paper}
            >
              {'Eject ' + paper_name + '.'}
            </Button>
          )}
        </Flex.Item>
      </Flex>
    </Section>
  );
};
