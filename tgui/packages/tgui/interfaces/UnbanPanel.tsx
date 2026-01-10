import { useBackend } from 'tgui/backend';
import { Button, Input, Stack, Table } from 'tgui/components';
import { Window } from 'tgui/layouts';

type UnbanData = {
  banned_players: Ban[];
  search: string;
};

type Ban = {
  ckey: string;
  ip: string;
  cid: string;
  permaban: boolean;
  timeban: boolean;
  expiry: string;
  admin: string;
  reason: string;
};

export const UnbanPanel = () => {
  const { data, act } = useBackend<UnbanData>();

  const { banned_players, search } = data;

  return (
    <Window width={850} height={450}>
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <Stack justify="end">
              <Stack.Item>
                <Input
                  placeholder="Search..."
                  value={search}
                  onChange={(_, val) => {
                    act('change_search', { ckey: val });
                  }}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Table>
              <Table.Row header>
                <Table.Cell>Ckey</Table.Cell>
                <Table.Cell>IP</Table.Cell>
                <Table.Cell>CID</Table.Cell>
                <Table.Cell>Reason</Table.Cell>
                <Table.Cell>Admin</Table.Cell>
                <Table.Cell>Expiry</Table.Cell>
              </Table.Row>
              {banned_players.map((ban) => (
                <Table.Row key={ban.ckey}>
                  <Table.Cell>{ban.ckey}</Table.Cell>
                  <Table.Cell>{ban.ip}</Table.Cell>
                  <Table.Cell>{ban.cid}</Table.Cell>
                  <Table.Cell>{ban.reason}</Table.Cell>
                  <Table.Cell>{ban.admin}</Table.Cell>
                  <Table.Cell>{ban.expiry}</Table.Cell>
                  <Table.Cell width="30px">
                    <Button
                      onClick={() => {
                        act(ban.permaban ? 'unban_perma' : 'unban_timed', {
                          ckey: ban.ckey,
                        });
                      }}
                    >
                      Unban
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
