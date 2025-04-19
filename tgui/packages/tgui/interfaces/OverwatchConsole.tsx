import type { BooleanLike } from 'common/react';
import { useBackend, useSharedState } from 'tgui/backend';
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
} from 'tgui/components';
import { Window } from 'tgui/layouts';

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

type Data = {
  marines: MarineData[];
  squad_leader: MarineData;
  total_deployed: number;
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
  theme: string;
  squad_list: string[];
  current_squad: string;
  primary_objective: string[] | null;
  secondary_objective: string[] | null;
  z_hidden: BooleanLike;
  saved_coordinates: {
    x: number;
    y: number;
    z: number;
    comment: string;
    index: number;
  }[];
  can_launch_crates: BooleanLike;
  has_crate_loaded: BooleanLike;
  can_launch_obs: BooleanLike;
  ob_cooldown?: number;
  ob_loaded: BooleanLike;
  ob_safety: Boolean;
  supply_cooldown: number;
  operator: string;
};

export const OverwatchConsole = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Window
      width={800}
      height={600}
      theme={data.theme ? data.theme : 'crtblue'}
    >
      <Window.Content>
        {(!data.current_squad && <HomePanel />) || <SquadPanel />}
      </Window.Content>
    </Window>
  );
};

const HomePanel = (props) => {
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

const SquadPanel = (props) => {
  const { act, data } = useBackend<Data>();

  const [category, setCategory] = useSharedState('selected', 'monitor');

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Collapsible title="Main Dashboard" fontSize="16px">
          <MainDashboard />
        </Collapsible>
      </Stack.Item>
      <Stack.Item>
        <Collapsible title="Squad Roles" fontSize="16px">
          <RoleTable />
        </Collapsible>
      </Stack.Item>
      <Stack.Item>
        <Tabs fluid pr="0" pl="0" mb="0" fontSize="16px">
          <Tabs.Tab
            selected={category === 'monitor'}
            icon="heartbeat"
            onClick={() => setCategory('monitor')}
          >
            Squad Monitor
          </Tabs.Tab>
          {!!data.can_launch_crates && (
            <Tabs.Tab
              selected={category === 'supply'}
              icon="wrench"
              onClick={() => setCategory('supply')}
            >
              Supply Drop
            </Tabs.Tab>
          )}
          {!!data.can_launch_obs && (
            <Tabs.Tab
              selected={category === 'ob'}
              icon="bomb"
              onClick={() => setCategory('ob')}
            >
              Orbital Bombardment
            </Tabs.Tab>
          )}
          <Tabs.Tab icon="map" onClick={() => act('tacmap_unpin')}>
            Tactical Map
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>
        {category === 'monitor' && <SquadMonitor />}
        {category === 'supply' && data.can_launch_crates && <SupplyDrop />}
        {category === 'ob' && data.can_launch_obs && <OrbitalBombardment />}
      </Stack.Item>
    </Stack>
  );
};

const MainDashboard = (props) => {
  const { act, data } = useBackend<Data>();

  let { current_squad, primary_objective, secondary_objective } = data;

  return (
    <Section
      fontSize="16px"
      title={current_squad + ' Overwatch | Dashboard'}
      buttons={
        <>
          <Button icon="user" onClick={() => act('change_operator')}>
            Operator - {data.operator}
          </Button>
          <Button icon="sign-out-alt" onClick={() => act('logout')}>
            Stop Overwatch
          </Button>
        </>
      }
    >
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
      <Box textAlign="center">
        <Button
          inline
          width="23%"
          icon="envelope"
          onClick={() => act('set_primary')}
        >
          SET PRIMARY
        </Button>
        {primary_objective && (
          <Button
            inline
            width="23%"
            icon="person"
            onClick={() => act('remind_primary')}
          >
            REMIND PRIMARY
          </Button>
        )}
        <Button
          inline
          width="23%"
          icon="envelope"
          onClick={() => act('set_secondary')}
        >
          SET SECONDARY
        </Button>
        {secondary_objective && (
          <Button
            inline
            width="23%"
            icon="person"
            onClick={() => act('remind_secondary')}
          >
            REMIND SECONDARY
          </Button>
        )}
      </Box>

      <Box textAlign="center">
        <Button
          inline
          width="45%"
          icon="envelope"
          onClick={() => act('message')}
        >
          MESSAGE SQUAD
        </Button>
        <Button
          inline
          width="45%"
          icon="person"
          onClick={() => act('sl_message')}
        >
          MESSAGE SQUAD LEADER
        </Button>
      </Box>
    </Section>
  );
};

