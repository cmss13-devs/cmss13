import type { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Flex } from '../components';
import { Window } from '../layouts';
import type { DataCoreData } from './common/commonTypes';

type Data = DataCoreData & {
  local_admin_login: string;
  admin_access_log: string[];
  local_current_menu: string;
  local_last_page: string;
  ares_logged_in: String;
  ares_sudo: BooleanLike;
  ares_access_text: string;
  local_spying_conversation: string[];
  local_active_convo: String[];
  local_active_ref: String;
};

const PAGES = {
  login: () => Login,
};

export const AresAccessCode = (props) => {
  const { data } = useBackend<Data>();
  const { local_current_menu } = data;
  const PageComponent = PAGES[local_current_menu]();

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
