import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import {
  Button,
  Flex,
  Icon,
  Section,
  Box,
  NoticeBox,
} from '../components';
import { Window } from '../layouts';

export const FaxMachine = (_props, context) => {
  const { act, data } = useBackend(context);
  const {
    department,
    network,
    idcard,
    paper,
    authenticated,
    target_department,
    worldtime,
    nextfaxtime,
    faxcooldown,
  } = data;
  const body = idcard ? <FaxMain /> : <FaxEmpty />;
  const windowHeight = idcard ? 500 : 150;

  return (
    <Window
      width={600}
      height={windowHeight}
      theme="weyland">
      <Window.Content scrollable>
        {body}
      </Window.Content>
    </Window>
  );
};

const FaxMain = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    department,
    network,
    idcard,
    paper,
    authenticated,
    target_department,
    worldtime,
    nextfaxtime,
    faxcooldown,
  } = data;
  return (
    <>
      <FaxId />
      {authenticated ? <FaxPaper /> : null}
      {authenticated ? <FaxSelect /> : null}
    </>
  );
};

const FaxId = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    department,
    network,
    idcard,
    paper,
    authenticated,
    target_department,
    worldtime,
    nextfaxtime,
    faxcooldown,
  } = data;
  return (
    <Section title="Authentication">
      <NoticeBox color="grey" textAlign="center">
        This machine is currently operating on the {network}
        <br />
        and is sending from {department}
      </NoticeBox>
      <Flex direction={"row"}>
        <Flex.Item>
          <Button
            icon="eject"
            fluid
            content={idcard}
            onClick={() => act('eject')}
          />
        </Flex.Item>
        <Flex.Item>
          <Button
            icon="sign-in-alt"
            fluid
            content={authenticated ? "log out" : "log in"}
            selected={authenticated}
            onClick={() =>
              act(authenticated ? 'logout' : 'auth')}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const FaxSelect = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    department,
    network,
    idcard,
    paper,
    authenticated,
    target_department,
    worldtime,
    nextfaxtime,
    faxcooldown,
  } = data;

  const timeLeft = (nextfaxtime - worldtime);
  const timeLeftPct = timeLeft / faxcooldown;


  return (
    <Section title="Department selection">
      <Button
        icon="eject"
        content="select department to send to"
        onClick={() => act('select')}
      />
      Currently sending to {target_department ? target_department : "nobody"}
      <Box>
        <Button
          icon="eject"
          content={paper ? (timeLeft > 0 ? "Transmitters realigning " + (timeLeft / 10) + " seconds left" :"send") : "No paper loaded!"}
          onClick={() => act('send')}
          disabled={timeLeft > 0 || !paper}
        />
      </Box>
    </Section>
  );
};

const FaxPaper = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    department,
    network,
    idcard,
    paper,
    authenticated,
    target_department,
    worldtime,
    nextfaxtime,
    faxcooldown,
  } = data;

  return (
    <Section title="Paper">
      <Box>
        {paper
          ? "Currently sending :" + { paper }
          : "No paper loaded"}
        <Button
          icon="eject"
          content={paper ? "Eject" : "No paper loaded!"}
          onClick={() => act('ejectpaper')}
          disabled={!paper}
        />
      </Box>
    </Section>
  );
};

const FaxEmpty = (props, context) => {
  return (
    <Section textAlign="center" flexGrow="1">
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="label">
          <Icon name="times-circle" mb="0.5rem" size="5" color="red" />
          <br />
          No ID card detected.
        </Flex.Item>
      </Flex>
    </Section>
  );
};
