import { useBackend } from '../backend';
import { Flex, Box, Section, Button, Stack } from '../components';
import { Window } from '../layouts';

const PAGES = {
  'login': () => Login,
  'main': () => MainMenu,
  'announcements': () => AnnouncementLogs,
  'bioscans': () => BioscanLogs,
  'bombardments': () => BombardmentLogs,
  'apollo': () => ApolloLog,
  'access_log': () => AccessLogs,
  'delete_log': () => DeletionLogs,
  'flight_log': () => FlightLogs,
  'talking': () => ARESTalk,
  'deleted_talks': () => DeletedTalks,
  'read_deleted': () => ReadingTalks,
  'security': () => Security,
  'requisitions': () => Requisitions,
  'emergency': () => Emergency,
  'admin_access_log': () => AdminAccessLogs,
  'access_management': () => AccessManagement,
};

export const AresAdmin = (props, context) => {
  const { data } = useBackend(context);
  const { current_menu, sudo } = data;
  const PageComponent = PAGES[current_menu]();

  let themecolor = 'crtyellow';
  if (sudo >= 1) {
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
      <Box fontFamily="monospace">ARES v3.2 Remote Interface</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 4.4.1</Box>
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
  const { logged_in, access_text, last_page, current_menu, sudo, admin_login } =
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
            <br />
            Remote Admin: {admin_login}
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
            <h3>Access Level 1</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Announcement Logs"
              tooltip="Access the AI Announcement logs."
              icon="bullhorn"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_announcements')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="ARES Communication"
              tooltip="Direct communication 1:1 with ARES."
              icon="comments"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_1to1')}
            />
          </Stack.Item>
        </Stack>

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 2</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Flight Records"
              tooltip="Read the Dropship Flight Control Records."
              icon="jet-fighter-up"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_flight')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Bioscan Logs"
              tooltip="Access the Bioscan records."
              icon="eye"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_bioscans')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Bombardment Logs"
              tooltip="Access Orbital Bombardment logs."
              icon="meteor"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_bombardments')}
            />
          </Stack.Item>
        </Stack>

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 3</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Security Updates"
              tooltip="Read the Security Updates."
              icon="file-shield"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_security')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="View Apollo Log"
              tooltip="Read the Apollo Link logs."
              icon="clipboard"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_apollo')}
            />
          </Stack.Item>
        </Stack>

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 5</h3>
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              content="Emergency Protocols"
              tooltip="Access emergency protocols."
              icon="shield"
              color="red"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_emergency')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="ASRS Audit Log"
              tooltip="Review the ASRS Audit Log."
              icon="cart-shopping"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_requisitions')}
            />
          </Stack.Item>
        </Stack>

        <Stack>
          <Stack.Item grow>
            <h3>Access Level 6</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              content="View Access Log"
              tooltip="View the recent logins."
              icon="users"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_access')}
            />
          </Stack.Item>
        </Stack>
        <Stack>
          <Stack.Item grow>
            <h3>Access Level 9</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              content="View Deletion Log"
              tooltip="View the deletion log."
              icon="sd-card"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_deleted')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="View Deleted 1:1's"
              tooltip="View the deleted 1:1 conversations with ARES."
              icon="sd-card"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_deleted_1to1')}
            />
          </Stack.Item>
        </Stack>
        <Stack>
          <Stack.Item grow>
            <h3>Maintenance Access</h3>
          </Stack.Item>
          {sudo === 0 && (
            <Stack.Item>
              <Button
                content="Sudo Login"
                tooltip="You cannot do this via remote console."
                icon="user-secret"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                disabled={access_text}
              />
            </Stack.Item>
          )}
          {sudo >= 1 && (
            <Stack.Item>
              <Button
                content="Sudo Logout"
                tooltip="You cannot do this via remote console."
                icon="user-secret"
                ml="auto"
                px="2rem"
                width="25vw"
                bold
                disabled={access_text}
              />
            </Stack.Item>
          )}
        </Stack>
        <Stack>
          <Stack.Item grow>
            <h3>Remote Admin</h3>
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Remote Access Log"
              tooltip="View which admins have been using ARES."
              icon="user-secret"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_admin_list')}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Access Tickets"
              tooltip="View and update access tickets."
              icon="user-tag"
              ml="auto"
              px="2rem"
              width="25vw"
              bold
              onClick={() => act('page_access_management')}
            />
          </Stack.Item>
        </Stack>
      </Section>
    </>
  );
};

const AnnouncementLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_announcement,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">Announcement Logs</h1>

        {!!records_announcement.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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
                  tooltip="You cannot do this via remote console."
                  disabled={access_text}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const BioscanLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_bioscan,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">Bioscan Logs</h1>

        {!!records_bioscan.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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
                  tooltip="You cannot do this via remote console."
                  disabled={access_text}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const BombardmentLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_bombardment,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">Orbital Bombardment Logs</h1>

        {!!records_bombardment.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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
              Coordinates
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
                  tooltip="You cannot do this via remote console."
                  disabled={access_text}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const ApolloLog = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    apollo_log,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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

const AccessLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    access_log,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">Access Log</h1>

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

const DeletionLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_deletion,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">Deletion Log</h1>

        {!!records_deletion.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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

const ARESTalk = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    active_convo,
    active_ref,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">ARES Communication</h1>
      </Section>

      <Section align="center">
        {!active_convo.length && (
          <Button
            content="New Conversation"
            icon="pen"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('new_conversation')}
          />
        )}
        {active_convo.map((message, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{message}</Flex.Item>
            </Flex>
          );
        })}
        {!!active_convo.length && (
          <Stack justify="center">
            <Stack.Item>
              <Button
                content="Reply as ARES"
                icon="pen"
                ml="auto"
                px="2rem"
                bold
                onClick={() => act('ares_reply', { active_convo: active_ref })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content="Send Fake Message"
                icon="pen"
                ml="auto"
                px="2rem"
                bold
                onClick={() =>
                  act('fake_message_ares', { active_convo: active_ref })
                }
              />
            </Stack.Item>
          </Stack>
        )}
      </Section>
      <Section align="center">
        <Button.Confirm
          content="Clear Conversation"
          icon="trash"
          tooltip="Clears the conversation. Please note, your 1:1 conversation is only visible to you."
          width="30vw"
          textAlign="center"
          fontSize="1.5rem"
          bold
          onClick={() =>
            act('clear_conversation', { active_convo: active_ref })
          }
          disabled={!active_convo.length}
        />
      </Section>
    </>
  );
};

const DeletedTalks = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    deleted_discussions,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">Deletion Log</h1>
        {!!deleted_discussions.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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

const ReadingTalks = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    deleted_conversation,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">Deleted Conversation</h1>
        {deleted_conversation.map((message, i) => {
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

const Requisitions = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_requisition,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">ASRS Audit Log</h1>
        {!!records_requisition.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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

const FlightLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_flight,
    access_level,
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
        <h1 align="center">Flight Control Logs</h1>
        {!!records_flight.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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
                  disabled={access_level < 4}
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

const Security = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    records_security,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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
        <h1 align="center">Security Updates</h1>
        {!!records_security.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
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
                  tooltip="You cannot do this via remote console."
                  disabled={access_text}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const Emergency = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu, admin_login } = data;

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
            <br />
            Remote Admin: {admin_login}
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

      <h1 align="center">Emergency Protocols</h1>
      <Flex align="center" justify="center" height="50%" direction="column">
        <Button.Confirm
          content="Call General Quarters"
          tooltip="You cannot do this via remote console."
          icon="triangle-exclamation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          disabled={access_text}
        />
        <Button.Confirm
          content="Initiate Evacuation"
          tooltip="You cannot do this via remote console."
          icon="shuttle-space"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          disabled={access_text}
        />
        <Button.Confirm
          content="Launch Distress Beacon"
          tooltip="You cannot do this via remote console."
          icon="circle-exclamation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          disabled={access_text}
        />
        <Button.Confirm
          content="Request Nuclear Device"
          tooltip="You cannot do this via remote console."
          icon="circle-radiation"
          color="red"
          width="40vw"
          textAlign="center"
          fontSize="1.5rem"
          p="1rem"
          mt="5rem"
          bold
          disabled={access_text}
        />
      </Flex>
    </>
  );
};

// -------------------------------------------------------------------- //
// Anything below this line is exclusive to the Admin Remote Interface.
// -------------------------------------------------------------------- //

const AdminAccessLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    admin_access_log,
    admin_login,
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
            <br />
            Remote Admin: {admin_login}
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

const AccessManagement = (props, context) => {
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
