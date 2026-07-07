import { decodeHtmlEntities } from 'common/string';
import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
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
  islink?: [string, string];
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
  ic_name: string | null;
  faction: string | null;
  role: string | null;
};

type Data = {
  is_admin: boolean;
  is_mentor: boolean;
  selected_tab: string;
  selected_ticket: number | null;
  admin_open_tickets: Ticket[];
  admin_archived_tickets: Ticket[];
  mentor_open_tickets: Ticket[];
  mentor_archived_tickets: Ticket[];
};

export const TicketPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const [ticketUpdateTime, setTicketUpdateTime] = useState(0);

  const FONT_SIZE_KEY = 'ticketPanelFontSize';
  const FONT_SIZE_DEFAULT = 13;
  const FONT_SIZE_MIN = 9;
  const FONT_SIZE_MAX = 20;

  const [fontSize, setFontSize] = useState<number>(() => {
    const saved = localStorage.getItem(FONT_SIZE_KEY);
    return saved ? parseInt(saved, 10) : FONT_SIZE_DEFAULT;
  });

  const changeFontSize = (delta: number) => {
    setFontSize((prev) => {
      const next = Math.min(
        FONT_SIZE_MAX,
        Math.max(FONT_SIZE_MIN, prev + delta),
      );
      localStorage.setItem(FONT_SIZE_KEY, String(next));
      return next;
    });
  };

  const resetFontSize = () => {
    setFontSize(FONT_SIZE_DEFAULT);
    localStorage.setItem(FONT_SIZE_KEY, String(FONT_SIZE_DEFAULT));
  };

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

  const [isInitialMessageExpanded, setIsInitialMessageExpanded] =
    useState(false);

  useEffect(() => {
    setIsInitialMessageExpanded(false);
  }, [data.selected_ticket]);

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
        ? [...data.admin_archived_tickets].reverse()
        : []
      : Array.isArray(data.mentor_archived_tickets)
        ? [...data.mentor_archived_tickets].reverse()
        : [];

  const tickets = [...openTickets, ...archivedTickets];
  const selectedTicketData = tickets.find(
    (ticket) => ticket.id === data.selected_ticket,
  );

  return (
    <Window theme="crtblue" width={1120} height={900}>
      <Window.Content style={{ fontSize: `${fontSize}px` }}>
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
                <Stack.Item ml="auto">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        color="transparent"
                        tooltip={`Decrease font size (current: ${fontSize}px)`}
                        onClick={() => changeFontSize(-1)}
                      >
                        A-
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        color="transparent"
                        tooltip={`Reset font size to default (${FONT_SIZE_DEFAULT}px)`}
                        onClick={resetFontSize}
                      >
                        {fontSize}px
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        color="transparent"
                        tooltip={`Increase font size (current: ${fontSize}px)`}
                        onClick={() => changeFontSize(1)}
                      >
                        A+
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item minWidth={30}>
                <Stack vertical fill>
                  <Stack.Item shrink>
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
                  </Stack.Item>
                  <Stack.Item grow={2}>
                    <Section
                      fill
                      title={`Open Tickets (${openTickets.length})`}
                      scrollable
                    >
                      {openTickets.length === 0 ? (
                        <Box>No open tickets.</Box>
                      ) : (
                        <Stack vertical fill>
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
                                      ticket.claimed_by &&
                                      !ticket.viewer_is_claiming
                                        ? 'default'
                                        : 'bad'
                                    }
                                    tooltip="Close Ticket"
                                    disabled={
                                      !!ticket.claimed_by &&
                                      !ticket.viewer_is_claiming
                                    }
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
                                    {ticket.role ? ` (${ticket.role})` : ''}
                                  </Box>
                                  {decodeHtmlEntities(ticket.subject) ? (
                                    <Box
                                      color={'average'}
                                      style={{
                                        whiteSpace: 'nowrap',
                                        overflow: 'hidden',
                                        textOverflow: 'ellipsis',
                                      }}
                                    >
                                      <b>
                                        {'[' +
                                          decodeHtmlEntities(ticket.subject) +
                                          ']'}
                                      </b>
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
                                    {decodeHtmlEntities(ticket.latest_message)}
                                  </Box>
                                  <Box color="gray" fontSize="0.9em">
                                    {ticket.timestamp}
                                  </Box>
                                </Stack.Item>
                              </Stack>
                            </Box>
                          ))}
                        </Stack>
                      )}
                    </Section>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Section
                      fill
                      title={`Archived (${archivedTickets.length})`}
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
                                act('select_ticket', {
                                  ticket_id: ticket.id,
                                })
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
                              <Stack align="center" fill>
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
                                    {ticket.role ? ` (${ticket.role})` : ''}
                                  </Box>
                                  {decodeHtmlEntities(ticket.subject) ? (
                                    <Box
                                      color={'average'}
                                      style={{
                                        whiteSpace: 'nowrap',
                                        overflow: 'hidden',
                                        textOverflow: 'ellipsis',
                                      }}
                                    >
                                      <b>
                                        {'[' +
                                          decodeHtmlEntities(ticket.subject) +
                                          ']'}
                                      </b>
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
                                    {decodeHtmlEntities(ticket.latest_message)}
                                  </Box>
                                  <Box color="gray" fontSize="0.9em">
                                    {ticket.timestamp}
                                  </Box>
                                </Stack.Item>
                              </Stack>
                            </Box>
                          ))}
                        </Stack>
                      )}
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Divider />

              <Stack.Item grow>
                {selectedTicketData ? (
                  <Stack fill vertical>
                    <Stack.Item grow basis={0} position="relative">
                      <Section
                        fill
                        m={0}
                        title={`${selectedTicketData.is_archived ? '[ARCHIVED] ' : ''}Ticket #${selectedTicketData.id} ${selectedTicketData.subject ? ': ' + decodeHtmlEntities(selectedTicketData.subject) : ''}`}
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
                              {!!data.is_admin && (
                                <>
                                  <Button
                                    icon="sticky-note"
                                    tooltip="View Author Notes"
                                    onClick={() => {
                                      act('get_author_notes', {
                                        ticket_id: selectedTicketData.id,
                                      });
                                    }}
                                  >
                                    View Notes
                                  </Button>
                                  <Button
                                    color="bad"
                                    icon="user-slash"
                                    onClick={() =>
                                      act('ban_author', {
                                        ticket_id: selectedTicketData.id,
                                      })
                                    }
                                  >
                                    Ban
                                  </Button>
                                </>
                              )}
                              <Button
                                icon="exchange-alt"
                                tooltip={
                                  data.selected_tab === 'admin'
                                    ? 'Defer to Mentors'
                                    : 'Defer to Admins'
                                }
                                onClick={() =>
                                  act('defer_ticket', {
                                    ticket_id: selectedTicketData.id,
                                  })
                                }
                              >
                                Defer
                              </Button>
                              <Button
                                icon={
                                  selectedTicketData.claimed_by
                                    ? 'user-slash'
                                    : 'user-check'
                                }
                                color={
                                  selectedTicketData.claimed_by
                                    ? 'average'
                                    : 'good'
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
                        <Stack fill vertical>
                          <Stack.Item>
                            <LabeledList>
                              {selectedTicketData.subject ? (
                                <LabeledList.Item label="Subject">
                                  <Box as="span" color="good">
                                    {selectedTicketData.subject}
                                  </Box>
                                </LabeledList.Item>
                              ) : (
                                ''
                              )}
                              <LabeledList.Item label="Author">
                                <Box
                                  as="span"
                                  color={
                                    selectedTicketData.claimed_by
                                      ? 'good'
                                      : 'default'
                                  }
                                >
                                  {selectedTicketData.author}
                                </Box>
                              </LabeledList.Item>
                              {selectedTicketData.ic_name && (
                                <LabeledList.Item label="IC Name">
                                  {selectedTicketData.ic_name}
                                </LabeledList.Item>
                              )}
                              {selectedTicketData.faction && (
                                <LabeledList.Item label="Faction">
                                  {selectedTicketData.faction}
                                </LabeledList.Item>
                              )}
                              {selectedTicketData.role && (
                                <LabeledList.Item label="Role">
                                  {selectedTicketData.role}
                                </LabeledList.Item>
                              )}
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
                                <Box
                                  style={{
                                    whiteSpace: 'pre-wrap',
                                    wordBreak: 'break-all',
                                  }}
                                >
                                  {(() => {
                                    const message = decodeHtmlEntities(
                                      selectedTicketData.message || '',
                                    );
                                    if (message.length <= 200) {
                                      return message;
                                    }
                                    if (isInitialMessageExpanded) {
                                      return (
                                        <>
                                          {message}
                                          <Box
                                            as="span"
                                            color="average"
                                            style={{
                                              cursor: 'pointer',
                                              marginLeft: '6px',
                                              textDecoration: 'underline',
                                            }}
                                            onClick={() =>
                                              setIsInitialMessageExpanded(false)
                                            }
                                          >
                                            Show Less
                                          </Box>
                                        </>
                                      );
                                    }
                                    return (
                                      <>
                                        {message.substring(0, 200)}...
                                        <Box
                                          as="span"
                                          color="average"
                                          style={{
                                            cursor: 'pointer',
                                            marginLeft: '6px',
                                            textDecoration: 'underline',
                                          }}
                                          onClick={() =>
                                            setIsInitialMessageExpanded(true)
                                          }
                                        >
                                          Show More
                                        </Box>
                                      </>
                                    );
                                  })()}
                                </Box>
                              </LabeledList.Item>
                            </LabeledList>
                          </Stack.Item>
                          <Stack.Item grow>
                            {(selectedTicketData.all_responses?.length ?? 0) >
                              0 && (
                              <Section
                                fill
                                scrollable
                                title="Conversation Log"
                                key={`ticket-${selectedTicketData.id}-${ticketUpdateTime}`}
                                m={0}
                              >
                                <Box m={2}>
                                  {selectedTicketData.all_responses?.map(
                                    (response, index) => {
                                      const link = response.islink;
                                      return (
                                        <Box key={index} mb={2}>
                                          <Stack align="flex-start">
                                            <Stack.Item
                                              style={{
                                                width: '120px',
                                                fontSize: '1em',
                                                color: 'gray',
                                              }}
                                            >
                                              {response.timestamp || 'Unknown'}
                                            </Stack.Item>
                                            <Stack.Item grow>
                                              <Box
                                                style={{
                                                  whiteSpace: 'pre-wrap',
                                                  wordBreak: 'break-all',
                                                }}
                                              >
                                                <Box
                                                  as="span"
                                                  color={
                                                    response.type === 'admin'
                                                      ? 'good'
                                                      : response.type ===
                                                          'mentor'
                                                        ? 'average'
                                                        : response.type ===
                                                            'system'
                                                          ? 'label'
                                                          : 'default'
                                                  }
                                                  bold={
                                                    response.type !== 'system'
                                                  }
                                                >
                                                  {response.author}:{' '}
                                                </Box>
                                                <Box as="span">
                                                  {link ? (
                                                    <Button
                                                      onClick={() => {
                                                        window.location.href =
                                                          link[1];
                                                      }}
                                                    >
                                                      {link[0]}
                                                    </Button>
                                                  ) : (
                                                    decodeHtmlEntities(
                                                      response.message,
                                                    )
                                                  )}
                                                </Box>
                                              </Box>
                                            </Stack.Item>
                                          </Stack>
                                        </Box>
                                      );
                                    },
                                  )}
                                </Box>
                              </Section>
                            )}
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>
                    <Stack.Item>
                      <Box mt={1} pb={1}>
                        {!selectedTicketData.is_archived ? (
                          <Stack vertical>
                            <Stack.Item>
                              <Button
                                icon="reply"
                                color="good"
                                fontSize="1.2em"
                                textAlign="center"
                                lineHeight={2}
                                fluid
                                onClick={() => {
                                  act('reply_ticket', {
                                    ticket_id: selectedTicketData.id,
                                  });
                                }}
                              >
                                Reply
                              </Button>
                            </Stack.Item>
                            <Stack.Item>
                              <Stack>
                                <Stack.Item grow>
                                  <Button
                                    icon="times"
                                    color="bad"
                                    fluid
                                    onClick={() =>
                                      act('close_ticket', {
                                        ticket_id: selectedTicketData.id,
                                      })
                                    }
                                  >
                                    Close Ticket
                                  </Button>
                                </Stack.Item>
                                <Stack.Item grow>
                                  <Button
                                    icon="reply-all"
                                    fluid
                                    onClick={() =>
                                      act('autoreply', {
                                        ticket_id: selectedTicketData.id,
                                      })
                                    }
                                  >
                                    Auto Reply
                                  </Button>
                                </Stack.Item>
                              </Stack>
                            </Stack.Item>
                          </Stack>
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
                      </Box>
                    </Stack.Item>
                  </Stack>
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
