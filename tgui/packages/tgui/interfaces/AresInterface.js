import { useBackend } from '../backend';
import { Flex, Box, Section, Button } from '../components';
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
  'talking': () => ARESTalk,
  'deleted_talks': () => DeletedTalks,
  'read_deleted': () => ReadingTalks,
};

export const AresInterface = (props, context) => {
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
      <Box fontFamily="monospace">ARES v3.2 Interface</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 8.1.1</Box>
      <Box fontFamily="monospace">Copyright © 2182, Weyland Yutani Corp.</Box>

      <Button
        content="Login"
        icon="user-shield"
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

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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

        <Flex align="center">
          <h3>Access Level 0</h3>
          <Button
            content="ARES Communication"
            tooltip="Direct communication 1:1 with ARES."
            icon="comments"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('ares_talk')}
          />
        </Flex>
        {access_level >= 1 && (
          <Flex align="center">
            <h3>Access Level 1</h3>
            <Button
              content="Announcement Logs"
              tooltip="Access the AI Announcement logs."
              icon="bullhorn"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('logs_announce')}
            />
            <Button
              content="Bioscan Logs"
              tooltip="Access the Bioscan records."
              icon="eye"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('logs_bio')}
            />
            <Button
              content="Bombardment Logs"
              tooltip="Access Orbital Bombardment logs."
              icon="meteor"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('logs_bomb')}
            />
          </Flex>
        )}
        {access_level >= 2 && (
          <Flex align="center">
            <h3>Access Level 2</h3>
            <Button
              content="View Apollo Log"
              tooltip="Read the Apollo Link logs."
              icon="clipboard"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('logs_apollo')}
            />
          </Flex>
        )}
        {access_level >= 4 && (
          <Flex align="center">
            <h3>Access Level 4</h3>
            <Button.Confirm
              content="Initiate Evacuation"
              tooltip="Begin evacuation procedures. Authorise Lifeboats."
              icon="shuttle-space"
              color="red"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('evacuation_start')}
            />
            <Button.Confirm
              content="Launch Distress Beacon"
              tooltip="Launch a Distress Beacon."
              icon="circle-exclamation"
              color="red"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('distress')}
            />
          </Flex>
        )}
        {access_level >= 5 && (
          <Flex align="center">
            <h3>Access Level 5</h3>
            <Button
              content="View Access Log"
              tooltip="View the recent logins."
              icon="users"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('logs_access')}
            />
          </Flex>
        )}
        {access_level >= 8 && (
          <Flex align="center">
            <h3>Access Level 8</h3>
            <Button
              content="View Deletion Log"
              tooltip="View the deletion log."
              icon="sd-card"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('logs_delete')}
            />
            <Button
              content="View Deleted 1:1's"
              tooltip="View the deletion log."
              icon="sd-card"
              ml="auto"
              px="2rem"
              bold
              onClick={() => act('logs_talk')}
            />
          </Flex>
        )}
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
    announcement_records,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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
        <h1 align="center">Announcement Logs</h1>
      </Section>

      <Section>
        {!!announcement_records.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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
        {announcement_records.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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
                  disabled={access_level < 3}
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

const BioscanLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    bioscan_records,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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
        <h1 align="center">Bioscan Logs</h1>
      </Section>

      <Section>
        {!!bioscan_records.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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
        {bioscan_records.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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

const BombardmentLogs = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    logged_in,
    access_text,
    last_page,
    current_menu,
    bombardment_records,
    access_level,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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
        <h1 align="center">Orbital Bombardment Logs</h1>
      </Section>

      <Section>
        {!!bombardment_records.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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
        {bombardment_records.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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

const ApolloLog = (props, context) => {
  const { data, act } = useBackend(context);
  const { logged_in, access_text, last_page, current_menu, apollo_log } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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
      </Section>
      <Section>
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
  const { logged_in, access_text, last_page, current_menu, access_log } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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
        <h1 align="center">Access Log</h1>
      </Section>
      <Section>
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
  const { logged_in, access_text, last_page, current_menu, deletion_records } =
    data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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
        <h1 align="center">Deletion Log</h1>
      </Section>

      <Section>
        {!!deletion_records.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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
        {deletion_records.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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
          <Button
            content="Send Message"
            icon="pen"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('message_ares', { active_convo: active_ref })}
          />
        )}
      </Section>
      <Section align="center">
        <Button.Confirm
          content="Clear Conversation"
          icon="trash"
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
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

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
        <h1 align="center">Deletion Log</h1>
      </Section>

      <Section>
        {!!deleted_discussions.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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
              <Flex.Item bold width="9rem" shrink="0" mr="1rem">
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
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Go back"
            onClick={() => act('go_back')}
            disabled={last_page === current_menu}
          />

          <h3>
            {logged_in}, {access_text}
          </h3>

          <Button
            icon="house"
            ml="auto"
            tooltip="Navigation Menu"
            onClick={() => act('home')}
          />
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
      </Section>
      <Section>
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
