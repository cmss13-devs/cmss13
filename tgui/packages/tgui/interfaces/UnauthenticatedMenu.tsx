import { useEffect, useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

const MAX_TIMEOUT = 10800000; // 3 hours

type AuthOption = {
  name: string;
  url: string;
};

type MenuData = {
  auth_options: AuthOption[];
};

export const UnauthenticatedMenu = () => {
  const { act } = useBackend();

  const [banned, setIsBanned] = useState<string>();
  const [browserOpened, setBrowserOpened] = useState(false);

  useEffect(() => {
    Byond.subscribeTo('logged_in', (payload: { access_code: string }) => {
      window.serverStorage.setItem(
        'access_code',
        JSON.stringify({
          time: Date.now(),
          code: payload.access_code,
        }),
      );
    });

    const code = window.serverStorage.getItem('access_code');
    if (code) {
      const json = JSON.parse(code);
      if (json.time > Date.now() - MAX_TIMEOUT) {
        act('recall_code', { code: json.code });
      }
    }

    Byond.subscribeTo('banned', (payload) => setIsBanned(payload.reason));
  }, []);

  return (
    <Window theme="crtgreen" fitted scrollbars={false}>
      <Window.Content height="100%">
        {browserOpened && (
          <>
            <Box position="absolute" top="10px" right="10px">
              <Button
                fontSize="24px"
                icon="xmark"
                color="red"
                onClick={() => {
                  act('close_browser');
                  setBrowserOpened(false);
                }}
                tooltip="Close authentication popup"
              />
            </Box>
            <Box
              position="absolute"
              top="50%"
              left="50%"
              width="750px"
              height="750px"
              style={{
                border: '5px solid #69E261',
                transform: 'translate(-50%, -52%)',
              }}
            />
          </>
        )}
        <Stack vertical height="100%" justify="space-around" align="center">
          <Stack.Item>
            <Stack align="center">
              <Stack.Item>
                {banned ? (
                  <Banned reason={banned} />
                ) : (
                  <Authentication setBrowserOpened={setBrowserOpened} />
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Authentication = (props: { readonly setBrowserOpened: (_) => void }) => {
  const { act, data } = useBackend<MenuData>();

  const { setBrowserOpened } = props;
  const { auth_options } = data;

  return (
    <Section title="Authenticate">
      <Stack vertical>
        <Stack.Item>
          You are not currently authenticated, so cannot log into the game.
        </Stack.Item>
        {auth_options.map((option) => (
          <Option
            key={option.name}
            option={option}
            setBrowserOpened={setBrowserOpened}
          />
        ))}
      </Stack>
    </Section>
  );
};

const Option = (props: {
  readonly option: AuthOption;
  readonly setBrowserOpened: (_) => void;
}) => {
  const { act } = useBackend<MenuData>();

  const { option, setBrowserOpened } = props;

  return (
    <Stack.Item>
      <Stack align="center">
        <Stack.Item grow>
          <Button
            fluid
            onClick={() => {
              act('open_browser', { auth_option: option.name });
              setBrowserOpened(true);
            }}
          >
            Click here to log in with {option.name}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="up-right-from-square"
            onClick={() =>
              act('open_ext_browser', { auth_option: option.name })
            }
            tooltip="Open in Browser"
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

const Banned = (props: { readonly reason: string }) => {
  const { reason } = props;
  return (
    <Section title="Authenticate">
      <Stack vertical>
        <Stack.Item>
          You are banned, and cannot currently log into the game.
        </Stack.Item>
        <Stack.Item>Reason: {reason}</Stack.Item>
        <Stack.Item>
          You will be automatically disconnected in ten seconds.
        </Stack.Item>
        <Stack.Item>Appeal this ban on the CM-SS13 forums.</Stack.Item>
      </Stack>
    </Section>
  );
};
