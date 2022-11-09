import { classes } from 'common/react';
import { useBackend } from '../backend';
import {
  Tabs,
  Box,
  Flex,
  Stack,
  Button,
  Divider,
  Collapsible,
  Table,
} from '../components';
import { Window } from '../layouts';

export const MarkMenu = (props, context) => {
  const { data } = useBackend(context);
  const { mark_meanings, mark_list_infos, selected_mark, is_leader } = data;

  return (
    <Window
      title={'Mark Menu'}
      theme="hive_status"
      resizable
      width={500}
      height={680}>
      <Window.Content scrollable>
        {!!is_leader && (
          <XenoCollapsible title="Select New Mark Meaning">
            <MarkMeaningList />
          </XenoCollapsible>
        )}
        <Divider />
        <XenoCollapsible title="Hive Mark List">
          <HiveMarkList />
        </XenoCollapsible>
      </Window.Content>
    </Window>
  );
};

const MarkMeaningList = (props, context) => {
  const { act, data } = useBackend(context);
  const { mark_meanings, selected_mark } = data;

  return (
    <Tabs vertical fluid fill>
      {mark_meanings.map((val, index) => (
        <Tabs.Tab
          key={index}
          selected={val.id === selected_mark}
          onClick={() => act('choose_mark', { type: val.id })}>
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
  const { act, data } = useBackend(context);
  const { mark_list_infos, tracked_mark, is_leader, user_nicknumber } = data;

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
  const { data } = useBackend(context);
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
