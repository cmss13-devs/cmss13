import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  Dropdown,
  Input,
  Section,
  Stack,
  TextArea,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  queryId: number;
  queryName: string;
  queryStatus: number;
  queryResults: string;
  queryMode: number;
  rankingMode: boolean;
  queryTimeStart: number;
  queryTimeEnd: number;
  queryRoundId: string; // String because it can be empty
  userQuery: string;
  logTypes: Array<string>;
  statusText: string;
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

const OPENSEARCH_QUERY_MODE_DSL_RAW = 0;
const OPENSEARCH_QUERY_MODE_DSL = 1;
const OPENSEARCH_QUERY_MODE_LUCENE = 2;

const QUERY_MODE_TO_NAME = ['DSL (RAW)', 'DSL', 'Lucene'];
const DEFAULT_QUERY_MODE = 'Lucene';

const LOGTYPE_TO_COLOR = {
  ATTACK: 'bad',
  SAY: 'purple',
  GAME: 'blue',
  ADMIN: 'good',
};

export const OpenSearchQuery = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    queryId,
    queryName,
    queryStatus,
    queryResults,
    queryMode,
    rankingMode,
    queryTimeStart,
    queryTimeEnd,
    queryRoundId,
    userQuery,
    logTypes,
    statusText,
  } = data;

  const [localQueryName, setQueryName] = useSharedState('queryName', queryName);
  const [localQueryMode, setQueryMode] = useSharedState('queryMode', queryMode);
  const [localRankingMode, setRankingMode] = useSharedState(
    'rankingMode',
    rankingMode,
  );
  const [localQueryTimeStart, setQueryTimeStart] = useSharedState(
    'queryTimeStart',
    queryTimeStart,
  );
  const [localQueryTimeEnd, setQueryTimeEnd] = useSharedState(
    'queryTimeEnd',
    queryTimeEnd,
  );
  const [localQueryRoundId, setQueryRoundId] = useSharedState(
    'queryRoundId',
    queryRoundId,
  );
  const [localUserQuery, setUserQuery] = useSharedState('userQuery', userQuery);
  const [localLogTypes, setLogTypes] = useSharedState('logTypes', logTypes);

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

  const submitQuery = (executeNow: boolean, queryOverride) => {
    act('update_query', {
      execute: executeNow,
      query_name: localQueryName,
      query_mode: localQueryMode,
      ranking_mode: localRankingMode,
      query_time_start: localQueryTimeStart,
      query_time_end: localQueryTimeEnd,
      // query_roundid: localQueryRoundId,
      log_types: localLogTypes,
      // for some reason localUserQuery is not updated here when fired through enter key on the query text field, so we do a little manual overriding of the value
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

  const generateLogElements = (results) => {
    let parsed = JSON.parse(results);
    let documents = parsed?.hits?.hits;
    return (
      <Stack vertical scrollable>
        {documents
          ? documents.map((onedoc) => generateSingleLogElement(onedoc))
          : ''}
      </Stack>
    );
  };

  const generateSingleLogElement = (onedoc) => {
    return (
      <Stack.Item>
        <Collapsible
          title={
            <Box as="span">
              <Button
                color={LOGTYPE_TO_COLOR[onedoc._source.logtype] || 'gray'}
              >
                {onedoc._source.logtype}
              </Button>
              {onedoc._id}
            </Box>
          }
        >
          {onedoc._source.message}
        </Collapsible>
      </Stack.Item>
    );
  };

  return (
    <Window
      title={`OpenSearch Query Builder &${queryId}`}
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
              {/*
              <Stack.Item align="left">
                <Box width={5} mt={0.5} color="label">
                  ID: &amp;{queryId}
                </Box>
              </Stack.Item>
              */}
              <Stack.Item grow align="center">
                <Input
                  minWidth={25}
                  value={localQueryName}
                  onChange={(e, value) => setQueryName(value)}
                />
              </Stack.Item>
              <Stack.Item align="right">
                <Button
                  icon={STATUS_TO_ICON[queryStatus]}
                  color={STATUS_TO_COLOR[queryStatus]}
                >
                  {STATUS_TO_NAME[queryStatus]}
                </Button>
              </Stack.Item>
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
                <Dropdown
                  width="8em"
                  selected={DEFAULT_QUERY_MODE}
                  displayText={QUERY_MODE_TO_NAME[localQueryMode]}
                  options={QUERY_MODE_TO_NAME}
                  onSelected={(selected) =>
                    setQueryMode(QUERY_MODE_TO_NAME.indexOf(selected))
                  }
                />
              </Stack.Item>
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

              <Stack.Item>
                <Button.Checkbox
                  width={5}
                  checked={localLogTypes.indexOf('GAME') !== -1}
                  color={localLogTypes.indexOf('GAME') !== -1 ? 'good' : 'bad'}
                  onClick={() => toggleLogType('GAME')}
                >
                  GAME
                </Button.Checkbox>
              </Stack.Item>
              <Stack.Item>
                <Button.Checkbox
                  width={6}
                  checked={localLogTypes.indexOf('ADMIN') !== -1}
                  color={localLogTypes.indexOf('ADMIN') !== -1 ? 'good' : 'bad'}
                  onClick={() => toggleLogType('ADMIN')}
                >
                  ADMIN
                </Button.Checkbox>
              </Stack.Item>
              <Stack.Item>
                <Button.Checkbox
                  width={4}
                  checked={localLogTypes.indexOf('SAY') !== -1}
                  color={localLogTypes.indexOf('SAY') !== -1 ? 'good' : 'bad'}
                  onClick={() => toggleLogType('SAY')}
                >
                  SAY
                </Button.Checkbox>
              </Stack.Item>
              <Stack.Item>
                <Button.Checkbox
                  width={6}
                  checked={localLogTypes.indexOf('ATTACK') !== -1}
                  color={
                    localLogTypes.indexOf('ATTACK') !== -1 ? 'good' : 'bad'
                  }
                  onClick={() => toggleLogType('ATTACK')}
                >
                  ATTACK
                </Button.Checkbox>
              </Stack.Item>

              {/* Round ID picker. Potentially don't need it because if you do you can open OpenSearch-Dashboards which does a better job than this UI }
              <Stack.Item>
                <Box color="label">round:</Box>
              </Stack.Item>
              <Stack.Item>
                <Input
                  width={6}
                  value={localQueryRoundId}
                  onChange={(e, value) => setQueryRoundId(value)}
                />
              </Stack.Item>
              */}

              {/* Start time picker. Potentially don't need it if you're gonna look at the whole round anyway
              <Stack.Item>
                <Box color="label">from:</Box>
              </Stack.Item>
              <Stack.Item>
                <Input
                  width={6}
                  value={timeOffsetToDisplay(localQueryTimeStart)}
                  onChange={(e, value) => {
                    setQueryTimeStart(localTimeOffsetToNumber(value));
                  }}
                />
              </Stack.Item>
              */}
              <Stack.Item grow />
              <Stack.Item align="right">
                <Box color="label">rewind:</Box>
              </Stack.Item>
              <Stack.Item align="right">
                <Input
                  width={5}
                  value={timeOffsetToDisplay(localQueryTimeEnd)}
                  onChange={(e, value) =>
                    setQueryTimeEnd(localTimeOffsetToNumber(value))
                  }
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <TextArea
                  minHeight="2em"
                  value={localUserQuery}
                  placeholder="Query"
                  onChange={(e, value) => setUserQuery(value)}
                  onEnter={(e, value) => {
                    setUserQuery(value);
                    submitQuery(true, value);
                  }}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title={
                (resultsFetched
                  ? `${resultsFetched}/${resultsTotal} results`
                  : 'No results') + (timeElapsed ? ` in ${timeElapsed}ms` : '')
              }
            >
              {generateLogElements(queryResults)}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
