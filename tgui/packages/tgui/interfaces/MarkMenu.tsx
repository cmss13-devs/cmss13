import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import {
  Tabs,
  Box,
  Flex,
  Stack,
  Button,
  Icon,
  Collapsible,
  Table,
} from '../components';
import { Window } from '../layouts';

interface MarkProps {
  mark_meanings: Mark[];
  mark_list_infos: PlacedMark[];
  selected_mark?: string;
  is_leader: HivePosition;
  user_nicknumber: string;
  tracked_mark: null | string;
}

interface Mark {
  name: string;
  icon_state: string;
  desc: string;
  id: string;
  image: string;
}

interface PlacedMark extends Mark {
  owner: string;
  owner_name: string;
  area: string;
  time: string;
}

// The position of the xeno in the hive (0 = normal xeno; 1 = queen; 2+ = hive leader)
type HivePosition = 0 | 1 | 2;


const MenuActions = (props, context) => {
  const [historicalSelected, setHistoricalSelected] = useLocalState(context, 'historicalSelected', '');
  const { data, act } = useBackend<MarkProps>(context);
  return (
    <Flex fill justify="space-between" className="ActionMenu">
      <Flex.Item>
        <Button
          color="xeno"
          disabled={historicalSelected === ''}
          onClick={() => act('watch', { type: historicalSelected })}>
            Watch
        </Button>
      </Flex.Item>
      <Flex.Item>
        <Button
          color="xeno"
          disabled={historicalSelected === ''}
          onClick={() => act('track', { type: historicalSelected })}>
          Track
        </Button>
      </Flex.Item>
      {data.is_leader !== 0 && (
        <Flex.Item>
          <Button
            color="red"
            disabled={historicalSelected === ''}
            onClick={() => {
              act('destroy', { type: historicalSelected });
              setHistoricalSelected('');
              }}>
            Destroy
          </Button>
        </Flex.Item>)}

      {data.is_leader === 1 && (
        <Flex.Item>
          <Button
            color="xeno"
            disabled={historicalSelected === ''}
            onClick={() => act('force', { type: historicalSelected })} >
            Force Tracking
          </Button>
        </Flex.Item>)}
    </Flex>);
};

const MarkSelection = (props, context) => {
  const { data } = useBackend<MarkProps>(context);
  const [selectionMenu, setSelectionMenu] = useLocalState(context, 'selectionMenu', false);
  const { selected_mark } = data;
  const mark_prototype = data.mark_meanings.find(x => x.id === selected_mark)
    ?? data.mark_meanings[0];
  return (
    <Box>
      <Stack className="MarkStack">
        <Stack.Item className="ChooseMark__BuildIcon">
          <Button
            className={classes(["MenuSelectionButton", selectionMenu && 'MenuSelectionButtonClicked'])}
            color="xeno"
            onClick={() => setSelectionMenu(!selectionMenu)}
            compact>
            <span
              className={classes([
                `choosemark64x64`,
                `${mark_prototype?.image}${'_big'}`,
              ])}
            />
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              <span className="MarkName">New Mark - {mark_prototype.name} </span>
            </Stack.Item>
            <Stack.Item>
              <span>{mark_prototype.desc}</span>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      {selectionMenu
        && (
          <div className="ChooseMenu">
            <MarkMeaningList onClick={() => setSelectionMenu(false)} />
          </div>)}
    </Box>
  );
};

