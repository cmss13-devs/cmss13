import { useBackend } from '../backend';
import { Box, Stack, Button, Icon } from '../components';
import { Window } from '../layouts';
import { Color } from 'common/color';
import { Ping } from 'common/ping';
import { Component } from 'react';

const RELAY_COUNT = 8;

const COLORS = [
  new Color(220, 40, 40), // red
  new Color(220, 200, 40), // yellow
  new Color(60, 220, 40), // green
];

const getPingColor = function (ping) {
  if (ping < 200) {
    return COLORS[2];
  }
  if (ping < 500) {
    return COLORS[1];
  }
  return COLORS[0];
};

export class PingResult {
  constructor(desc = 'Loading...', url = '', ping = -1, color = COLORS[0]) {
    this.desc = desc;
    this.url = url;
    this.ping = ping;
    this.color = color;
    this.error = null;
  }

  update = function (desc, url, ping, error) {
    this.desc = desc;
    this.url = url;
    this.ping = ping;
    this.color = getPingColor(ping);
    this.error = error;
  };
}

class PingApp extends Component {
  constructor() {
    super();

    this.pinger = new Ping();
    this.state = { currentIndex: 0 };

    this.results = new Array(RELAY_COUNT);
    for (let i = 0; i < RELAY_COUNT; i++) {
      this.results[i] = new PingResult();
    }
  }

  startTest(desc, pingURL, connectURL) {
    this.pinger.ping('http://' + pingURL, (error, pong) => {
      this.results[this.state.currentIndex]?.update(
        desc,
        'byond://' + connectURL,
        pong,
        error
      );
      this.setState((prevState) => ({
        currentIndex: prevState.currentIndex + 1,
      }));
    });
  }

  componentDidMount() {
    this.startTest('Direct', 'play.cm-ss13.com:8998', 'play.cm-ss13.com:1400');
    this.startTest(
      'United Kingdom, London',
      'uk.cm-ss13.com:8998',
      'uk.cm-ss13.com:1400'
    );
    this.startTest(
      'France, Gravelines',
      'eu-w.cm-ss13.com:8998',
      'eu-w.cm-ss13.com:1400'
    );
    this.startTest(
      'Poland, Warsaw',
      'eu-e.cm-ss13.com:8998',
      'eu-e.cm-ss13.com:1400'
    );
    this.startTest(
      'Oregon, Hillsboro',
      'us-w.cm-ss13.com:8998',
      'us-w.cm-ss13.com:1400'
    );
    this.startTest(
      'Virginia, Vint Hill',
      'us-e.cm-ss13.com:8998',
      'us-e.cm-ss13.com:1400'
    );
    this.startTest(
      'Singapore',
      'asia-se.cm-ss13.com:8998',
      'asia-se.cm-ss13.com:1400'
    );
    this.startTest(
      'Australia, Sydney',
      'aus.cm-ss13.com:8998',
      'aus.cm-ss13.com:1400'
    );
  }

  render() {
    const { act } = useBackend();

    return (
      <Stack direction="column" fill vertical>
        {this.results.map((result, i) => (
          <Stack.Item key={i} height={2}>
            <Button.Confirm
              fluid
              height={2}
              confirmContent={'Connect? '}
              confirmColor="caution"
              disabled={result.ping === -1 || result.error}
              onClick={() => act('connect', { url: result.url })}>
              {result.ping <= -1 && result.error === null && (
                <>
                  <Icon name="spinner" spin inline />
                  <Box inline>{result.desc}</Box>
                </>
              )}
              {result.ping > -1 && result.error === null && (
                <>
                  <Icon name="plug" inline />
                  <Box inline>{result.desc}</Box>
                  <Box inline preserveWhitespace color={result.color} bold>
                    {' (' + result.ping + ')'}
                  </Box>
                </>
              )}
              {result.error !== null && (
                <>
                  <Icon name="x" inline color={COLORS[0]} />
                  <Box inline>{result.desc}</Box>
                  <Box inline preserveWhitespace color={COLORS[0]} bold>
                    {' (' + result.error + ')'}
                  </Box>
                </>
              )}
            </Button.Confirm>
          </Stack.Item>
        ))}
      </Stack>
    );
  }
}

export const PingRelaysPanel = () => {
  return (
    <Window width={400} height={300} theme={'weyland'}>
      <Window.Content>
        <PingApp />
      </Window.Content>
    </Window>
  );
};
