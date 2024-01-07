import { useBackend } from '../backend';
import { Button, Stack, Section, Box, Flex } from '../components';
import { Window } from '../layouts';

const PAGES = {
  'Panel': () => PlayerList,
  'Update': () => StatusUpdate,
};

const hasPermission = (data, action) => {
  if (!(action in data.glob_pp_actions)) return false;

  const action_data = data.glob_pp_actions[action];
  return !!(action_data.permissions_required & data.current_permissions);
};

export const WhitelistPanel = (props, context) => {
  const { data } = useBackend(context);
  const { current_menu } = data;
  const PageComponent = PAGES[current_menu]();

  let themecolor = 'crtblue';

  return (
    <Window theme={themecolor} width={950} height={725}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const PlayerList = (props, context) => {
  const { data, act } = useBackend(context);
  const { last_page, current_menu, whitelisted_players } = data;

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
          </Box>
        </Flex>
      </Section>

      <Section>
        <h1 align="center">Whitelist Panel</h1>

        {!!whitelisted_players.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
            <Flex.Item width="3rem" shrink="0" mr="1rem" />
            <Flex.Item bold width="20rem" shrink="0" mr="1rem">
              CKey
            </Flex.Item>
            <Flex.Item width="30rem" grow bold>
              Status
            </Flex.Item>
          </Flex>
        )}
        {whitelisted_players.map((record, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item mr="1rem">
                <Button
                  icon="pen"
                  tooltip="Edit Whitelists"
                  onClick={() => act('select_player', { player: record.ckey })}
                />
              </Flex.Item>
              <Flex.Item bold width="20rem" shrink="0" mr="1rem">
                {record.ckey}
              </Flex.Item>
              <Flex.Item width="40rem" ml="1rem" shrink="0" textAlign="center">
                {record.status}
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const StatusUpdate = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    co_flags,
    syn_flags,
    yaut_flags,
    misc_flags,
    client_muted,
    viewed_player,
    user_rights,
  } = data;
  return (
    <Section fill>
      <h1 align="center">Whitelists for: {viewed_player.name}</h1>
      <Section title="Commanding Officer">
        <Stack align="right" grow={1}>
          {co_flags.map((bit, i) => {
            const isWhitelisted =
              viewed_player.flags && viewed_player.flags & bit.bitflag;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={isWhitelisted}
                color={isWhitelisted ? 'good' : 'bad'}
                content={bit.name}
                onClick={() =>
                  act('mob_mute', {
                    'mute_flag': !isWhitelisted
                      ? client_muted | bit.bitflag
                      : client_muted & ~bit.bitflag,
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
            const isWhitelisted =
              viewed_player.flags && viewed_player.flags & bit.bitflag;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={isWhitelisted}
                color={isWhitelisted ? 'good' : 'bad'}
                content={bit.name}
                onClick={() =>
                  act('mob_mute', {
                    'mute_flag': !isWhitelisted
                      ? client_muted | bit.bitflag
                      : client_muted & ~bit.bitflag,
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
            const isWhitelisted =
              viewed_player.flags && viewed_player.flags & bit.bitflag;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={isWhitelisted}
                color={isWhitelisted ? 'good' : 'bad'}
                content={bit.name}
                onClick={() =>
                  act('mob_mute', {
                    'mute_flag': !isWhitelisted
                      ? client_muted | bit.bitflag
                      : client_muted & ~bit.bitflag,
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
            const isWhitelisted =
              viewed_player.flags && viewed_player.flags & bit.bitflag;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={isWhitelisted}
                color={isWhitelisted ? 'good' : 'bad'}
                content={bit.name}
                onClick={() =>
                  act('mob_mute', {
                    'mute_flag': !isWhitelisted
                      ? client_muted | bit.bitflag
                      : client_muted & ~bit.bitflag,
                  })
                }
              />
            );
          })}
        </Stack>
      </Section>
      <Section title="Controller">
        <Stack align="right" grow={1}>
          {misc_flags.map((bit, i) => {
            const isWhitelisted =
              viewed_player.flags && viewed_player.flags & bit.bitflag;
            return (
              <Button.Checkbox
                key={i}
                width="100%"
                height="100%"
                checked={isWhitelisted}
                color={isWhitelisted ? 'good' : 'bad'}
                content={bit.name}
                onClick={() =>
                  act('mob_mute', {
                    'mute_flag': !isWhitelisted
                      ? client_muted | bit.bitflag
                      : client_muted & ~bit.bitflag,
                  })
                }
              />
            );
          })}
        </Stack>
      </Section>
    </Section>
  );
};
