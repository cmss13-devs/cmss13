import { useBackend, useLocalState } from '../backend';
import { round } from 'common/math';
import {
  Button,
  Section,
  NoticeBox,
  Stack,
  Flex,
  Icon,
  NumberInput,
  LabeledList,
  ProgressBar,
  Divider,
  Table,
  Box,
  Dropdown,
  ColorBox,
} from '../components';
import { Window } from '../layouts';

import { createLogger } from '../logging';
const logger = createLogger('Overwatch');

export const OverwatchConsole = (_props, context) => {
  const { act, data } = useBackend(context);
  const { operator } = data;
  const body = operator ? <OverwatchMain /> : <OverwatchEmpty />;
  const windowWidth = operator ? 1000 : 600;
  const windowHeight = operator ? 700 : 300;

  return (
    <Window
      width={windowWidth}
      height={windowHeight}
      scrollable
      theme="weyland">
      <Window.Content>{body}</Window.Content>
    </Window>
  );
};

export const OverwatchMain = (props, context) => {
  const { act, data } = useBackend(context);
  const { squad_data, mapRef } = data;
  const [currentControlCategory] = useLocalState(
    context,
    'current_control_category',
    1
  );

  return (
    <>
      <OverwatchId />
      {squad_data ? (
        <Stack direction="column" fontFamily="consolas" grow>
          <Stack.Item>
            <Stack mb="1em">
              <Stack.Item grow>
                <Stack>
                  <Stack.Item>
                    <OverwatchTab />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Stack>
                      {currentControlCategory === 1 ? (
                        <Stack.Item grow fill>
                          <OverwatchSelect />
                          <OverwatchSquad />
                        </Stack.Item>
                      ) : (
                        <Stack.Item grow fill>
                          <OverwatchDrop />
                        </Stack.Item>
                      )}
                    </Stack>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <OverwatchMonitor />
          </Stack.Item>
        </Stack>
      ) : (
        <OverwatchSelect />
      )}
    </>
  );
};

export const OverwatchTab = (props, context) => {
  const { act, data } = useBackend(context);
  const [currentControlCategory, setCategory] = useLocalState(
    context,
    'current_control_category',
    1
  );
  return (
    <Section title="Category">
      <Stack.Item>
        <Button
          fluid
          selected={currentControlCategory === 1}
          textColor={currentControlCategory === 1 ? '#ffffff' : '#161613'}
          icon="person"
          onClick={() => setCategory(1)}
          content="Squad Control"
          lineHeight="8.8em"
        />
      </Stack.Item>
      <Stack.Item grow>
        <Button
          fluid
          selected={currentControlCategory === 2}
          icon="burst"
          textColor={currentControlCategory === 2 ? '#ffffff' : '#161613'}
          onClick={() => setCategory(2)}
          content="Ship Control"
          lineHeight="8.8em"
        />
      </Stack.Item>
    </Section>
  );
};

export const OverwatchDrop = (props, context) => {
  const { act, data } = useBackend(context);
  const [currentCategory, setCategory] = useLocalState(
    context,
    'current_category',
    1
  );

  return (
    <Section
      title={currentCategory === 1 ? 'Supply Drop' : 'Orbital Bombardment'}>
      <Stack>
        <Stack.Item grow>
          <Button
            fluid
            selected={currentCategory === 1}
            textColor={currentCategory === 1 ? '#ffffff' : '#161613'}
            icon="box-open"
            onClick={() => setCategory(1)}
            content="Supply Drop"
          />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            fluid
            selected={currentCategory === 2}
            icon="burst"
            textColor={currentCategory === 2 ? '#ffffff' : '#161613'}
            onClick={() => setCategory(2)}
            content="Orbital Bombardment"
          />
        </Stack.Item>
      </Stack>
      <Divider />
      <Box>
        {currentCategory === 1 ? <OverwatchSupplies /> : <OverwatchBomb />}
      </Box>
    </Section>
  );
};

