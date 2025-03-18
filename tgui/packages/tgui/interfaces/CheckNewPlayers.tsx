import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Icon,
  Input,
  LabeledList,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';

type NewPlayerData = {
  new_players: NewPlayer[];
};

type NewPlayer = {
  ckey: string;
  client_hours: number;
  first_join: string;
  days_first_join: number;
  byond_account_age: string;
};

type SortConfig = {
  key: keyof NewPlayer;
  direction: 'asc' | 'desc';
};

export const CheckNewPlayers = () => {
  const { data, act } = useBackend<NewPlayerData>();
  const { new_players } = data;

  const [clientHoursFilter, setClientHoursFilter] = useState('');
  const [daysFirstJoinFilter, setDaysFirstJoinFilter] = useState('');
  const [sortConfig, setSortConfig] = useState<SortConfig | null>({
    key: 'days_first_join',
    direction: 'asc',
  });

  const sortedPlayers = [...new_players].sort((a, b) => {
    if (!sortConfig) return 0;

    const key = sortConfig.key;
    const valueA = a[key];
    const valueB = b[key];

    if (typeof valueA === 'number' && typeof valueB === 'number') {
      return sortConfig.direction === 'asc' ? valueA - valueB : valueB - valueA;
    }

    if (typeof valueA === 'string' && typeof valueB === 'string') {
      return sortConfig.direction === 'asc'
        ? valueA.localeCompare(valueB)
        : valueB.localeCompare(valueA);
    }

    return 0;
  });

  const filteredPlayers = sortedPlayers.filter((player) => {
    const clientHoursMatch = clientHoursFilter
      ? player.client_hours < Number(clientHoursFilter)
      : true;

    const daysFirstJoinMatch = daysFirstJoinFilter
      ? player.days_first_join < Number(daysFirstJoinFilter)
      : true;

    return clientHoursMatch && daysFirstJoinMatch;
  });

  const handleSort = (key: keyof NewPlayer) => {
    let direction: 'asc' | 'desc' = 'asc';
    if (sortConfig?.key === key && sortConfig.direction === 'asc') {
      direction = 'desc';
    }
    setSortConfig({ key, direction });
  };

  const SortIcon = ({ sortKey }: { readonly sortKey: keyof NewPlayer }) => {
    if (sortConfig?.key !== sortKey) return null;
    return (
      <Icon
        name={sortConfig.direction === 'asc' ? 'sort-up' : 'sort-down'}
        ml={1}
      />
    );
  };

  return (
    <Window width={1000} height={600}>
      <Window.Content scrollable>
        <Section
          title="Filters"
          buttons={
            <Button
              icon="sync"
              onClick={() => act('update')}
              tooltip="Update"
            />
          }
        >
          <Stack>
            <Stack.Item grow>
              <LabeledList>
                <LabeledList.Item
                  label="Client Hours (less than)"
                  labelColor="label"
                >
                  <Input
                    placeholder="Filter by hours"
                    value={clientHoursFilter}
                    onChange={(e, value) => setClientHoursFilter(value)}
                    width="100%"
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item grow>
              <LabeledList>
                <LabeledList.Item
                  label="Days Since First Join (less than)"
                  labelColor="label"
                >
                  <Input
                    placeholder="Filter by days"
                    value={daysFirstJoinFilter}
                    onChange={(e, value) => setDaysFirstJoinFilter(value)}
                    width="100%"
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="New Players" mt={1}>
          <Table>
            <Table.Row header>
              <Table.Cell
                width="15%"
                textAlign="center"
                onClick={() => handleSort('ckey')}
              >
                Ckey <SortIcon sortKey="ckey" />
              </Table.Cell>
              <Table.Cell
                width="10%"
                textAlign="center"
                onClick={() => handleSort('client_hours')}
              >
                Playtime <SortIcon sortKey="client_hours" />
              </Table.Cell>
              <Table.Cell
                width="15%"
                textAlign="center"
                onClick={() => handleSort('first_join')}
              >
                First Joined <SortIcon sortKey="first_join" />
              </Table.Cell>
              <Table.Cell
                width="15%"
                textAlign="center"
                onClick={() => handleSort('days_first_join')}
              >
                Days Since Join <SortIcon sortKey="days_first_join" />
              </Table.Cell>
              <Table.Cell
                width="20%"
                textAlign="center"
                onClick={() => handleSort('byond_account_age')}
              >
                BYOND Account Age <SortIcon sortKey="byond_account_age" />
              </Table.Cell>
            </Table.Row>
            {filteredPlayers.map((player) => (
              <Table.Row key={player.ckey}>
                <Table.Cell textAlign="center">
                  <Button
                    icon="user"
                    color="good"
                    onClick={() =>
                      act('open_player_panel', { ckey: player.ckey })
                    }
                    onContextMenu={(e) => {
                      e.preventDefault();
                      act('follow', { ckey: player.ckey });
                    }}
                    tooltip={
                      <Box>
                        Left Click: Open Player Panel
                        <br />
                        Right Click: Follow
                      </Box>
                    }
                    style={{
                      width: '100%',
                      transition: 'all 0.1s',
                    }}
                    className="hover-button"
                  >
                    {player.ckey}
                  </Button>
                </Table.Cell>
                <Table.Cell textAlign="center">
                  {player.client_hours}h
                </Table.Cell>
                <Table.Cell textAlign="center">{player.first_join}</Table.Cell>
                <Table.Cell textAlign="center">
                  {player.days_first_join}d
                </Table.Cell>
                <Table.Cell textAlign="center">
                  {player.byond_account_age}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
          {filteredPlayers.length === 0 && (
            <Box textAlign="center" mt={2} color="label">
              No players matching filters
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
