import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  Input,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type TicketResponse = {
  timestamp: string;
  author: string;
  message: string;
  type: 'admin' | 'mentor' | 'system' | 'legacy';
};

type Ticket = {
  id: number;
  author: string;
  message: string;
  subject: string;
  latest_message: string;
  status: string;
  timestamp: string;
  closed_at: string;
  claimed_by: string | null;
  viewer_is_claiming: boolean;
  all_responses: TicketResponse[];
  is_archived: boolean;
};

type Data = {
  is_admin: boolean;
  is_mentor: boolean;
  selected_tab: string;
  selected_ticket: number | null;
  entered_message: string;
  admin_open_tickets: Ticket[];
  admin_archived_tickets: Ticket[];
  mentor_open_tickets: Ticket[];
  mentor_archived_tickets: Ticket[];
};

export const TicketPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const [ticketUpdateTime, setTicketUpdateTime] = useState(0);

  useEffect(() => {
    const updateTime = Date.now();
    setTicketUpdateTime(updateTime);
  }, [
    data.admin_open_tickets,
    data.admin_archived_tickets,
    data.mentor_open_tickets,
    data.mentor_archived_tickets,
    data.selected_ticket,
  ]);

  const openTickets =
    data.selected_tab === 'admin'
      ? Array.isArray(data.admin_open_tickets)
        ? data.admin_open_tickets
        : []
      : Array.isArray(data.mentor_open_tickets)
        ? data.mentor_open_tickets
        : [];

  const archivedTickets =
    data.selected_tab === 'admin'
      ? Array.isArray(data.admin_archived_tickets)
        ? data.admin_archived_tickets
        : []
      : Array.isArray(data.mentor_archived_tickets)
        ? data.mentor_archived_tickets
        : [];

  const tickets = [...openTickets, ...archivedTickets];
  const selectedTicketData = tickets.find(
    (ticket) => ticket.id === data.selected_ticket,
  );

  return (
    <Window theme="crtblue" width={1120} height={800}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item>
                  <Button
                    icon="user-shield"
                    color="good"
                    tooltip="Start a new adminhelp to a player"
                    onClick={() => act('start_adminhelp')}
                  >
                    New Adminhelp
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="user-graduate"
                    color="average"
                    tooltip="Start a new mentorhelp to a player"
                    onClick={() => act('start_mentorhelp')}
                  >
                    New Mentorhelp
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="sync"
                    color="default"
                    tooltip="Refresh ticket list"
                    onClick={() => act('refresh')}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item width="300px">
                <Tabs vertical>
                  {data.is_admin ? (
                    <Tabs.Tab
                      selected={data.selected_tab === 'admin'}
                      onClick={() => act('select_tab', { tab: 'admin' })}
                      icon="user-shield"
                    >
                      Admin Tickets ({data.admin_open_tickets.length})
                    </Tabs.Tab>
                  ) : (
                    ''
                  )}
                  <Tabs.Tab
                    selected={data.selected_tab === 'mentor'}
                    onClick={() => act('select_tab', { tab: 'mentor' })}
                    icon="user-graduate"
                  >
                    Mentor Tickets ({data.mentor_open_tickets.length})
                  </Tabs.Tab>
                </Tabs>

                <Box
                  style={{ height: 'calc(100vh - 100px)', overflowY: 'auto' }}
                >
                  <Stack vertical>
                    <Section
                      title={`Open Tickets (${openTickets.length})`}
                      scrollable
                    >
                      {openTickets.length === 0 ? (
                        <Box>No open tickets.</Box>
                      ) : (
                        <Stack vertical>
                          {openTickets.map((ticket) => (
                            <Box
                              key={ticket.id}
                              className={[
                                'TicketItem',
                                data.selected_ticket === ticket.id &&
                                  'TicketItem--selected',
                              ]
                                .filter(Boolean)
                                .join(' ')}
                              onClick={() =>
                                act('select_ticket', { ticket_id: ticket.id })
                              }
                              p={1}
                              mb={1}
                              style={{
                                cursor: 'pointer',
                                borderRadius: '6px',
                                backgroundColor:
                                  data.selected_ticket === ticket.id
                                    ? 'rgba(0,0,0,0.15)'
                                    : 'transparent',
                              }}
                            >
                              <Stack align="center">
                                <Stack.Item>
                                  <Button
                                    icon="times"
                                    color={
                                      !ticket.viewer_is_claiming
                                        ? 'default'
                                        : 'bad'
                                    }
                                    tooltip="Close Ticket"
                                    disabled={!ticket.viewer_is_claiming}
                                    onClick={(e) => {
                                      e.stopPropagation();
                                      act('close_ticket', {
                                        ticket_id: ticket.id,
                                      });
                                    }}
                                  />
                                </Stack.Item>
                                <Stack.Item>
                                  <Icon
                                    name={
                                      ticket.claimed_by ? 'user-check' : 'user'
                                    }
                                    color={
                                      ticket.claimed_by ? 'good' : 'average'
                                    }
                                    mr={1}
                                  />
                                </Stack.Item>
                                <Stack.Item grow={1} overflow="hidden">
                                  <Box
                                    bold
                                    color={
                                      ticket.claimed_by ? 'good' : 'default'
                                    }
                                  >
                                    {ticket.author}
                                  </Box>
                                  {ticket.subject ? (
                                    <Box
                                      color={'average'}
                                      style={{
                                        whiteSpace: 'nowrap',
                                        overflow: 'hidden',
                                        textOverflow: 'ellipsis',
                                      }}
                                    >
                                      <b>{'[' + ticket.subject + ']'}</b>
                                    </Box>
                                  ) : (
                                    ''
                                  )}
                                  <Box
                                    color="label"
                                    style={{
                                      whiteSpace: 'nowrap',
                                      overflow: 'hidden',
                                      textOverflow: 'ellipsis',
                                    }}
                                  >
                                    {ticket.latest_message}
                                  </Box>
                                  <Box color="gray" fontSize="0.8em">
                                    {ticket.timestamp}
                                  </Box>
                                </Stack.Item>
                              </Stack>
                            </Box>
                          ))}
                        </Stack>
                      )}
                    </Section>

                    <Section
                      title={`Archived (Read-Only) (${archivedTickets.length})`}
                      scrollable
                    >
                      {archivedTickets.length === 0 ? (
                        <Box>No archived tickets.</Box>
                      ) : (
                        <Stack vertical>
                          {archivedTickets.map((ticket) => (
                            <Box
                              key={ticket.id}
                              className={[
                                'TicketItem',
                                data.selected_ticket === ticket.id &&
                                  'TicketItem--selected',
                              ]
                                .filter(Boolean)
                                .join(' ')}
                              onClick={() =>
                                act('select_ticket', { ticket_id: ticket.id })
                              }
                              p={1}
                              mb={1}
                              style={{
                                cursor: 'pointer',
                                borderRadius: '6px',
                                backgroundColor:
                                  data.selected_ticket === ticket.id
                                    ? 'rgba(0,0,0,0.15)'
                                    : 'rgba(0,0,0,0.05)',
                                opacity: '0.7',
                              }}
                            >
                              <Stack align="center">
                                <Stack.Item>
                                  <Icon name="lock" color="average" mr={1} />
                                </Stack.Item>
                                <Stack.Item>
                                  <Icon
                                    name={
                                      ticket.claimed_by ? 'user-check' : 'user'
                                    }
                                    color={
                                      ticket.claimed_by ? 'good' : 'average'
                                    }
                                    mr={1}
                                  />
                                </Stack.Item>
                                <Stack.Item grow={1} overflow="hidden">
                                  <Box
                                    bold
                                    color={
                                      ticket.claimed_by ? 'good' : 'default'
                                    }
                                  >
                                    {ticket.author}
                                  </Box>
                                  {ticket.subject ? (
                                    <Box
                                      color={'average'}
                                      style={{
                                        whiteSpace: 'nowrap',
                                        overflow: 'hidden',
                                        textOverflow: 'ellipsis',
                                      }}
                                    >
                                      <b>{'[' + ticket.subject + ']'}</b>
                                    </Box>
                                  ) : (
                                    ''
                                  )}
                                  <Box
                                    color="label"
                                    style={{
                                      whiteSpace: 'nowrap',
                                      overflow: 'hidden',
                                      textOverflow: 'ellipsis',
                                    }}
                                  >
                                    {ticket.latest_message}
                                  </Box>
                                  <Box color="gray" fontSize="0.8em">
                                    {ticket.timestamp}
                                  </Box>
                                </Stack.Item>
                              </Stack>
                            </Box>
                          ))}
                        </Stack>
                      )}
                    </Section>
                  </Stack>
                </Box>
              </Stack.Item>

              <Stack.Divider />

              <Stack.Item grow={1}>
                {selectedTicketData ? (
                  <Section
                    title={`${selectedTicketData.is_archived ? '[ARCHIVED] ' : ''}Ticket #${selectedTicketData.id} ${selectedTicketData.subject ? ': ' + selectedTicketData.subject : ''}`}
                    buttons={
                      !selectedTicketData.is_archived ? (
                        <>
                          <Button
                            icon="user"
                            tooltip="Open Player Panel"
                            onClick={() => {
                              act('open_player_panel', {
                                ticket_id: selectedTicketData.id,
                              });
                            }}
                          />
                          <Button
                            icon="pencil-alt"
                            tooltip="Set Subject"
                            onClick={() => {
                              act('set_subject', {
                                ticket_id: selectedTicketData.id,
                              });
                            }}
                          >
                            Set Subject
                          </Button>
                          <Button
                            icon="sticky-note"
                            tooltip="View Author Notes"
                            onClick={() => {
                              act('get_author_notes', {
                                ticket_id: selectedTicketData.id,
                              });
                            }}
                            disabled={data.selected_tab !== 'admin'}
                          >
                            View Notes
                          </Button>
                          <Button
                            color="bad"
                            icon="user-slash"
                            disabled={data.selected_tab === 'mentor'}
                            onClick={() =>
                              act('ban_author', {
                                ticket_id: selectedTicketData.id,
                              })
                            }
                          >
                            Ban
                          </Button>
                          <Button
                            icon={
                              selectedTicketData.claimed_by
                                ? 'user-slash'
                                : 'user-check'
                            }
                            color={
                              selectedTicketData.claimed_by ? 'average' : 'good'
                            }
                            onClick={() =>
                              act('claim_ticket', {
                                ticket_id: selectedTicketData.id,
                              })
                            }
                          >
                            {selectedTicketData.claimed_by
                              ? 'Unclaim'
                              : 'Claim'}
                          </Button>
                        </>
                      ) : (
                        <Box color="average" italic>
                          Read-Only (Archived)
                        </Box>
                      )
                    }
                  >
                    <LabeledList>
                      {selectedTicketData.subject ? (
                        <LabeledList.Item label="Subject">
                          <Box as="span" color="good">
                            {selectedTicketData.subject}
                          </Box>
                        </LabeledList.Item>
                      ) : ""}
                      <LabeledList.Item label="Author">
                        <Box
                          as="span"
                          color={
                            selectedTicketData.claimed_by ? 'good' : 'default'
                          }
                        >
                          {selectedTicketData.author}
                        </Box>
                      </LabeledList.Item>
                      <LabeledList.Item
                        label="Status"
                        color={
                          selectedTicketData.status === 'open'
                            ? 'good'
                            : 'average'
                        }
                      >
                        {selectedTicketData.status.toUpperCase()}
                      </LabeledList.Item>
                      <LabeledList.Item label="Opened At">
                        {selectedTicketData.timestamp}
                      </LabeledList.Item>
                      {selectedTicketData.closed_at && (
                        <LabeledList.Item label="Closed At">
                          {selectedTicketData.closed_at}
                        </LabeledList.Item>
                      )}
                      <LabeledList.Item label="Claimed By">
                        {selectedTicketData.claimed_by
                          ? selectedTicketData.claimed_by
                          : 'Unclaimed'}
                      </LabeledList.Item>
                      <LabeledList.Item label="Initial Message">
                        <Box style={{ whiteSpace: 'pre-wrap' }}>
                          {selectedTicketData.message}
                        </Box>
                      </LabeledList.Item>
                    </LabeledList>

                    {(selectedTicketData.all_responses?.length ?? 0) > 0 && (
                      <Section
                        title="Conversation Log"
                        mt={2}
                        key={`ticket-${selectedTicketData.id}-${ticketUpdateTime}`}
                      >
                        <Box
                          mt={2}
                          style={{
                            maxHeight: '300px',
                            overflowY: 'auto',
                            overflowX: 'hidden',
                            padding: '0.5em',
                          }}
                        >
                          {selectedTicketData.all_responses?.map(
                            (response, index) => (
                              <Box key={index} mb={2}>
                                <Stack align="flex-start">
                                  <Stack.Item
                                    style={{
                                      width: '120px',
                                      fontSize: '0.85em',
                                      color: 'gray',
                                    }}
                                  >
                                    {response.timestamp || 'Unknown'}
                                  </Stack.Item>
                                  <Stack.Item grow>
                                    <Box>
                                      <Box
                                        as="span"
                                        color={
                                          response.type === 'admin'
                                            ? 'good'
                                            : response.type === 'mentor'
                                              ? 'average'
                                              : response.type === 'system'
                                                ? 'label'
                                                : 'default'
                                        }
                                        bold={response.type !== 'system'}
                                      >
                                        {response.author}:{' '}
                                      </Box>
                                      <Box as="span">{response.message}</Box>
                                    </Box>
                                  </Stack.Item>
                                </Stack>
                              </Box>
                            ),
                          )}
                        </Box>
                      </Section>
                    )}
                    {!selectedTicketData.is_archived ? (
                      <>
                        <Input
                          placeholder="Type your message here..."
                          width="100%"
                          height="100px"
                          value={data.entered_message}
                          onChange={(e) =>
                            act('update_message', {
                              message: e.currentTarget.value,
                            })
                          }
                        />
                        <Button
                          mt={2}
                          onClick={() => {
                            act('reply_ticket', {
                              ticket_id: selectedTicketData.id,
                            });
                          }}
                        >
                          Send
                        </Button>
                        <Button
                          mt={2}
                          onClick={() =>
                            act('close_ticket', {
                              ticket_id: selectedTicketData.id,
                            })
                          }
                        >
                          Close
                        </Button>
                        <Button
                          mt={2}
                          icon="reply-all"
                          onClick={() =>
                            act('autoreply', {
                              ticket_id: selectedTicketData.id,
                            })
                          }
                        >
                          Auto Reply
                        </Button>
                      </>
                    ) : (
                      <>
                        <Box color="label" italic mb={2}>
                          This ticket is archived and cannot be modified.
                        </Box>
                        <Button
                          icon="undo"
                          color="good"
                          onClick={() =>
                            act('reopen_ticket', {
                              ticket_id: selectedTicketData.id,
                            })
                          }
                        >
                          Reopen Ticket
                        </Button>
                      </>
                    )}
                  </Section>
                ) : (
                  <Section fill textAlign="center" align="center">
                    <Box fontSize="1.2em" color="label">
                      {tickets.length > 0
                        ? 'Select a ticket to view details'
                        : 'No tickets available'}
                    </Box>
                  </Section>
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
