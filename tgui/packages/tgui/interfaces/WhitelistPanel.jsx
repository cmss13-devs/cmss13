import { useBackend } from '../backend';
import { Button, Stack, Section, Flex } from '../components';
import { Window } from '../layouts';

const PAGES = {
  'Panel': () => PlayerList,
  'Update': () => StatusUpdate,
};

export const WhitelistPanel = (props, context) => {
  const { data } = useBackend(context);
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

const PlayerList = (props, context) => {
  const { data, act } = useBackend(context);
  const { whitelisted_players } = data;

  return (
    <Section>
      <Flex align="center" grow>
        <Flex.Item mr="1rem">
          <Button
            icon="clipboard"
            content="Search"
            tooltip="Add new player, or find an existing one."
            onClick={() => act('add_player')}
          />
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
          fontSize="1.25rem">
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

const StatusUpdate = (props, context) => {
  const { act, data } = useBackend(context);
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
                content={bit.name}
              />
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
                content={bit.name}
                disabled={!editable}
                onClick={() =>
                  act('update_number', {
                    'wl_flag': !new_state
                      ? new_rights | bit.bitflag
                      : new_rights & ~bit.bitflag,
                  })
                }
              />
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
                content={bit.name}
              />
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
                content={bit.name}
                disabled={!editable}
                onClick={() =>
                  act('update_number', {
                    'wl_flag': !new_state
                      ? new_rights | bit.bitflag
                      : new_rights & ~bit.bitflag,
                  })
                }
              />
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
                content={bit.name}
              />
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
                content={bit.name}
                disabled={!editable}
                onClick={() =>
                  act('update_number', {
                    'wl_flag': !new_state
                      ? new_rights | bit.bitflag
                      : new_rights & ~bit.bitflag,
                  })
                }
              />
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
                content={bit.name}
              />
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
                content={bit.name}
                disabled={!editable}
                onClick={() =>
                  act('update_number', {
                    'wl_flag': !new_state
                      ? new_rights | bit.bitflag
                      : new_rights & ~bit.bitflag,
                  })
                }
              />
            );
          })}
        </Stack>
      </Section>
      <Flex align="center">
        <Button
          icon="check"
          width="100%"
          textAlign="center"
          content="Update Whitelists"
          tooltip="Update Whitelists"
          onClick={() => act('update_perms', { 'player': viewed_player.ckey })}
        />
      </Flex>
    </Section>
  );
};
