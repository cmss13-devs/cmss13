// -------------------------------------------------------------------- //
// Please ensure when updating this menu, changes are reflected in AresAdmin.js
// -------------------------------------------------------------------- //

import type { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Stack } from '../components';
import { Window } from '../layouts';
import type { VentRecord } from './common/commonTypes';

const PAGES = {
  login: () => Login,
  main: () => MainMenu,
  vents: () => SecVents,
};

type Data = {
  current_menu: string;
  last_page: string;
  access_text: string;
  logged_in: string;
  access_level: number;
  has_hidden_cell: BooleanLike;
  has_room_divider: BooleanLike;
  open_divider: BooleanLike;
  open_cell_door: BooleanLike;
  open_cell_shutters: BooleanLike;
  cell_flash_cooldown: number;
  sec_flash_cooldown: number;
  security_vents: VentRecord[];
};

export const WYComputer = (props) => {
  const { data, act } = useBackend<Data>();
  const { current_menu, last_page, access_text, logged_in } = data;
  const PageComponent = PAGES[current_menu]();

  return (
    <Window theme="weyland" width={800} height={725}>
      {current_menu === 'Login' && (
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
  const { data, act } = useBackend<Data>();
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
  const { data, act } = useBackend<Data>();
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    access_level,
    has_hidden_cell,
    has_room_divider,
    open_divider,
    open_cell_door,
    open_cell_shutters,
    cell_flash_cooldown,
    sec_flash_cooldown,
  } = data;

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
        <h1 style={{ textAlign: 'center' }}>Navigation Menu</h1>

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
      {(access_level === 3 || access_level >= 5) && (
        <Section>
          <h1 style={{ textAlign: 'center' }}>Security Protocols</h1>
          {!!has_room_divider && !has_hidden_cell && (
            <Button.Confirm
              align="center"
              tooltip="Activate/Deactivate the concealed Room Divider."
              icon="fingerprint"
              color={open_divider ? 'green' : 'red'}
              ml="auto"
              px="2rem"
              width="100%"
              bold
              onClick={() => act('unlock_divider')}
              disabled={!has_room_divider}
            >
              Room Divider
            </Button.Confirm>
          )}
          <Button.Confirm
            align="center"
            tooltip="Activate any security flashbulbs."
            icon="lightbulb"
            color="yellow"
            ml="auto"
            px="2rem"
            width="100%"
            bold
            onClick={() => act('security_flash')}
            disabled={sec_flash_cooldown}
          >
            Security Flash
          </Button.Confirm>
          {(access_level === 3 || access_level >= 6) && (
            <Button
              align="center"
              tooltip="Release stored CN20-X nerve gas from security vents."
              icon="wind"
              color="red"
              ml="auto"
              px="2rem"
              width="100%"
              bold
              onClick={() => act('page_vents')}
            >
              Nerve Gas Control
            </Button>
          )}
        </Section>
      )}
      {(access_level === 3 || access_level >= 5) && !!has_hidden_cell && (
        <Section>
          <h1 style={{ textAlign: 'center' }}>Hidden Cell Controls</h1>
          {!!has_room_divider && (
            <Button.Confirm
              align="center"
              tooltip="Activate/Deactivate the concealed Room Divider."
              icon="fingerprint"
              color={open_divider ? 'green' : 'red'}
              ml="auto"
              px="2rem"
              width="100%"
              bold
              onClick={() => act('unlock_divider')}
              disabled={!has_room_divider}
            >
              Room Divider
            </Button.Confirm>
          )}
          <Button.Confirm
            align="center"
            tooltip="Open/Close the cell security shutters."
            icon={open_cell_shutters ? 'lock-open' : 'lock'}
            color={open_cell_shutters ? 'green' : 'red'}
            ml="auto"
            px="2rem"
            width="100%"
            bold
            onClick={() => act('cell_shutters')}
            disabled={!has_hidden_cell}
          >
            Door Shutters
          </Button.Confirm>
          <Button.Confirm
            align="center"
            tooltip="Open/Close the cell door."
            icon={open_cell_door ? 'door-open' : 'door-closed'}
            color={open_cell_door ? 'green' : 'red'}
            ml="auto"
            px="2rem"
            width="100%"
            bold
            onClick={() => act('cell_door')}
            disabled={!has_hidden_cell}
          >
            Door Control
          </Button.Confirm>
          <Button.Confirm
            align="center"
            tooltip="Activate the cell's flashbulb."
            icon="lightbulb"
            color="yellow"
            ml="auto"
            px="2rem"
            width="100%"
            bold
            onClick={() => act('cell_flash')}
            disabled={cell_flash_cooldown}
          >
            Cell Flash
          </Button.Confirm>
        </Section>
      )}
    </>
  );
};

const SecVents = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    logged_in,
    access_text,
    access_level,
    last_page,
    current_menu,
    security_vents,
  } = data;

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
        <h1 style={{ textAlign: 'center' }}>Security Vent Controls</h1>
      </Section>
      <Section>
        {security_vents.map((vent, i) => {
          return (
            <Button.Confirm
              key={i}
              align="center"
              icon="wind"
              tooltip="Release Gas"
              width="100%"
              disabled={
                (access_level < 6 && access_level !== 3) || !vent.available
              }
              onClick={() => act('trigger_vent', { vent: vent.ref })}
            >
              {vent.vent_tag}
            </Button.Confirm>
          );
        })}
      </Section>
    </>
  );
};
