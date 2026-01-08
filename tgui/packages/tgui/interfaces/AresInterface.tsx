// -------------------------------------------------------------------- //
// Please ensure when updating this menu, changes are reflected in AresAdmin.js
// -------------------------------------------------------------------- //

import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Dropdown, Flex, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

import type { DataCoreData } from './common/commonTypes';

type Data = DataCoreData & {
  local_current_menu: string;
  local_last_page: string;
  local_logged_in: string;
  local_sudo: BooleanLike;
  local_access_text: string;
  local_access_level: number;
  local_spying_conversation: string[];
  local_printer_cooldown: BooleanLike;
  local_active_convo: string[];
  local_active_ref: string;
};

const PAGES = {
  login: () => Login,
  main: () => MainMenu,
  announcements: () => AnnouncementLogs,
  bioscans: () => BioscanLogs,
  bombardments: () => BombardmentLogs,
  apollo: () => ApolloLog,
  access_log: () => AccessLogs,
  delete_log: () => DeletionLogs,
  flight_log: () => FlightLogs,
  talking: () => ARESTalk,
  deleted_talks: () => DeletedTalks,
  read_deleted: () => ReadingTalks,
  security: () => Security,
  requisitions: () => Requisitions,
  emergency: () => Emergency,
  tech_log: () => TechLogs,
  core_security: () => CoreSec,
  talking_log: () => ActiveTalks,
};

