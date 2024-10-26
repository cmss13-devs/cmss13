// -------------------------------------------------------------------- //
// Please ensure when updating this menu, changes are reflected in AresAdmin.js
// -------------------------------------------------------------------- //

import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Stack } from '../components';
import { Window } from '../layouts';

const PAGES = {
  login: () => Login,
  main: () => MainMenu,
};

export const WYComputer = (props) => {
  const { data } = useBackend();
  const { current_menu, last_page, access_text, logged_in } = data;
  const PageComponent = PAGES[current_menu]();

  let themecolor = 'crtyellow';
  if (current_menu === 'emergency') {
    themecolor = 'crtred';
  }

  return (
    <Window theme={themecolor} width={800} height={725}>
      {!!current_menu === 'Login' && (
        <Section>
          <Flex align="center">
            <Box>
              <Button
                icon="arrow-left"
                px="2rem"
                textAlign="center"
                tooltip="Go back"
                onClick={() => act('go_back')}
                disabled={last_page === current_menu}
              />
              <Button
                icon="house"
                ml="auto"
                mr="1rem"
                tooltip="Navigation Menu"
                onClick={() => act('home')}
              />
            </Box>

            <h3>
              {logged_in}, {access_text}
            </h3>

            <Button.Confirm
              icon="circle-user"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('logout')}
            >
              Logout
            </Button.Confirm>
          </Flex>
        </Section>
      )}

      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const Login = (props) => {
  const { act } = useBackend();

  return (
    <Flex
      direction="column"
      justify="center"
      align="center"
      height="100%"
      color="darkgrey"
      fontSize="2rem"
      mt="-3rem"
      bold
    >
      <Box fontFamily="monospace">WY Intranet Terminal</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 1.3.7</Box>
      <Box fontFamily="monospace">Copyright © 2182, Weyland Yutani Corp.</Box>

      <Button
        icon="id-card"
        width="30vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        mt="5rem"
        onClick={() => act('login')}
      >
        Login
      </Button>
    </Flex>
  );
};

const MainMenu = (props) => {
  const { data, act } = useBackend();
  const { logged_in, access_text, last_page, current_menu, access_level } =
    data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={last_page === current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
              disabled={current_menu === 'main'}
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Logout
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">Navigation Menu</h1>

        {access_level >= 4 && (
          <Stack>
            <Stack.Item grow>
              <h3>Intranet Tier 4</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="View the recent logins."
                icon="users"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_access')}
              >
                View Access Log
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Section>
      {access_level >= 3 && (
        <Section>
          <h1 align="center">Security Protocols</h1>
          <Stack>
            <Stack.Item grow>
              <Button.Confirm
                align="center"
                tooltip="Activate/Deactivate the concealed Room Divider."
                icon="lock"
                color="red"
                ml="auto"
                px="2rem"
                width="100%"
                bold
                onClick={() => act('unlock_divider')}
              >
                Room Divider
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item grow>
              <Button
                align="center"
                tooltip="Release stored CN20-X nerve gas from security vents."
                icon="wind"
                color="red"
                ml="auto"
                px="2rem"
                width="100%"
                bold
                onClick={() => act('page_core_sec')}
                disabled={access_level}
              >
                Nerve Gas Control
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      )}
    </>
  );
};
