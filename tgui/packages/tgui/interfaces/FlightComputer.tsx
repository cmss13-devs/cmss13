import { toFixed } from 'common/math';
import { randomNumber } from 'common/random';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  ColorBox,
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
    <Window width={700} height={410}>
      <Window.Content className="FlightComputer__Background">
        <Box className="FlightComputer__Casing">
          <Table height="100%">
            <Table.Row>
              <Table.Cell align="start" verticalAlign="top">
                <HexScrew />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell align="end" verticalAlign="top">
                <HexScrew />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell />
              <Table.Cell className="FlightComputer__Gradient">
                <Box
                  width="100%"
                  height="100%"
                  className="FlightComputer__Static"
                >
                  <Box className="FlightComputer__Screen">
                    <CrtDisplay />
                  </Box>
                </Box>
              </Table.Cell>
              <Table.Cell />
            </Table.Row>
            <Table.Row>
              <Table.Cell align="start" verticalAlign="bottom">
                <HexScrew />
              </Table.Cell>
              <Table.Cell />
              <Table.Cell align="end" verticalAlign="bottom">
                <HexScrew />
              </Table.Cell>
            </Table.Row>
          </Table>
        </Box>
      </Window.Content>
    </Window>
  );
};

const CrtDisplay = (props) => {
  const { act, data } = useBackend<FlightComputerData>();

  return (
    <Stack m="6px" pl="1%">
      <Stack.Item width="54%" className="FlightComputer__MainDivider">
        <FuelPanel />
      </Stack.Item>
      <Stack.Item grow>
        <Console />
        <TankReadouts />
      </Stack.Item>
    </Stack>
  );
};

