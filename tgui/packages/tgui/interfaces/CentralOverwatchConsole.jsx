import { capitalize } from 'common/string';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Input,
  LabeledControls,
  NumberInput,
  Section,
  Stack,
  Table,
  Tabs,
} from '../components';
import { ButtonConfirm } from '../components/Button';
import { Window } from '../layouts';

export const CentralOverwatchConsole = (props) => {
  const { act, data } = useBackend();

  const [category, setCategory] = useSharedState('selected', 'monitor');

  return (
    <Window
      width={850}
      height={820}
      theme={data.theme ? data.theme : 'crtblue'}
    >
      <Window.Content>
        {(!data.current_squad && <HomePanel />) || (
          <Stack vertical>
            <Stack.Item>
              <DebugSquadPanel />
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

const HomePanel = (props) => {
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
    <Section
      fontSize="20px"
      textAlign="center"
      title="OVERWATCH DISABLED - SELECT SQUAD"
    >
      <Stack justify="center" align="end" fontSize="20px">
        {data.squad_list.map((squad, index) => {
          return (
            <Stack.Item key={index}>
              <Button
                color={
                  squadColorMap[squad.toLowerCase()]
                    ? squadColorMap[squad.toLowerCase()]
                    : 'red'
                }
                onClick={() => act('pick_squad', { squad: squad })}
              >
                {squad.toUpperCase()}
              </Button>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};

const SecondaryFunctions = (props) => {
  const { act, data } = useBackend();

  const [secondarycategory, setsecondaryCategory] = useSharedState(
    'secondaryselected',
    'secondarymonitor',
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
            <Tabs.Tab
              selected={secondarycategory === 'supply'}
              icon="wrench"
              onClick={() => setsecondaryCategory('supply')}
              p="3px"
              bold
            >
              Supply Drop
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item grow>
          {secondarycategory === 'supply' && data.can_launch_crates && (
            <SupplyDrop />
          )}
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

const DebugSquadPanel = (props) => {
  const { act, data } = useBackend();

  const [category, setCategory] = useSharedState('selected', 'monitor');

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
      title="Combined Operations Console | "
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
                  selected={
                    category === squadStringify[squad.name.toLowerCase()]
                  }
                  onClick={() => {
                    setCategory(squadStringify[squad.name.toLowerCase()]);
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
                {category === squadStringify[squad.name.toLowerCase()] && (
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
                                {squad.squad_leader.name
                                  ? squad.squad_leader.name
                                  : 'NONE'}
                                <Box
                                  color={
                                    squad.squad_leader.state !== 'Dead'
                                      ? 'green'
                                      : 'red'
                                  }
                                >
                                  {squad.squad_leader.state !== 'Dead'
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
                              <Button icon="user" inline width="100%">
                                Operator - {squad.operator}
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

const MainDashboard = (props) => {
  const { act, data } = useBackend();

  let { current_squad, primary_objective, secondary_objective } = data;

  return (
    <Section fontSize="16px" title={current_squad + ' Overwatch | Dashboard'}>
      <Table mb="5px">
        <Table.Row bold>
          <Table.Cell textAlign="center">PRIMARY ORDERS</Table.Cell>
          <Table.Cell textAlign="center">SECONDARY ORDERS</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell textAlign="center">
            {primary_objective ? primary_objective : 'NONE'}
          </Table.Cell>
          <Table.Cell textAlign="center">
            {secondary_objective ? secondary_objective : 'NONE'}
          </Table.Cell>
        </Table.Row>
      </Table>
      <Collapsible textAlign="center" title="Expand Controls" fontSize="16px">
        <Box textAlign="center">
          <Box>
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="envelope"
                onClick={() => act('set_primary')}
              >
                SET PRIMARY
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="envelope"
                onClick={() => act('set_secondary')}
              >
                SET SECONDARY
              </Button>
            </Stack.Item>
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
          </Box>
        </Box>
      </Collapsible>
      <RoleTable />
    </Section>
  );
};

const ExecutivePanel = (props) => {
  const { act, data } = useBackend();

  return (
    <Section fill fontSize="14px">
      <Stack horizontal>
        <Stack.Item grow>
          <Box bold textAlign="center" mb="10px">
            GROUNDSIDE OPERATIONS
          </Box>
          <Box mb="10px" align="center">
            <Stack.Item>
              <Button inline width="100%" icon="bullhorn" p="4px">
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
                onClick={() => act('set_secondary')}
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
                color="transperant"
                onClick={() => act('message')}
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
                onClick={() => act('sl_message')}
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
              <Button inline width="100%" icon="exclamation-triangle" p="3px">
                CHANGE ALERT LEVEL
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button inline width="100%" color="transperant">
                CURRENT ALERT LEVEL: GREEN
              </Button>
            </Stack.Item>
            <Divider />
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="bullhorn"
                mb="3px"
                onClick={() => act('set_secondary')}
              >
                MAKE A SHIPWIDE ANNOUNCEMENT
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                inline
                width="100%"
                icon="paper-plane"
                onClick={() => act('message')}
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
                onClick={() => act('sl_message')}
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
            icon="exclamation-triangle"
            mt="1px"
            p="7px"
            color="red"
            onClick={() => act('red_alert')}
          >
            ELEVATE TO RED ALERT
          </ButtonConfirm>
          <ButtonConfirm
            inline
            textAlign="center"
            width="100%"
            icon="ban"
            mt="5px"
            p="4px"
            color="transperant"
            onClick={() => act('set_secondary')}
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
                color="transperant"
              >
                INITIATE EVACUATION
              </ButtonConfirm>
            </Stack.Item>
            <Stack.Item>
              <ButtonConfirm
                inline
                width="100%"
                icon="ban"
                mt="1px"
                color="transperant"
                onClick={() => act('set_secondary')}
              >
                SELF-DESTRUCT DISABLED
              </ButtonConfirm>
            </Stack.Item>
            <Stack.Item>
              <ButtonConfirm
                inline
                width="100%"
                icon="ban"
                mt="1px"
                color="transperant"
                onClick={() => act('set_secondary')}
              >
                DISTRESS BEACON DISABLED
              </ButtonConfirm>
            </Stack.Item>
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const RoleTable = (props) => {
  const { act, data } = useBackend();

  const {
    squad_leader,
    leaders_alive,
    ftl_alive,
    ftl_count,
    specialist_type,
    spec_alive,
    smart_alive,
    smart_count,
    spec_count,
    medic_count,
    medic_alive,
    engi_alive,
    engi_count,
    living_count,
    total_deployed,
  } = data;

  return (
    <Table pb="4px" m="1px" fontSize="12px" bold>
      <Table.Row>
        <Table.Cell textAlign="center" collapsing p="4px">
          Squad Leader
        </Table.Cell>
        <Table.Cell textAlign="center" collapsing p="4px">
          Fire Team Leaders
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        {(squad_leader && (
          <Table.Cell textAlign="center">
            {squad_leader.name ? squad_leader.name : 'NONE'}
            <Box color={squad_leader.state !== 'Dead' ? 'green' : 'red'}>
              {squad_leader.state !== 'Dead' ? 'ALIVE' : 'DEAD'}
            </Box>
          </Table.Cell>
        )) || (
          <Table.Cell textAlign="center">
            NONE
            <Box color="red">NOT DEPLOYED</Box>
          </Table.Cell>
        )}

        <Table.Cell textAlign="center" bold>
          <Box>{ftl_count} DEPLOYED</Box>
          <Box color={ftl_alive ? 'green' : 'red'}>{ftl_alive} ALIVE</Box>
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
          <Box>{specialist_type ? specialist_type : 'NONE'}</Box>
          <Box color={spec_alive ? 'green' : 'red'}>
            {spec_count ? (spec_alive ? 'ALIVE' : 'DEAD') : 'NOT DEPLOYED'}
          </Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box color={smart_count ? 'green' : 'red'}>
            {smart_count ? smart_count + ' DEPLOYED' : 'NONE'}
          </Box>
          <Box color={smart_alive ? 'green' : 'red'}>
            {smart_count ? (smart_alive ? 'ALIVE' : 'DEAD') : 'N/A'}
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
          <Box>{medic_count} DEPLOYED</Box>
          <Box color={medic_alive ? 'green' : 'red'}>{medic_alive} ALIVE</Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box>{engi_count} DEPLOYED</Box>
          <Box color={engi_alive ? 'green' : 'red'}>{engi_alive} ALIVE</Box>
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell textAlign="center" collapsing p="4px" colSpan="2">
          Total/Living
        </Table.Cell>
      </Table.Row>
      <Table.Row>
        <Table.Cell textAlign="center" bold colSpan="2">
          <Box>{total_deployed} TOTAL</Box>
          <Box color={living_count ? 'green' : 'red'}>{living_count} ALIVE</Box>
        </Table.Cell>
      </Table.Row>
    </Table>
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
      pb="1.5%"
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
            mb="4px"
            value={marineSearch}
            onInput={(e, value) => setMarineSearch(value)}
          />
        </Stack.Item>
        <Stack.Item>
          <Section m="2px" mb="4px" scrollable>
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
                <Table.Cell textAlign="center" />
              </Table.Row>
              {squad_leader && (
                <Table.Row key="index" bold>
                  <Table.Cell collapsing p="2px">
                    {(squad_leader.has_helmet && (
                      <Button
                        onClick={() =>
                          act('watch_camera', { target_ref: squad_leader.ref })
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
                  <Table.Cell />
                </Table.Row>
              )}
              {marines &&
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
                      <Table.Row key={index}>
                        <Table.Cell collapsing p="2px">
                          {(marine.has_helmet && (
                            <Button
                              onClick={() =>
                                act('watch_camera', { target_ref: marine.ref })
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
                        <Table.Cell p="2px">
                          {(hidden_marines.includes(marine.ref) && (
                            <Button
                              icon="plus"
                              color="green"
                              tooltip="Show marine"
                              onClick={() => toggle_marine_hidden(marine.ref)}
                            />
                          )) || (
                            <Button
                              icon="minus"
                              color="red"
                              tooltip="Hide marine"
                              onClick={() => toggle_marine_hidden(marine.ref)}
                            />
                          )}
                          <Button
                            icon="arrow-up"
                            color="green"
                            tooltip="Promote marine to Squad Leader"
                            onClick={() =>
                              act('replace_lead', { ref: marine.ref })
                            }
                          />
                        </Table.Cell>
                      </Table.Row>
                    );
                  })}
            </Table>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const SupplyDrop = (props) => {
  const { act, data } = useBackend();

  const [supplyX, setSupplyX] = useSharedState('supplyx', 0);
  const [supplyY, setSupplyY] = useSharedState('supply', 0);

  let crate_status = 'Crate Loaded';
  let crate_color = 'green';
  if (data.supply_cooldown) {
    crate_status = 'Cooldown - ' + data.supply_cooldown / 10 + ' seconds';
    crate_color = 'yellow';
  } else if (!data.has_crate_loaded) {
    crate_status = 'No crate loaded';
    crate_color = 'red';
  }

  return (
    <Section fill fontSize="14px" title="Supply Drop">
      <Stack justify={'space-between'} m="10px">
        <Stack.Item fontSize="14px">
          <LabeledControls mb="5px">
            <LabeledControls.Item label="LONGITUDE">
              <NumberInput
                value={supplyX}
                onChange={(value) => setSupplyX(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="LATITUDE">
              <NumberInput
                value={supplyY}
                onChange={(value) => setSupplyY(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="STATUS">
              <Box color={crate_color} bold>
                {crate_status}
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
          <Box textAlign="center">
            <Button
              fontSize="20px"
              width="100%"
              icon="box"
              color="yellow"
              onClick={() => act('dropsupply', { x: supplyX, y: supplyY })}
            >
              Launch
            </Button>
            <Button
              fontSize="20px"
              width="100%"
              icon="save"
              color="yellow"
              onClick={() =>
                act('save_coordinates', { x: supplyX, y: supplyY })
              }
            >
              Save
            </Button>
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Divider vertical />
        </Stack.Item>
        <SavedCoordinates forSupply />
      </Stack>
      <Divider horizontal />
    </Section>
  );
};

const OrbitalBombardment = (props) => {
  const { act, data } = useBackend();

  const [OBX, setOBX] = useSharedState('obx', 0);
  const [OBY, setOBY] = useSharedState('oby', 0);

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
            [ {ob_status} ]
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
                  onClick={() => act('dropbomb', { x: OBX, y: OBY })}
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

const SavedCoordinates = (props) => {
  const { act, data } = useBackend();

  const [OBX, setOBX] = useSharedState('obx', 0);
  const [OBY, setOBY] = useSharedState('oby', 0);
  const [supplyX, setSupplyX] = useSharedState('supplyx', 0);
  const [supplyY, setSupplyY] = useSharedState('supply', 0);

  const { forOB, forSupply } = props;

  let transferCoords = (x, y) => {
    if (forSupply) {
      setSupplyX(x);
      setSupplyY(y);
    } else if (forOB) {
      setOBX(x);
      setOBY(y);
    }
  };

  return (
    <Stack.Item>
      <Box bold textAlign="center">
        Max 3 stored coordinates. Will overwrite oldest first.
      </Box>
      <Table>
        <Table.Row bold>
          <Table.Cell p="5px" collapsing>
            LONG.
          </Table.Cell>
          <Table.Cell p="5px" collapsing>
            LAT.
          </Table.Cell>
          <Table.Cell p="5px">COMMENT</Table.Cell>
          <Table.Cell p="5px" collapsing />
        </Table.Row>
        {data.saved_coordinates.map((coords, index) => (
          <Table.Row key={index}>
            <Table.Cell p="6px">{coords.x}</Table.Cell>
            <Table.Cell p="5px">{coords.y}</Table.Cell>
            <Table.Cell p="5px">
              <Input
                width="100%"
                value={coords.comment}
                onChange={(e, value) =>
                  act('change_coordinate_comment', {
                    comment: value,
                    index: coords.index,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell p="5px">
              <Button
                color="yellow"
                icon="arrow-left"
                onClick={() => transferCoords(coords.x, coords.y)}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Stack.Item>
  );
};
