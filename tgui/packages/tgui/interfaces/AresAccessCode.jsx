import { useBackend } from '../backend';
import { Box, Button, Flex } from '../components';
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
};

export const AresAccessCode = (props) => {
  const { data } = useBackend();
  const { current_menu, sudo } = data;
  const PageComponent = PAGES[current_menu]();

  let themecolor = 'crtyellow';

  return (
    <Window theme={themecolor} width={800} height={725}>
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
      <Box fontFamily="monospace">AIDT Access Interface</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 11</Box>
      <Box fontFamily="monospace">Copyright © 2182, Weyland Yutani Corp.</Box>

      <Button
        icon="id-card"
        width="30vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        mt="5rem"
        onClick={() => act('enter_code')}
      >
        Enter Code
      </Button>
    </Flex>
  );
};
