import { filter, sortBy } from 'common/collections';
import { useBackend, useLocalState } from '../../backend';
import { Window } from '../../layouts';
import { Box, Stack, Button, Section, Tabs, NoticeBox, Input, LabeledList, Flex } from 'tgui/components';
import type { BackendContext, SecurityRecord } from './types';
import { CRIMESTATUS2COLOR } from './constants';
import { isRecordMatch } from './helpers';
import { flow } from 'common/fp';
import { capitalize } from 'common/string';
import { decodeHtmlEntities } from 'common/string';

export const SecurityRecords = () => {
  return (
    <Window width={750} height={550}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow>
            <RecordTabs />
          </Stack.Item>
          <Stack.Item grow={2}>
            <SecurityRecordView />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Tabs on left, with search bar */
const RecordTabs = (props, context) => {
  const { act, data } = useBackend<BackendContext>(context);
  const { records, prints } = data;

  const errorMessage = !records.length
    ? 'No records found.'
    : 'No match. Refine your search.';

  const [search, setSearch] = useLocalState(context, 'search', '');

  const sorted: SecurityRecord[] = flow([
    filter((record: SecurityRecord) => isRecordMatch(record, search)),
    sortBy((record: SecurityRecord) => record.name),
  ])(records);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Input
          fluid
          placeholder="Name/Rank/ID"
          onInput={(event, value) => setSearch(value)}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Tabs vertical>
            {!sorted.length ? (
              <NoticeBox>{errorMessage}</NoticeBox>
            ) : (
              sorted.map((record, index) => (
                <CrewTab record={record} key={index} />
              ))
            )}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item align="center">
        <Stack fill>
          <Stack.Item>
            <Button
              icon="plus"
              tooltip="Add a new record"
              onClick={() => act('new_general_record')}>
              Create
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              content="Purge"
              icon="trash"
              color="bad"
              onClick={() => act('delete_all_security_records')}
              tooltip="Wipe all criminal records"
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>

      {!!prints.length && (
        <Stack.Item>
          <Section
            title="Prints"
            buttons={
              <>
                <Button
                  icon="eject"
                  tooltip="Eject scanner"
                  onClick={() => act('eject_fingerprint_scanner')}
                />
                <Button
                  icon="print"
                  tooltip="Print report"
                  onClick={() => act('print_fingerprint_report')}
                />
                <Button.Confirm
                  icon="trash"
                  tooltip="Wipe the scanner"
                  color="bad"
                  onClick={() => act('wipe_fingerprint_scanner')}
                />
              </>
            }>
            <Stack vertical>
              {prints.map((print, i) => (
                <>
                  {!!i && <hr color="grey" />}

                  <LabeledList key={print.name}>
                    <LabeledList.Item label="Name">
                      {print.name}
                    </LabeledList.Item>
                    <LabeledList.Item label="Rank">
                      {print.rank}
                    </LabeledList.Item>
                    <LabeledList.Item label="Desc">
                      {print.desc}
                    </LabeledList.Item>
                  </LabeledList>
                </>
              ))}
            </Stack>
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

/** Individual tab */
const CrewTab = (props: { record: SecurityRecord }, context) => {
  const { act, data } = useBackend<BackendContext>(context);
  const { active_record } = data;
  const { record } = props;
  const { ref, name, criminal_status } = record;
  const isSelected = active_record.ref === ref;

  return (
    <Tabs.Tab
      className="candystripe"
      label={record.name}
      onClick={() => act('set_active_record', { ref: record.ref })}
      selected={isSelected}>
      <Box bold={isSelected} color={CRIMESTATUS2COLOR[criminal_status]} wrap>
        {name}
      </Box>
    </Tabs.Tab>
  );
};

/** Record details */
const SecurityRecordView = (props, context) => {
  const { act, data } = useBackend<BackendContext>(context);
  const { active_record, wanted_statuses } = data;
  const [activeTab, setTab] = useLocalState(context, 'activeTab', 0);

  if (!active_record.id) {
    return null;
  }

  const incidentCount = active_record.incidents?.length;
  const commentCount = active_record.comments?.length;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title={active_record.name}
          buttons={
            <>
              <Button
                content={'Print'}
                icon="print"
                onClick={() => act('print_active_record')}
              />
              <Button.Confirm
                content={'Delete'}
                icon="trash"
                tooltip="Delete this security record"
                color="bad"
                disabled={!active_record.criminal_status}
                onClick={() =>
                  act('delete_security_record', { ref: active_record.ref })
                }
              />
            </>
          }>
          <LabeledList>
            <LabeledList.Item label="Name">
              {active_record.name}
              <Button
                icon="pen"
                ml={1}
                onClick={() => act('edit_name', { ref: active_record.ref })}
              />
            </LabeledList.Item>
            {active_record.criminal_status && (
              <LabeledList.Item
                verticalAlign="middle"
                label="Status"
                color={CRIMESTATUS2COLOR[active_record.criminal_status]}>
                <Flex justify="space-between">
                  <Flex.Item>{active_record.criminal_status}</Flex.Item>
                  <Flex.Item>
                    {wanted_statuses.map((status) => {
                      let isActiveStatus =
                        status === active_record.criminal_status;
                      return (
                        <Button
                          key={status}
                          tooltip={status}
                          tooltipPosition="bottom"
                          color={
                            isActiveStatus ? CRIMESTATUS2COLOR[status] : 'grey'
                          }
                          icon={isActiveStatus ? 'check' : ' '}
                          onClick={() =>
                            act('set_criminal_status', {
                              new_status: status,
                              ref: active_record.ref,
                            })
                          }>
                          {status.charAt(0)}
                        </Button>
                      );
                    })}
                  </Flex.Item>
                </Flex>
              </LabeledList.Item>
            )}
            <LabeledList.Item label="Rank">
              {active_record.rank}
            </LabeledList.Item>
            <LabeledList.Item label="Sex">
              {capitalize(active_record.sex)}
              <Button
                icon="pen"
                ml={1}
                onClick={() => act('toggle_sex', { ref: active_record.ref })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Age">
              {active_record.age}
              <Button
                icon="pen"
                ml={1}
                onClick={() => act('edit_age', { ref: active_record.ref })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Physical Status">
              {active_record.physical_status}
            </LabeledList.Item>
            <LabeledList.Item label="Mental Status">
              {active_record.mental_status}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>

      <Stack vertical fill mt=".5rem">
        {active_record.criminal_status && (
          <>
            <Tabs height="3rem">
              <Tabs.Tab selected={activeTab === 0} onClick={() => setTab(0)}>
                Incidents {!!incidentCount && '(' + incidentCount + ')'}
              </Tabs.Tab>
              <Tabs.Tab selected={activeTab === 1} onClick={() => setTab(1)}>
                Comments {!!commentCount && '(' + commentCount + ')'}
              </Tabs.Tab>
            </Tabs>
            <Section fill scrollable>
              {activeTab === 0 && <IncidentList />}
              {activeTab === 1 && <CommentsList />}
            </Section>
          </>
        )}

        {!active_record.criminal_status && (
          <Stack.Item grow>
            {' '}
            <NoticeBox danger width="100%" py="1.5rem" textAlign="center">
              <Box fontSize={1.35}>No security record found</Box>
              <Button
                normal
                style={{
                  'font-style': 'normal',
                }}
                mt={2}
                px={4}
                py={1}
                onClick={() =>
                  act('new_security_record', {
                    ref: active_record.ref,
                  })
                }>
                Create
              </Button>
            </NoticeBox>
          </Stack.Item>
        )}
      </Stack>
    </Stack>
  );
};

const IncidentList = (props, context) => {
  const { data } = useBackend<BackendContext>(context);
  const { active_record } = data;

  return (
    <Stack vertical>
      {!active_record.incidents.length && (
        <NoticeBox p={1} textAlign="center">
          No incidents.
        </NoticeBox>
      )}

      {active_record.incidents.map((incident, index) => (
        <Stack key={index} vertical>
          {!!index && <hr color="grey" />}

          {/* Incident charges */}
          <Stack vertical>
            {incident.crimes.map((crime) => (
              <Stack.Item key={crime}>{crime}</Stack.Item>
            ))}
          </Stack>

          {/* Incident summary */}
          <Stack.Item color="label" italic>
            Summary:{' '}
            {incident.summary ? decodeHtmlEntities(incident.summary) : 'none.'}
          </Stack.Item>
        </Stack>
      ))}
    </Stack>
  );
};

const CommentsList = (props, context) => {
  const { act, data } = useBackend<BackendContext>(context);
  const { active_record } = data;

  return (
    <Stack vertical>
      {!active_record.comments.length && (
        <NoticeBox p={1} textAlign="center">
          No comments.
        </NoticeBox>
      )}

      {active_record.comments.map((comment, index) => (
        <Stack key={index} vertical>
          {!!index && <hr color="grey" />}

          <Stack.Item italic>
            {/* Comment deleted text */}
            {comment.deleted_by && (
              <Box color="bad">
                {'Comment deleted by '}
                {comment.deleted_by}
                {' at '}
                {decodeHtmlEntities(comment.deleted_at)}
              </Box>
            )}

            {/* Comment content */}
            {!comment.deleted_by && (
              <Box color="label">{decodeHtmlEntities(comment.entry)}</Box>
            )}
          </Stack.Item>

          {/* Comment author */}
          <Stack.Item>
            {comment.created_by_name}
            {' ('}
            {comment.created_by_rank}
            {')'}
          </Stack.Item>

          {/* Edit comment */}
          <Stack.Item>
            <Button
              icon="pen"
              onClick={() =>
                act('edit_comment', {
                  ref: active_record.ref,
                  comment_id: index + 1,
                })
              }
              tooltip="Edit comment"
              disabled={comment.deleted_by}
            />

            {/* Delete comment */}
            <Button.Confirm
              icon="trash"
              onClick={() =>
                act('delete_comment', {
                  ref: active_record.ref,
                  comment_id: index + 1,
                })
              }
              tooltip="Delete comment"
              disabled={comment.deleted_by}
            />
          </Stack.Item>
        </Stack>
      ))}
      {/* New comment */}
      <Stack.Item align="center" mt="2">
        <Button
          px={4}
          py={1.5}
          textAlign="center"
          onClick={() =>
            act('add_comment', {
              ref: active_record.ref,
            })
          }>
          Add Comment
        </Button>
      </Stack.Item>
    </Stack>
  );
};