export const AresInterface = (props) => {
  const { data } = useBackend<Data>();
  const { local_current_menu, local_sudo } = data;
  const PageComponent = PAGES[local_current_menu]();

  let themecolor = 'crtblue';
  if (local_sudo) {
    themecolor = 'crtred';
  } else if (local_current_menu === 'emergency') {
    themecolor = 'crtred';
  } else if (local_current_menu === 'core_security') {
    themecolor = 'crtred';
  }

  return (
    <Window theme={themecolor} width={800} height={725}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const Login = (props) => {
  const { act } = useBackend<Data>();

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
      <Box fontFamily="monospace">ARES v3.2 Interface</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 8.3.4</Box>
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
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    local_access_level,
    local_sudo,
    faction_options,
    sentry_setting,
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
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
              disabled={local_current_menu === 'main'}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
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

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 1</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltip="Access the AI Announcement logs."
              icon="bullhorn"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_announcements')}
            >
              Announcement Logs
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltip="Direct communication 1:1 with ARES."
              icon="comments"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_1to1')}
            >
              ARES Communication
            </Button>
          </Stack.Item>
        </Stack>
        {local_access_level >= 2 && (
          <Stack>
            <Stack.Item grow>
              <h3>Access Level 2</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Read the Dropship Flight Control Records."
                icon="jet-fighter-up"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_flight')}
              >
                Flight Records
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Access the Bioscan records."
                icon="eye"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_bioscans')}
              >
                Bioscan Logs
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Access Orbital Bombardment logs."
                icon="meteor"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_bombardments')}
              >
                Bombardment Logs
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {local_access_level >= 3 && (
          <Stack>
            <Stack.Item grow>
              <h3>Access Level 3</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Read the Security Updates."
                icon="file-shield"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_security')}
              >
                Security Updates
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Read the Apollo Link logs."
                icon="clipboard"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_apollo')}
              >
                View Apollo Log
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {local_access_level >= 5 && (
          <Stack>
            <Stack.Item grow>
              <h3>Access Level 5</h3>
            </Stack.Item>
            <Stack.Item>
              <Button.Confirm
                tooltip="Access emergency protocols."
                icon="shield"
                color="red"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_emergency')}
              >
                Emergency Protocols
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Review the ASRS Audit Log."
                icon="magnifying-glass-dollar"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_requisitions')}
              >
                ASRS Audit Log
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Review the Intel Tech Log."
                icon="magnifying-glass-chart"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_tech')}
              >
                Tech Control Log
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {local_access_level >= 6 && (
          <Stack>
            <Stack.Item grow>
              <h3>Access Level 6</h3>
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
        {local_access_level >= 9 && (
          <Stack>
            <Stack.Item grow>
              <h3>Access Level 9</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="View the deletion log."
                icon="sd-card"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_deleted')}
              >
                View Deletion Log
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="View the active 1:1 conversations with ARES."
                icon="sd-card"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_records_1to1')}
              >
                View Active 1:1&apos;s
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="View the deleted 1:1 conversations with ARES."
                icon="sd-card"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_deleted_1to1')}
              >
                View Deleted 1:1&apos;s
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {local_access_level >= 11 && (
          <Stack>
            <Stack.Item grow>
              <h3>Maintenance Access</h3>
            </Stack.Item>
            {local_sudo ? (
              <Stack.Item>
                <Button
                  tooltip="Logout of Sudo mode."
                  icon="user-secret"
                  ml="auto"
                  px="2rem"
                  width="25vw"
                  bold
                  onClick={() => act('sudo_logout')}
                >
                  Sudo Logout
                </Button>
              </Stack.Item>
            ) : (
              <Stack.Item>
                <Button
                  tooltip="Remote Login."
                  icon="user-secret"
                  ml="auto"
                  px="2rem"
                  width="25vw"
                  bold
                  onClick={() => act('sudo')}
                >
                  Sudo Login
                </Button>
              </Stack.Item>
            )}
          </Stack>
        )}
      </Section>
      {(local_access_level === 3 || local_access_level >= 6) && (
        <Section>
          <h1 style={{ textAlign: 'center' }}>Core Security Protocols</h1>
          <Stack>
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
              >
                Nerve Gas Control
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button.Confirm
                align="center"
                tooltip="Activate/Deactivate the AI Core Lockdown."
                icon="lock"
                color="red"
                ml="auto"
                px="2rem"
                width="100%"
                bold
                onClick={() => act('security_lockdown')}
              >
                AI Core Lockdown
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item ml="0" mr="0">
              <Dropdown
                options={faction_options}
                selected={sentry_setting}
                color="red"
                onSelected={(value) =>
                  act('update_sentries', { chosen_iff: value })
                }
                width="90px"
                disabled={local_access_level < 9}
              />
            </Stack.Item>
          </Stack>
        </Section>
      )}
    </>
  );
};

const AnnouncementLogs = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_announcement,
    local_access_level,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Announcement Logs</h1>

        {!!records_announcement.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item width="10rem" grow bold>
              Title
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              Details
            </Flex.Item>
          </Flex>
        )}
        {records_announcement.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="10rem" grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="Delete Record"
                  disabled={local_access_level < 4}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const BioscanLogs = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_bioscan,
    local_access_level,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Bioscan Logs</h1>

        {!!records_bioscan.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item grow bold>
              Title
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              Details
            </Flex.Item>
          </Flex>
        )}
        {records_bioscan.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="Delete Record"
                  disabled={local_access_level < 5}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const BombardmentLogs = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_bombardment,
    local_access_level,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Orbital Bombardment Logs</h1>

        {!!records_bombardment.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item grow bold>
              Warhead
            </Flex.Item>
            <Flex.Item grow bold>
              User
            </Flex.Item>
            <Flex.Item width="30rem" textAlign="center">
              Details
            </Flex.Item>
          </Flex>
        )}
        {records_bombardment.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item>{record.user}</Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="Delete Record"
                  disabled={local_access_level < 5}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const ApolloLog = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    apollo_log,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Apollo Log</h1>

        {apollo_log.map((apollo_message, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{apollo_message}</Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const AccessLogs = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    ares_access_log,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Access Log</h1>

        {ares_access_log.map((login, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{login}</Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const DeletionLogs = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_deletion,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Deletion Log</h1>

        {!!records_deletion.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Deletion Time
            </Flex.Item>
            <Flex.Item grow bold>
              Deleted by
            </Flex.Item>
            <Flex.Item grow bold>
              Title
            </Flex.Item>
            <Flex.Item width="30rem" textAlign="center">
              Details
            </Flex.Item>
          </Flex>
        )}
        {records_deletion.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="10rem">{record.user}</Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const ARESTalk = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    local_active_convo,
    local_active_ref,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>ARES Communication</h1>
      </Section>

      <Section align="center">
        {!local_active_convo.length && (
          <Button
            icon="pen"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('new_conversation')}
          >
            New Conversation
          </Button>
        )}
        {local_active_convo.map((message, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{message}</Flex.Item>
            </Flex>
          );
        })}
        {!!local_active_convo.length && (
          <Button
            icon="pen"
            ml="auto"
            px="2rem"
            bold
            onClick={() =>
              act('message_ares', { passed_active_convo: local_active_ref })
            }
          >
            Send Message
          </Button>
        )}
      </Section>
      <Section align="center">
        <Button.Confirm
          icon="trash"
          tooltip="Clears the conversation. Please note, your 1:1 conversation is only visible to you."
          width="30vw"
          textAlign="center"
          fontSize="1.5rem"
          bold
          onClick={() =>
            act('clear_conversation', { passed_active_convo: local_active_ref })
          }
          disabled={!local_active_convo.length}
        >
          Clear Conversation
        </Button.Confirm>
      </Section>
    </>
  );
};

const DeletedTalks = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    deleted_discussions,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Deletion 1:1 Log</h1>
        {!!deleted_discussions.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Deletion Time
            </Flex.Item>
            <Flex.Item grow bold>
              Title
            </Flex.Item>
            <Flex.Item width="30rem" textAlign="center">
              Read Record
            </Flex.Item>
          </Flex>
        )}
        {deleted_discussions.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                <Button
                  icon="eye"
                  tooltip="Read Conversation"
                  onClick={() => act('read_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const ActiveTalks = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_discussions,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Active 1:1 Records</h1>
        {!!records_discussions.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Start Time
            </Flex.Item>
            <Flex.Item grow bold>
              Title
            </Flex.Item>
            <Flex.Item width="30rem" textAlign="center">
              Read Record
            </Flex.Item>
          </Flex>
        )}
        {records_discussions.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                <Button
                  icon="eye"
                  tooltip="Read Conversation"
                  onClick={() => act('read_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const ReadingTalks = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    local_spying_conversation,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Accessed 1:1 Conversation</h1>
        {local_spying_conversation.map((message, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{message}</Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const Requisitions = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_requisition,
    local_printer_cooldown,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>ASRS Audit Log</h1>
        <h4 style={{ alignContent: 'center' }}>
          <Button
            icon="print"
            px="2rem"
            textAlign="center"
            tooltip="Print Audit Log"
            onClick={() => act('print_req')}
            disabled={local_printer_cooldown}
          >
            Print Audit Log
          </Button>
        </h4>

        {!!records_requisition.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item grow bold>
              User
            </Flex.Item>
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
              Source
            </Flex.Item>
            <Flex.Item bold width="30rem" textAlign="center">
              Order
            </Flex.Item>
          </Flex>
        )}
        {records_requisition.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item grow italic>
                {record.user}
              </Flex.Item>
              <Flex.Item width="9rem" shrink="0" mr="1rem">
                {record.title}
              </Flex.Item>
              <Flex.Item width="30rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const FlightLogs = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_flight,
    local_access_level,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Flight Control Logs</h1>
        {!!records_flight.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item width="10rem" grow bold>
              User
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              Details
            </Flex.Item>
          </Flex>
        )}
        {records_flight.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="10rem" grow italic>
                {record.user}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="Delete Record"
                  disabled={local_access_level < 4}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const Security = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_security,
    local_access_level,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Security Updates</h1>
        {!!records_security.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item width="10rem" grow bold>
              Title
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              Details
            </Flex.Item>
          </Flex>
        )}
        {records_security.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="10rem" grow italic>
                {record.title}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="Delete Record"
                  disabled={local_access_level < 8}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const Emergency = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    alert_level,
    worldtime,
    distresstimelock,
    distresstime,
    quarterstime,
    evac_status,
    mission_failed,
    nuketimelock,
    nuke_available,
  } = data;
  const minimumEvacTime = worldtime > distresstimelock;
  const distressCooldown = worldtime < distresstime;
  const quartersCooldown = worldtime < quarterstime;
  const canQuarters = !quartersCooldown;
  let quarters_reason = 'Call for General Quarters.';
  if (quartersCooldown) {
    quarters_reason =
      'It has not been long enough since the last General Quarters call.';
  }
  const canDistress = alert_level === 2 && !distressCooldown && minimumEvacTime;
  let distress_reason = 'Launch a Distress Beacon.';
  if (alert_level === 3) {
    distress_reason = 'Self-destruct in progress. Beacon disabled.';
  } else if (alert_level !== 2) {
    distress_reason = 'Ship is not under an active emergency.';
  } else if (distressCooldown) {
    distress_reason = 'Beacon is currently on cooldown.';
  } else if (!minimumEvacTime) {
    distress_reason = "It's too early to launch a distress beacon.";
  }

  const canEvac = evac_status === 0 && alert_level >= 2;
  let evac_reason = 'Begin evacuation procedures. Authorise Lifeboats.';
  if (alert_level !== 2) {
    evac_reason = 'Ship is not under an active emergency.';
  } else if (evac_status === 1) {
    evac_reason = 'Evacuation initiating.';
  } else if (evac_status === 2) {
    evac_reason = 'Evacuation in progress.';
  } else if (evac_status === 3) {
    evac_reason = 'Evacuation complete.';
  }

  const minimumNukeTime = worldtime > nuketimelock;
  const canNuke =
    nuke_available && !mission_failed && evac_status === 0 && minimumNukeTime;
  let nuke_reason =
    'Request a nuclear device to be authorized by USCM High Command.';
  if (!nuke_available) {
    nuke_reason =
      'No nuclear ordnance is available during this operation, or one has already been provided.';
  } else if (mission_failed) {
    nuke_reason =
      'You have already lost the objective, you cannot use a nuclear device aboard the ship!';
  } else if (evac_status !== 0) {
    nuke_reason = 'You cannot use a nuclear device while abandoning the ship!';
  } else if (!minimumNukeTime) {
    nuke_reason = 'It is too soon to use a nuclear device. Keep fighting!';
  }

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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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

      <h1 style={{ textAlign: 'center' }}>Emergency Protocols</h1>
      <Flex align="center" justify="center" height="50%" direction="column">
        <Button.Confirm
          tooltip={quarters_reason}
          icon="triangle-exclamation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          onClick={() => act('general_quarters')}
          disabled={!canQuarters}
        >
          Call General Quarters
        </Button.Confirm>
        <Button.Confirm
          tooltip={evac_reason}
          icon="shuttle-space"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          onClick={() => act('evacuation_start')}
          disabled={!canEvac}
        >
          Initiate Evacuation
        </Button.Confirm>
        <Button.Confirm
          tooltip={distress_reason}
          icon="circle-exclamation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          onClick={() => act('distress')}
          disabled={!canDistress}
        >
          Launch Distress Beacon
        </Button.Confirm>
        <Button.Confirm
          tooltip={nuke_reason}
          icon="circle-radiation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          onClick={() => act('nuclearbomb')}
          disabled={!canNuke}
        >
          Request Nuclear Device
        </Button.Confirm>
      </Flex>
    </>
  );
};

const TechLogs = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    records_tech,
    local_access_level,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Tech Control Logs</h1>
        {!!records_tech.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item width="15rem" grow bold>
              Authenticator
            </Flex.Item>
            <Flex.Item width="40rem" textAlign="center">
              Details
            </Flex.Item>
          </Flex>
        )}
        {records_tech.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {record.time}
              </Flex.Item>
              <Flex.Item width="15rem" grow italic>
                {record.user}
              </Flex.Item>
              {!!record.tier_changer && (
                <Flex.Item
                  width="40rem"
                  ml="1rem"
                  shrink="0"
                  textAlign="center"
                  color="red"
                >
                  {record.details}
                </Flex.Item>
              )}
              {!record.tier_changer && (
                <Flex.Item
                  width="40rem"
                  ml="1rem"
                  shrink="0"
                  textAlign="center"
                >
                  {record.details}
                </Flex.Item>
              )}

              <Flex.Item ml="1rem">
                <Button.Confirm
                  icon="trash"
                  tooltip="Delete Record"
                  disabled={local_access_level < 4 || !!record.tier_changer}
                  onClick={() => act('delete_record', { record: record.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const CoreSec = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_access_level,
    local_last_page,
    local_current_menu,
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
              disabled={local_last_page === local_current_menu}
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
            {local_logged_in}, {local_access_text}
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
        <h1 style={{ textAlign: 'center' }}>Core Security Protocols</h1>
      </Section>
      <Section>
        <h1 style={{ textAlign: 'center' }}>Nerve Gas Release</h1>
        {security_vents.map((vent, i) => {
          return (
            <Button.Confirm
              key={i}
              align="center"
              icon="wind"
              tooltip="Release Gas"
              width="100%"
              disabled={
                (local_access_level < 5 && local_access_level !== 3) ||
                !vent.available
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
