import { randomNumber } from 'common/random';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  ColorBox,
  Divider,
  Flex,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

const HexScrew = () => {
  return (
    <svg viewBox="0 0 10 10" width="30px" height="30px">
      <circle
        cx="5"
        cy="5"
        r="4"
        fill="#202020"
        stroke="#505050"
        strokeWidth="0.5"
      />
      <polygon
        points="3.5,2.5 6.5,2.5 8,5 6.5,7.5 3.5,7.5 2,5"
        fill="#040404"
      />
    </svg>
  );
};

export const FlightComputer = (props) => {
  const { act, data } = useBackend();

  const vtol_detected = data.vtol_detected;
  const fuel = data.fuel;
  const max_fuel = data.max_fuel;
  const battery = data.battery;
  const max_battery = data.max_battery;
  const fueling = data.fueling;

  const message = vtol_detected
    ? 'Aircraft detected - AD-19D chimera'
    : 'No aircraft detected.';

  const fuel_button = () => {
    if (!vtol_detected) {
      return null;
    }

    if (fueling) {
      return (
        <Button onClick={() => act('stop_fueling')}>
          Stop Fueling & Charging
        </Button>
      );
    } else {
      return (
        <Button onClick={() => act('start_fueling')}>
          Start Fueling & Charing
        </Button>
      );
    }
  };

  return (
    <Window width={700} height={410} theme="crtgreen">
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <Box m={-10} height={40}>
              <svg>
                <rect
                  fill="rgb(0, 0, 0)"
                  x="10"
                  y="10"
                  width="100%"
                  height="100%"
                />
              </svg>
            </Box>
            <Box mt={-71.5} width={60.2} ml={-1.5} height={32}>
              <svg>
                <rect
                  stroke="rgb(7, 7, 7)"
                  strokeWidth={4}
                  fill="rgb(17, 17, 17)"
                  x="10"
                  y="10"
                  rx="10"
                  ry="10"
                  width="95%"
                  height="95%"
                />
              </svg>
            </Box>
            <Box mt={-58.5} width={50.5} ml={5} height={32}>
              <svg>
                <defs>
                  <radialGradient
                    id="gradient-fill"
                    x1="0"
                    y1="0"
                    x2="800"
                    y2="0"
                    gradientUnits="userSpaceOnUse"
                  >
                    <stop offset="0" stop-color="#042208" />

                    <stop offset="1" stop-color="#000b02" />
                  </radialGradient>
                </defs>

                <rect
                  stroke="#00e94e"
                  strokeWidth={2}
                  fill="url(#gradient-fill)"
                  x="10"
                  y="10"
                  rx="5"
                  ry="5"
                  width="100%"
                  height="75%"
                />
              </svg>
            </Box>
          </Stack.Item>

          <Stack.Item align="center" mt={-67.5} width={50} mr={0.2}>
            <Box height={22.4} fitted p={0.7} m={2} mt={7.5}>
              <FuelPanel />
            </Box>
          </Stack.Item>
          <Stack.Item mt={-46} width={107.5} ml={1}>
            <Flex width="100%">
              <Flex.Item grow>
                <HexScrew />
              </Flex.Item>
              <Flex.Item grow>
                <HexScrew />
              </Flex.Item>
            </Flex>
            <Flex width="100%" mt={-59}>
              <Flex.Item grow>
                <HexScrew />
              </Flex.Item>
              <Flex.Item grow>
                <HexScrew />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Debug = (props) => {
  const { act, data } = useBackend();

  const vtol_detected = data.vtol_detected;
  const fuel = data.fuel;
  const max_fuel = data.max_fuel;
  const battery = data.battery;
  const max_battery = data.max_battery;
  const fueling = data.fueling;

  const message = vtol_detected
    ? 'Aircraft detected - AD-19D chimera'
    : 'No aircraft detected.';

  const fuel_button = () => {
    if (!vtol_detected) {
      return null;
    }

    if (fueling) {
      return (
        <Button onClick={() => act('stop_fueling')}>
          Stop Fueling & Charging
        </Button>
      );
    } else {
      return (
        <Button onClick={() => act('start_fueling')}>
          Start Fueling & Charing
        </Button>
      );
    }
  };

  return (
    <Window width={450} height={445}>
      <Window.Content scrollable>
        {message + '\n'}

        {vtol_detected ? (
          <ProgressBar
            value={fuel / max_fuel}
            ranges={{
              good: [0.7, Infinity],
              average: [0.2, 0.7],
              bad: [-Infinity, 0.2],
            }}
          />
        ) : null}
        {'\n'}

        {vtol_detected ? (
          <ProgressBar
            value={battery / max_battery}
            ranges={{
              good: [0.7, Infinity],
              average: [0.2, 0.7],
              bad: [-Infinity, 0.2],
            }}
          />
        ) : null}
        {'\n'}

        {fuel_button()}
      </Window.Content>
    </Window>
  );
};

const FuelPanel = (props) => {
  const { act, data } = useBackend();

  let { vtol_detected, fuel, max_fuel, battery, max_battery, fueling } = data;

  return (
    <Box p={1} width={25.7}>
      <Stack horizontal>
        <Stack.Item>
          <Flex ml={2.5} mb={1} bold fontSize={0.9}>
            <Flex.Item grow>LEFT</Flex.Item>
            <Flex.Item grow>RIGHT</Flex.Item>
          </Flex>

          <Stack horizontal mb={1} height={10.3}>
            <Stack.Item grow fontSize={0.75}>
              <Box
                inline
                mb={2.5}
                width="26px"
                fontSize={1}
                bold
                textColor="white"
                textAlign="right"
              >
                F -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                3/4 -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                2/4 -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                1/4 -
              </Box>
              <Box
                inline
                width="26px"
                fontSize={1}
                bold
                textColor="white"
                textAlign="right"
              >
                E -
              </Box>
            </Stack.Item>
            <Stack.Item ml={5}>
              <Stack.Item height={10}>
                <ColorBox color="green" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(fuel / max_fuel) * -20}>
                <ColorBox height={(fuel / max_fuel) * 10} color="green" />
              </Stack.Item>
            </Stack.Item>
            <Stack.Divider ml={2} mr={1} height={10} />
            <Stack.Item grow fontSize={0.75}>
              <Box
                inline
                mb={2.5}
                width="26px"
                fontSize={1}
                bold
                textColor="white"
                textAlign="right"
              >
                F -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                3/4 -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                2/4 -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                1/4 -
              </Box>
              <Box
                inline
                width="26px"
                fontSize={1}
                bold
                textColor="white"
                textAlign="right"
              >
                E -
              </Box>
            </Stack.Item>
            <Stack.Item ml={5} mr={1}>
              <Stack.Item height={10}>
                <ColorBox color="green" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(fuel / max_fuel) * -20}>
                <ColorBox height={(fuel / max_fuel) * 10} color="green" />
              </Stack.Item>
            </Stack.Item>
          </Stack>
          <Box bold fontSize={0.8} textAlign="center">
            TANK VOLUME:{' '}
            <AnimatedNumber
              initial={0}
              value={Math.round((fuel / max_fuel) * 100)}
            />
            %
          </Box>
          <Divider />
          <Box textAlign="center" bold mt={1.5} fontFamily="monospace">
            FUEL TANK LEVELS
          </Box>
          <Box textAlign="center" bold fontSize={0.7}>
            [ 16,000L CAPACITY ]
          </Box>
        </Stack.Item>
        <Stack.Divider ml={3} mr={2} />
        <Stack.Item verticalAlign="center">
          <Flex ml={2.5} mb={1} bold fontSize={0.9}>
            <Flex.Item grow>CELL</Flex.Item>
            <Flex.Item grow>INPUT</Flex.Item>
          </Flex>

          <Stack horizontal mb={1} height={10.3}>
            <Stack.Item grow fontSize={0.75}>
              <Box
                inline
                ml={-1}
                mb={2.5}
                width="30px"
                bold
                textColor="white"
                textAlign="right"
              >
                2.8 -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                2.1 -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                1.4 -
              </Box>
              <Box inline mb={2.5} width="30px" bold textColor="white">
                0.7 -
              </Box>
              <Box
                inline
                width="30px"
                bold
                ml={-1}
                textColor="white"
                textAlign="right"
              >
                0 -
              </Box>
            </Stack.Item>
            <Stack.Item ml={5}>
              <Stack.Item height={10}>
                <ColorBox color="green" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(battery / max_battery) * -20}>
                <ColorBox height={(battery / max_battery) * 10} color="green" />
              </Stack.Item>
            </Stack.Item>
            <Stack.Divider ml={2.5} mr={2.5} height={10} />
            <Stack.Item grow fontSize={0.75}>
              <Box inline ml={-2} mb={2.5} width="40px" bold textColor="white">
                1.2kW -
              </Box>
              <Box inline mb={2.5} ml={-2} width="40px" bold textColor="white">
                0.9kW -
              </Box>
              <Box inline mb={2.5} ml={-2} width="40px" bold textColor="white">
                0.6kW -
              </Box>
              <Box inline mb={2.5} ml={-2} width="40px" bold textColor="white">
                0.9kW -
              </Box>
              <Box
                inline
                mb={2.5}
                ml={-0.4}
                width="40px"
                bold
                textColor="white"
              >
                0kW -
              </Box>
            </Stack.Item>
            <Stack.Item ml={5} mr={1}>
              <Stack.Item height={10}>
                <ColorBox color="green" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox
                  color="darkgreen"
                  height={fueling ? randomNumber(2, 3) : 9.3}
                  width={0.5}
                />
              </Stack.Item>
            </Stack.Item>
          </Stack>
          <Box bold fontSize={0.8} textAlign="center">
            APROX CHARGE:{' '}
            <AnimatedNumber
              initial={0}
              value={Math.round((battery / max_battery) * 100)}
            />
            %
          </Box>
          <Divider />
          <Box textAlign="center" bold mt={1.5} fontFamily="monospace">
            POWERCELL CHARGE
          </Box>
          <Box textAlign="center" bold fontSize={0.7}>
            [ 2x Li BATTERY, KWh ]
          </Box>
        </Stack.Item>
      </Stack>
      <Button
        align="center"
        icon={!vtol_detected || fueling ? 'ban' : 'tint'}
        fluid
        onClick={() => act((!fueling ? 'start' : 'stop') + '_fueling')}
        fontSize={1.2}
        mt={1.3}
        mr={3}
        mb={0}
      >
        {(!fueling ? 'BEGIN' : 'STOP') + ' FUELING AND CHARGING'}
      </Button>
    </Box>
  );
};

const EngineTemp = (props) => {
  const { act, data } = useBackend();

  return (
    <Section fill>
      <svg>
        <rect
          fill="rgb(24, 24, 24)"
          x="10"
          y="10"
          rx="10"
          ry="10"
          width="95%"
          height="95%"
        />
      </svg>
    </Section>
  );
};

const EngineTempBar = (props) => {
  const { act, data } = useBackend();

  return (
    <Stack vertical height={10}>
      <Stack.Item ml={5} mr={1}>
        <Stack.Item height={10}>
          <ColorBox color="green" height={10} />
        </Stack.Item>
        <Stack.Item mt={-19.5} ml={0.5}>
          <ColorBox color="darkgreen" height={randomNumber(2, 3)} width={0.5} />
        </Stack.Item>
      </Stack.Item>
    </Stack>
  );
};