const RoleTable = (props) => {
  const { act, data } = useBackend<Data>();

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
        <Table.Cell textAlign="center" p="4px">
          Squad Leader
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          Fire Team Leaders
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          Specialist
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          Smartgunner
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          Hospital Corpsmen
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          Combat Technicians
        </Table.Cell>
        <Table.Cell collapsing p="4px">
          Total/Living
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
        <Table.Cell textAlign="center" bold>
          <Box>{medic_count} DEPLOYED</Box>
          <Box color={medic_alive ? 'green' : 'red'}>{medic_alive} ALIVE</Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box>{engi_count} DEPLOYED</Box>
          <Box color={engi_alive ? 'green' : 'red'}>{engi_alive} ALIVE</Box>
        </Table.Cell>
        <Table.Cell textAlign="center" bold>
          <Box>{total_deployed} TOTAL</Box>
          <Box color={living_count ? 'green' : 'red'}>{living_count} ALIVE</Box>
        </Table.Cell>
      </Table.Row>
    </Table>
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

  let { marines, squad_leader } = data;

  const [hidden_marines, setHiddenMarines] = useSharedState(
    'hidden_marines',
    [] as string[],
  );

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
      pb="3%"
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
          <Button
            color="red"
            icon="running"
            onClick={() => act('insubordination')}
          >
            Insubordination
          </Button>
        </>
      }
    >
      <Input
        fluid
        placeholder="Search.."
        m="0"
        mb="4px"
        value={marineSearch}
        onInput={(e, value) => setMarineSearch(value)}
      />
      <Section m="0" pb="2px" fill scrollable>
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
                )) || <Box color="yellow">{squad_leader.name} (NO CAMERA)</Box>}
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
                if (marineSearch && !marineSearch.includes('\\')) {
                  const searchableString = String(marine.name).toLowerCase();
                  return searchableString.match(new RegExp(marineSearch, 'i'));
                }
                return marine;
              })
              .map((marine, index) => {
                if (squad_leader) {
                  if (marine.ref === squad_leader.ref) {
                    return;
                  }
                }
                if (hidden_marines.includes(marine.ref) && !showHiddenMarines) {
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
                      )) || <Box color="yellow">{marine.name} (NO CAMERA)</Box>}
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
                        onClick={() => act('replace_lead', { ref: marine.ref })}
                      />
                    </Table.Cell>
                  </Table.Row>
                );
              })}
        </Table>
      </Section>
    </Section>
  );
};

