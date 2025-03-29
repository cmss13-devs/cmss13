import { toFixed } from 'common/math';
import { randomNumber } from 'common/random';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  ColorBox,
  Divider,
  Flex,
  RoundGauge,
  Stack,
  Table,
} from '../components';
import { formatSiUnit } from '../format';
import { Window } from '../layouts';

type FlightComputerData = {
  vtol_detected: string;
  fuel: number;
  max_fuel: number;
  battery: number;
  max_battery: number;
  fueling: number;
};

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
  const { act, data } = useBackend<FlightComputerData>();

  return (
    <Window width={700} height={410} theme="crtgreen">
      <Window.Content>
        <Stack vertical width="100%">
          <Stack.Item height="100%">
            <Box m={-10} height={40}>
              <svg width="100%" height="100%">
                <rect
                  fill="rgb(0, 0, 0)"
                  x="10"
                  y="10"
                  width="100%"
                  height="100%"
                />
              </svg>
            </Box>
            <Box mt={-71.5} width="100%" height={32}>
              <Box width="100%" height="100%" ml={-0.5}>
                <svg width="100%" height="100%">
                  <rect
                    stroke="rgb(7, 7, 7)"
                    strokeWidth={4}
                    fill="rgb(17, 17, 17)"
                    x="10"
                    y="10"
                    rx="10"
                    ry="10"
                    width="98%"
                    height="95%"
                  />
                </svg>
              </Box>

              <Table mt={-64} height="100%">
                <Table.Row>
                  <Table.Cell align="start" verticalAlign="top" p="12px">
                    <HexScrew />
                  </Table.Cell>
                  <Table.Cell align="end" verticalAlign="top" p="12px">
                    <HexScrew />
                  </Table.Cell>
                </Table.Row>
                <Table.Row>
                  <Table.Cell align="start" verticalAlign="bottom" p="12px">
                    <HexScrew />
                  </Table.Cell>
                  <Table.Cell align="end" verticalAlign="bottom" p="12px">
                    <HexScrew />
                  </Table.Cell>
                </Table.Row>
              </Table>
            </Box>

            <Box mt={-58.5} height={32} width="90%" ml="4%">
              <Box width="100%" height="100%">
                <svg width="100%" height="100%">
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
                    width="97%"
                    height="75%"
                  />
                </svg>
              </Box>
            </Box>
          </Stack.Item>

          <Stack.Item align="center" mt={-67.5} width={50} mr={0.2}>
            <Box height={22.4} p={0.7} m={2} mt={7.5}>
              <CrtDisplay />
            </Box>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const FuelPanel = (props) => {
  const { act, data } = useBackend<FlightComputerData>();

  const { vtol_detected, fuel, max_fuel, battery, max_battery, fueling } = data;

  return (
    <Box pt={2} width="100%">
      <Stack>
        <Stack.Item>
          <Flex ml={2.5} mb={1} bold fontSize={0.9}>
            <Flex.Item grow>LEFT</Flex.Item>
            <Flex.Item grow>RIGHT</Flex.Item>
          </Flex>

          <Stack mb={1} height={10.3}>
            <Stack.Item grow fontSize={0.75} mr={0}>
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
            <Stack.Item ml={0}>
              <Stack.Item height={10}>
                <ColorBox color="green" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(fuel / max_fuel) * -20} minHeight="0px">
                <ColorBox
                  height={vtol_detected ? (fuel / max_fuel) * 10 : 0}
                  color="green"
                />
              </Stack.Item>
            </Stack.Item>
            <Stack.Divider ml={2} mr={1} height={10} opacity={0.99} />
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
            <Stack.Item ml={0} mr={1}>
              <Stack.Item height={10}>
                <ColorBox color="green" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(fuel / max_fuel) * -20} minHeight="0px">
                <ColorBox
                  height={vtol_detected ? (fuel / max_fuel) * 10 : 0}
                  color="green"
                />
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

          <Box textAlign="center" bold mt={2} fontFamily="monospace">
            FUEL TANK LEVELS
          </Box>
          <Box textAlign="center" bold fontSize={0.7}>
            {vtol_detected ? '[ 16,000L CAPACITY ]' : 'NONE DETECTED'}
          </Box>
        </Stack.Item>
        <Stack.Divider ml={3} mr={2} />
        <Stack.Item verticalAlign="center">
          <Flex ml={2.5} mb={1} bold fontSize={0.9}>
            <Flex.Item grow>CELL</Flex.Item>
            <Flex.Item grow>INPUT</Flex.Item>
          </Flex>

          <Stack mb={1} height={10.3}>
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
            <Stack.Item ml={0}>
              <Stack.Item height={10}>
                <ColorBox color="green" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(battery / max_battery) * -20}>
                <ColorBox
                  height={vtol_detected ? (battery / max_battery) * 10 : 0}
                  color="green"
                />
              </Stack.Item>
            </Stack.Item>
            <Stack.Divider ml={2.5} mr={2.5} height={10} opacity={0.99} />
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
            <Stack.Item ml={0} mr={2}>
              <Stack.Item height={10}>
                <ColorBox color="green" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox
                  color="darkgreen"
                  height={
                    fueling && battery !== max_battery
                      ? randomNumber(2, 3)
                      : 9.3
                  }
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

          <Box textAlign="center" bold mt={2} fontFamily="monospace">
            POWERCELL CHARGE
          </Box>
          <Box textAlign="center" bold fontSize={0.7}>
            {vtol_detected ? '[ 2x Li BATTERY, KWh ]' : 'NONE DETECTED'}
          </Box>
        </Stack.Item>
      </Stack>
      <Button
        align="center"
        icon={!vtol_detected || fueling ? 'ban' : 'tint'}
        fluid
        bold
        color={!vtol_detected && 'transperant'}
        onClick={() =>
          act(vtol_detected ? (fueling ? 'stop' : 'start') + '_fueling' : '')
        }
        fontSize={1.2}
        mt={2.5}
        mr={2}
        mb={0}
        tooltip={
          !vtol_detected && 'No linked aircraft detected on landing pad!'
        }
      >
        {(!fueling ? 'BEGIN' : 'STOP') + ' FUELING AND CHARGING'}
      </Button>
    </Box>
  );
};

