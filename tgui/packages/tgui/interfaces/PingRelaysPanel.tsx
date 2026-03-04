import { round } from 'common/math';
import type { BooleanLike } from 'common/react';
import { Component } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, Icon, RoundGauge, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

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
  sockets: WebSocket[];
  results: PingResult[];
  state: State;

  constructor(props: PingAppProps) {
    super(props);

    this.sockets = [];
    this.results = [];
    this.state = {
      currentIndex: 0,
      lastClickedIndex: 0,
      lastClickedState: false,
    };
  }

  startTest(index: number, desc: string, pingURL: string, connectURL: string) {
    const pingsSent: Record<string, number> = {};
    const pingTimes: number[] = [];

    const socket = new WebSocket(`wss://${pingURL}`);
    this.sockets[index] = socket;

    const sendPing = (iter: number) => {
      if (socket.readyState !== WebSocket.OPEN) {
        return;
      }
      pingsSent[String(iter)] = Date.now();
      socket.send(String(iter));
    };

    socket.addEventListener('open', () => {
      sendPing(1);
    });

    socket.addEventListener('message', (event) => {
      const rtt = Date.now() - pingsSent[event.data];
      pingTimes.push(rtt);

      const avgPing = round(
        pingTimes.reduce((a, b) => a + b, 0) / pingTimes.length,
        0,
      );

      this.results[index]?.update(desc, `byond://${connectURL}`, avgPing, null);

      this.setState((prevState: State) => ({
        currentIndex: prevState.currentIndex + 1,
      }));

      const nextIter = Number(event.data) + 1;
      if (nextIter <= 10) {
        sendPing(nextIter);
      } else {
        socket.close();
      }
    });

    socket.addEventListener('error', () => {
      this.results[index]?.update(desc, `byond://${connectURL}`, -1, 'Error');

      this.setState((prevState: State) => ({
        currentIndex: prevState.currentIndex + 1,
      }));
    });

    socket.addEventListener('close', () => {
      if (this.results[index]?.ping === -1 && !this.results[index]?.error) {
        this.results[index]?.update(
          desc,
          `byond://${connectURL}`,
          -1,
          'Closed',
        );

        this.setState((prevState: State) => ({
          currentIndex: prevState.currentIndex + 1,
        }));
      }
    });
  }

  handleConfirmChange(index: number, newState: boolean) {
    if (newState || this.state.lastClickedIndex === index) {
      this.setState({ lastClickedIndex: index });
      this.setState({ lastClickedState: newState });
    }
  }

  componentDidMount() {
    this.setState({ currentIndex: 0 });
    for (let i = 0; i < this.props.relayNames.length; i++) {
      this.results.push(new PingResult());
      this.startTest(
        i,
        this.props.relayNames[i],
        this.props.relayPings[i],
        this.props.relayCons[i],
      );
    }
  }

  componentWillUnmount() {
    for (const socket of this.sockets) {
      if (
        socket &&
        (socket.readyState === WebSocket.OPEN ||
          socket.readyState === WebSocket.CONNECTING)
      ) {
        socket.close();
      }
    }
  }

  render() {
    const { act } = useBackend();

    const sortedResults = this.results
      .map((result, index) => ({ result, index }))
      .sort((a, b) => {
        const aValid = a.result.ping > -1 && a.result.error === null;
        const bValid = b.result.ping > -1 && b.result.error === null;
        if (aValid && bValid) {
          return a.result.ping - b.result.ping;
        }
        if (aValid) return -1;
        if (bValid) return 1;
        return 0;
      });

    return (
      <Stack direction="column" fill vertical>
        {sortedResults.map(({ result, index }) => (
          <Stack.Item key={index} height={2}>
            <Button.Confirm
              fluid
              height={2}
              confirmContent=""
              confirmColor="caution"
              disabled={result.ping === -1 || result.error !== null}
              onConfirmChange={(clickedOnce) =>
                this.handleConfirmChange(index, clickedOnce)
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
                      {this.state.lastClickedIndex === index &&
                      this.state.lastClickedState
                        ? `Connect via ${result.desc}?`
                        : result.desc}
                    </Box>
                  </Flex.Item>
                  <Flex.Item width={8}>
                    <RoundGauge
                      value={result.ping}
                      maxValue={1000}
                      minValue={50}
                      minWidth={3.8}
                      pr={1}
                      ranges={{
                        good: [0, 200],
                        average: [200, 500],
                        bad: [500, 1000],
                      }}
                      format={(x) => `${Math.round(x)}ms`}
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
                      {` (${result.error})`}
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
