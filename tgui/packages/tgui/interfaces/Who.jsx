import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Icon,
  Input,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const Who = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    base_data,
    player_additional,
    player_stealthed_additional,
    factions_additional,
  } = data;

  const total_players = mergeArrays(
    base_data.total_players,
    player_additional?.total_players,
    player_stealthed_additional?.total_players,
  );

  const [searchQuery, setSearchQuery] = useLocalState('searchQuery', '');

  const searchPlayers = () =>
    total_players.filter((playerObj) => isMatch(playerObj, searchQuery));

  const filteredTotalPlayers = searchPlayers();

  return (
    <Window resizable width={800} height={600}>
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
                    onEnter={(e, value) =>
                      act('get_player_panel', {
                        ckey: searchPlayers()?.[0][0],
                      })
                    }
                    onInput={(e) => setSearchQuery(e.target.value)}
                    placeholder="Search..."
                    value={searchQuery}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item mt={0.2} grow>
            {filteredTotalPlayers ? (
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
            ) : null}
            {factions_additional ? (
              <Section>
                <WhoCollapsible title="Information" color="olive">
                  <Box direction="column">
                    {factions_additional.map((x, index) => (
                      <GetAddInfo
                        key={index}
                        content={x.content}
                        color={x.color}
                        text={x.text}
                      />
                    ))}
                  </Box>
                </WhoCollapsible>
              </Section>
            ) : null}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const WhoCollapsible = (props, context) => {
  const { act } = useBackend(context);
  const { title, color, children } = props;
  return (
    <Collapsible title={title} color={color} open>
      {children}
    </Collapsible>
  );
};

const GetAddInfo = (props, context) => {
  const { act } = useBackend(context);
  const { content, color, text } = props;

  return (
    <Button
      color={'transparent'}
      style={{
        'border-color': color,
        'border-style': 'solid',
        'border-width': '1px',
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
  const { act } = useBackend(context);
  const { players_to_filter } = props;

  return players_to_filter.map((x) => {
    const ckey = Object.keys(x)[0];
    const params = x[ckey];
    const extractedParams = {};
    params.forEach((param) => {
      Object.keys(param).forEach((key) => {
        extractedParams[key] = param[key];
      });
    });
    return <GetPlayerInfo key={ckey} ckey={ckey} {...extractedParams} />;
  });
};

const GetPlayerInfo = (props, context) => {
  const { act } = useBackend(context);
  const { ckey, text, ckey_color, color } = props;

  return (
    <Button
      color={'transparent'}
      style={{
        'border-color': color ? color : '#2185d0',
        'border-style': 'solid',
        'border-width': '1px',
        color: color ? color : ckey_color,
      }}
      onClick={() => act('get_player_panel', { ckey: ckey })}
      tooltip={text}
      tooltipPosition="bottom-start"
    >
      <div color={color ? color : ckey_color}>{ckey}</div>
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
    if (!array) {
      return;
    }

    array.forEach((item) => {
      if (!item) {
        return;
      }

      const key = Object.keys(item)[0];
      const value = item[key];

      if (!mergedObject[key]) {
        mergedObject[key] = [];
      }

      value.forEach((subItem) => {
        if (!subItem) {
          return;
        }

        const subKey = Object.keys(subItem)[0];
        const subValue = subItem[subKey];

        const existingItem = mergedObject[key].find(
          (funny_value) => Object.keys(funny_value)[0] === subKey,
        );

        if (existingItem) {
          existingItem[subKey] = subValue;
        } else {
          mergedObject[key].push({ [subKey]: subValue });
        }
      });
    });
  });

  return Object.keys(mergedObject).map((key) => ({ [key]: mergedObject[key] }));
};
