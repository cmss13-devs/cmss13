import { capitalize } from 'common/string';

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

export const CentralOverwatchConsole = (props) => {
  const { act, data } = useBackend();

  return (
    <Window
      width={850}
      height={700}
      theme={data.theme ? data.theme : 'crtblue'}
    >
      <Window.Content>
        {(!data.operator && <LoginPanel />) || (
          <Stack vertical>
            <Stack.Item>
              <CombinedSquadPanel />
            </Stack.Item>
            <Stack.Item m="0">
              <SecondaryFunctions />
            </Stack.Item>
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};

const LoginPanel = (props) => {
  const { act, data } = useBackend();

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
  const { act, data } = useBackend();

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
      <Stack horizontal justify="center" align="end">
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
          {secondarycategory === 'squadmonitor' && <SquadMonitor />}
          {secondarycategory === 'execpanel' && <ExecutivePanel />}
          {secondarycategory === 'emergencypanel' && <EmergencyPanel />}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CombinedSquadPanel = (props) => {
  const { act, data } = useBackend();

  const [category, setCategory] = useSharedState('selected', 'alpha');

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
      <Stack vertical justify="center" align="end">
        <Stack.Item>
          <Tabs fluid pr="0" pl="0" mb="0" fontSize="16px">
            {data.squad_data.map((squad, index) => {
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
            })}
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          {data.squad_data.map((squad, index) => {
            return (
              <Stack.Item key={index} fontSize="13px">
                {category === squad.name.toLowerCase() && (
                  <Table>
                    <Table.Row>
                      <Table.Cell fontSize="15px" bold p="6px" colSpan={2}>
                        {'Overwatching Squad - [ ' + squad.name + ' ]'}
                      </Table.Cell>
                    </Table.Row>
                    <Table.Row bold>
                      <Table.Cell textAlign="center">PRIMARY ORDERS</Table.Cell>
                      <Table.Cell rowSpan={5} width="65%">
                        <Table fontSize="12px" bold>
                          <Table.Row>
                            <Table.Cell textAlign="center" collapsing p="4px">
                              Squad Leader
                            </Table.Cell>
                            <Table.Cell textAlign="center" collapsing p="4px">
                              Fire Team Leaders
                            </Table.Cell>
                          </Table.Row>
                          <Table.Row>
                            {(squad.squad_leader && (
                              <Table.Cell textAlign="center">
                                {squad.squad_leader
                                  ? squad.squad_leader
                                  : 'NONE'}
                                <Box
                                  color={
                                    squad.squad_leader.stat === '2'
                                      ? 'green'
                                      : 'red'
                                  }
                                >
                                  {squad.squad_leader.stat !== 2
                                    ? 'ALIVE'
                                    : 'DEAD'}
                                </Box>
                              </Table.Cell>
                            )) || (
                              <Table.Cell textAlign="center">
                                NONE
                                <Box color="red">NOT DEPLOYED</Box>
                              </Table.Cell>
                            )}

                            <Table.Cell textAlign="center" bold>
                              <Box>{squad.ftl_count} DEPLOYED</Box>
                              <Box color={squad.ftl_alive ? 'green' : 'red'}>
                                {squad.ftl_alive} ALIVE
                              </Box>
                            </Table.Cell>
                          </Table.Row>
                          <Table.Row>
                            <Table.Cell textAlign="center" collapsing p="4px">
                              Specialist
                            </Table.Cell>
                            <Table.Cell textAlign="center" collapsing p="4px">
                              Smartgunner
                            </Table.Cell>
                          </Table.Row>
                          <Table.Row>
                            <Table.Cell textAlign="center" bold>
                              <Box>
                                {squad.specialist_type
                                  ? squad.specialist_type
                                  : 'NONE'}
                              </Box>
                              <Box color={squad.spec_alive ? 'green' : 'red'}>
                                {squad.spec_count
                                  ? squad.spec_alive
                                    ? 'ALIVE'
                                    : 'DEAD'
                                  : 'NOT DEPLOYED'}
                              </Box>
                            </Table.Cell>
                            <Table.Cell textAlign="center" bold>
                              <Box color={squad.smart_count ? 'green' : 'red'}>
                                {squad.smart_count
                                  ? squad.smart_count + ' DEPLOYED'
                                  : 'NONE'}
                              </Box>
                              <Box color={squad.smart_alive ? 'green' : 'red'}>
                                {squad.smart_count
                                  ? squad.smart_alive
                                    ? 'ALIVE'
                                    : 'DEAD'
                                  : 'N/A'}
                              </Box>
                            </Table.Cell>
                          </Table.Row>
                          <Table.Row>
                            <Table.Cell textAlign="center" collapsing p="4px">
                              Hospital Corpsmen
                            </Table.Cell>
                            <Table.Cell textAlign="center" collapsing p="4px">
                              Combat Technicians
                            </Table.Cell>
                          </Table.Row>
                          <Table.Row>
                            <Table.Cell textAlign="center" bold>
                              <Box>{squad.medic_count} DEPLOYED</Box>
                              <Box color={squad.medic_alive ? 'green' : 'red'}>
                                {squad.medic_alive} ALIVE
                              </Box>
                            </Table.Cell>
                            <Table.Cell textAlign="center" bold>
                              <Box>{squad.engi_count} DEPLOYED</Box>
                              <Box color={squad.engi_alive ? 'green' : 'red'}>
                                {squad.engi_alive} ALIVE
                              </Box>
                            </Table.Cell>
                          </Table.Row>
                          <Table.Row>
                            <Table.Cell
                              textAlign="center"
                              collapsing
                              p="4px"
                              colSpan="2"
                            >
                              Total/Living
                            </Table.Cell>
                          </Table.Row>
                          <Table.Row>
                            <Table.Cell textAlign="center" bold colSpan="2">
                              <Box>{squad.total_deployed} TOTAL</Box>
                              <Box color={squad.living_count ? 'green' : 'red'}>
                                {squad.living_count} ALIVE
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
                              <Button icon="user" inline width="100%" compact>
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
  const { act, data } = useBackend();
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
      <Stack horizontal>
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
                onClick={() => act('announce')}
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
                onClick={() => act('selectlz')}
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
                onClick={() => act('activate_echo')}
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
  const { act, data } = useBackend();
  const AlertLevel = data.alert_level;
  const evacstatus = data.evac_status;
  const worldTime = data.worldtime;

  let emergencylockout;
  if (AlertLevel >= 2) {
    emergencylockout = null;
  }
  if (AlertLevel < 2) {
    emergencylockout = 1;
  }

  const minimumTimeElapsed = worldTime > data.distresstimelock;

  const canRequest = // requesting distress beacon
    data.time_request < worldTime && AlertLevel === 2 && minimumTimeElapsed;

  let distress_reason;

  if (AlertLevel === 3) {
    distress_reason = 'Self-destruct in progress. Beacon disabled.';
    destruct_reason = 'Self-destruct is already active!';
  } else if (AlertLevel !== 2) {
    distress_reason = 'Ship is not under an active emergency.';
    destruct_reason = 'Ship is not under an active emergency.';
  } else if (data.time_request < worldTime) {
    distress_reason =
      'Beacon is currently recharging. Time remaining: ' +
      Math.ceil((data.time_message - worldTime) / 10) +
      'secs.';
  } else if (data.time_destruct < worldTime) {
    destruct_reason =
      'A request has already been sent to HC. Please wait: ' +
      Math.ceil((data.time_destruct - worldTime) / 10) +
      'secs to send another.';
  } else if (!minimumTimeElapsed) {
    distress_reason = "It's too early to launch a distress beacon.";
    destruct_reason = "It's too early to initiate the self-destruct.";
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
            icon={emergencylockout ? 'exclamation-triangle' : null}
            mt="1px"
            p="7px"
            color={emergencylockout ? 'red' : 'transperant'}
            onClick={emergencylockout ? () => act('red_alert') : null}
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
            onClick={emergencylockout ? null : () => act('general_quarters')}
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
                    ? null
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
  const { act, data } = useBackend();

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

  let { marines, squad_leader } = data;

  const [hidden_marines, setHiddenMarines] = useSharedState(
    'hidden_marines',
    [],
  );

  const [showHiddenMarines, setShowHiddenMarines] = useSharedState(
    'showhidden',
    false,
  );
  const [showDeadMarines, setShowDeadMarines] = useSharedState(
    'showdead',
    true,
  );

  const [marineSearch, setMarineSearch] = useSharedState('marinesearch', null);

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

  let toggle_marine_hidden = (ref) => {
    if (!hidden_marines.includes(ref)) {
      setHiddenMarines([...hidden_marines, ref]);
    } else {
      let array_copy = [...hidden_marines];
      let index = array_copy.indexOf(ref);
      if (index > -1) {
        array_copy.splice(index, 1);
      }
      setHiddenMarines(array_copy);
    }
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
      title="Monitor"
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
      <Stack vertical>
        <Stack.Item>
          <Input
            fluid
            placeholder="Search.."
            value={marineSearch}
            onInput={(e, value) => setMarineSearch(value)}
          />
        </Stack.Item>
        <Stack.Item>
          <Section m="0px" mb="3px" scrollable height="190px" fill fitted>
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
              {data.leader_count ? (
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
                        new RegExp(marineSearch, 'i'),
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
                    if (
                      hidden_marines.includes(marine.ref) &&
                      !showHiddenMarines
                    ) {
                      return;
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

const OrbitalBombardment = (props) => {
  const { act, data } = useBackend();

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
      <Stack justify={'space-between'} horizontal m="10px">
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
                  color={data.ob_safety ? 'green' : 'red'}
                  m="1px"
                  fontSize="16px"
                >
                  [ {data.ob_safety ? 'ENGAGED' : 'DISENGAGED'} ]
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
      <Divider horizontal />
      <Stack justify={'space-between'} horizontal m="10px">
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
          <Stack horizontal m="7px" ml="1px">
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
      <Divider horizontal />
    </Section>
  );
};
