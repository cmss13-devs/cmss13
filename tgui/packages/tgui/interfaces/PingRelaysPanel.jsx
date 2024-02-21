import { Box, Stack } from '../components';
import { Window } from '../layouts';
import { Color } from 'common/color';
import { Ping } from 'common/ping';
import { Component } from 'react';
import { createLogger } from '../logging'; // TODO: Remove this

const logger = createLogger('pingRelays'); // TODO: Remove this

const RELAY_COUNT = 8;

const COLORS = [
  new Color(220, 40, 40), // red
  new Color(220, 200, 40), // yellow
  new Color(60, 220, 40), // green
];

const getPingColor = function (ping) {
  if (ping < 100) {
    return COLORS[2];
  }
  if (ping < 400) {
    return COLORS[1];
  }
  return COLORS[0];
};

export class PingResult {
  constructor(desc = 'Loading...', url = '', ping = 0, color = COLORS[0]) {
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
    logger.log('starting test for ' + desc); // TODO: Remove this
    this.pinger.ping('http://' + pingURL, (error, pong) => {
      this.results[this.state.currentIndex]?.update(
        desc,
        'byond://' + connectURL,
        pong,
        error
      );
      logger.log(
        'finished ' + this.state.currentIndex + ' ' + pong + ' ' + error
      ); // TODO: Remove this
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
      'aus.cm-ss13.com:8996', // wrong
      'aus.cm-ss13.com:1400'
    );
  }

  render() {
    return (
      <Stack direction="column" fill>
        {this.results.map((result, i) => (
          <Stack.Item key={i} basis="content" grow={0} pb={1}>
            {result.desc}: <a href={result.url}>{result.url}</a>{' '}
            <Box color={result.color}>({result.ping})</Box> {result.error}
          </Stack.Item>
        ))}
      </Stack>
    );
  }
}

export const PingRelaysPanel = () => {
  return (
    <Window width={300} height={400} theme={'ntos'}>
      <Window.Content>
        <PingApp />
      </Window.Content>
    </Window>
  );
};
