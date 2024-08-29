import { useBackend } from '../backend';
import { Box, Button, Dropdown, Flex, Section, Stack } from '../components';
import { Window } from '../layouts';

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
  admin_access_log: () => AdminAccessLogs,
  access_management: () => AccessManagement,
  maintenance_management: () => MaintManagement,
};

export const AresAdmin = (props) => {
  const { data } = useBackend();
  const { local_current_menu, ares_sudo } = data;
  const PageComponent = PAGES[local_current_menu]();

  let themecolor = 'crtyellow';
  if (ares_sudo >= 1) {
    themecolor = 'crtred';
  } else if (local_current_menu === 'emergency') {
    themecolor = 'crtred';
  } else if (local_current_menu === 'core_security') {
    themecolor = 'crtred';
  }

  return (
    <Window theme={themecolor} width={950} height={725}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const { data } = useBackend();
const { is_pda } = data;
let remotelock = !is_pda;
let remotetip = 'You cannot do this via remote console.';
let deletetip = remotetip;
if (!remotelock) {
  remotetip = '';
  deletetip = 'Delete Record';
}

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
      <Box fontFamily="monospace">ARES v3.2 Remote Interface</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 4.5.2</Box>
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
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    ares_sudo,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
              disabled={local_current_menu === 'main'}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 1</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
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
              tooltipPosition="top"
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

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 2</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
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
              tooltipPosition="top"
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
              tooltipPosition="top"
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

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 3</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
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
              tooltipPosition="top"
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

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 5</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
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
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
              tooltip="Review the ASRS Audit Log."
              icon="cart-shopping"
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
              tooltipPosition="top"
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

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 6</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
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
        <Stack>
          <Stack.Item grow>
            <h3>Access Level 9</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
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
              tooltipPosition="top"
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
        <Stack>
          <Stack.Item grow>
            <h3>Maintenance Access</h3>
          </Stack.Item>
          {ares_sudo === 0 && (
            <Stack.Item>
              <Button
                icon="user-secret"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('sudo')}
                disabled={remotelock}
                tooltipPosition="top"
                tooltip={remotetip}
              >
                Sudo Login
              </Button>
            </Stack.Item>
          )}
          {ares_sudo >= 1 && (
            <Stack.Item>
              <Button
                icon="user-secret"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('sudo_logout')}
                disabled={!sudo}
                tooltipPosition="top"
                tooltip="Sudo Logout"
              >
                Sudo Logout
              </Button>
            </Stack.Item>
          )}
        </Stack>
      </Section>
      <Section align="center">
        <h1 align="center">Core Security Protocols</h1>
        <Button
          align="center"
          tooltipPosition="top"
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

        <Stack>
          <Stack.Item grow mr="0">
            <Button.Confirm
              align="center"
              tooltip="Activate/Deactivate the AI Core Lockdown."
              icon="lock"
              color="red"
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
              tooltip="Change core sentries IFF settings."
            />
          </Stack.Item>
        </Stack>
      </Section>
      <Section>
        <Stack>
          <Stack.Item grow>
            <h3>Remote Admin</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="satellite"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('bioscan')}
              disabled={remotelock}
              tooltipPosition="top"
              tooltip="Trigger an immediate bioscan for diagnostics."
            >
              Bioscan
            </Button>
          </Stack.Item>
        </Stack>
      </Section>
      <Section>
        {remotelock && (
          <Stack>
            <Stack.Item grow>
              <h3>Remote Admin</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltipPosition="top"
                tooltip="View which admins have been using ARES."
                icon="user-secret"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                onClick={() => act('page_admin_list')}
              >
                Remote Access Log
              </Button>
            </Stack.Item>
          </Stack>
        )}
        <Stack>
          <Stack.Item grow>
            <h3>ARES Actions</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
              tooltip="View and update access tickets."
              icon="user-tag"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_access_management')}
            >
              Access Tickets
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              tooltipPosition="top"
              tooltip="View, create and update maintenance tickets."
              icon="user-tag"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_maint_management')}
            >
              Maintenance Tickets
            </Button>
          </Stack.Item>
        </Stack>
      </Section>
    </>
  );
};

