import { round } from 'common/math';
import { Ping } from 'common/ping';
import { BooleanLike } from 'common/react';
import { Component } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, RoundGauge, Stack } from '../components';
import { Window } from '../layouts';

const RED = '#dc2828';

export class PingResult {
  desc: string = 'Loading...';
  url: string = '';
  ping: number = -1;
  error: string | null = null;

  update(desc: string, url: string, ping: number, error: string | null) {
    this.desc = desc;
    this.url = url;
    this.ping = ping;
    this.error = error;
  }
}

type PingAppProps = {
  readonly relayNames: Array<string>;
  readonly relayPings: Array<string>;
  readonly relayCons: Array<string>;
};

type State = {
  currentIndex: number;
  lastClickedIndex: number;
  lastClickedState: BooleanLike;
};

class PingApp extends Component<PingAppProps> {
  pinger: Ping;
  results: PingResult[];
  state: State;
  realCurrentIndex: number;

  constructor(props: PingAppProps) {
    super(props);

    this.pinger = new Ping();
    this.results = new Array();
    this.state = {
      currentIndex: 0,
      lastClickedIndex: 0,
      lastClickedState: false,
    };
    this.realCurrentIndex = 0;
  }

  startTest(desc: string, pingURL: string, connectURL: string) {
    this.pinger.ping(
      'http://' + pingURL,
      (error: string | null, pong: number) => {
        // reading state is too unreliable now somereason so we have to use realCurrentIndex
        this.results[this.realCurrentIndex++]?.update(
          desc,
          'byond://' + connectURL,
          round(pong * 0.75, 0), // The ping is inflated so lets compensate a bit
          error,
        );
        // We still have to set a state to cause a redraw
        this.setState((prevState: State) => ({
          currentIndex: prevState.currentIndex + 1,
        }));
      },
    );
  }

  handleConfirmChange(index: number, newState: boolean) {
    if (newState || this.state.lastClickedIndex === index) {
      this.setState({ lastClickedIndex: index });
      this.setState({ lastClickedState: newState });
    }
  }

  componentDidMount() {
    // We have to set a state to cause a redraw (buttons are now populated)
    this.realCurrentIndex = 0;
    this.setState({ currentIndex: 0 });
    for (let i = 0; i < this.props.relayNames.length; i++) {
      this.results.push(new PingResult());
      this.startTest(
        this.props.relayNames[i],
        this.props.relayPings[i],
        this.props.relayCons[i],
      );
    }
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
              disabled={result.ping === -1 || result.error !== null}
              onConfirmChange={(clickedOnce) =>
                this.handleConfirmChange(i, clickedOnce)
              }
              onClick={() =>
                act('connect', { url: result.url, desc: result.desc })
              }
            >
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
                        good: [0, 200],
                        average: [200, 500],
                        bad: [500, 1000],
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

type PingRelaysPanelData = {
  relay_names: Array<string>;
  relay_pings: Array<string>;
  relay_cons: Array<string>;
};

export const PingRelaysPanel = () => {
  const { data } = useBackend<PingRelaysPanelData>();
  const { relay_names, relay_pings, relay_cons } = data;

  return (
    <Window width={400} height={300} theme={'weyland'}>
      <Window.Content>
        <PingApp
          relayNames={relay_names}
          relayPings={relay_pings}
          relayCons={relay_cons}
        />
      </Window.Content>
    </Window>
  );
};
