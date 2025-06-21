import { storage } from 'common/storage';
import { useEffect, useState } from 'react';

import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

const MAX_TIMEOUT = 10800000; // 3 hours

type MenuData = {
  auth_options: { name: string; url: string }[];
};

export const UnauthenticatedMenu = () => {
  const { act } = useBackend();

  const [banned, setIsBanned] = useState(false);

  useEffect(() => {
    Byond.subscribeTo('logged_in', (payload: { access_code: string }) => {
      storage.set('access_code', {
        time: Date.now(),
        code: payload.access_code,
      });
    });

    storage.get('access_code').then((value: { time: number; code: string }) => {
      if (value.time > Date.now() - MAX_TIMEOUT) {
        act('recall_code', { code: value.code });
      }
    });

    Byond.subscribeTo('banned', () => setIsBanned(true));
  }, []);

  return (
    <Window theme="crtgreen" fitted scrollbars={false}>
      <Window.Content height="100%">
        <Stack vertical height="100%" justify="space-around" align="center">
          <Stack.Item>
            <Stack align="center">
              <Stack.Item>
                {banned ? <Banned /> : <Authentication />}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Authentication = () => {
  const { act, data } = useBackend<MenuData>();

  const { auth_options } = data;

  return (
    <Section title="Authenticate">
      <Stack vertical>
        <Stack.Item>
          You are not currently authenticated, so cannot log into the game.
        </Stack.Item>
        {auth_options.map((option) => (
          <Stack.Item key={option.name}>
            <Stack align="center">
              <Stack.Item grow>
                <Button
                  onClick={() =>
                    act('open_browser', { auth_option: option.name })
                  }
                  fluid
                  textAlign="center"
                >
                  Click here to log in with {option.name}
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const Banned = () => {
  return (
    <Section title="Authenticate">
      <Stack vertical>
        <Stack.Item>
          You are banned, and cannot currently log into the game.
        </Stack.Item>
        <Stack.Item>
          You will be automatically disconnected in ten seconds.
        </Stack.Item>
        <Stack.Item>Appeal this ban on the CM-SS13 forums.</Stack.Item>
      </Stack>
    </Section>
  );
};
