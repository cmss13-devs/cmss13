
import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Stack, Table } from '../components';
import { BoxProps } from '../components/Box';
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
  tl?: SquadMarineEntry | [];
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
  user: {name: string, observer: number}
}

const FireTeamLead = (props: {fireteam: FireTeamEntry, ft: string}, context) => {
  const { data, act } = useBackend<SquadProps>(context);
  const fireteamLead = props.fireteam.tl;
  if (fireteamLead === undefined) {
    return <span>Team Lead: Unassigned</span>;
  }

  if (fireteamLead instanceof Array) {
    return <span>Team Lead: Unassigned</span>;
  }

  const demote = () => act('demote_ftl', { target_ft: props.ft });
  return (
    <Flex fill justify="space-between">
      <Flex.Item>
        Team Lead: {fireteamLead.name}
      </Flex.Item>
      <Flex.Item>
        {fireteamLead.name !== 'Not assigned'
            && (
            <Button icon="xmark" onClick={demote} />
        )}
      </Flex.Item>
    </Flex>);
};
interface FireteamBoxProps extends BoxProps {
  name: string;
}

const FireteamBox = (props: FireteamBoxProps, context) => {
  return (
    <Box className="FireteamBox">
      <div className="Title">
        {props.name}
      </div>
      {props.children}
    </Box>
  );
};

const FireTeam = (props: {ft: string}, context) => {
  const { data, act } = useBackend<SquadProps>(context);
  const fireteam: FireTeamEntry = data.fireteams[props.ft];
  const members: SquadMarineEntry[] = Object.keys(fireteam.mar).map(x => fireteam.mar[x]);
  return (
    <FireteamBox name={fireteam.name}>
      <Stack vertical>
        {members.length === 0
        && (
          <Stack.Item>
            <span>Fireteam is empty.</span>
          </Stack.Item>
        )}
        {members.length > 0
          && (
            <>
              <Stack.Item>
                <FireTeamLead fireteam={fireteam} ft={props.ft} />
              </Stack.Item>
              <Stack.Item>
                <Button onClick={() => act('disband_ft', { target_ft: props.ft })}>
                  Disband
                </Button>
              </Stack.Item>
              <hr />
              <Stack.Item>
                <Table className="FireteamMembersTable">
                  <TableRow>
                    <TableCell>
                      Rank
                    </TableCell>
                    <TableCell>
                    Member
                    </TableCell>
                    <TableCell>
                    Actions
                    </TableCell>
                  </TableRow>
                  {members.map(x => (
                    <TableRow key={x.name}>
                      <FireTeamMember member={x} key={x.name} team={props.ft} fireteam={fireteam} />
                    </TableRow>))
                  }
                </Table>
              </Stack.Item>
            </>)}
      </Stack>
    </FireteamBox>);
};

const FireTeamMember = (props: {member: SquadMarineEntry, team: string, fireteam?: FireTeamEntry}, context) => {
  const { data, act } = useBackend<SquadProps>(context);
  const assignFT1 = { target_ft: 'FT1', target_marine: props.member.name };
  const assignFT2 = { target_ft: 'FT2', target_marine: props.member.name };
  const assignFT3 = { target_ft: 'FT3', target_marine: props.member.name };

  const promote = () => {
    const teamlead = props.fireteam?.tl;
    if (teamlead !== undefined && !(teamlead instanceof Array)) {
      if (teamlead.name !== "Not assigned") {
        act('demote_ftl', { target_ft: props.team, target_marine: teamlead.name });
      }
    }
    act('promote_ftl', { target_ft: props.team, target_marine: props.member.name });
  };

  const unassign = () => act('unassign_ft', { target_ft: props.team, target_marine: props.member.name });

  return (
    <>
      <TableCell>
          {props.member.rank}
      </TableCell>
      <TableCell>
        {props.member.name}
      </TableCell>
      {props.team === "unassigned"
        && (
          <TableCell>
            <Flex justify="space-around">
              <Flex.Item>
                <Button onClick={() => act('assign_ft', assignFT1)}>
                  FT1
                </Button>
              </Flex.Item>
              <Flex.Item>
                <Button onClick={() => act('assign_ft', assignFT2)}>
                  FT2
                </Button>
              </Flex.Item>
              <Flex.Item>
                <Button onClick={() => act('assign_ft', assignFT3)}>
                  FT3
                </Button>
              </Flex.Item>
            </Flex>
          </TableCell>
        )}
      {props.team !== "unassigned"
        && (
          <TableCell>
            <Flex fill justify="space-around">
              <Flex.Item>
                <Button icon="chevron-up" onClick={promote} />
              </Flex.Item>
              <Flex.Item>
                <Button icon="xmark" onClick={unassign} />
              </Flex.Item>
            </Flex>
          </TableCell>
        )}
    </>);
};

const UnassignedMembers = (_, context) => {
  const { data } = useBackend<SquadProps>(context);
  const unassignedMembers: SquadMarineEntry[] = Object.keys(data.mar_free).map(x => data.mar_free[x]);
  return (
    <>
      {unassignedMembers.length === 0 && (
        <span>No unassigned members</span>
      )}
      {unassignedMembers.length > 0
        && (
          <Section title="Unassigned">
            <Table className="FireteamMembersTable">
              <TableRow>
                <TableCell>
                  Rank
                </TableCell>
                <TableCell>
                  Name
                </TableCell>
                <TableCell>
                  Actions
                </TableCell>
              </TableRow>
              {unassignedMembers.map(x => <FireTeamMember member={x} key={x.name} team="unassigned" />)}
            </Table>
          </Section>)}
    </>);
};

export const SquadInfo = (_, context) => {
  const { data } = useBackend<SquadProps>(context);
  return (
    <Window width={680} height={500} theme="ntos">
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <Section title={`Squad Leader: ${data.sl?.name ?? 'None'}`}>
              <Flex justify="space-between">
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
            </Section>
          </Stack.Item>
          <hr />
          <Stack.Item>
            <UnassignedMembers />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>);
};
