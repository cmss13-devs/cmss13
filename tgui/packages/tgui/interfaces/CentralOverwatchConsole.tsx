import type { BooleanLike } from 'common/react';
import { capitalize } from 'common/string';
import { useState } from 'react';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Input,
  Section,
  Stack,
  Table,
  Tabs,
} from '../components';
import { ButtonConfirm } from '../components/Button';
import { Window } from '../layouts';
import { replaceRegexChars } from './helpers';

type MarineData = {
  name: string;
  state: string;
  has_helmet: BooleanLike;
  role: string;
  acting_sl: string;
  fteam: string;
  distance: string;
  area_name: string;
  ref: string;
};

type SquadData = {
  name: string;
  primary_objective: string;
  secondary_objective: string;
  overwatch_officer: string;
  ref: any;
};

type Data = {
  marines: MarineData[];
  squad_data: SquadData[];
  squad_leader: MarineData | null;
  living_count: number;
  leader_count: number;
  ftl_count: number;
  spec_count: number;
  medic_count: number;
  engi_count: number;
  smart_count: number;
  leaders_alive: number;
  ftl_alive: number;
  spec_alive: number;
  medic_alive: number;
  engi_alive: number;
  smart_alive: number;
  specialist_type: string;
  total_deployed: number;
  theme: string;
  squad_list: string[];
  current_squad: string;
  primary_objective: string[] | null;
  secondary_objective: string[] | null;
  z_hidden: BooleanLike;
  can_launch_obs: BooleanLike;
  ob_cooldown?: number;
  ob_loaded: BooleanLike;
  ob_safety: Boolean;
  supply_cooldown: number;
  operator: string;
  aa_targeting: string;
  primary_lz: string;
  alert_level: number;
  evac_status: string;
  world_time: number;
  distress_time_lock: number;
  time_request: number;
  ob_warhead: string;
  echo_squad_active: Boolean;
};

type Props = Partial<{
  minimised: boolean;
}>;

