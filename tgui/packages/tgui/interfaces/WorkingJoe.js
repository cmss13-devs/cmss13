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
  'access_returns': () => AccessReturns,
  'access_tickets': () => AccessTickets,
};
export const WorkingJoe = (props, context) => {
  const { data } = useBackend(context);
  const { current_menu } = data;
  const PageComponent = PAGES[current_menu]();

  return (
    <Window theme="crtblue" width={780} height={725}>
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
      <Box fontFamily="monospace">Version 12.7.1</Box>
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
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    access_level,
    ticket_console,
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
          {access_level <= 1 && (
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
                disabled={logged_in}
              />
            </Stack.Item>
          )}
          {access_level === 2 && (
            <Stack.Item>
              <Button
                content="Surrender Access Ticket"
                tooltip="Return your temporary access."
                icon="eye"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_returns')}
                disabled={logged_in}
              />
            </Stack.Item>
          )}
          <Stack.Item>
            <Button
              content="Submit a Maintenance Ticket"
              tooltip="Report a Maintenance problem to ARES."
              icon="comments"
              ml="auto"
              px="2rem"
              width="33vw"
              bold
              onClick={() => act('page_report')}
            />
          </Stack.Item>
        </Stack>

        {access_level >= 3 && (
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
        {access_level >= 4 && (
          <Stack>
            <Stack.Item grow>
              <h3>Task Management</h3>
            </Stack.Item>
            {ticket_console && (
              <Stack.Item>
                <Button
                  content="Create Access Ticket"
                  tooltip="Grant temporary visitation access to personnel."
                  icon="user-shield"
                  ml="auto"
                  px="2rem"
                  width="33vw"
                  bold
                  onClick={() => act('page_tickets')}
                  disabled={logged_in}
                />
              </Stack.Item>
            )}
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
                disabled={logged_in}
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
    temp_maint_name,
    temp_maint_details,
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
        <h1 align="center">Report Maintenance</h1>
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
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Time
            </Flex.Item>
            <Flex.Item width="15rem" grow bold>
              Title
            </Flex.Item>
            <Flex.Item width="35rem" textAlign="left">
              Details
            </Flex.Item>
          </Flex>
        )}
        {maintenance_tickets.map((ticket, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="15rem" grow italic>
                {ticket.title}
              </Flex.Item>
              <Flex.Item width="35rem" ml="1rem" shrink="0" textAlign="left">
                {ticket.details}
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
      </Section>
    </>
  );
};
const AccessRequests = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu } = data;

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
      </Section>
    </>
  );
};
const AccessReturns = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu } = data;

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
        <h1 align="center">Return Access</h1>
      </Section>
    </>
  );
};
const AccessTickets = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu } = data;

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
      </Section>
    </>
  );
};
