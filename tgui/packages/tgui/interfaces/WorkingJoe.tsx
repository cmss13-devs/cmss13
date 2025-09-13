import { useBackend } from 'tgui/backend';
import { Box, Button, Dropdown, Flex, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

import type { DataCoreData } from './common/commonTypes';

type Data = DataCoreData & {
  local_current_menu: string;
  local_last_page: string;
  local_logged_in: string;
  local_access_text: string;
  local_access_level: number;
  local_notify_sounds: boolean;
};

const PAGES = {
  login: () => Login,
  main: () => MainMenu,
  apollo: () => ApolloLog,
  login_records: () => LoginRecords,
  maint_reports: () => MaintReports,
  maint_claim: () => MaintManagement,
  access_requests: () => AccessRequests,
  access_tickets: () => AccessTickets,
  // id_access: () => AccessID,
  core_security_gas: () => CoreSecGas,
};
export const WorkingJoe = (props) => {
  const { data } = useBackend<Data>();
  const { local_current_menu } = data;
  const PageComponent = PAGES[local_current_menu]();

  let themecolor = 'crtblue';
  if (local_current_menu === 'core_security_gas') {
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
      <Box fontFamily="monospace">APOLLO Maintenance Controller</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 12.8.3</Box>
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
    local_notify_sounds,
    faction_options,
    sentry_setting,
  } = data;
  let can_request_access = 'Yes';
  if (local_access_level > 2) {
    can_request_access = 'No';
  }
  let soundicon = 'volume-high';
  if (!local_notify_sounds) {
    soundicon = 'volume-xmark';
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
              tooltip="Navigation Menu"
              onClick={() => act('home')}
              disabled={local_current_menu === 'main'}
            />
            <Button
              icon={soundicon}
              ml="auto"
              mr="1rem"
              tooltip="Mute/Un-Mute notifcation sounds."
              onClick={() => act('toggle_sound')}
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
            <h3>Request Submission</h3>
          </Stack.Item>
          {can_request_access === 'Yes' && (
            <Stack.Item>
              <Button
                tooltip="Request an access ticket to visit ARES."
                icon="bullhorn"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_request')}
              >
                Request Access Ticket
              </Button>
            </Stack.Item>
          )}
          {local_access_level === 3 && (
            <Stack.Item>
              <Button.Confirm
                tooltip="Return your temporary access."
                icon="eye"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('return_access')}
              >
                Surrender Access Ticket
              </Button.Confirm>
            </Stack.Item>
          )}
          <Stack.Item>
            <Button
              tooltip="View or Report any maintenance problems."
              icon="comments"
              ml="auto"
              px="2rem"
              width="33vw"
              bold
              onClick={() => act('page_report')}
            >
              Maintenance Tickets
            </Button>
          </Stack.Item>
        </Stack>

        {local_access_level >= 4 && (
          <Stack>
            <Stack.Item grow>
              <h3>Certified Personnel</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Read the Apollo Link logs."
                icon="clipboard"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_apollo')}
              >
                View Apollo Log
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="View the recent logins."
                icon="users"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_logins')}
              >
                View Access Log
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {local_access_level >= 5 && (
          <Stack>
            <Stack.Item grow>
              <h3>Task Management</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Approve, or deny, temporary visitation access to personnel."
                icon="user-shield"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_tickets')}
              >
                Manage Access Tickets
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Claim, Complete, Prioritise or Cancel Maintenance Tickets."
                icon="cart-shopping"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_maintenance')}
              >
                Manage Maintenance Tickets
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Section>
      {local_access_level >= 5 && (
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
                onClick={() => act('page_core_gas')}
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
                disabled={local_access_level < 6}
              />
            </Stack.Item>
          </Stack>
        </Section>
      )}
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

const LoginRecords = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    apollo_access_log,
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
        <h1 style={{ textAlign: 'center' }}>Login Records</h1>

        {apollo_access_log.map((login, i) => {
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

const MaintReports = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    maintenance_tickets,
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
        <h1 style={{ textAlign: 'center' }}>Maintenance Reports</h1>
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
            <Flex.Item bold width="5rem" shrink="0" mr="1.5rem">
              ID
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item width="12rem" bold>
              Category
            </Flex.Item>
            <Flex.Item width="40rem" bold>
              Details
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
          let can_cancel = 'Yes';
          if (ticket.submitter !== local_logged_in) {
            can_cancel = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_cancel = 'No';
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="12rem" mr="1rem">
                {ticket.category}
              </Flex.Item>
              <Flex.Item width="40rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="8rem" ml="1rem">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="file-circle-xmark"
                  tooltip="Cancel Ticket"
                  disabled={can_cancel === 'No'}
                  onClick={() => act('cancel_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};
const MaintManagement = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    maintenance_tickets,
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
        <h1 style={{ textAlign: 'center' }}>Maintenance Reports Management</h1>

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
          if (ticket.assignee !== local_logged_in && ticket.assignee !== null) {
            can_mark = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
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
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="user-lock"
                  tooltip="Claim Ticket"
                  disabled={can_claim === 'No'}
                  onClick={() => act('claim_ticket', { ticket: ticket.ref })}
                />
                <Button.Confirm
                  icon="user-gear"
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
const AccessRequests = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_access_level,
    local_last_page,
    local_current_menu,
    access_tickets,
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
        <h1 style={{ textAlign: 'center' }}>Request Access</h1>
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
            onClick={() => act('new_access')}
            disabled={local_access_level > 2}
          >
            Create Ticket
          </Button>
        </Flex>

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
              For
            </Flex.Item>
            <Flex.Item width="40rem" bold>
              Details
            </Flex.Item>
          </Flex>
        )}
        {access_tickets.map((ticket, i) => {
          let view_status = 'Access Ticket is pending assignment.';
          let view_icon = 'circle-question';
          if (ticket.status === 'assigned') {
            view_status = 'Access Ticket is assigned.';
            view_icon = 'circle-plus';
          } else if (ticket.status === 'rejected') {
            view_status = 'Access Ticket has been rejected.';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = 'Access Ticket was cancelled by reporter.';
            view_icon = 'circle-stop';
          } else if (ticket.status === 'granted') {
            view_status = 'Access ticket has been granted.';
            view_icon = 'circle-check';
          } else if (ticket.status === 'revoked') {
            view_status = 'Access ticket has been revoked.';
            view_icon = 'circle-minus';
          } else if (ticket.status === 'returned') {
            view_status = 'Access ticket has been returned.';
            view_icon = 'circle-minus';
          }
          let can_cancel = 'Yes';
          if (ticket.submitter !== local_logged_in) {
            can_cancel = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_cancel = 'No';
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.title}
              </Flex.Item>
              <Flex.Item width="40rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="8rem" ml="1rem">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="file-circle-xmark"
                  tooltip="Cancel Ticket"
                  disabled={can_cancel === 'No'}
                  onClick={() => act('cancel_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const AccessTickets = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    access_tickets,
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
        <h1 style={{ textAlign: 'center' }}>Access Ticket Management</h1>
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
          let can_claim = 'Yes';
          if (ticket.assignee === local_logged_in) {
            can_claim = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_claim = 'No';
          }
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
          let can_reject = true;
          if (can_update === 'No') {
            can_reject = false;
          }
          if (ticket.status !== 'pending') {
            can_reject = false;
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
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="user-gear"
                  tooltip={update_tooltip}
                  disabled={can_update === 'No'}
                  onClick={() => act('auth_access', { ticket: ticket.ref })}
                />
                {can_reject && (
                  <Button.Confirm
                    icon="user-minus"
                    tooltip="Reject Ticket"
                    disabled={!can_reject}
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

const CoreSecGas = (props) => {
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
        <h1 style={{ textAlign: 'center' }}>Nerve Gas Release</h1>
        {security_vents.map((vent, i) => {
          return (
            <Button.Confirm
              key={i}
              align="center"
              icon="wind"
              tooltip="Release Gas"
              width="100%"
              disabled={local_access_level < 5 || !vent.available}
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