export const OverwatchEmpty = (props, context) => {
  const { act, data } = useBackend(context);
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
  const { operator, operator_name, authenticated } = data;
  return (
    <Section title="Authentication">
      <Stack>
        <Stack.Item grow>
          <Button
            icon="user"
            fluid
            content={
              operator ? 'Operator: ' + operator_name : 'Unauthenticated'
            }
            onClick={() => act('change_operator')}
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

export const OverwatchSelect = (props, context) => {
  const { act, data } = useBackend(context);
  const { squad_data, squad_list } = data;
  return (
    <Section
      title="Squad Selection"
      buttons={
        <Dropdown
          options={squad_list}
          onSelected={(value) => act('pick_squad', { squadpicked: value })}
          selected="Select"
          noscroll
          displayText="Select..."
          lineHeight="1.5em"
          height="1.8em"
        />
      }>
      <Stack>
        <Stack.Item grow>
          <Button
            textAlign="center"
            icon={'user'}
            fluid
            content={
              squad_data ? 'Squad: ' + squad_data.squad_name : 'Squad: None'
            }
            disabled={!squad_data}
            onClick={() => act('logout_squad')}
            lineHeight="2em"
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
    <Section title={squad_data.squad_name}>
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
              act('use_cam', { cam_target: squad_data.current_squad_leader })}
          />
        </Stack.Item>
        <Stack.Item width="15%">
          <Button
            textAlign="center"
            icon={'comment'}
            fluid
            content={'Message'}
            disabled={!squad_data.current_squad_leader_name}
            onClick={() => act('sl_message')}
          />
        </Stack.Item>
        <Stack.Item width="25%">
          <Dropdown
            options={squad_data.sl_candidates}
            displayText={
              squad_data.current_squad_leader_name
                ? 'Reassign Squad Leader'
                : 'Assign Squad Leader'
            }
            onSelected={(value) =>
              act('change_lead', { marine_picked: marine_list[value].ref })}
            selected="Select"
            noscroll
            lineHeight="1.5em"
            height="2em"
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
                  })}
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
                  })}
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
            onClick={() =>
              act('message', {
                message: value,
              })}
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
                onSelected={(value) =>
                  act('insubordination', {
                    marine_picked: marine_list[value].ref,
                  })}
                noscroll
                width="100%"
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
                ml="-0.5em"
                onSelected={(value) =>
                  act('camera_view', { marine_picked: marine_list[value].ref })}
                noscroll
                width="104%"
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      <Divider hidden />
      <Button
        textAlign="center"
        icon={'map'}
        fluid
        content={'View Tactical Map'}
        onClick={() => act('mapview')}
      />
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
  } = data;

  const marine_data = Object.values(marine_list);
  logger.warn(data);

  return (
    <Section
      title="Squad Monitor"
      height="25em"
      ml="-0.5em"
      mr="0.5em"
      buttons={
        <Stack>
          <Stack.Item>
            <Button
              content={dead_hidden ? 'Show Dead Marines' : 'Hide Dead Marines'}
              textColor={dead_hidden ? '#ffffff' : '#161613'}
              selected={dead_hidden}
              onClick={() => act('hide_dead')}
              height="1.8em"
              lineHeight="1.5em"
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              selected={!marine_filter_enabled}
              textColor={!marine_filter_enabled ? '#ffffff' : '#161613'}
              content={
                marine_filter_enabled
                  ? 'Show Filtered Marines'
                  : 'Hide Filtered Marines'
              }
              onClick={() => act('toggle_marine_filter')}
              height="1.8em"
              lineHeight="1.5em"
            />
          </Stack.Item>
          <Stack.Item>
            <Dropdown
              options={['Ship', 'Ground', 'None']}
              displayText={z_hidden ? "Hidden Area: " + (z_hidden === 2 ? "Almayer" : "Colony") : "Hide Area"}
              onSelected={(value) => act('choose_z', { area_picked: value })}
              noscroll
              width={z_hidden ? "14em" : "8em"}
              height="1.8em"
              lineHeight="1.5em"
            />
          </Stack.Item>
        </Stack>
      }>
      <Stack direction="column" justify="space-between" height="21em">
        <Section scrollable>
          <Stack.Item height="16em">
            <Table fontFamily="consolas">
              <Table.Row>
                <Table.Cell bold>Name</Table.Cell>
                <Table.Cell bold>Rank</Table.Cell>
                <Table.Cell bold>Status</Table.Cell>
                <Table.Cell bold>Area</Table.Cell>
                <Table.Cell bold>SL Distance</Table.Cell>
                <Table.Cell bold>Filter</Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell>
                  <Divider />
                </Table.Cell>
                <Table.Cell>
                  <Divider />
                </Table.Cell>
                <Table.Cell>
                  <Divider />
                </Table.Cell>
                <Table.Cell>
                  <Divider />
                </Table.Cell>
                <Table.Cell>
                  <Divider />
                </Table.Cell>
                <Table.Cell>
                  <Divider />
                </Table.Cell>
              </Table.Row>
              {marine_data.map((marine_data) => (
                <Table.Row key={marine_data}>
                  <Table.Cell>
                    <Button
                      fluid
                      content={marine_data['name']}
                      onClick={() =>
                        act('use_cam', {
                          cam_target: marine_data['ref'],
                        })}
                    />
                  </Table.Cell>
                  <Table.Cell>
                    {marine_data['role']
                      + (marine_data['act_sl'] === true
                        ? marine_data['act_sl']
                        : '')
                      + (marine_data['fteam']
                        ? ' (' + marine_data['fteam'] + ')'
                        : '')}
                  </Table.Cell>
                  <Table.Cell>
                    <ColorBox
                      color={
                        marine_data['mob_state'] === 'Conscious'
                          ? 'green'
                          : 'red'
                      }
                    />
                    {' ' + marine_data['mob_state']}{' '}
                    {!marine_data['helmet'] ? ' (no helmet)' : null}
                  </Table.Cell>
                  <Table.Cell>
                    {marine_data['area_name']
                      ? marine_data['area_name']
                      : 'N/A'}
                  </Table.Cell>
                  <Table.Cell>
                    {marine_data['dist']
                      ? marine_data['dist']
                      : 'N/A'}
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      content={marine_data['filtered'] ? 'HIDE' : 'SHOW'}
                      onClick={() =>
                        act('filter_marine', {
                          squaddie: marine_data.ref })} />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Stack.Item>
        </Section>
        <Stack.Item>
          <Table>
            <Table.Row>
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
                <Divider />
              </Table.Cell>
              <Table.Cell>
                <Divider />
              </Table.Cell>
              <Table.Cell>
                <Divider />
              </Table.Cell>
              <Table.Cell>
                <Divider />
              </Table.Cell>
              <Table.Cell>
                <Divider />
              </Table.Cell>
              <Table.Cell>
                <Divider />
              </Table.Cell>
              <Table.Cell>
                <Divider />
              </Table.Cell>
              <Table.Cell>
                <Divider />
              </Table.Cell>
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
                <ColorBox
                  color={squad_data.specialists > 0 ? 'green' : 'red'}
                />
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
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const OverwatchSupplies = (props, context) => {
  const { act, data } = useBackend(context);
  const { x_supply, y_supply, supply_cooldown, supply_ready } = data;

  const [target_x, setTargetX] = useLocalState(context, 'target_x', x_supply);
  const [target_y, setTargetY] = useLocalState(context, 'target_y', y_supply);

  return (
    <>
      <ProgressBar
        ranges={{
          good: [-Infinity, 200],
          average: [200, 400],
          bad: [Infinity, 400],
        }}
        minValue={0}
        maxValue={500}
        value={supply_cooldown}>
        {supply_cooldown + ' seconds'}
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
                onChange={(_, value) => setTargetX(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Y">
              <NumberInput
                width="4em"
                minValue="-1000"
                maxValue="1000"
                stepPixelSize="20"
                value={target_y}
                onChange={(_, value) => setTargetY(value)}
              />
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <Box p="0.2em" />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            fluid
            textAlign="center"
            content="Dial Target"
            icon="crosshairs"
            lineHeight="3.5em"
            onClick={() =>
              act('set_supply', {
                target_x: target_x,
                target_y: target_y,
              })}
          />
        </Stack.Item>
      </Stack>
      <Divider />
      <Button.Confirm
        fluid
        icon="box-open"
        content="Drop Supply"
        lineHeight="3.5em"
        textAlign="center"
        disabled={!supply_ready}
        confirmContent={'Fire at ' + x_supply + ', ' + y_supply + '?'}
        onClick={() =>
          act('set_supply', {
            target_x: target_x,
            target_y: target_y,
          })}
      />
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
    </>
  );
};

export const OverwatchBomb = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    x_bomb,
    y_bomb,
    bombardment_cooldown,
    almayer_cannon_empty,
    almayer_cannon_disabled,
  } = data;

  const bombardment = round(bombardment_cooldown / 10);

  const [bomb_x, setTargetX] = useLocalState(context, 'bomb_x', x_bomb);
  const [bomb_y, setTargetY] = useLocalState(context, 'bomb_y', y_bomb);

  const bombardment_enabled = bombardment_cooldown === 0
  && !almayer_cannon_disabled
  && !almayer_cannon_empty;

  return (
    <>
      <ProgressBar
        ranges={{
          good: [-Infinity, 200],
          average: [200, 400],
          bad: [Infinity, 400],
        }}
        minValue="0"
        maxValue="500"
        value={bombardment}>
        {bombardment + ' seconds'}
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
                onChange={(_, value) => setTargetX(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Y">
              <NumberInput
                width="4em"
                minValue="-1000"
                maxValue="1000"
                stepPixelSize="20"
                value={bomb_y}
                onChange={(_, value) => setTargetY(value)}
              />
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <Box p="0.2em" />
        </Stack.Item>
        <Stack.Item grow>
          <Button
            fluid
            textAlign="center"
            content="Dial Target"
            icon="crosshairs"
            lineHeight="3.5em"
            onClick={() =>
              act('set_bomb', {
                target_x: bomb_x,
                target_y: bomb_y,
              })}
          />
        </Stack.Item>
      </Stack>
      <Divider />
      <Button.Confirm
        fluid
        textAlign="center"
        content="Bombardment"
        lineHeight="3.5em"
        textColor={bombardment_enabled ? ("#0000000") : ("#ffffff")}
        color="red"
        icon="burst"
        disabled={bombardment_enabled}
        onClick={() => act('dropbomb')}
        confirmContent={'Fire at ' + x_bomb + ', ' + y_bomb + '?'}
      />
      <Divider />
      {bombardment_cooldown === 0
      && !almayer_cannon_disabled
      && !almayer_cannon_empty
        ? (
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
    </>
  );
};