const AnnouncementLogs = (props) => {
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    records_announcement,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Announcement Logs</h1>

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
                  onClick={() => act('delete_record', { record: record.ref })}
                  disabled={remotelock}
                  tooltipPosition="top"
                  tooltip={deletetip}
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    records_bioscan,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Bioscan Logs</h1>

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
                  onClick={() => act('delete_record', { record: record.ref })}
                  disabled={remotelock}
                  tooltipPosition="top"
                  tooltip={deletetip}
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    records_bombardment,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Orbital Bombardment Logs</h1>

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
                  onClick={() => act('delete_record', { record: record.ref })}
                  disabled={remotelock}
                  tooltipPosition="top"
                  tooltip={deletetip}
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    apollo_log,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Apollo Log</h1>

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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    ares_access_log,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Access Log</h1>

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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    records_deletion,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Deletion Log</h1>

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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    local_active_convo,
    local_active_ref,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">ARES Communication</h1>
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
          <Stack justify="center">
            <Stack.Item>
              <Button
                icon="pen"
                ml="auto"
                px="2rem"
                bold
                onClick={() =>
                  act('ares_reply', { local_active_convo: local_active_ref })
                }
              >
                Reply as ARES
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="pen"
                ml="auto"
                px="2rem"
                bold
                tooltipPosition="top"
                tooltip="Send a message as if you were the person logged in at the interface."
                onClick={() =>
                  act('fake_message_ares', {
                    local_active_convo: local_active_ref,
                  })
                }
              >
                Send Fake Message
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Section>
      <Section align="center">
        <Button.Confirm
          icon="trash"
          tooltipPosition="top"
          tooltip="Clears the conversation. Please note, your 1:1 conversation is only visible to you."
          width="30vw"
          textAlign="center"
          fontSize="1.5rem"
          bold
          onClick={() =>
            act('clear_conversation', { local_active_convo: local_active_ref })
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    deleted_discussions,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Deletion Log</h1>
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
                  tooltipPosition="top"
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    local_deleted_conversation,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Deleted Conversation</h1>
        {local_deleted_conversation.map((message, i) => {
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    records_requisition,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">ASRS Audit Log</h1>
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    records_flight,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Flight Control Logs</h1>
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
                  onClick={() => act('delete_record', { record: record.ref })}
                  disabled={remotelock}
                  tooltipPosition="top"
                  tooltip={deletetip}
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    records_security,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Security Updates</h1>
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
                  onClick={() => act('delete_record', { record: record.ref })}
                  disabled={remotelock}
                  tooltipPosition="top"
                  tooltip={deletetip}
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    local_admin_login,
    worldtime,
    alert_level,
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
  if (remotelock) {
    distress_reason = remotetip;
  } else if (alert_level === 3) {
    distress_reason = 'Self-destruct in progress. Beacon disabled.';
  } else if (alert_level !== 2) {
    distress_reason = 'Ship is not under an active emergency.';
  } else if (distressCooldown) {
    distress_reason = 'Beacon is currently on cooldown.';
  } else if (!minimumEvacTime) {
    distress_reason = "It's too early to launch a distress beacon.";
  }

  const canEvac = (evac_status === 0, alert_level >= 2);
  let evac_reason = 'Begin evacuation procedures. Authorise Lifeboats.';
  if (remotelock) {
    evac_reason = remotetip;
  } else if (alert_level !== 2) {
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
    (nuke_available, !mission_failed, evac_reason === 0, minimumNukeTime);
  let nuke_reason =
    'Request a nuclear device to be authorized by USCM High Command.';
  if (remotelock) {
    nuke_reason = remotetip;
  } else if (!nuke_available) {
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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

      <h1 align="center">Emergency Protocols</h1>
      <Flex align="center" justify="center" height="50%" direction="column">
        <Button.Confirm
          tooltipPosition="top"
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
          tooltipPosition="top"
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
          disabled={remotelock || !canEvac}
        >
          Initiate Evacuation
        </Button.Confirm>
        <Button.Confirm
          tooltipPosition="top"
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
          disabled={remotelock || !canDistress}
        >
          Launch Distress Beacon
        </Button.Confirm>
        <Button.Confirm
          tooltipPosition="top"
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
          disabled={remotelock || !canNuke}
        >
          Request Nuclear Device
        </Button.Confirm>
      </Flex>
    </>
  );
};

const TechLogs = (props) => {
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    records_tech,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Tech Control Logs</h1>
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
                  onClick={() => act('delete_record', { record: record.ref })}
                  disabled={remotelock}
                  tooltipPosition="top"
                  tooltip={deletetip}
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
  const { data, act } = useBackend();
  const {
    ares_logged_in,
    ares_access_text,
    local_last_page,
    local_current_menu,
    security_vents,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {ares_logged_in}, {ares_access_text}
            <br />
            Remote Admin: {local_admin_login}
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
        <h1 align="center">Core Security Protocols</h1>
      </Section>
      <Section>
        <h1 align="center">Nerve Gas Release</h1>
        {security_vents.map((vent, i) => {
          return (
            <Button.Confirm
              key={i}
              align="center"
              icon="wind"
              tooltipPosition="top"
              tooltip="Release Gas"
              width="100%"
              disabled={!vent.available}
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

// -------------------------------------------------------------------- //
// Anything below this line is exclusive to the Admin Remote Interface.
// -------------------------------------------------------------------- //

const AdminAccessLogs = (props) => {
  const { data, act } = useBackend();
  const {
    local_last_page,
    local_current_menu,
    admin_access_log,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>Remote Admin: {local_admin_login}</h3>

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
        <h1 align="center">Access Log</h1>

        {admin_access_log.map((login, i) => {
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

const AccessManagement = (props) => {
  const { data, act } = useBackend();
  const {
    local_last_page,
    local_current_menu,
    access_tickets,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>Remote Admin: {local_admin_login}</h3>

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
        <h1 align="center">Access Ticket Management</h1>
        {!!access_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0" mr="1.5rem">
              ID
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item width="8rem" mr="1rem" bold>
              Submitter
            </Flex.Item>
            <Flex.Item width="8rem" mr="1rem" bold>
              For
            </Flex.Item>
            <Flex.Item width="30rem" bold>
              Reason
            </Flex.Item>
          </Flex>
        )}
        {access_tickets.map((ticket, i) => {
          let can_update = 'Yes';
          if (ticket.lock_status === 'CLOSED') {
            can_update = 'No';
          }
          let view_status = 'Ticket is pending assignment.';
          let view_icon = 'circle-question';
          let update_tooltip = 'Grant Access';
          if (ticket.status === 'rejected') {
            view_status = 'Ticket has been rejected.';
            view_icon = 'circle-xmark';
            update_tooltip = 'Ticket rejected. No further changes possible.';
          } else if (ticket.status === 'cancelled') {
            view_status = 'Ticket was cancelled by reporter.';
            view_icon = 'circle-stop';
            update_tooltip = 'Ticket cancelled. No further changes possible.';
          } else if (ticket.status === 'granted') {
            view_status = 'Access ticket has been granted.';
            view_icon = 'circle-check';
            update_tooltip = 'Revoke Access';
          } else if (ticket.status === 'revoked') {
            view_status = 'Access ticket has been revoked.';
            view_icon = 'circle-minus';
            update_tooltip = 'Access revoked. No further changes possible.';
          } else if (ticket.status === 'returned') {
            view_status = 'Access ticket has been returned.';
            view_icon = 'circle-minus';
            update_tooltip =
              'Access self-returned. No further changes possible.';
          }
          let can_reject = 'Yes';
          if (can_update === 'No') {
            can_reject = 'No';
          }
          if (ticket.status !== 'pending') {
            can_reject = 'No';
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                {ticket.id}
              </Flex.Item>
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.submitter}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.title}
              </Flex.Item>
              <Flex.Item width="30rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button
                  icon={view_icon}
                  tooltipPosition="top"
                  tooltip={view_status}
                />
                <Button.Confirm
                  icon="user-gear"
                  tooltipPosition="top"
                  tooltip={update_tooltip}
                  disabled={can_update === 'No'}
                  onClick={() => act('auth_access', { ticket: ticket.ref })}
                />
                {can_reject === 'Yes' && (
                  <Button.Confirm
                    icon="user-minus"
                    tooltipPosition="top"
                    tooltip="Reject Ticket"
                    disabled={can_reject === 'No'}
                    onClick={() => act('reject_access', { ticket: ticket.ref })}
                  />
                )}
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const MaintManagement = (props) => {
  const { data, act } = useBackend();
  const {
    local_last_page,
    local_current_menu,
    maintenance_tickets,
    local_admin_login,
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
              tooltipPosition="top"
              tooltip="Go back"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltipPosition="top"
              tooltip="Navigation Menu"
              onClick={() => act('home')}
            />
          </Box>

          <h3>Remote Admin: {local_admin_login}</h3>

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
        <h1 align="center">Maintenance Reports Management</h1>

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
          <Button
            icon="exclamation-circle"
            width="30vw"
            textAlign="center"
            fontSize="1.5rem"
            mt="5rem"
            onClick={() => act('new_report')}
          >
            New Report
          </Button>
        </Flex>

        {!!maintenance_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0">
              ID
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" ml="1rem">
              Time
            </Flex.Item>
            <Flex.Item width="12rem" bold>
              Category
            </Flex.Item>
            <Flex.Item width="20rem" bold>
              Details
            </Flex.Item>
            <Flex.Item width="10rem" bold>
              Submit By
            </Flex.Item>
            <Flex.Item width="10rem" bold ml="0.5rem">
              Assigned To
            </Flex.Item>
          </Flex>
        )}
        {maintenance_tickets.map((ticket, i) => {
          let view_status = 'Ticket is pending assignment.';
          let view_icon = 'circle-question';
          if (ticket.status === 'assigned') {
            view_status = 'Ticket is assigned.';
            view_icon = 'circle-plus';
          } else if (ticket.status === 'rejected') {
            view_status = 'Ticket has been rejected.';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = 'Ticket was cancelled by reporter.';
            view_icon = 'circle-stop';
          } else if (ticket.status === 'completed') {
            view_status = 'Ticket has been successfully resolved.';
            view_icon = 'circle-check';
          }
          let can_claim = 'Yes';
          if (ticket.lock_status === 'CLOSED') {
            can_claim = 'No';
          }
          let can_mark = 'Yes';
          if (ticket.lock_status === 'CLOSED') {
            can_mark = 'No';
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" ml="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="12rem">{ticket.category}</Flex.Item>
              <Flex.Item width="20rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="10rem" shrink="0" textAlign="left">
                {ticket.submitter}
              </Flex.Item>
              <Flex.Item width="10rem" shrink="0" textAlign="left" ml="0.5rem">
                {ticket.assignee}
              </Flex.Item>
              <Flex.Item width="8rem" ml="1rem" direction="column">
                <Button
                  icon={view_icon}
                  tooltipPosition="top"
                  tooltip={view_status}
                />
                <Button.Confirm
                  icon="user-lock"
                  tooltipPosition="top"
                  tooltip="Claim Ticket"
                  disabled={can_claim === 'No'}
                  onClick={() => act('claim_ticket', { ticket: ticket.ref })}
                />
                <Button
                  icon="user-gear"
                  tooltipPosition="top"
                  tooltip="Mark Ticket"
                  disabled={can_mark === 'No'}
                  onClick={() => act('mark_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};