export const CentralOverwatchConsole = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Window
      width={850}
      height={700}
      theme={data.theme ? data.theme : 'crtblue'}
    >
      <Window.Content>
        {(!data.operator && <LoginPanel />) || (
          <Stack vertical height="100%">
            <Stack.Item>
              <CombinedSquadPanel />
            </Stack.Item>
            <Stack.Item m="0" grow>
              <SecondaryFunctions />
            </Stack.Item>
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};

const LoginPanel = (props) => {
  const { act, data } = useBackend<Data>();

  // Buttons don't seem to support hexcode colors, so we'll have to do this manually, sadly
  const squadColorMap = {
    alpha: 'red',
    bravo: 'yellow',
    charlie: 'purple',
    delta: 'blue',
    echo: 'green',
    foxtrot: 'brown',
    intel: 'green',
  };

  return (
    <Flex
      direction="column"
      justify="center"
      align="center"
      height="100%"
      fontSize="2rem"
      mt="-3rem"
      bold
    >
      <Box fontSize="2.5rem">GROUNDSIDE OPERATIONS CONSOLE</Box>
      <Box mb="7rem" fontFamily="monospace" fontSize="1.5rem">
        [ Version 2.1.8 | Copyright © 2182, Weyland Yutani Corp. ]
      </Box>
      <Box fontSize="2rem">INTERFACE ACCESS RESTRICTED</Box>
      <Box fontFamily="monospace" fontSize="1.7rem">
        [ IDENTITY VERIFICATION REQUIRED ]
      </Box>

      <Button
        icon="id-card"
        width="60vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        m="1rem"
        onClick={() => act('pick_squad', { squad: 'Root' })}
      >
        Login
      </Button>

      <Box fontFamily="monospace" fontSize="1.6rem">
        - UNAUTHORIZED USE STRICTLY PROHIBITED -
      </Box>
    </Flex>
  );
};

const SecondaryFunctions = (props) => {
  const { act, data } = useBackend<Data>();

  const [secondarycategory, setsecondaryCategory] = useSharedState(
    'secondaryselected',
    'squadmonitor',
  );

  const squadStringify = {
    alpha: 'red',
    bravo: 'yellow',
    charlie: 'purple',
    delta: 'blue',
    echo: 'green',
    foxtrot: 'brown',
    intel: 'green',
  };

  return (
    <Section fontSize="18px" fill>
      <Stack justify="center" align="top" height="100%">
        <Stack.Item width="24.5%">
          <Tabs fluid mr="0" fontSize="15px" vertical>
            <Tabs.Tab
              selected={secondarycategory === 'squadmonitor'}
              icon="heartbeat"
              onClick={() => setsecondaryCategory('squadmonitor')}
              p="3px"
              bold
            >
              Squad Monitor
            </Tabs.Tab>
            <Tabs.Tab
              selected={secondarycategory === 'execpanel'}
              icon="id-card"
              onClick={() => setsecondaryCategory('execpanel')}
              p="3px"
              bold
            >
              Executive Panel
            </Tabs.Tab>
            <Tabs.Tab
              selected={secondarycategory === 'emergencypanel'}
              icon="exclamation-triangle"
              onClick={() => setsecondaryCategory('emergencypanel')}
              p="3px"
              bold
            >
              Emergency Measures
            </Tabs.Tab>
            <Tabs.Tab
              selected={secondarycategory === 'ob'}
              icon="cog"
              onClick={() => setsecondaryCategory('ob')}
              p="3px"
              bold
            >
              Ordnance Systems
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item grow>
          {secondarycategory === 'ob' && data.can_launch_obs && (
            <OrbitalBombardment />
          )}
          {secondarycategory === 'squadmonitor' &&
            (data.current_squad !== 'Root' ? (
              <SquadMonitor />
            ) : (
              <CommandMonitor />
            ))}
          {secondarycategory === 'execpanel' && <ExecutivePanel />}
          {secondarycategory === 'emergencypanel' && <EmergencyPanel />}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CombinedSquadPanel = (props: Props) => {
  const { act, data } = useBackend<Data>();

  const [category, setCategory] = useSharedState('selected', 'root');

  let { squad_data, squad_leader } = data;

  const [minimised, setMinimised] = useState(props.minimised);

  const squadStringify = {
    alpha: 'red',
    bravo: 'yellow',
    charlie: 'purple',
    delta: 'blue',
    echo: 'green',
    foxtrot: 'brown',
    intel: 'green',
  };

  return (
    <Section
      fontSize="18px"
      title="Combined Overwatch Functions | "
      buttons={
        <>
          <Button icon="user" onClick={() => act('change_operator')}>
            Operator - {data.operator}
          </Button>
          <Button icon="sign-out-alt" onClick={() => act('logout')}>
            Sign Out
          </Button>
        </>
      }
      fitted
    >
      <Stack vertical justify="center" align="center">
        <Stack.Item width="100%">
          <Tabs fluid pr="0" pl="0" mb="0" fontSize="16px">
            {squad_data.length
              ? squad_data.map((squad, index) => {
                  return (
                    <Tabs.Tab
                      selected={category === squad.name.toLowerCase()}
                      onClick={() => {
                        setCategory(squad.name.toLowerCase());
                        act('gather_index_squad_data', { squad: squad.ref });
                      }}
                      key={index}
                    >
                      {squad.name + ' Overwatch'}
                    </Tabs.Tab>
                  );
                })
              : null}
            <Tabs.Tab
              selected={category === 'root'}
              onClick={() => {
                setCategory('root');
                act('gather_index_squad_data', { squad: 'root' });
              }}
            >
              {'Command Overwatch'}
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item align="center" width="100%">
          {data.squad_data.map((squad, index) => {
            return (
              <Stack.Item key={index} fontSize="13px">
                {category === squad.name.toLowerCase() && (
                  <Table>
                    <Table.Row>
                      <Table.Cell fontSize="15px" bold p="6px" colSpan={2}>
                        <Flex align="center">
                          <Flex.Item width="62.5%" pl="5px">
                            {'Overwatching Squad - [ ' + squad.name + ' ]'}
                          </Flex.Item>
                          <Flex.Item width="5%">
                            <Button
                              inline
                              width="80%"
                              icon="minus"
                              m="0px"
                              align="center"
                              tooltip={
                                '[ ' +
                                (minimised ? 'Expand' : 'Minimise') +
                                ' squad overview ]'
                              }
                              onClick={() => setMinimised(!minimised)}
                            />
                          </Flex.Item>
                          <Flex.Item grow>
                            <Button
                              pl="15px"
                              inline
                              width="100%"
                              icon="bullhorn"
                              m="0px"
                              onClick={() =>
                                act('announce', {
                                  announcement_type: 'groundside',
                                })
                              }
                            >
                              MAKE AN ANNOUNCEMENT
                            </Button>
                          </Flex.Item>
                        </Flex>
                      </Table.Cell>
                    </Table.Row>
                    {!minimised && (
                      <>
                        <Table.Row bold>
                          <Table.Cell textAlign="center">
                            PRIMARY ORDERS
                          </Table.Cell>
                          <Table.Cell rowSpan={5} width="65%">
                            <Table fontSize="12px" bold>
                              <Table.Row>
                                <Table.Cell
                                  textAlign="center"
                                  collapsing
                                  p="4px"
                                >
                                  Squad Leader
                                </Table.Cell>
                                <Table.Cell
                                  textAlign="center"
                                  collapsing
                                  p="4px"
                                >
                                  Fire Team Leaders
                                </Table.Cell>
                              </Table.Row>
                              <Table.Row>
                                {(data.leader_count && squad_leader && (
                                  <Table.Cell textAlign="center">
                                    {squad_leader.name
                                      ? squad_leader.name
                                      : 'NONE'}
                                    <Box
                                      color={
                                        squad_leader.state !== 'Dead'
                                          ? 'green'
                                          : 'red'
                                      }
                                    >
                                      {squad_leader.state.toUpperCase()}
                                    </Box>
                                  </Table.Cell>
                                )) || (
                                  <Table.Cell textAlign="center">
                                    NONE
                                    <Box color="red">NOT DEPLOYED</Box>
                                  </Table.Cell>
                                )}

                                <Table.Cell textAlign="center" bold>
                                  <Box>{data.ftl_count} DEPLOYED</Box>
                                  <Box color={data.ftl_alive ? 'green' : 'red'}>
                                    {data.ftl_alive} ALIVE
                                  </Box>
                                </Table.Cell>
                              </Table.Row>
                              <Table.Row>
                                <Table.Cell
                                  textAlign="center"
                                  collapsing
                                  p="4px"
                                >
                                  Specialist
                                </Table.Cell>
                                <Table.Cell
                                  textAlign="center"
                                  collapsing
                                  p="4px"
                                >
                                  Smartgunner
                                </Table.Cell>
                              </Table.Row>
                              <Table.Row>
                                <Table.Cell textAlign="center" bold>
                                  <Box>
                                    {data.specialist_type
                                      ? data.specialist_type
                                      : 'NONE'}
                                  </Box>
                                  <Box
                                    color={data.spec_alive ? 'green' : 'red'}
                                  >
                                    {data.spec_count
                                      ? data.spec_alive
                                        ? 'ALIVE'
                                        : 'DEAD'
                                      : 'NOT DEPLOYED'}
                                  </Box>
                                </Table.Cell>
                                <Table.Cell textAlign="center" bold>
                                  <Box
                                    color={data.smart_count ? 'green' : 'red'}
                                  >
                                    {data.smart_count
                                      ? data.smart_count + ' DEPLOYED'
                                      : 'NONE'}
                                  </Box>
                                  <Box
                                    color={data.smart_alive ? 'green' : 'red'}
                                  >
                                    {data.smart_count
                                      ? data.smart_alive
                                        ? 'ALIVE'
                                        : 'DEAD'
                                      : 'N/A'}
                                  </Box>
                                </Table.Cell>
                              </Table.Row>
                              <Table.Row>
                                <Table.Cell
                                  textAlign="center"
                                  collapsing
                                  p="4px"
                                >
                                  Hospital Corpsmen
                                </Table.Cell>
                                <Table.Cell
                                  textAlign="center"
                                  collapsing
                                  p="4px"
                                >
                                  Combat Technicians
                                </Table.Cell>
                              </Table.Row>
                              <Table.Row>
                                <Table.Cell textAlign="center" bold>
                                  <Box>{data.medic_count} DEPLOYED</Box>
                                  <Box
                                    color={data.medic_alive ? 'green' : 'red'}
                                  >
                                    {data.medic_alive} ALIVE
                                  </Box>
                                </Table.Cell>
                                <Table.Cell textAlign="center" bold>
                                  <Box>{data.engi_count} DEPLOYED</Box>
                                  <Box
                                    color={data.engi_alive ? 'green' : 'red'}
                                  >
                                    {data.engi_alive} ALIVE
                                  </Box>
                                </Table.Cell>
                              </Table.Row>
                              <Table.Row>
                                <Table.Cell
                                  textAlign="center"
                                  collapsing
                                  p="4px"
                                  colSpan={2}
                                >
                                  Total/Living
                                </Table.Cell>
                              </Table.Row>
                              <Table.Row>
                                <Table.Cell textAlign="center" bold colSpan={2}>
                                  <Box>{data.total_deployed} TOTAL</Box>
                                  <Box
                                    color={data.living_count ? 'green' : 'red'}
                                  >
                                    {data.living_count} ALIVE
                                  </Box>
                                </Table.Cell>
                              </Table.Row>
                            </Table>
                          </Table.Cell>
                        </Table.Row>
                        <Table.Row>
                          <Table.Cell textAlign="center" p="10px">
                            {squad.primary_objective
                              ? squad.primary_objective
                              : 'NONE'}
                          </Table.Cell>
                        </Table.Row>
                        <Table.Row bold>
                          <Table.Cell textAlign="center">
                            SECONDARY ORDERS
                          </Table.Cell>
                        </Table.Row>
                        <Table.Row>
                          <Table.Cell textAlign="center" p="10px">
                            {squad.secondary_objective
                              ? squad.secondary_objective
                              : 'NONE'}
                          </Table.Cell>
                        </Table.Row>
                        <Table.Row>
                          <Table.Cell>
                            <Box textAlign="center">
                              <Box>
                                <Stack.Item>
                                  <Button
                                    inline
                                    width="100%"
                                    icon="envelope"
                                    onClick={() => act('message')}
                                  >
                                    MESSAGE SQUAD
                                  </Button>
                                </Stack.Item>
                                <Stack.Item>
                                  <Button
                                    inline
                                    width="100%"
                                    icon="person"
                                    onClick={() => act('sl_message')}
                                  >
                                    MESSAGE SQUAD LEADER
                                  </Button>
                                </Stack.Item>
                                <Stack.Item>
                                  <Button
                                    icon="user"
                                    inline
                                    width="100%"
                                    compact
                                  >
                                    Overwatch Officer
                                    <Box>
                                      {squad.overwatch_officer
                                        ? squad.overwatch_officer
                                        : 'NONE'}
                                    </Box>
                                  </Button>
                                </Stack.Item>
                              </Box>
                            </Box>
                          </Table.Cell>
                        </Table.Row>
                      </>
                    )}
                  </Table>
                )}
              </Stack.Item>
            );
          })}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const ExecutivePanel = (props) => {
  const { act, data } = useBackend<Data>();
  const AlertLevel = data.alert_level;

  let alertLevelString;
  let alertLevelColor;
  if (AlertLevel === 3) {
    alertLevelString = 'DELTA';
    alertLevelColor = 'purple';
  }
  if (AlertLevel === 2) {
    alertLevelString = 'RED';
    alertLevelColor = 'red';
  }
  if (AlertLevel === 1) {
    alertLevelString = 'BLUE';
    alertLevelColor = 'blue';
  }
  if (AlertLevel === 0) {
    alertLevelString = 'GREEN';
    alertLevelColor = 'transperant';
  }

  return (
    <Section fill fontSize="14px">
      <Stack>
        <Stack.Item grow>
          <Box bold textAlign="center" mb="10px">
            GROUNDSIDE OPERATIONS
          </Box>
          <Box mb="10px" align="center">
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="bullhorn"
                p="4px"
                onClick={() =>
                  act('announce', { announcement_type: 'groundside' })
                }
              >
                MAKE AN ANNOUNCEMENT
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="map"
                p="4px"
                mt="3px"
                onClick={() => act('tacmap_unpin')}
              >
                VIEW TACTICAL MAP
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Divider />
              <Button
                inline
                width="100%"
                icon="home"
                p="3px"
                mt="1px"
                color={data.primary_lz ? 'transperant' : 'default'}
                onClick={() => act(data.primary_lz ? '' : 'selectlz')}
              >
                DESIGNATE PRIMARY LZ
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="users"
                mt="1px"
                p="3px"
                color={data.echo_squad_active ? 'transperant' : 'default'}
                onClick={() =>
                  act(data.echo_squad_active ? '' : 'activate_echo')
                }
              >
                ACTIVATE ECHO SQUAD
              </Button>
            </Stack.Item>
          </Box>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item grow>
          <Box bold textAlign="center" mb="10px">
            SHIP CONTROL
          </Box>
          <Box mb="10px" align="center">
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="exclamation-triangle"
                p="3px"
                onClick={() => act('change_sec_level')}
              >
                CHANGE ALERT LEVEL
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button inline width="100%" color={alertLevelColor}>
                CURRENT ALERT LEVEL: {alertLevelString}
              </Button>
            </Stack.Item>
            <Divider />
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="bullhorn"
                mb="3px"
                onClick={() =>
                  act('announce', { announcement_type: 'shipside' })
                }
              >
                MAKE A SHIPWIDE ANNOUNCEMENT
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="paper-plane"
                onClick={() => act('messageUSCM')}
              >
                MESSAGE USCM HIGH COMMAND
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="medal"
                mt="1px"
                onClick={() => act('award')}
              >
                AWARD A MEDAL
              </Button>
            </Stack.Item>
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const EmergencyPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const AlertLevel = data.alert_level;
  const evacstatus = data.evac_status;
  const world_time = data.world_time;

  let emergencylockout;
  if (AlertLevel >= 2) {
    emergencylockout = null;
  }
  if (AlertLevel < 2) {
    emergencylockout = 1;
  }

  const minimumTimeElapsed = world_time > data.distress_time_lock;

  const canRequest = // requesting distress beacon
    data.time_request < world_time && AlertLevel === 2 && minimumTimeElapsed;

  let distress_reason;

  if (AlertLevel === 3) {
    distress_reason = 'Self-destruct in progress. Beacon disabled.';
  } else if (AlertLevel !== 2) {
    distress_reason = 'Ship is not under an active emergency.';
  } else if (data.time_request < world_time) {
    distress_reason =
      'Beacon is currently recharging. Time remaining: ' +
      Math.ceil((data.time_request - world_time) / 10) +
      'secs.';
  } else if (!minimumTimeElapsed) {
    distress_reason = "It's too early to launch a distress beacon.";
  }

  return (
    <Section fill fontSize="14px">
      <Divider />
      <Box bold textAlign="center">
        EMERGENCY MEASURES
      </Box>
      <Stack vertical>
        <Stack.Item align="center">
          <Box bold italic fontSize="12px" textAlign="center">
            The ship must be under red alert in order to enact evacuation
            procedures
          </Box>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <ButtonConfirm
            inline
            textAlign="center"
            width="100%"
            icon={emergencylockout ? 'exclamation-triangle' : false}
            mt="1px"
            p="7px"
            color={emergencylockout ? 'red' : 'transperant'}
            onClick={emergencylockout ? () => act('red_alert') : undefined}
          >
            {emergencylockout
              ? 'ELEVATE TO RED ALERT'
              : '- ALREADY AT RED ALERT -'}
          </ButtonConfirm>
          <ButtonConfirm
            inline
            textAlign="center"
            width="100%"
            icon={emergencylockout ? 'ban' : 'exclamation-triangle'}
            mt="5px"
            p="4px"
            color={emergencylockout ? 'transperant' : 'red'}
            onClick={
              emergencylockout ? undefined : () => act('general_quarters')
            }
          >
            CALL GENERAL QUARTERS
          </ButtonConfirm>
        </Stack.Item>
        <Stack.Divider mb="7px" />
        <Stack.Item>
          <Box mb="10px" align="center">
            <Stack.Item>
              <ButtonConfirm
                inline
                width="100%"
                icon="door-open"
                color={emergencylockout ? 'transperant' : 'red'}
                onClick={
                  emergencylockout
                    ? undefined
                    : () =>
                        act(
                          evacstatus ? 'evacuation_cancel' : 'evacuation_start',
                        )
                }
              >
                {evacstatus ? 'CANCEL EVACUATION' : 'INITIATE EVACUATION'}
              </ButtonConfirm>
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="ban"
                mt="1px"
                color="transperant"
              >
                SELF-DESTRUCT DISABLED
              </Button>
            </Stack.Item>
            <Stack.Item>
              {!canRequest && (
                <Button
                  tooltip={distress_reason}
                  fluid
                  icon="ban"
                  color="transperant"
                  inline
                  width="100%"
                  mt="1px"
                >
                  DISTRESS BEACON DISABLED
                </Button>
              )}
              {canRequest && (
                <Button.Confirm
                  color="orange"
                  icon="phone-volume"
                  confirmColor="bad"
                  confirmContent="Confirm?"
                  confirmIcon="question"
                  inline
                  width="100%"
                  mt="1px"
                  onClick={() => act('distress')}
                >
                  SEND DISTRESS BEACON
                </Button.Confirm>
              )}
            </Stack.Item>
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const SquadMonitor = (props) => {
  const { act, data } = useBackend<Data>();

  const sortByRole = (a, b) => {
    a = a.role;
    b = b.role;
    const roleValues = {
      'Squad Leader': 10,
      'Fireteam Leader': 9,
      'Weapons Specialist': 8,
      Smartgunner: 7,
      'Hospital Corpsman': 6,
      'Combat Technician': 5,
      Rifleman: 4,
    };
    let valueA = roleValues[a];
    let valueB = roleValues[b];
    if (a.includes('Weapons Specialist')) {
      valueA = roleValues['Weapons Specialist'];
    }
    if (b.includes('Weapons Specialist')) {
      valueB = roleValues['Weapons Specialist'];
    }
    if (!valueA && !valueB) return 0; // They're both unknown
    if (!valueA) return 1; // B is defined but A is not
    if (!valueB) return -1; // A is defined but B is not

    if (valueA > valueB) return -1; // A is more important
    if (valueA < valueB) return 1; // B is more important

    return 0; // They're equal
  };

  let { marines, squad_data, squad_leader, leaders_alive } = data;

  const [showHiddenMarines, setShowHiddenMarines] = useSharedState(
    'showhidden',
    false,
  );
  const [showDeadMarines, setShowDeadMarines] = useSharedState(
    'showdead',
    true,
  );

  const [marineSearch, setMarineSearch] = useSharedState('marinesearch', '');

  let determine_status_color = (status) => {
    let conscious = status.includes('Conscious');
    let unconscious = status.includes('Unconscious');

    let state_color = 'red';
    if (conscious) {
      state_color = 'green';
    } else if (unconscious) {
      state_color = 'yellow';
    }
    return state_color;
  };

  let location_filter;
  if (data.z_hidden === 2) {
    location_filter = 'groundside';
  } else if (data.z_hidden === 1) {
    location_filter = 'shipside';
  } else {
    location_filter = 'all';
  }

  return (
    <Section
      fill
      fontSize="14px"
      title="Squad Monitor"
      buttons={
        <>
          <Button
            color="yellow"
            tooltip="Show marines depending on location"
            onClick={() => act('change_locations_ignored')}
          >
            Shown: {location_filter}
          </Button>
          {(showDeadMarines && (
            <Button color="yellow" onClick={() => setShowDeadMarines(false)}>
              Hide dead
            </Button>
          )) || (
            <Button color="yellow" onClick={() => setShowDeadMarines(true)}>
              Show dead
            </Button>
          )}
          {(showHiddenMarines && (
            <Button color="yellow" onClick={() => setShowHiddenMarines(false)}>
              Hide hidden
            </Button>
          )) || (
            <Button color="yellow" onClick={() => setShowHiddenMarines(true)}>
              Show hidden
            </Button>
          )}
          <Button
            color="yellow"
            icon="arrow-right"
            onClick={() => act('transfer_marine')}
          >
            Transfer Marine
          </Button>
        </>
      }
    >
      <Stack vertical fill height="100%">
        <Stack.Item>
          <Input
            fluid
            placeholder="Search.."
            value={marineSearch}
            onInput={(e, value) => setMarineSearch(value)}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Section m="0px" mb="3px" scrollable fill fitted>
            <Table>
              <Table.Row bold fontSize="14px">
                <Table.Cell textAlign="center">Name</Table.Cell>
                <Table.Cell textAlign="center">Role</Table.Cell>
                <Table.Cell textAlign="center" collapsing>
                  State
                </Table.Cell>
                <Table.Cell textAlign="center">Location</Table.Cell>
                <Table.Cell textAlign="center" collapsing fontSize="12px">
                  SL Dist.
                </Table.Cell>
              </Table.Row>
              {squad_leader && data.leader_count ? (
                <Table.Row bold>
                  <Table.Cell collapsing p="2px">
                    {(squad_leader.has_helmet && (
                      <Button
                        onClick={() =>
                          act('watch_camera', {
                            target_ref: squad_leader.ref,
                          })
                        }
                      >
                        {squad_leader.name}
                      </Button>
                    )) || (
                      <Box color="yellow">{squad_leader.name} (NO HELMET)</Box>
                    )}
                  </Table.Cell>
                  <Table.Cell p="2px">{squad_leader.role}</Table.Cell>
                  <Table.Cell
                    p="2px"
                    color={determine_status_color(squad_leader.state)}
                  >
                    {squad_leader.state}
                  </Table.Cell>
                  <Table.Cell p="2px">{squad_leader.area_name}</Table.Cell>
                  <Table.Cell p="2px" collapsing>
                    {squad_leader.distance}
                  </Table.Cell>
                </Table.Row>
              ) : (
                <div />
              )}
              {marines.length ? (
                marines
                  .sort(sortByRole)
                  .filter((marine) => {
                    if (marineSearch) {
                      const searchableString = String(
                        marine.name,
                      ).toLowerCase();
                      return searchableString.match(
                        new RegExp(replaceRegexChars(marineSearch), 'i'),
                      );
                    }
                    return marine;
                  })
                  .map((marine, index) => {
                    if (squad_leader) {
                      if (marine.ref === squad_leader.ref) {
                        return;
                      }
                    }
                    if (marine.state === 'Dead' && !showDeadMarines) {
                      return;
                    }

                    return (
                      <Table.Row key={marine.ref}>
                        <Table.Cell collapsing p="2px">
                          {(marine.has_helmet && (
                            <Button
                              onClick={() =>
                                act('watch_camera', {
                                  target_ref: marine.ref,
                                })
                              }
                            >
                              {marine.name}
                            </Button>
                          )) || (
                            <Box color="yellow">{marine.name} (NO HELMET)</Box>
                          )}
                        </Table.Cell>
                        <Table.Cell p="2px">{marine.role}</Table.Cell>
                        <Table.Cell
                          p="2px"
                          color={determine_status_color(marine.state)}
                        >
                          {marine.state}
                        </Table.Cell>
                        <Table.Cell p="2px">{marine.area_name}</Table.Cell>
                        <Table.Cell p="2px" collapsing>
                          {marine.distance}
                        </Table.Cell>
                      </Table.Row>
                    );
                  })
              ) : (
                <div />
              )}
            </Table>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CommandMonitor = (props) => {
  const { act, data } = useBackend<Data>();

  let { marines } = data;

  const rankFinder = {
    'Commanding Officer': 'MAJ. ',
    'Executive Officer': 'CAPT. ',
    'Staff Officer': 'LT. ',
  };

  let determine_status_color = (status) => {
    let conscious = status.includes('Conscious');
    let unconscious = status.includes('Unconscious');

    let state_color = 'red';
    if (conscious) {
      state_color = 'green';
    } else if (unconscious) {
      state_color = 'yellow';
    }
    return state_color;
  };

  return (
    <Section
      fill
      fontSize="14px"
      title="USS ALMAYER - COMMAND PERSONNEL"
      scrollable
    >
      <Stack vertical fill height="100%" width="100%">
        {marines.map((marine, index) => {
          return (
            <Stack.Item key={marine.ref}>
              <Section fitted mb="6px">
                <Box
                  bold
                  backgroundColor="#8ac8ff"
                  textColor="#000011"
                  p="1px"
                  pl="5px"
                  pb="3.5px"
                  fontSize="1.25rem"
                >
                  <Flex>
                    <Flex.Item width="50%" align="center">
                      {marine.role.toUpperCase()}
                    </Flex.Item>
                    <Flex.Item grow>
                      <Button
                        fluid
                        textColor="#8ac8ff"
                        backgroundColor="#000011"
                        fontSize="1.15rem"
                        m="-1px"
                        icon={marine.has_helmet ? 'satellite-dish' : 'ban'}
                        pl="10px"
                        onClick={() =>
                          act('watch_camera', {
                            target_ref: marine.ref,
                          })
                        }
                      >
                        {marine.has_helmet
                          ? 'VIEW HELMET CAMERA'
                          : 'NO HELMET FOUND'}
                      </Button>
                    </Flex.Item>
                  </Flex>
                </Box>
                <Flex>
                  <Flex.Item width="50%">
                    <Box
                      fontSize="2rem"
                      bold
                      p="5px"
                      pt="15px"
                      pb="15px"
                      align="center"
                    >
                      {rankFinder[marine.role] + marine.name.toUpperCase()}
                    </Box>
                  </Flex.Item>
                  <Flex.Item textAlign="end" align="center">
                    <Box>State:</Box>
                    <Box>Location:</Box>
                  </Flex.Item>
                  <Flex.Item pl="3px" bold align="center">
                    <Box textColor={determine_status_color(marine.state)}>
                      {marine.state.toUpperCase()}
                    </Box>
                    <Box>{marine.area_name}</Box>
                  </Flex.Item>
                </Flex>
              </Section>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};

const OrbitalBombardment = (props) => {
  const { act, data } = useBackend<Data>();

  let { ob_safety } = data;

  let ob_status = 'Ready';
  let ob_color = 'green';
  let ob_warhead = 'No Shells Loaded';
  if (data.ob_warhead) {
    ob_warhead = capitalize(data.ob_warhead) + ' Shell Loaded';
  }
  if (data.ob_cooldown) {
    ob_status = 'Cooldown - ' + data.ob_cooldown / 10 + ' seconds';
    ob_color = 'yellow';
  } else if (!data.ob_loaded) {
    ob_status = 'Not chambered';
    ob_color = 'red';
  }

  return (
    <Section fill fontSize="14px">
      <Stack justify={'space-between'} m="10px">
        <Stack.Item fontSize="13px" bold width="50%">
          Orbital Bombardment Subsystem:
          <Box color="green" bold m="2px">
            [ Fully Operational ]
          </Box>
          Warhead Status:
          <Box color={ob_color} bold m="2px">
            [ {ob_warhead} ]
          </Box>
          Cannon Status:
          <Box color={ob_color} bold m="2px">
            [ {ob_status.toUpperCase()} ]
          </Box>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item width="50%" ml="15px">
          <Box textAlign="center" bold>
            <Table>
              <Table.Cell fontSize="14px" m="2px" p="7px" textAlign="center">
                OB SAFETY SYSTEM:
                <Box
                  color={ob_safety ? 'green' : 'red'}
                  m="1px"
                  fontSize="16px"
                >
                  [ {ob_safety ? 'ENGAGED' : 'DISENGAGED'} ]
                </Box>
                <Button
                  fontSize="16px"
                  width="96%"
                  color="transperant"
                  p="5px"
                  m="4px"
                >
                  Keycard Override Required
                </Button>
              </Table.Cell>
            </Table>
          </Box>
        </Stack.Item>
      </Stack>
      <Divider />
      <Stack justify={'space-between'} m="10px">
        <Stack.Item fontSize="13px" bold width="50%" mt="5px">
          IX-50 MGAD Cannon Subsystem:
          <Box color="green" bold m="2px">
            [ Fully Operational ]
          </Box>
          Currently Targeting:
          <Box color={data.aa_targeting ? 'green' : 'red'} bold m="2px">
            [ {data.aa_targeting ? data.aa_targeting : 'Zone Not Selected'} ]
          </Box>
          Cannon Status:
          <Box color={data.aa_targeting ? 'green' : 'red'} bold m="2px">
            [ {data.aa_targeting ? 'ENGAGED' : 'DISENGAGED'} ]
          </Box>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item fontSize="13px" bold width="50%" ml="15px" mt="5px">
          Mk 33 ASAT Railgun Subsystem:
          <Box color="red" bold m="2px">
            [ Operations Suspended ]
          </Box>
          Available Ammunition:
          <Stack m="7px" ml="1px">
            <Stack.Item>
              <Box bold ml="2px">
                ASAT-21
              </Box>
              <Box color="red" bold ml="2px">
                [ EXPENDED ]
              </Box>
            </Stack.Item>
            <Stack.Item ml="15px">
              <Box bold ml="5px">
                BGM-227
              </Box>
              <Box color="red" bold ml="5px">
                [ EXPENDED ]
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      <Divider />
    </Section>
  );
};
