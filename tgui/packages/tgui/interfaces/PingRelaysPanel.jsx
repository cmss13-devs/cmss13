import { useBackend } from '../backend';
import { round } from 'common/math';
import { Box, Stack, Button, Icon, RoundGauge, Flex } from '../components';
import { Window } from '../layouts';
import { Color } from 'common/color';
import { Ping } from 'common/ping';
import { Component } from 'react';

const RELAY_COUNT = 8;
const RED = new Color(220, 40, 40);

export class PingResult {
  constructor(desc = 'Loading...', url = '', ping = -1) {
    this.desc = desc;
    this.url = url;
    this.ping = ping;
    this.error = null;
  }

  update = function (desc, url, ping, error) {
    this.desc = desc;
    this.url = url;
    this.ping = ping;
    this.error = error;
  };
}

class PingApp extends Component {
  constructor() {
    super();

    this.pinger = new Ping();
    this.state = {
      currentIndex: 0,
      lastClickedIndex: 0,
      lastClickedState: false,
    };

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
        round(pong * 0.75), // The ping is inflated so lets compensate a bit
        error
      );
      this.setState((prevState) => ({
        currentIndex: prevState.currentIndex + 1,
      }));
    });
  }

  handleConfirmChange(index, newState) {
    if (newState || this.state.lastClickedIndex === index) {
      this.setState({ lastClickedIndex: index });
      this.setState({ lastClickedState: newState });
    }
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

  componentWillUnmount() {
    this.pinger.cancel();
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
              confirmContent=""
              confirmColor="caution"
              disabled={result.ping === -1 || result.error}
              onConfirmChange={(clickedOnce) =>
                this.handleConfirmChange(i, clickedOnce)
              }
              onClick={() => act('connect', { url: result.url })}>
              {result.ping <= -1 && result.error === null && (
                <Flex justify="space-between">
                  <Flex.Item>
                    <Icon name="spinner" spin inline />
                  </Flex.Item>
                  <Flex.Item>
                    <Box inline>{result.desc}</Box>
                  </Flex.Item>
                  <Flex.Item width={8} />
                </Flex>
              )}
              {result.ping > -1 && result.error === null && (
                <Flex justify="space-between">
                  <Flex.Item>
                    <Icon name="plug" inline />
                  </Flex.Item>
                  <Flex.Item>
                    <Box inline>
                      {this.state.lastClickedIndex === i &&
                      this.state.lastClickedState
                        ? 'Connect via ' + result.desc + '?'
                        : result.desc}
                    </Box>
                  </Flex.Item>
                  <Flex.Item width={8}>
                    <RoundGauge
                      value={result.ping}
                      maxValue={1000}
                      minValue={50}
                      minWidth={4}
                      ranges={{
                        'good': [0, 200],
                        'average': [200, 500],
                        'bad': [500, 1000],
                      }}
                      format={(x) => x + 'ms'}
                      inline
                    />
                  </Flex.Item>
                </Flex>
              )}
              {result.error !== null && (
                <Flex justify="space-between">
                  <Flex.Item>
                    <Icon name="x" inline color={RED} />
                  </Flex.Item>
                  <Flex.Item>
                    <Box inline>{result.desc}</Box>
                  </Flex.Item>
                  <Flex.Item width={8}>
                    <Box inline preserveWhitespace color={RED} bold>
                      {' (' + result.error + ')'}
                    </Box>
                  </Flex.Item>
                </Flex>
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