const FuelPanel = (props) => {
  const { act, data } = useBackend<FlightComputerData>();

  const { vtol_detected, fuel, max_fuel, battery, max_battery, fueling } = data;

  return (
    <Box pt={2} width="100%">
      <Stack className="FlightComputer__Fuel">
        <Stack.Item className="FlightComputer__Divider">
          <Flex ml={2.5} mb={1} bold fontSize={0.9}>
            <Flex.Item grow>LEFT</Flex.Item>
            <Flex.Item grow>RIGHT</Flex.Item>
          </Flex>

          <Stack mb={1} height={10.3} pr={1}>
            <Stack.Item grow fontSize={0.9} mr={0}>
              <Box
                inline
                mb={2.5}
                width="26px"
                fontSize={1}
                bold
                textAlign="right"
              >
                F -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                3/4 -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                2/4 -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                1/4 -
              </Box>
              <Box inline width="26px" fontSize={1} bold textAlign="right">
                E -
              </Box>
            </Stack.Item>
            <Stack.Item ml={0}>
              <Stack.Item height={10}>
                <ColorBox color="#00e94ef5" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(fuel / max_fuel) * -20} minHeight="0px">
                <ColorBox
                  height={vtol_detected ? (fuel / max_fuel) * 10 : 0}
                  color="#00e94ef5"
                />
              </Stack.Item>
            </Stack.Item>
            <Stack.Item className="FlightComputer__Subdivider" />
            <Stack.Item grow fontSize={0.9}>
              <Box
                inline
                mb={2.5}
                width="26px"
                fontSize={1}
                bold
                textAlign="right"
              >
                F -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                3/4 -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                2/4 -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                1/4 -
              </Box>
              <Box inline width="26px" fontSize={1} bold textAlign="right">
                E -
              </Box>
            </Stack.Item>
            <Stack.Item ml={0} mr={1}>
              <Stack.Item height={10}>
                <ColorBox color="#00e94ef5" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(fuel / max_fuel) * -20} minHeight="0px">
                <ColorBox
                  height={vtol_detected ? (fuel / max_fuel) * 10 : 0}
                  color="#00e94ef5"
                />
              </Stack.Item>
            </Stack.Item>
          </Stack>
          <Box
            bold={fuel / max_fuel === 1 ? false : true}
            fontSize={0.8}
            textAlign="center"
            className={
              fuel / max_fuel === 1 ? 'FlightComputer__TextConfirm' : ''
            }
          >
            TANK VOLUME:{' '}
            <AnimatedNumber
              initial={0}
              value={Math.round((fuel / max_fuel) * 100)}
            />
            %
          </Box>

          <Box textAlign="center" bold mt={1.8} fontFamily="monospace">
            FUEL TANK LEVELS
          </Box>
          <Box textAlign="center" bold fontSize={0.7}>
            {vtol_detected ? '[ 16,000L CAPACITY ]' : 'NONE DETECTED'}
          </Box>
        </Stack.Item>

        <Stack.Item verticalAlign="center">
          <Flex ml={2.5} mb={1} bold fontSize={0.9}>
            <Flex.Item grow>CELL</Flex.Item>
            <Flex.Item grow>INPUT</Flex.Item>
          </Flex>

          <Stack mb={1} height={10.3} pr={1}>
            <Stack.Item fontSize={0.9}>
              <Box
                inline
                ml={-0.5}
                mb={2.5}
                width="30px"
                bold
                textAlign="right"
              >
                2.8 -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                2.1 -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                1.4 -
              </Box>
              <Box inline className="FlightComputer__Fuelnotch" bold>
                0.7 -
              </Box>
              <Box inline width="30px" bold ml={-0.5} textAlign="right">
                0 -
              </Box>
            </Stack.Item>
            <Stack.Item ml={0}>
              <Stack.Item height={10}>
                <ColorBox color="#00e94ef5" height={10} />
              </Stack.Item>
              <Stack.Item mt={-19.5} ml={0.5}>
                <ColorBox color="darkgreen" height={9.5} width={0.5} />
              </Stack.Item>
              <Stack.Item mt={(battery / max_battery) * -20}>
                <ColorBox
                  height={vtol_detected ? (battery / max_battery) * 10 : 0}
                  color="#00e94ef5"
                />
              </Stack.Item>
            </Stack.Item>
            <Stack.Item className="FlightComputer__Subdivider" />
            <Stack.Item grow fontSize={0.8} mr={0.5}>
              <Box inline ml={-0.5} mb={2.5} width="40px" bold>
                1.2kW -
              </Box>
              <Box inline className="FlightComputer__Energynotch" bold>
                0.9kW -
              </Box>
              <Box inline className="FlightComputer__Energynotch" bold>
                0.6kW -
              </Box>
              <Box inline className="FlightComputer__Energynotch" bold>
                0.9kW -
              </Box>
              <Box
                inline
                mb={2.5}
                width="40px"
                bold
                textAlign="right"
                ml={-0.6}
              >
                0kW -
              </Box>
            </Stack.Item>
            <Stack.Item ml={0} mr={2}>
              <Stack.Item height={10}>
                <ColorBox color="#00e94ef5" height={10} />
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
          <Box
            bold={battery / max_battery === 1 ? false : true}
            fontSize={0.8}
            textAlign="center"
            width="95%"
            className={
              battery / max_battery === 1 ? 'FlightComputer__TextConfirm' : ''
            }
          >
            APROX CHARGE:{' '}
            <AnimatedNumber
              initial={0}
              value={Math.round((battery / max_battery) * 100)}
            />
            %
          </Box>

          <Box textAlign="center" bold ml={-1} mt={1.7} fontFamily="monospace">
            POWERCELL CHARGE
          </Box>
          <Box textAlign="center" bold ml={-1} fontSize={0.7}>
            {vtol_detected ? '[ 2x Li BATTERY, KWh ]' : 'NONE DETECTED'}
          </Box>
        </Stack.Item>
      </Stack>
      <Button
        align="center"
        className="FlightComputer__FuelButton"
        icon={!vtol_detected || fueling ? 'ban' : 'tint'}
        fluid
        bold
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

const Console = (props) => {
  const { act, data } = useBackend<FlightComputerData>();
  let { vtol_detected, fueling } = data;
  return (
    <Box height={10.75} opacity={0.99}>
      <Box mt={1} mb={1} className="FlightComputer__HorizontalDivider" />
      <Box bold fontFamily="monospace" fontSize={1.1}>
        {vtol_detected ? 'Linked aircraft detected:' : 'No aircraft detected!'}
      </Box>
      <Box bold>{vtol_detected && '[ AD-71E BLACKFOOT ]'}</Box>
      <Box bold fontFamily="monospace" fontSize={1.1} mt={1.3}>
        Refuel and recharge status:
      </Box>
      <Box bold fontSize={1.1}>
        {fueling ? '[ ENGAGED ]' : '[ DISENGAGED ]'}
      </Box>
      <Box bold fontFamily="monospace" fontSize={1.1} mt={1.3}>
        Primary resupply systems:
      </Box>
      <Box bold fontSize={0.95} mb={1.3}>
        [ SYSTEMS NOMINAL ]
      </Box>
      <Box className="FlightComputer__HorizontalDivider" />
    </Box>
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
            className="FlightComputer__Readout"
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
            className="FlightComputer__Readout"
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
      <Box mb={1} className="FlightComputer__HorizontalDivider" />
    </Box>
  );
};