const CrtDisplay = (props) => {
  const { act, data } = useBackend<FlightComputerData>();

  return (
    <Stack>
      <Stack.Item width="55%">
        <FuelPanel />
      </Stack.Item>
      <Stack.Divider opacity={0.99} mr={1} />
      <Stack.Item grow>
        <Console />
        <TankReadouts />
      </Stack.Item>
    </Stack>
  );
};

const TankReadouts = (props) => {
  const { act, data } = useBackend<FlightComputerData>();

  let { vtol_detected, fuel } = data;

  const formatPressure = (value) => {
    if (value < 10000) {
      return toFixed(value) + ' kPa';
    }
    return formatSiUnit(value * 1000, 1, 'Pa');
  };

  const formatLitres = (value) => {
    return toFixed(value / 1000) + ' kL';
  };

  return (
    <Box opacity={0.99}>
      <Box
        mb={0.5}
        bold
        fontSize={1.4}
        textAlign="center"
        fontFamily="monospace"
        backgroundColor="rgb(0, 233, 78)"
        color="rgb(17, 17, 17)"
      >
        FUEL STORAGE TANK
      </Box>

      <Flex mb={2}>
        <Flex.Item grow textAlign="center" fontFamily="monospace">
          <Box m={1} bold ml={-0.2}>
            INT. PRESSURE
          </Box>
          <RoundGauge
            value={randomNumber(945, 950)}
            minValue={800}
            maxValue={1000}
            size={2}
            format={formatPressure}
            ranges={{
              average: [800, 925],
              green: [925, 975],
              red: [975, 995],
            }}
          />
        </Flex.Item>
        <Flex.Item grow textAlign="center" fontFamily="monospace">
          <Box m={1} bold>
            STORED FUEL
          </Box>
          <RoundGauge
            value={vtol_detected ? 35000 - fuel * 27 : 36000}
            minValue={0}
            maxValue={40000}
            size={2}
            format={formatLitres}
            ranges={{
              green: [10000, 37000],
              red: [0, 10000],
            }}
          />
        </Flex.Item>
      </Flex>
      <Divider />
    </Box>
  );
};

const Console = (props) => {
  const { act, data } = useBackend<FlightComputerData>();
  let { vtol_detected, fueling } = data;
  return (
    <Box height={10.75} opacity={0.99}>
      <Divider />
      <Box bold fontFamily="monospace" fontSize={1.1}>
        {vtol_detected ? 'Linked aircraft detected:' : 'No aircraft detected!'}
      </Box>
      <Box bold>{vtol_detected && '[ AD-71E BLACKFOOT ]'}</Box>
      <Box bold fontFamily="monospace" fontSize={1.1} mt={1.3}>
        Refuel and recharge status:
      </Box>
      <Box bold color={fueling ? 'default' : 'red'} fontSize={1.1}>
        {fueling ? '[ ENGAGED ]' : '[ DISENGAGED ]'}
      </Box>
      <Box bold fontFamily="monospace" fontSize={1.1} mt={1.3}>
        Primary resupply systems:
      </Box>
      <Box bold fontSize={0.95} mb={1.3}>
        [ SYSTEMS NOMINAL ]
      </Box>
      <Divider />
    </Box>
  );
};