const SupplyDrop = (props) => {
  const { act, data } = useBackend<Data>();

  const [supplyX, setSupplyX] = useSharedState('supplyx', 0);
  const [supplyY, setSupplyY] = useSharedState('supply', 0);
  const [supplyZ, setSupplyZ] = useSharedState('supplyz', 0);

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
                step={1}
                value={supplyX}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setSupplyX(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="LATITUDE">
              <NumberInput
                step={1}
                value={supplyY}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setSupplyY(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="HEIGHT">
              <NumberInput
                step={1}
                value={supplyZ}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setSupplyZ(value)}
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
              onClick={() =>
                act('dropsupply', { x: supplyX, y: supplyY, z: supplyZ })
              }
            >
              Launch
            </Button>
            <Button
              fontSize="20px"
              width="100%"
              icon="save"
              color="yellow"
              onClick={() =>
                act('save_coordinates', { x: supplyX, y: supplyY, z: supplyZ })
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
      <Divider />
    </Section>
  );
};

const OrbitalBombardment = (props) => {
  const { act, data } = useBackend<Data>();

  const [OBX, setOBX] = useSharedState('obx', 0);
  const [OBY, setOBY] = useSharedState('oby', 0);
  const [OBZ, setOBZ] = useSharedState('obz', 0);

  let ob_status = 'Ready';
  let ob_color = 'green';
  if (data.ob_cooldown) {
    ob_status = 'Cooldown - ' + data.ob_cooldown / 10 + ' seconds';
    ob_color = 'yellow';
  } else if (data.ob_safety) {
    ob_status = 'Cannon Safety Engaged';
    ob_color = 'red';
  } else if (!data.ob_loaded) {
    ob_status = 'Not chambered';
    ob_color = 'red';
  }

  return (
    <Section fill fontSize="14px" title="Orbital Bombardment">
      <Stack justify={'space-between'} m="10px">
        <Stack.Item fontSize="14px">
          <LabeledControls mb="5px">
            <LabeledControls.Item label="LONGITUDE">
              <NumberInput
                step={1}
                value={OBX}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setOBX(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="LATITUDE">
              <NumberInput
                step={1}
                value={OBY}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setOBY(value)}
                width="75px"
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="HEIGHT">
              <NumberInput
                step={1}
                value={OBZ}
                minValue={-Infinity}
                maxValue={Infinity}
                onChange={(value) => setOBZ(value)}
                width="75px"
              />
            </LabeledControls.Item>

            <LabeledControls.Item label="STATUS">
              <Box color={ob_color} bold>
                {ob_status}
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
          <Box textAlign="center">
            <Button
              fontSize="20px"
              width="100%"
              icon={data.ob_safety ? 'ban' : 'bomb'}
              color={data.ob_safety ? 'transperant' : 'red'}
              onClick={() => act('dropbomb', { x: OBX, y: OBY, z: OBZ })}
            >
              Fire
            </Button>
            <Button
              fontSize="20px"
              width="100%"
              icon="save"
              color="yellow"
              onClick={() =>
                act('save_coordinates', { x: OBX, y: OBY, z: OBZ })
              }
            >
              Save
            </Button>
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Divider vertical />
        </Stack.Item>
        <SavedCoordinates forOB />
      </Stack>
      <Divider />
    </Section>
  );
};

const SavedCoordinates = (props) => {
  const { act, data } = useBackend<Data>();

  const [OBX, setOBX] = useSharedState('obx', 0);
  const [OBY, setOBY] = useSharedState('oby', 0);
  const [OBZ, setOBZ] = useSharedState('obz', 0);
  const [supplyX, setSupplyX] = useSharedState('supplyx', 0);
  const [supplyY, setSupplyY] = useSharedState('supply', 0);
  const [supplyZ, setSupplyZ] = useSharedState('supplyz', 0);

  const { forOB, forSupply } = props;

  let transferCoords = (x, y, z) => {
    if (forSupply) {
      setSupplyX(x);
      setSupplyY(y);
      setSupplyZ(z);
    } else if (forOB) {
      setOBX(x);
      setOBY(y);
      setOBZ(z);
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
          <Table.Cell p="5px" collapsing>
            HEIGHT
          </Table.Cell>
          <Table.Cell p="5px">COMMENT</Table.Cell>
          <Table.Cell p="5px" collapsing />
        </Table.Row>
        {data.saved_coordinates.map((coords, index) => (
          <Table.Row key={index}>
            <Table.Cell p="6px">{coords.x}</Table.Cell>
            <Table.Cell p="5px">{coords.y}</Table.Cell>
            <Table.Cell p="4px">{coords.z}</Table.Cell>
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
                onClick={() => transferCoords(coords.x, coords.y, coords.z)}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Stack.Item>
  );
};
