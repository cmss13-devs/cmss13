
import { useBackend } from '../backend';
import { Button, Flex, Stack, Table } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

interface SquadLeadEntry {
  name: string;
  observer: number;
}

interface SquadMarineEntry {
  name: string;
  med: number;
  eng: number;
  status: null;
  refer?: string;
  paygrade: string;
  rank: string;
}

interface FireTeamEntry {
  name: string;
  total: number;
  tl?: SquadMarineEntry;
  mar: SquadMarineEntry[];
}

interface FireTeams {
  FT1: FireTeamEntry;
  FT2: FireTeamEntry;
  FT3: FireTeamEntry;
}

interface SquadProps {
  sl?: SquadLeadEntry;
  fireteams: FireTeams;
  mar_free: SquadMarineEntry[];
  total_mar: number;
  total_kia: number;
  total_free: number;
}

const SquadLeader = (_, context) => {
  const { data } = useBackend<SquadProps>(context);
  return (
    <Stack.Item>
      <span>
        Squad Leader: {data.sl?.name}
      </span>
    </Stack.Item>);
};

const FireTeam = (props: {ft: string}, context) => {
  const { data } = useBackend<SquadProps>(context);
  const fireteam: FireTeamEntry = data.fireteams[props.ft];
  const members: SquadMarineEntry[] = Object.keys(fireteam.mar).map(x => fireteam.mar[x]);
  return (
    <div>
      <Stack vertical>
        <Stack.Item>
          {fireteam.name}
        </Stack.Item>
        <Stack.Item>
          Team Lead: {fireteam.tl?.name} <Button>Demote</Button>
        </Stack.Item>
        <Stack.Item>
          <Table>
            <TableRow>
              <TableCell>
                Rank
              </TableCell>
              <TableCell>
                Member
              </TableCell>
            </TableRow>
            {members.map(x => <FireTeamMember member={x} key={x.name} team={fireteam.name} />)}
          </Table>
        </Stack.Item>
      </Stack>
    </div>);
};

const FireTeamMember = (props: {member: SquadMarineEntry, team: string}, context) => {
  const { data, act } = useBackend<SquadProps>(context);
  const assignFT1 = { target_ft: 'FT1', target_marine: props.member.name };
  const assignFT2 = { target_ft: 'FT2', target_marine: props.member.name };
  const assignFT3 = { target_ft: 'FT3', target_marine: props.member.name };
  return (
    <TableRow key={props.member.name}>
      <TableCell>
        {props.member.rank}
      </TableCell>
      <TableCell>
        {props.member.name}
      </TableCell>
      {props.team === "unassigned"
        && (
          <>
            <TableCell>
              <Button onClick={() => act('assign_ft', assignFT1)}>
                FT1
              </Button>
            </TableCell>
            <TableCell>
              <Button onClick={() => act('assign_ft', assignFT2)}>
                FT2
              </Button>
            </TableCell>
            <TableCell>
              <Button onClick={() => act('assign_ft', assignFT3)}>
                FT3
              </Button>
            </TableCell>
          </>
        )}
      {props.team !== "unassigned"
        && (
          <TableCell>
            <Button onClick={() => act('unassign_ft', { target_marine: props.member.name })}>
                Unassign
            </Button>
          </TableCell>
        )}
      <TableCell />
    </TableRow>);
};

export const SquadInfo = (_, context) => {
  const { data } = useBackend<SquadProps>(context);
  const unassignedMembers: SquadMarineEntry[] = Object.keys(data.mar_free).map(x => data.mar_free[x]);
  return (
    <Window width={680} height={500}>
      <Window.Content>
        <Stack vertical>
          {data.sl && <SquadLeader />}
          <Stack.Item>
            <Flex justify="space-between" fill>
              <Flex.Item>
                <FireTeam ft="FT1" />
              </Flex.Item>
              <Flex.Item>
                <FireTeam ft="FT2" />
              </Flex.Item>
              <Flex.Item>
                <FireTeam ft="FT3" />
              </Flex.Item>
            </Flex>
          </Stack.Item>
          <Stack.Item>
            <Table>
              {unassignedMembers.map(x => <FireTeamMember member={x} key={x.name} team="unassigned" />)}
            </Table>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>);
};
