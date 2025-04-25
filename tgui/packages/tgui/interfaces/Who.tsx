import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  Flex,
  Icon,
  Input,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type PlayerPayload = {
  text: string;
  ckey_color: string;
};

type FactionPayload = { content: string; color: string; text: string };

type Data = {
  base_data: {
    total_players: Record<string, { text: string; ckey_color: String }>;
  };
  player_additional: { total_players: PlayerPayload };
  player_stealthed_additional: { total_players: PlayerPayload };
  factions_additional: FactionPayload[];
};

export const Who = (props, context) => {
  const { act, data } = useBackend<Data>();
  const {
    base_data,
    player_additional,
    player_stealthed_additional,
    factions_additional,
  } = data;

  const total_players = mergeArrays(
    base_data?.total_players,
    player_additional?.total_players,
    player_stealthed_additional?.total_players,
  );

  const [searchQuery, setSearchQuery] = useState('');

  const searchPlayers = () =>
    total_players.filter((playerObj) => isMatch(playerObj, searchQuery));

  const filteredTotalPlayers = searchPlayers();

  return (
    <Window width={800} height={600}>
      <Window.Content scrollable>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item>
                  <Icon name="search" />
                </Stack.Item>
                <Stack.Item grow>
                  <Input
                    autoFocus
                    fluid
                    onEnter={(e, value) => {
                      const clientObj = searchPlayers()?.[0];
                      if (!clientObj) return;
                      act('get_player_panel', {
                        ckey: Object.keys(clientObj)[0],
                      });
                    }}
                    onInput={(e, value) => setSearchQuery(value)}
                    placeholder="Search..."
                    value={searchQuery}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item mt={0.2} grow>
            {filteredTotalPlayers && (
              <Section>
                <WhoCollapsible
                  title={'Players - ' + filteredTotalPlayers.length}
                  color="good"
                >
                  <Box>
                    <FilterPlayers players_to_filter={filteredTotalPlayers} />
                  </Box>
                </WhoCollapsible>
              </Section>
            )}
            {factions_additional && (
              <Section>
                <WhoCollapsible title="Information" color="olive">
                  <Flex direction="column">
                    {factions_additional.map((x, index) => (
                      <GetAddInfo
                        key={index}
                        content={x.content}
                        color={x.color}
                        text={x.text}
                      />
                    ))}
                  </Flex>
                </WhoCollapsible>
              </Section>
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const WhoCollapsible = (props, context) => {
  const { title, color, children } = props;
  return (
    <Collapsible title={title} color={color} open>
      {children}
    </Collapsible>
  );
};

const GetAddInfo = (props, context) => {
  const { content, color, text } = props;

  return (
    <Button
      color="transparent"
      style={{
        borderColor: color,
        borderStyle: 'solid',
        borderWidth: '1px',
        color: color,
      }}
      tooltip={text}
      tooltipPosition="bottom-start"
    >
      {content}
    </Button>
  );
};

const FilterPlayers = (props, context) => {
  const { players_to_filter } = props;

  return players_to_filter.map((clientObj) => {
    const ckey = Object.keys(clientObj)[0];
    return <GetPlayerInfo key={ckey} ckey={ckey} {...clientObj[ckey][0]} />;
  });
};

const GetPlayerInfo = (props, context) => {
  const { act } = useBackend<Data>();
  const { ckey, text, color, ckey_color } = props;

  return (
    <Button
      color="transparent"
      style={{
        borderColor: color || '#2185d0',
        borderStyle: 'solid',
        borderWidth: '1px',
        color: color || ckey_color || '#2185d0',
      }}
      onClick={() => act('get_player_panel', { ckey: ckey })}
      tooltip={text}
      tooltipPosition="bottom-start"
    >
      <div style={{ color: color || ckey_color || '#2185d0' }}>{ckey}</div>
    </Button>
  );
};

const isMatch = (playerObj, searchQuery) => {
  if (!searchQuery) {
    return true;
  }

  const key = Object.keys(playerObj)[0];
  return key.toLowerCase().includes(searchQuery?.toLowerCase()) || false;
};

// Krill me please
const mergeArrays = (...arrays) => {
  const mergedObject = {};

  arrays.forEach((array) => {
    if (!array) return;

    array.forEach((item) => {
      if (!item) return;

      const key = Object.keys(item)[0];
      const value = item[key];

      if (!mergedObject[key]) {
        mergedObject[key] = [];
      }

      value.forEach((subItem) => {
        if (typeof subItem !== 'object' || subItem === null) return;

        const existingItemIndex = mergedObject[key].findIndex(
          (existingSubItem) =>
            Object.keys(existingSubItem).some((subKey) =>
              Object.prototype.hasOwnProperty.call(subItem, subKey),
            ),
        );

        if (existingItemIndex !== -1) {
          mergedObject[key][existingItemIndex] = {
            ...mergedObject[key][existingItemIndex],
            ...subItem,
          };
        } else {
          mergedObject[key].push(subItem);
        }
      });
    });
  });

  return Object.keys(mergedObject).map((key) => ({ [key]: mergedObject[key] }));
};
