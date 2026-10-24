import { useEffect, useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
  TextArea,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  queryId: number;
  queryName: string;
  queryStatus: number;
  queryResults: string;
  rankingMode: boolean;
  queryTimeAgo: number;
  userQuery: string;
  roundid: string;
  logTypes: Array<string>;
  errorText: string;
  rangedQuery: boolean;
};

const OPENSEARCH_QUERY_STATUS_READY = 1;
const OPENSEARCH_QUERY_STATUS_BUILD_ERROR = 2;
const OPENSEARCH_QUERY_STATUS_EXECUTING = 3;
const OPENSEARCH_QUERY_STATUS_FAILED = 4;
const OPENSEARCH_QUERY_STATUS_SUCCESS = 5;
const STATUS_TO_NAME = [
  'INVALID',
  'READY',
  'BUILD ERROR',
  'RUNNING',
  'FAILED',
  'SUCCESS',
];
const STATUS_TO_ICON = [
  'circle-xmark',
  'check',
  'triangle-exclamation',
  'spinner',
  'circle-xmark',
  'check',
];
const STATUS_TO_COLOR = ['bad', 'good', 'average', 'blue', 'bad', 'good'];

const LOGTYPE_TO_COLOR = {
  ATTACK: 'bad',
  SAY: 'purple',
  HIVEMIND: 'purple',
  EMOTE: 'purple',
  OOC: 'violet',
  GAME: 'blue',
  ADMIN: 'good',
};

// A vastly simplified version of TGUI's Collapsible, with no icon, less margins, etc
const MiniCollapsible = (props) => {
  const { children, header, color, ...rest } = props;
  const [open, setOpen] = useState(props.open);

  return (
    <Box mb={1}>
      <Button
        fluid
        color={color}
        onClick={(e) => {
          e.cancelBubble = true;
          if (e.stopPropagation) {
            e.stopPropagation();
          }
          setOpen(!open);
        }}
        {...rest}
      >
        {header}
      </Button>
      {open && <Box mt={1}>{children}</Box>}
    </Box>
  );
};

