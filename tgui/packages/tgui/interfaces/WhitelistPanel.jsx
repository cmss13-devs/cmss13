import { useBackend } from '../backend';
import { Button, Flex, Section, Stack } from '../components';
import { Window } from '../layouts';

const PAGES = {
  Panel: () => PlayerList,
  Update: () => StatusUpdate,
};

export const WhitelistPanel = (props) => {
  const { data } = useBackend();
  const { current_menu } = data;
  const PageComponent = PAGES[current_menu]();

  return (
    <Window theme={'crtblue'} width={990} height={750}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const PlayerList = (props) => {
  const { data, act } = useBackend();
  const { whitelisted_players } = data;

  return (
    <Section>
      <Flex align="center" grow>
        <Flex.Item mr="1rem">
          <Button
            icon="clipboard"
            tooltip="Add new player, or find an existing one."
            onClick={() => act('add_player')}
          >
            Search
          </Button>
        </Flex.Item>
        <Flex.Item mr="1rem">
          <Button
            icon="rotate-right"
            textAlign="center"
            tooltip="Refresh Data"
            onClick={() => act('refresh_data')}
          />
        </Flex.Item>
        <Flex.Item mr="1rem" width="90%">
          <h1 align="center">Whitelist Panel</h1>
        </Flex.Item>
      </Flex>
      {!!whitelisted_players.length && (
        <Flex
          className="candystripe"
          p=".75rem"
          align="center"
          fontSize="1.25rem"
        >
          <Flex.Item bold width="20rem" shrink="0" mr="5rem">
            CKey
          </Flex.Item>
          <Flex.Item width="40rem" grow bold>
            Status
          </Flex.Item>
        </Flex>
      )}
      {whitelisted_players.map((record, i) => {
        return (
          <Flex key={i} className="candystripe" p=".75rem" align="center">
            <Flex.Item mr="5%">
              <Button
                icon="pen"
                tooltip="Edit Whitelists"
                onClick={() => act('select_player', { player: record.ckey })}
              />
            </Flex.Item>
            <Flex.Item bold width="20%" shrink="0" mr="1rem">
              {record.ckey}
            </Flex.Item>
            <Flex.Item width="75%" ml="1rem" shrink="0">
              {record.status}
            </Flex.Item>
          </Flex>
        );
      })}
    </Section>
  );
};

const StatusUpdate = (props) => {
  const { act, data } = useBackend();
  const {
    co_flags,
    syn_flags,
    yaut_flags,
    misc_flags,
    viewed_player,
    user_rights,
    target_rights,
    new_rights,
  } = data;
  return (
    <Section fill>
      <Flex align="center">
        <Button
          icon="arrow-left"
          px="2rem"
          textAlign="center"
          tooltip="Go back"
          onClick={() => act('go_back')}
        />
      </Flex>
      <h1 align="center">Whitelists for: {viewed_player.ckey}</h1>
      <Section title="Commanding Officer">
        <Stack align="right" grow={1}>
          {co_flags.map((bit, i) => {
            const isWhitelisted = target_rights && target_rights & bit.bitflag;
            return (
              <Button
                key={i}
                width="100%"
                height="100%"
                color={isWhitelisted ? 'purple' : 'blue'}
                tooltip={isWhitelisted ? 'Whitelisted' : 'Not Whitelisted'}
              >
                {bit.name}
              </Button>
            );
          })}
        </Stack>
        <Stack align="right" grow={1}>
          {co_flags.map((bit, i) => {
            const new_state = new_rights && new_rights & bit.bitflag;
            const editable = user_rights && bit.permission & user_rights;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={new_state}
                color={new_state ? 'good' : 'bad'}
                disabled={!editable}
                onClick={() =>
                  act('update_number', {
                    wl_flag: !new_state
                      ? new_rights | bit.bitflag
                      : new_rights & ~bit.bitflag,
                  })
                }
              >
                {bit.name}
              </Button.Checkbox>
            );
          })}
        </Stack>
      </Section>
      <Section title="Synthetic">
        <Stack align="right" grow={1}>
          {syn_flags.map((bit, i) => {
            const isWhitelisted = target_rights && target_rights & bit.bitflag;
            return (
              <Button
                key={i}
                width="100%"
                height="100%"
                color={isWhitelisted ? 'purple' : 'blue'}
                tooltip={isWhitelisted ? 'Whitelisted' : 'Not Whitelisted'}
              >
                {bit.name}
              </Button>
            );
          })}
        </Stack>
        <Stack align="right" grow={1}>
          {syn_flags.map((bit, i) => {
            const new_state = new_rights && new_rights & bit.bitflag;
            const editable = user_rights && bit.permission & user_rights;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={new_state}
                color={new_state ? 'good' : 'bad'}
                disabled={!editable}
                onClick={() =>
                  act('update_number', {
                    wl_flag: !new_state
                      ? new_rights | bit.bitflag
                      : new_rights & ~bit.bitflag,
                  })
                }
              >
                {bit.name}
              </Button.Checkbox>
            );
          })}
        </Stack>
      </Section>
      <Section title="Yautja">
        <Stack align="right" grow={1}>
          {yaut_flags.map((bit, i) => {
            const isWhitelisted = target_rights && target_rights & bit.bitflag;
            return (
              <Button
                key={i}
                width="100%"
                height="100%"
                color={isWhitelisted ? 'purple' : 'blue'}
                tooltip={isWhitelisted ? 'Whitelisted' : 'Not Whitelisted'}
              >
                {bit.name}
              </Button>
            );
          })}
        </Stack>
        <Stack align="right" grow={1}>
          {yaut_flags.map((bit, i) => {
            const new_state = new_rights && new_rights & bit.bitflag;
            const editable = user_rights && bit.permission & user_rights;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={new_state}
                color={new_state ? 'good' : 'bad'}
                disabled={!editable}
                onClick={() =>
                  act('update_number', {
                    wl_flag: !new_state
                      ? new_rights | bit.bitflag
                      : new_rights & ~bit.bitflag,
                  })
                }
              >
                {bit.name}
              </Button.Checkbox>
            );
          })}
        </Stack>
      </Section>
      <Section title="Misc">
        <Stack align="right" grow={1}>
          {misc_flags.map((bit, i) => {
            const isWhitelisted = target_rights && target_rights & bit.bitflag;
            return (
              <Button
                key={i}
                width="100%"
                height="100%"
                color={isWhitelisted ? 'purple' : 'blue'}
                tooltip={isWhitelisted ? 'Whitelisted' : 'Not Whitelisted'}
              >
                {bit.name}
              </Button>
            );
          })}
        </Stack>
        <Stack align="right" grow={1}>
          {misc_flags.map((bit, i) => {
            const new_state = new_rights && new_rights & bit.bitflag;
            const editable = user_rights && bit.permission & user_rights;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={new_state}
                color={new_state ? 'good' : 'bad'}
                disabled={!editable}
                onClick={() =>
                  act('update_number', {
                    wl_flag: !new_state
                      ? new_rights | bit.bitflag
                      : new_rights & ~bit.bitflag,
                  })
                }
              >
                {bit.name}
              </Button.Checkbox>
            );
          })}
        </Stack>
      </Section>
      <Flex align="center">
        <Button
          icon="check"
          width="100%"
          textAlign="center"
          tooltip="Update Whitelists"
          onClick={() => act('update_perms', { player: viewed_player.ckey })}
        >
          Update Whitelists
        </Button>
      </Flex>
    </Section>
  );
};