const HistoricalMark = (props: {mark: PlacedMark}, context) => {
  const { data } = useBackend<MarkProps>(context);
  const { mark } = props;
  const [historicalSelected, setHistoricalSelected] = useLocalState(context, 'historicalSelected', '');

  const isTracked = data.tracked_mark === null ? false : data.tracked_mark === mark.id;

  return (
    <Box
      className={classes([historicalSelected === mark.id && 'Selected'])}
      onClick={() => setHistoricalSelected(historicalSelected === '' ? mark.id : historicalSelected === mark.id ? '' : mark.id)}
    >
      <Stack className="MarkStack" direction="row">
        <Stack.Item className="ChooseMark__BuildIcon">
          <span
            className={classes([
              `choosemark64x64`,
              `${mark.image}_big`,
              'ChooseMark__BuildIcon',
            ])}
          />
        </Stack.Item>
        <Stack.Item className="MarkLabel">
          <Flex align="flex-top" justify="space-between" fill align-items="stretch">
            <Flex.Item >
              <Stack vertical>
                <Stack.Item>
                  <span className="MarkName">{mark.name} - </span>
                  <span>{mark.area}</span>
                </Stack.Item>
                <Stack.Item>
                  <span>Owner: {mark.owner_name}</span>
                </Stack.Item>
                <Stack.Item>
                  <span>Placed: {mark.time}</span>
                </Stack.Item>
              </Stack>
            </Flex.Item>
            {isTracked
              && (
                <Flex.Item>
                  <Icon name="eye" className="TrackIcon" size={2} />
                </Flex.Item>)}
          </Flex>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const MarkHistory = (props, context) => {

  const { data } = useBackend<MarkProps>(context);

  const { mark_list_infos } = data;
  return (
    <Flex direction="column" fill className="History">
      <Flex.Item>
        <MarkSelection />
      </Flex.Item>

      <hr />

      <Flex.Item>
        <MenuActions />
      </Flex.Item>

      {mark_list_infos.map(x => (
        <Flex.Item key={x.id}>
          <HistoricalMark mark={x} />
        </Flex.Item>
      ))}

    </Flex>
  );
};

export const MarkMenu = (props, context) => {
  return (
    <Window
      title={'Mark Menu'}
      theme="hive_status"
      resizable
      width={500}
      height={680}>
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <MarkHistory />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MarkMeaningList = (props: {onClick?: () => void}, context) => {
  const { data, act } = useBackend<MarkProps>(context);
  const { mark_meanings, selected_mark } = data;

  return (
    <Tabs vertical fluid fill>
      {mark_meanings.map((val, index) => (
        <Tabs.Tab
          key={index}
          selected={val.id === selected_mark}
          onClick={() => {
            act('choose_mark', { type: val.id });
            if (props.onClick) {
              props.onClick();
            }
          }}>
          <Stack align="center">
            <Stack.Item>
              <span
                className={classes([
                  `choosemark${'32x32'}`,
                  `${val.image}${''}`,
                  'ChooseMark__BuildIcon',
                ])}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Box fontSiz>{val.desc}</Box>
            </Stack.Item>
          </Stack>
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};


const HiveMarkList = (props, context) => {
  const { data, act } = useBackend<MarkProps>(context);
  const { mark_list_infos, is_leader, user_nicknumber } = data;

  return (
    <Flex direction="column">
      <Table className="xeno_list">
        <Table.Row header className="xenoListRow">
          <Table.Cell width="12.25%" className="noPadCell" />
          <Table.Cell width="12.25%">Owner</Table.Cell>
          <Table.Cell width="12.25%">Type</Table.Cell>
          <Table.Cell width="12.25%">Location</Table.Cell>
          <Table.Cell width="50%">Actions</Table.Cell>
        </Table.Row>
        {mark_list_infos.map((val, index) => (
          <Table.Row key={index}>
            <Table.Cell width="12.25%">
              <Flex>
                <span
                  className={classes([
                    `choosemark${'32x32'}`,
                    `${val.image}${''}`,
                    'ChooseMark__BuildIcon',
                  ])}
                />
              </Flex>
            </Table.Cell>
            <Table.Cell width="12.25%">{val.owner_name}</Table.Cell>
            <Table.Cell width="12.25%">{val.name}</Table.Cell>
            <Table.Cell width="12.25%">{val.area}</Table.Cell>
            <Table.Cell width="50%" className="noPadCell" textAlign="center">
              <Flex
                unselectable="on"
                wrap="wrap"
                className="actionButton"
                align="center"
                justify="space-around"
                inline>
                <Flex.Item>
                  <Button
                    content="Watch"
                    color="xeno"
                    onClick={() => act('watch', { type: val.id })}
                  />
                  <Button
                    content="Track"
                    color="xeno"
                    onClick={() => act('track', { type: val.id })}
                  />
                  {is_leader === 1 && (
                    <Button
                      content="Destroy"
                      color="red"
                      onClick={() => act('destroy', { type: val.id })}
                    />
                  )}
                  {user_nicknumber === val.owner && is_leader !== 1 && (
                    <Button
                      content="Destroy"
                      color="red"
                      onClick={() => act('destroy', { type: val.id })}
                    />
                  )}
                  {is_leader === 1 && (
                    <Button
                      content="Force Tracking"
                      color="xeno"
                      onClick={() => act('force', { type: val.id })}
                    />
                  )}
                </Flex.Item>
              </Flex>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Flex>
  );
};

const XenoCollapsible = (props, context) => {
  const { data, act } = useBackend<MarkProps>(context);
  const { title, children } = props;
  const { hive_color } = data;

  return (
    <Collapsible
      title={title}
      backgroundColor={!!hive_color && hive_color}
      color={!hive_color && 'xeno'}
      open>
      {children}
    </Collapsible>
  );
};