export const OpenSearchQuery = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    queryId,
    queryName,
    queryStatus,
    queryResults,
    rankingMode,
    queryTimeAgo,
    roundid,
    userQuery,
    logTypes,
    errorText,
    rangedQuery,
  } = data;

  const [localUserQuery, setUserQuery] = useState(userQuery);
  const [localQueryName, setQueryName] = useState(queryName);
  const [localRangedQuery, setRangedQuery] = useState(rangedQuery);

  // Force refresh the important bits if they're updated by backend
  useEffect(() => {
    setQueryName(queryName);
  }, [queryName]);

  useEffect(() => {
    setUserQuery(userQuery);
  }, [userQuery]);

  useEffect(() => {
    setRangedQuery(rangedQuery);
  }, [rangedQuery]);

  // The smaller stuff is fine as shared states as they're manipulated only in UI
  const [localQueryTimeAgo, setQueryTimeAgo] = useSharedState(
    'queryTimeAgo',
    queryTimeAgo,
  );
  const [localLogTypes, setLogTypes] = useSharedState('logTypes', logTypes);
  const [localRankingMode, setRankingMode] = useSharedState(
    'rankingMode',
    rankingMode,
  );
  const [localRoundid, setRoundid] = useSharedState('roundid', roundid);

  const parsedResults = queryResults ? JSON.parse(queryResults) : {};
  const resultsTotal = parsedResults?.hits?.total?.value;
  const resultsFetched = parsedResults?.hits?.hits?.length;
  const timeElapsed = parsedResults?.took;

  const toggleLogType = (logType: string) => {
    let newLogTypes = [...localLogTypes];
    if (newLogTypes.indexOf(logType) !== -1) {
      newLogTypes = newLogTypes.filter((e) => e !== logType);
    } else {
      newLogTypes.push(logType);
    }
    setLogTypes(newLogTypes);
  };

  const logTypeButton = (logType: string) => {
    return (
      <Stack.Item>
        <Button.Checkbox
          checked={localLogTypes.indexOf(logType) !== -1}
          color={localLogTypes.indexOf(logType) !== -1 ? 'good' : 'bad'}
          onClick={() => toggleLogType(logType)}
        >
          {logType}
        </Button.Checkbox>
      </Stack.Item>
    );
  };

  // For some reason, storing the state within a onEnter does NOT work,
  // so we'll have to override the query when doing that
  const submitQuery = (executeNow: boolean, queryOverride) => {
    act('update_query', {
      execute: executeNow,
      query_name: localQueryName,
      ranking_mode: localRankingMode,
      time_ago: localQueryTimeAgo,
      log_types: localLogTypes,
      roundid: localRoundid,
      user_query: queryOverride || localUserQuery,
    });
  };

  const localTimeOffsetToNumber = (string) => {
    const suffix = string[string.length - 1];
    let numericPart = parseInt(string, 10);
    switch (suffix) {
      case 'm':
        numericPart *= 60;
        break;
      case 'h':
        numericPart *= 60 * 60;
        break;
      case 'd':
        numericPart *= 24 * 60 * 60;
        break;
      case 'w':
        numericPart *= 7 * 24 * 60 * 60;
        break;
    }
    return numericPart;
  };

  const timeOffsetToDisplay = (offset) => {
    let suffix = 's';
    let remaining = offset;
    if (remaining && remaining % 60 === 0) {
      remaining /= 60;
      suffix = 'm';
    }
    if (remaining && remaining % 60 === 0) {
      remaining /= 60;
      suffix = 'h';
    }
    if (remaining && remaining % 24 === 0) {
      remaining /= 24;
      suffix = 'd';
    }
    if (remaining && remaining % 7 === 0) {
      remaining /= 7;
      suffix = 'w';
    }
    return `${remaining}${suffix}`;
  };

  const debloatDocument = (input) => {
    let cloned = { ...input };
    delete cloned['host'];
    delete cloned['@timestamp'];
    delete cloned['@version'];
    delete cloned['event'];
    delete cloned['log'];
    delete cloned['roundid'];
    delete cloned['filetype'];
    delete cloned['tags'];
    // Those are already in the quick view above, no need to display again
    delete cloned['logtype'];
    delete cloned['ckey'];
    delete cloned['character_name'];
    delete cloned['playertext'];
    return cloned;
  };

  const doubleDigitize = (input) => {
    return input >= 10 ? `${input}` : `0${input}`;
  };

  const generateTimestampButton = (timestamp) => {
    let dd: Date = new Date(timestamp);
    return (
      <Button pr={1} color="label">
        {`${doubleDigitize(dd.getUTCHours())}:${doubleDigitize(dd.getUTCMinutes())}:${doubleDigitize(dd.getUTCSeconds())}`}
      </Button>
    );
  };

  const generateLogElements = (results) => {
    let parsed = JSON.parse(results);
    let documents = parsed?.hits?.hits;
    return documents
      ? documents.map((onedoc) => generateSingleLogElement(onedoc))
      : '';
  };

  const generateSingleLogElement = (onedoc) => {
    return (
      onedoc._source && (
        <MiniCollapsible
          header={
            <Box as="span">
              <Table>
                <Table.Row>
                  {generateTimestampButton(onedoc._source.timestamp)}
                  <Button
                    pr={1}
                    color={LOGTYPE_TO_COLOR[onedoc._source.logtype] || 'grey'}
                  >
                    {onedoc._source.logtype}
                  </Button>
                  {onedoc._source.loc_x &&
                    onedoc._source.loc_y &&
                    onedoc._source.loc_z && (
                      <Button
                        color="average"
                        onClick={() =>
                          act('jmp', {
                            x: onedoc._source.loc_x,
                            y: onedoc._source.loc_y,
                            z: onedoc._source.loc_z,
                          })
                        }
                        tooltip={`Jump to (${onedoc._source.loc_x},${onedoc._source.loc_y},${onedoc._source.loc_z})`}
                      >
                        JMP
                      </Button>
                    )}
                  {onedoc._source.message_mode && (
                    <Button pr={1} color="purple">
                      [{onedoc._source.message_mode}]
                    </Button>
                  )}
                  {onedoc._source.ckey && (
                    <Button
                      pr={1}
                      color="blue"
                      tooltip="Click to open Player Panel"
                      onClick={() =>
                        act('playerpanel', { ckey: onedoc._source.ckey })
                      }
                    >
                      ckey:{onedoc._source.ckey}
                    </Button>
                  )}
                  {onedoc._source.character_name && (
                    <Button pr={1} color="good">
                      {onedoc._source.character_name}
                    </Button>
                  )}
                  {onedoc._source.area && (
                    <Button pr={1} color="grey">
                      area:{onedoc._source.area}
                    </Button>
                  )}
                </Table.Row>
                <Table.Row>
                  {onedoc._source.playertext || onedoc._source.message}
                </Table.Row>
              </Table>
            </Box>
          }
        >
          {JSON.stringify(debloatDocument(onedoc._source))}
        </MiniCollapsible>
      )
    );
  };

  return (
    <Window
      title={`OpenSearch Query Builder ~${queryId}`}
      width={700}
      height={700}
    >
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Stack fill>
              <Stack.Item align="left">
                <Button
                  icon={
                    queryStatus !== OPENSEARCH_QUERY_STATUS_EXECUTING
                      ? 'check'
                      : 'spinner'
                  }
                  color={
                    queryStatus !== OPENSEARCH_QUERY_STATUS_EXECUTING
                      ? 'good'
                      : 'blue'
                  }
                  disabled={queryStatus === OPENSEARCH_QUERY_STATUS_EXECUTING}
                  tooltip="Save and Start the query"
                  onClick={() => submitQuery(true, null)}
                >
                  Exec
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="floppy-disk"
                  color="blue"
                  tooltip="Save the query without executing it"
                  onClick={() => submitQuery(false, null)}
                >
                  Save
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="fa-globe"
                  color="violet"
                  tooltip="Saves and Opens the query on OpenSearch Dashboards"
                  onClick={() => {
                    submitQuery(false, null);
                    act('open_dashboards');
                  }}
                >
                  Dashboards
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="window-restore"
                  color="blue"
                  tooltip="Opens the list of queries"
                  onClick={() => {
                    act('open_queries');
                  }}
                >
                  Queries
                </Button>
              </Stack.Item>
              <Stack.Item align="center">
                <Input
                  minWidth={15}
                  value={localQueryName}
                  onChange={(e, value) => setQueryName(value)}
                />
              </Stack.Item>
              <Stack.Item>
                <Input
                  width={6}
                  value={localRoundid}
                  onChange={(e, value) => setRoundid(value)}
                  placeholder="#round"
                />
              </Stack.Item>
              <Stack.Item grow />
              <Stack.Item align="right">
                <Button.Confirm
                  ml={1}
                  icon="trash-can"
                  onClick={() => act('delete')}
                  color="bad"
                  confirmColor="bad"
                  tooltip="Delete the query"
                >
                  Delete
                </Button.Confirm>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack fill>
              <Stack.Item>
                <Button.Checkbox
                  checked={localRankingMode}
                  onClick={() => setRankingMode(!localRankingMode)}
                  tooltip="In Ranking mode, return the most relevant queries at top, irrespective of time."
                  color={localRankingMode ? 'good' : 'blue'}
                >
                  {localRankingMode ? 'Sort: Rank' : 'Sort: Time'}
                </Button.Checkbox>
              </Stack.Item>

              <Button.Checkbox
                ml={1}
                color={localRangedQuery ? 'purple' : 'blue'}
                checked={rangedQuery}
                onClick={() => act('toggle_range')}
                tooltip="Click to toggle additional filtering based on the position you're standing at when clicking it. Only events that have location information can be filtered that way, so some might be omitted."
              >
                Filter Nearby
              </Button.Checkbox>

              {logTypeButton('GAME')}
              {logTypeButton('ADMIN')}
              {logTypeButton('SAY')}
              {logTypeButton('ATTACK')}

              <Stack.Item grow />
              <Stack.Item align="right">
                <Input
                  width={5}
                  value={timeOffsetToDisplay(localQueryTimeAgo)}
                  onChange={(e, value) =>
                    setQueryTimeAgo(localTimeOffsetToNumber(value))
                  }
                />
              </Stack.Item>
              <Stack.Item align="right">
                <Button
                  color="label"
                  disabled
                  tooltip="Enter to the left how long ago you want the search to start. For example if you enter '1d' only events at least 1 day old will be shown. Valid prefix are s (seconds), m (miutes), h (hours), d (days), w (weeks)."
                >
                  ... ago
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <TextArea
              scrollbar
              autoFocus
              minHeight="5em" // Just enough to scroll i guess, cause you can't actually resize this properly within the Stack.Item
              value={localUserQuery}
              placeholder="Query"
              onChange={(e, value) => {
                setUserQuery(value);
              }}
              onEnter={(e, value) => {
                setUserQuery(value);
                submitQuery(true, value);
              }}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title={
                (queryStatus === OPENSEARCH_QUERY_STATUS_FAILED &&
                  'Failed to execute query: ') ||
                (queryStatus === OPENSEARCH_QUERY_STATUS_BUILD_ERROR &&
                  'Failed to create query: ') ||
                (queryStatus === OPENSEARCH_QUERY_STATUS_EXECUTING &&
                  'Executing...') ||
                (queryStatus === OPENSEARCH_QUERY_STATUS_READY && 'Ready.') ||
                (resultsFetched
                  ? `${resultsFetched}/${resultsTotal} results`
                  : 'No results') + (timeElapsed ? ` in ${timeElapsed}ms` : '')
              }
            >
              {errorText && errorText.length && (
                <NoticeBox color="bad" warning>
                  {errorText}
                </NoticeBox>
              )}
              {generateLogElements(queryResults)}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
