import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import {
  Button,
  Flex,
  Icon,
  Section,
  NoticeBox,
  Stack,
  Box,
} from '../components';
import { Window } from '../layouts';

export const FaxMachine = (_props, context) => {
  const { act, data } = useBackend(context);
  const { idcard } = data;
  const body = idcard ? <FaxMain /> : <FaxEmpty />;
  const windowWidth = idcard ? 600 : 400;
  const windowHeight = idcard ? 270 : 215;

  return (
    <Window width={windowWidth} height={windowHeight} theme="weyland">
      <Window.Content>{body}</Window.Content>
    </Window>
  );
};

const FaxMain = (props, context) => {
  return (
    <>
      <FaxId />
      <FaxSelect />
    </>
  );
};

const FaxId = (props, context) => {
  const { act, data } = useBackend(context);
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
          <Button
            icon="eject"
            mb="0"
            content={idcard}
            onClick={() => act('ejectid')}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            icon="sign-in-alt"
            fluid
            content={authenticated ? 'Log Out' : 'Log In'}
            selected={authenticated}
            onClick={() => act(authenticated ? 'logout' : 'auth')}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FaxSelect = (props, context) => {
  const { act, data } = useBackend(context);
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
            content="Select department to send to"
            disabled={!authenticated}
            onClick={() => act('select')}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            icon="building"
            fluid
            disabled={!authenticated}
            content={'Currently sending to : ' + target_department + '.'}
          />
        </Stack.Item>
      </Stack>
      <Box width="600px" height="5px" />
      <Stack>
        <Stack.Item>
          <Button
            icon="eject"
            fluid
            content={
              paper ? 'Currently sending : ' + paper_name : 'No paper loaded!'
            }
            onClick={() => act(paper ? 'ejectpaper' : 'insertpaper')}
            color={paper ? 'default' : 'grey'}
          />
        </Stack.Item>
        <Stack.Item grow>
          {(timeLeft < 0 && (
            <Button
              icon="paper-plane"
              fluid
              content={paper ? 'Send' : 'No paper loaded!'}
              onClick={() => act('send')}
              disabled={timeLeft > 0 || !paper || !authenticated}
            />
          )) || (
            <Button
              icon="window-close"
              fluid
              content={
                'Transmitters realigning, ' + timeLeft / 10 + ' seconds left.'
              }
              disabled={1}
            />
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FaxEmpty = (props, context) => {
  const { act, data } = useBackend(context);
  const { paper, paper_name } = data;
  return (
    <Section textAlign="center" flexGrow="1" fill>
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="red">
          <Icon name="times-circle" mb="0.5rem" size="5" color="red" />
          <br />
          No ID card detected.
          <br />
          {paper && (
            <Button
              icon="eject"
              content={'Eject ' + paper_name + '.'}
              onClick={() => act('ejectpaper')}
              disabled={!paper}
            />
          )}
        </Flex.Item>
      </Flex>
    </Section>
  );
};
