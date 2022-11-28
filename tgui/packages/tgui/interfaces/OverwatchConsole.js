import { sortBy, uniqBy } from 'common/collections';
import { useBackend, useLocalState } from '../backend';
import { createSearch } from 'common/string';
import { round } from 'common/math';
import { Button, Section, NoticeBox, Stack, Flex, Icon, NumberInput, LabeledList, ProgressBar, Divider, Table, Box, Dropdown, ColorBox, Dimmer, Input } from '../components';
import { Window } from '../layouts';
import { createLogger } from '../logging';

export const searchFor = (searchText) => {
  return createSearch(searchText, (thing) => thing?.name);
};

export const OverwatchConsole = (_props, context) => {
  const { act, data } = useBackend(context);
  const { operator } = data;

  const windowWidth = 825;
  const windowHeight = 480;

  return (
    <Window width={windowWidth} height={windowHeight}>
      <Window.Content>
        {operator && <OverwatchMain />}
        {!operator && <OverwatchEmpty />}
      </Window.Content>
    </Window>
  );
};

export const OverwatchMain = (props, context) => {
  const { act, data } = useBackend(context);
  const { squad_data } = data;
  const [currentControlCategory] = useLocalState(
    context,
    'current_control_category',
    1
  );

  return (
    <>
      <OverwatchId />
      {squad_data?.squad_name && (
        <>
          <OverwatchTab />
          {currentControlCategory === 1 && <OverwatchSquad />}
          {currentControlCategory === 2 && <OverwatchSupplies />}
          {currentControlCategory === 3 && <OverwatchBomb />}
          {currentControlCategory === 4 && <OverwatchMonitor />}
        </>
      )}
    </>
  );
};

