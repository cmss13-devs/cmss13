import { useBackend } from '../backend';
import { Flex, Box, Section, Button, Stack } from '../components';
import { Window } from '../layouts';

const PAGES = {
  'login': () => Login,
  'main': () => MainMenu,
  'apollo': () => ApolloLog,
  'login_records': () => LoginRecords,
  'maint_reports': () => MaintReports,
  'maint_claim': () => MaintManagement,
  'access_requests': () => AccessRequests,
  'access_tickets': () => AccessTickets,
  'id_access': () => AccessID,
};
export const WorkingJoe = (props, context) => {
  const { data } = useBackend(context);
  const { current_menu } = data;
  const PageComponent = PAGES[current_menu]();

  return (
    <Window theme="crtblue" width={950} height={725}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const Login = (props, context) => {
  const { act } = useBackend(context);

  return (
    <Flex
      direction="column"
      justify="center"
      align="center"
      height="100%"
      color="darkgrey"
      fontSize="2rem"
      mt="-3rem"
      bold>
      <Box fontFamily="monospace">APOLLO Maintenance Controller</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 12.8.3</Box>
      <Box fontFamily="monospace">Copyright © 2182, Weyland Yutani Corp.</Box>

      <Button
        content="Login"
        icon="id-card"
        width="30vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        mt="5rem"
        onClick={() => act('login')}
      />
    </Flex>
  );
};

const MainMenu = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu, access_level } =
    data;
  let can_request_access = 'Yes';
  if (access_level > 2) {
    can_request_access = 'No';
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
            content="Logout"
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          />
        </Flex>
      </Section>

      <Section>
        <h1 align="center">Navigation Menu</h1>
        <Stack>
          <Stack.Item grow>
            <h3>Request Submission</h3>
          </Stack.Item>
          {can_request_access === 'Yes' && (
            <Stack.Item>
              <Button
                content="Request Access Ticket"
                tooltip="Request an access ticket to visit ARES."
                icon="bullhorn"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_request')}
              />
            </Stack.Item>
          )}
          {access_level === 3 && (
            <Stack.Item>
              <Button.Confirm
                content="Surrender Access Ticket"
                tooltip="Return your temporary access."
                icon="eye"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('return_access')}
              />
            </Stack.Item>
          )}
          <Stack.Item>
            <Button
              content="Maintenance Tickets"
              tooltip="View or Report any maintenance problems."
              icon="comments"
              ml="auto"
              px="2rem"
              width="33vw"
              bold
              onClick={() => act('page_report')}
            />
          </Stack.Item>
        </Stack>

        {access_level >= 4 && (
          <Stack>
            <Stack.Item grow>
              <h3>Certified Personnel</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                content="View Apollo Log"
                tooltip="Read the Apollo Link logs."
                icon="clipboard"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_apollo')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content="View Access Log"
                tooltip="View the recent logins."
                icon="users"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_logins')}
              />
            </Stack.Item>
          </Stack>
        )}
        {access_level >= 5 && (
          <Stack>
            <Stack.Item grow>
              <h3>Task Management</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                content="Manage Access Tickets"
                tooltip="Approve, or deny, temporary visitation access to personnel."
                icon="user-shield"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_tickets')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content="Manage Maintenance Tickets"
                tooltip="Claim, Complete, Prioritise or Cancel Maintenance Tickets."
                icon="cart-shopping"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_maintenance')}
              />
            </Stack.Item>
          </Stack>
        )}
      </Section>
    </>
  );
};

const ApolloLog = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu, apollo_log } = data;

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
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            content="Logout"
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          />
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

const LoginRecords = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu, access_log } = data;

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
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            content="Logout"
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          />
        </Flex>
      </Section>

      <Section>
        <h1 align="center">Login Records</h1>

        {access_log.map((login, i) => {
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

const MaintReports = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
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
            content="Logout"
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          />
        </Flex>
      </Section>

      <Section>
        <h1 align="center">Maintenance Reports</h1>
        <Flex
          direction="column"
          justify="center"
          align="center"
          height="100%"
          color="darkgrey"
          fontSize="2rem"
          mt="-3rem"
          bold>
          <Button
            content="New Report"
            icon="exclamation-circle"
            width="30vw"
            textAlign="center"
            fontSize="1.5rem"
            mt="5rem"
            onClick={() => act('new_report')}
          />
        </Flex>

        {!!maintenance_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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
          if (ticket.submitter !== logged_in) {
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
const MaintManagement = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
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
            content="Logout"
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          />
        </Flex>
      </Section>

      <Section>
        <h1 align="center">Maintenance Reports Management</h1>

        {!!maintenance_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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
          if (ticket.assignee !== logged_in && ticket.assignee !== null) {
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
const AccessRequests = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu, access_tickets } =
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
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            content="Logout"
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          />
        </Flex>
      </Section>

      <Section>
        <h1 align="center">Request Access</h1>
        <Flex
          direction="column"
          justify="center"
          align="center"
          height="100%"
          color="darkgrey"
          fontSize="2rem"
          mt="-3rem"
          bold>
          <Button
            content="Create Ticket"
            icon="exclamation-circle"
            width="30vw"
            textAlign="center"
            fontSize="1.5rem"
            mt="5rem"
            onClick={() => act('new_access')}
            disabled={access_level > 2}
          />
        </Flex>

        {!!access_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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
          if (ticket.submitter !== logged_in) {
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

const AccessTickets = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu, access_tickets } =
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
            />
          </Box>

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button.Confirm
            content="Logout"
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          />
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
            fontSize="1.25rem">
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
          if (ticket.assignee === logged_in) {
            can_claim = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_claim = 'No';
          }
          let can_update = 'Yes';
          if (ticket.assignee !== logged_in) {
            can_update = 'No';
          } else if (ticket.lock_status === 'CLOSED') {
            can_update = 'No';
          }
          let view_status = 'Ticket is pending assignment.';
          let view_icon = 'circle-question';
          let update_tooltip = 'Update Access';
          if (ticket.status === 'assigned') {
            view_status = 'Ticket is assigned.';
            view_icon = 'circle-plus';
            update_tooltip = 'Grant Access';
          } else if (ticket.status === 'rejected') {
            view_status = 'Ticket has been rejected.';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = 'Ticket was cancelled by reporter.';
            view_icon = 'circle-stop';
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
                  icon="user-lock"
                  tooltip="Claim Ticket"
                  disabled={can_claim === 'No'}
                  onClick={() => act('claim_ticket', { ticket: ticket.ref })}
                />
                <Button.Confirm
                  icon="user-gear"
                  tooltip={update_tooltip}
                  disabled={can_update === 'No'}
                  onClick={() => act('auth_access', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};