export const OverwatchTab = (props, context) => {
  const [currentControlCategory, setCategory] = useLocalState(
    context,
    'current_control_category',
    1
  );
  return (
    <Section title="Category">
      <Stack>
        <Stack.Item grow>
          <Button
            fluid
            selected={currentControlCategory === 1}
            icon="person"
            onClick={() => setCategory(1)}
            content="Squad Control"
          />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            fluid
            selected={currentControlCategory === 2}
            icon="box"
            onClick={() => setCategory(2)}
            content="Supply Drop"
          />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            fluid
            selected={currentControlCategory === 3}
            icon="burst"
            onClick={() => setCategory(3)}
            content="Orbital Bombardment"
          />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            fluid
            selected={currentControlCategory === 4}
            icon="camera"
            onClick={() => setCategory(4)}
            content="Squad Monitor"
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const OverwatchEmpty = (props, context) => {
  return (
    <Section flexGrow="1" fill>
      <OverwatchId />
      <Flex height="100%" textAlign="center">
        <Flex.Item grow="1" align="center" colour="red">
          <Icon name="times-circle" mb="0.5rem" size="5" colour="red" />
          <br />
          Authentication required.
          <br />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const OverwatchId = (props, context) => {
  const { act, data } = useBackend(context);
  const { operator, authenticated, squad_list, squad_data, user } = data;
  return (
    <Section title="Authentication">
      <Stack>
        <Stack.Item grow>
          <Button
            icon="user"
            fluid
            content={operator ? 'Operator: ' + operator : 'Unauthenticated'}
            onClick={() => act('change_operator')}
          />
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            options={squad_list}
            disabled={!operator || operator !== user}
            onSelected={(value) => act('pick_squad', { squadpicked: value })}
            style={{ 'background-color': squad_data?.color }}
            noscroll
            displayText={
              squad_data ? 'Squad: ' + squad_data.squad_name : 'Select Squad'
            }
            lineHeight="1.5em"
            width="10em"
            height="1.6em"
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="sign-in-alt"
            fluid
            content={`Sign Out`}
            disabled={!operator}
            selected={authenticated}
            onClick={() => act('logout')}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const OverwatchSquad = (props, context) => {
  const { act, data } = useBackend(context);
  const { squad_data, marine_list } = data;

  const marine_list_keys = Object.keys(marine_list);

  return (
    <Section title="Squad Control">
      <OverwatchAuthenticated />
      <Stack>
        <Stack.Item width="60%">
          <Button
            textAlign="center"
            icon={'camera'}
            fluid
            content={
              squad_data.current_squad_leader_name
                ? 'Squad Leader: ' + squad_data.current_squad_leader_name
                : 'Squad Leader: None'
            }
            disabled={!squad_data.current_squad_leader_name}
            onClick={() =>
              act('use_cam', { cam_target: squad_data.current_squad_leader })
            }
          />
        </Stack.Item>
        {squad_data.current_squad_leader_name && (
          <Stack.Item width="15%">
            <Button.Input
              fluid
              textAlign="center"
              content={'Message'}
              onCommit={(e, value) =>
                act('sl_message', {
                  message: value,
                })
              }
            />
          </Stack.Item>
        )}
        <Stack.Item
          width={squad_data.current_squad_leader_name ? '25%' : '40%'}>
          <Dropdown
            options={squad_data.sl_candidates}
            displayText={
              squad_data.current_squad_leader_name
                ? 'Reassign Squad Leader'
                : 'Assign Squad Leader'
            }
            onSelected={(value) =>
              act('change_lead', { marine_picked: marine_list[value].ref })
            }
            selected="Select"
            noscroll
            lineHeight="1.5em"
            height="1.6em"
            width="100%"
          />
        </Stack.Item>
      </Stack>
      <Divider />
      <Stack>
        <Stack.Item width="75%">
          <Stack>
            <Stack.Item width="80%">
              <Button.Input
                fluid
                textAlign="center"
                overflow="hidden"
                text-overflow="ellipsis"
                content={
                  squad_data.primary_objective
                    ? 'Primary Objective: ' + squad_data.primary_objective
                    : 'Set Primary Objective'
                }
                onCommit={(e, value) =>
                  act('set_primary', {
                    objective: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item width="20%">
              <Button
                icon={'bullhorn'}
                fluid
                textAlign="center"
                disabled={!squad_data.primary_objective}
                content={'Remind'}
                onClick={() => act('check_primary')}
              />
            </Stack.Item>
          </Stack>
          <Stack>
            <Stack.Item width="80%">
              <Button.Input
                textAlign="center"
                fluid
                overflow="hidden"
                text-overflow="ellipsis"
                content={
                  squad_data.secondary_objective
                    ? 'Secondary Objective: ' + squad_data.secondary_objective
                    : 'Set Secondary Objective'
                }
                onCommit={(e, value) =>
                  act('set_secondary', {
                    objective: value,
                  })
                }
              />
            </Stack.Item>
            <Stack.Item width="20%">
              <Button
                icon={'bullhorn'}
                fluid
                textAlign="center"
                disabled={!squad_data.secondary_objective}
                content={'Remind'}
                onClick={() => act('check_secondary')}
              />
            </Stack.Item>
          </Stack>
          <Button.Input
            fluid
            textAlign="center"
            content={'Send Message to Squad'}
            onCommit={(e, value) =>
              act('message', {
                message: value,
              })
            }
          />
        </Stack.Item>
        <Stack.Item width="25%">
          <Stack
            direction="column"
            wrap="wrap"
            justify="space-between"
            height="100%">
            <Stack.Item>
              <Dropdown
                options={marine_list_keys}
                icon={'square-xmark'}
                displayText="Mark Insubordination"
                nochevron
                width="100%"
                onSelected={(value) =>
                  act('insubordination', {
                    marine_picked: marine_list[value].ref,
                  })
                }
                noscroll
              />
            </Stack.Item>
            <Stack.Item>
              <Divider />
            </Stack.Item>
            <Stack.Item>
              <Dropdown
                options={marine_list_keys}
                icon={'arrow-right'}
                displayText="Squad Transfer"
                nochevron
                width="103%"
                ml="-0.5em"
                onSelected={(value) =>
                  act('squad_transfer', {
                    marine_picked: marine_list[value].ref,
                  })
                }
                noscroll
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const OverwatchMonitor = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    squad_data,
    marine_list,
    dead_hidden,
    marine_filter_enabled,
    z_hidden,
    operator,
    user,
  } = data;

  const roleList = [
    'Squad Rifleman',
    'Squad Hospital Corpsmen',
    'Squad Combat Technician',
    'Squad Smartgunner',
    'Squad Weapons Specialist',
    'Squad Radio Telephone Operator',
    'Squad Leader',
  ];

  const roleSort = (a, b) => {
    if (a.role === 'Squad Rifleman' && b.role === 'Squad Rifleman') {
      return a.paygrade === 'PFC' ? -1 : 1;
    }
    const a_index = roleList.findIndex((str) => a.role === str);
    const b_index = roleList.findIndex((str) => b.role === str);
    return a_index > b_index ? -1 : 1;
  };

  const marine_data = sortBy((marine) => marine?.role)(
    Object.values(marine_list) ?? []
  );
  const unique_jobs = uniqBy((marine) => marine?.role)(
    Object.values(marine_list) ?? []
  );

  const [searchText, setSearchText] = useLocalState(context, 'searchText', '');
  const [selectedJob, setSelectedJob] = useLocalState(
    context,
    'selectedJob',
    ''
  );

  const marine_data_filtered = marine_data
    ?.filter((marine) => !marine?.filtered)
    .filter(searchFor(searchText))
    .filter(
      (marine) =>
        marine?.role === selectedJob || selectedJob === null || !selectedJob
    );

  return (
    <>
      <Section
        title="Monitor"
        fill
        height="55%"
        scrollable
        buttons={
          <Stack>
            {selectedJob && (
              <Stack.Item>
                <Button
                  icon="xmark"
                  onClick={() => setSelectedJob(null)}
                  selected
                />
              </Stack.Item>
            )}
            <Stack.Item>
              <Dropdown
                options={unique_jobs.map((marine) => marine?.role)}
                disabled={operator !== user}
                displayText={'Select Role'}
                onSelected={(value) => setSelectedJob(value)}
                noscroll
                width="8em"
                height="1.6em"
                lineHeight="1.6em"
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content={
                  dead_hidden ? 'Show Dead Marines' : 'Hide Dead Marines'
                }
                disabled={operator !== user}
                selected={dead_hidden}
                onClick={() => act('hide_dead')}
                height="1.6em"
                lineHeight="1.6em"
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                selected={!marine_filter_enabled}
                disabled={operator !== user}
                content={
                  marine_filter_enabled
                    ? 'Show Filtered Marines'
                    : 'Hide Filtered Marines'
                }
                onClick={() => act('toggle_marine_filter')}
                height="1.6em"
                lineHeight="1.6em"
              />
            </Stack.Item>
            <Stack.Item>
              <Dropdown
                options={['Ship', 'Ground', 'None']}
                disabled={operator !== user}
                displayText={
                  z_hidden
                    ? 'Hidden Area: ' + (z_hidden === 2 ? 'Almayer' : 'Colony')
                    : 'Hide Area'
                }
                onSelected={(value) => act('choose_z', { area_picked: value })}
                noscroll
                width={z_hidden ? '14em' : '8em'}
                height="1.6em"
                lineHeight="1.6em"
              />
            </Stack.Item>
            <Stack.Item>
              <Input
                placeholder="Search for Marine"
                fluid
                width="10em"
                value={searchText}
                onInput={(_, value) => setSearchText(value)}
                height="1.6em"
                lineHeight="1.6em"
              />
            </Stack.Item>
          </Stack>
        }>
        <Stack direction="column">
          <Section>
            <Stack.Item>
              <Table>
                <Table.Row style={{ 'border-bottom': '1px solid #2F3037' }}>
                  <Table.Cell />
                  <Table.Cell bold>Name</Table.Cell>
                  <Table.Cell bold>Rank</Table.Cell>
                  <Table.Cell bold>Status</Table.Cell>
                  <Table.Cell bold>Area</Table.Cell>
                  <Table.Cell bold>SL Distance</Table.Cell>
                </Table.Row>
                {marine_data_filtered.sort(roleSort).map((marine_data) => (
                  <Table.Row key={marine_data}>
                    <Table.Cell textAlign="center">
                      <Button
                        icon={'eye'}
                        selected={marine_data?.manually_filtered}
                        tooltip={'Hide'}
                        onClick={() =>
                          act('filter_marine', {
                            squaddie: marine_data?.ref,
                          })
                        }
                      />
                    </Table.Cell>
                    <Table.Cell>
                      <Button
                        content={marine_data?.name}
                        disabled={!marine_data?.helmet}
                        fluid
                        onClick={() =>
                          act('use_cam', {
                            cam_target: marine_data?.ref,
                          })
                        }
                      />
                    </Table.Cell>
                    <Table.Cell>
                      {marine_data?.role +
                        (marine_data?.act_sl === true
                          ? marine_data?.act_sl
                          : '') +
                        (marine_data?.fteam
                          ? ' (' + marine_data?.fteam + ')'
                          : '')}
                    </Table.Cell>
                    <Table.Cell>
                      <ColorBox
                        color={
                          marine_data?.mob_state === 'Conscious'
                            ? 'green'
                            : marine_data?.mob_state === 'Unconscious'
                              ? 'yellow'
                              : 'red'
                        }
                      />
                      {' ' + marine_data?.mob_state}{' '}
                      {!marine_data?.helmet ? ' (no helmet)' : null}
                      {marine_data.SSD ? ' (SSD)' : null}
                    </Table.Cell>
                    <Table.Cell>
                      {marine_data?.area_name ? marine_data?.area_name : 'N/A'}
                    </Table.Cell>
                    <Table.Cell>
                      {marine_data?.dist ? marine_data?.dist : 'N/A'}
                      {marine_data?.dir
                        ? ' (' + marine_data?.dir + ')'
                        : ' (N/A)'}
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Stack.Item>
          </Section>
        </Stack>
      </Section>
      <Section>
        <Table>
          <Table.Row style={{ 'border-bottom': '1px solid #2F3037' }}>
            <Table.Cell>Squad Leader</Table.Cell>
            <Table.Cell>RTO</Table.Cell>
            <Table.Cell>Specialist</Table.Cell>
            <Table.Cell>Smartgunner</Table.Cell>
            <Table.Cell>Medic</Table.Cell>
            <Table.Cell>Combat Technician</Table.Cell>
            <Table.Cell>Alive</Table.Cell>
            <Table.Cell>Deployed</Table.Cell>
          </Table.Row>
          <Table.Row>
            <Table.Cell>
              <ColorBox
                color={squad_data.current_squad_leader_name ? 'green' : 'red'}
              />
              {squad_data.current_squad_leader_name ? ' Deployed' : ' None'}
            </Table.Cell>
            <Table.Cell>
              <ColorBox color={squad_data.rto > 0 ? 'green' : 'red'} />
              {squad_data.rto ? ' ' + squad_data.rto + ' Deployed' : ' None'}
            </Table.Cell>
            <Table.Cell>
              <ColorBox color={squad_data.specialists > 0 ? 'green' : 'red'} />
              {squad_data.specialists ? ' Deployed' : ' None'}
            </Table.Cell>
            <Table.Cell>
              <ColorBox color={squad_data.smartgun > 0 ? 'green' : 'red'} />
              {squad_data.smartgun
                ? ' ' + squad_data.smartgun + ' Deployed'
                : ' None'}
            </Table.Cell>
            <Table.Cell>
              <ColorBox color={squad_data.medics > 0 ? 'green' : 'red'} />
              {squad_data.medics
                ? ' ' + squad_data.medics + ' Deployed'
                : ' None'}
            </Table.Cell>
            <Table.Cell>
              <ColorBox color={squad_data.engineers > 0 ? 'green' : 'red'} />
              {squad_data.engineers
                ? ' ' + squad_data.engineers + ' Deployed'
                : ' None'}
            </Table.Cell>
            <Table.Cell>{squad_data.alive}</Table.Cell>
            <Table.Cell>{squad_data.total_deployed}</Table.Cell>
          </Table.Row>
        </Table>
      </Section>
    </>
  );
};

export const OverwatchSupplies = (props, context) => {
  const { act, data } = useBackend(context);
  const { x_supply, y_supply, supply_cooldown, supply_pad_ready, world_time } =
    data;

  const logger = createLogger('ow');
  logger.warn(data);
  const cooldown = round((supply_cooldown - world_time) * 0.1);

  const supply_ready =
    supply_pad_ready && (!supply_cooldown || supply_cooldown < world_time);

  const [target_x, setTargetX] = useLocalState(context, 'target_x', x_supply);
  const [target_y, setTargetY] = useLocalState(context, 'target_y', y_supply);

  const cooldown_seconds = data.max_supply_cooldown * 0.1;
  const lower_cooldown_seconds = cooldown_seconds * 0.4;
  const upper_cooldown_seconds = cooldown_seconds * 0.8;

  return (
    <Section title="Supply Drop">
      <OverwatchAuthenticated />
      <OverwatchBusy />
      <ProgressBar
        ranges={{
          good: [-Infinity, lower_cooldown_seconds],
          average: [lower_cooldown_seconds, upper_cooldown_seconds],
          bad: [upper_cooldown_seconds, Infinity],
        }}
        minValue={0}
        maxValue={cooldown_seconds}
        value={cooldown}>
        {cooldown > 0 ? cooldown + ' second cooldown' : 'Ready to Fire'}
      </ProgressBar>
      <Divider />
      <Stack>
        <Stack.Item width="10em">
          <LabeledList>
            <LabeledList.Item label="Target X">
              <NumberInput
                width="4em"
                minValue="-1000"
                maxValue="1000"
                stepPixelSize="20"
                value={target_x}
                onChange={(_, value) => {
                  setTargetX(value);
                  act('set_supply', {
                    target_x: value,
                    target_y: target_y,
                  });
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Y">
              <NumberInput
                width="4em"
                minValue="-1000"
                maxValue="1000"
                stepPixelSize="20"
                value={target_y}
                onChange={(_, value) => {
                  setTargetY(value);
                  act('set_supply', {
                    target_x: target_x,
                    target_y: value,
                  });
                }}
              />
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <Box p="0.2em" />
        </Stack.Item>
        <Stack.Item grow>
          <Button.Confirm
            fluid
            icon="box-open"
            content="Fire Supply Drop"
            lineHeight="3.5em"
            textAlign="center"
            disabled={!supply_ready}
            confirmContent={'Fire at ' + x_supply + ', ' + y_supply + '?'}
            onClick={() => act('dropsupply')}
          />
        </Stack.Item>
      </Stack>
      <Divider />
      {supply_ready ? (
        <NoticeBox success textAlign="center">
          Ready to drop!
        </NoticeBox>
      ) : (
        <NoticeBox warning textAlign="center">
          Drop pad is empty!
        </NoticeBox>
      )}
    </Section>
  );
};

export const OverwatchAuthenticated = (props, context) => {
  const { act, data } = useBackend(context);
  const { operator, user } = data;

  return (
    <Box>
      {operator !== user && (
        <Dimmer>
          <Box textAlign="center">
            <Icon name="times-circle" mb="0.5rem" size="5" colour="red" />
            <Box>Scan does not match Operator</Box>
          </Box>
        </Dimmer>
      )}
    </Box>
  );
};

export const OverwatchBusy = (props, context) => {
  const { act, data } = useBackend(context);
  const { busy } = data;
  return (
    <Box>
      {busy !== 0 && (
        <Dimmer fontSize="32px">
          <Icon name="cog" spin />
          {' Processing...'}
        </Dimmer>
      )}
    </Box>
  );
};

export const OverwatchBomb = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    x_bomb,
    y_bomb,
    bombardment_cooldown,
    almayer_cannon_ready,
    almayer_cannon_disabled,
    world_time,
  } = data;

  const bombardment = round((bombardment_cooldown - world_time) * 0.1);

  const [bomb_x, setTargetX] = useLocalState(context, 'bomb_x', x_bomb);
  const [bomb_y, setTargetY] = useLocalState(context, 'bomb_y', y_bomb);

  const bombardment_enabled =
    (!bombardment_cooldown || bombardment_cooldown < world_time) &&
    !almayer_cannon_disabled &&
    almayer_cannon_ready;

  const logger = createLogger('ow');
  logger.warn(data);

  const cooldown_seconds = data.max_bombardment_cooldown * 0.1;
  const lower_cooldown_seconds = cooldown_seconds * 0.4;
  const upper_cooldown_seconds = cooldown_seconds * 0.8;

  return (
    <Section title="Orbital Bombardment">
      <OverwatchAuthenticated />
      <OverwatchBusy />
      <ProgressBar
        ranges={{
          good: [-Infinity, lower_cooldown_seconds],
          average: [lower_cooldown_seconds, upper_cooldown_seconds],
          bad: [upper_cooldown_seconds, Infinity],
        }}
        minValue={0}
        maxValue={cooldown_seconds}
        value={bombardment}>
        {bombardment > 0 ? bombardment + ' second cooldown' : 'Ready to Fire'}
      </ProgressBar>
      <Divider />
      <Stack>
        <Stack.Item width="10em">
          <LabeledList>
            <LabeledList.Item label="Target X">
              <NumberInput
                width="4em"
                minValue="-1000"
                maxValue="1000"
                stepPixelSize="20"
                value={bomb_x}
                onChange={(_, value) => {
                  setTargetX(value);
                  act('set_bomb', {
                    target_x: value,
                    target_y: bomb_y,
                  });
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Y">
              <NumberInput
                width="4em"
                minValue="-1000"
                maxValue="1000"
                stepPixelSize="20"
                value={bomb_y}
                onChange={(_, value) => {
                  setTargetY(value);
                  act('set_bomb', {
                    target_x: bomb_x,
                    target_y: value,
                  });
                }}
              />
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <Box p="0.2em" />
        </Stack.Item>
        <Stack.Item grow>
          <Button.Confirm
            fluid
            textAlign="center"
            content="Fire Orbital Bombardment"
            lineHeight="3.5em"
            color="red"
            icon="burst"
            disabled={!bombardment_enabled}
            onClick={() => act('dropbomb')}
            confirmContent={'Fire at ' + x_bomb + ', ' + y_bomb + '?'}
          />
        </Stack.Item>
      </Stack>
      <Divider />
      {!bombardment_enabled ? (
        <NoticeBox warning textAlign="center">
          Chamber is not ready!
        </NoticeBox>
      ) : (
        <NoticeBox danger textAlign="center">
          <Icon name="skull-crossbones" mr="1em" />
          Ready to fire!
          <Icon name="skull-crossbones" ml="1em" />
        </NoticeBox>
      )}
      {almayer_cannon_disabled ? (
        <NoticeBox warning textAlign="center">
          Orbital cannon is disabled!
        </NoticeBox>
      ) : (
        ''
      )}
    </Section>
  );
};
