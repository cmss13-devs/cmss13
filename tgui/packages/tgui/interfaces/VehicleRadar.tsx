import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Flex, Icon, Table } from '../components';
import { DmIcon } from '../components';
import { Image } from '../components';
import { Window } from '../layouts';

type RadarData = {
  radar_map: any;
  interface_active: boolean;
  volume: number;
  map_zoom: number;
  minimap_shown: boolean;
  locking_mode: string;
  blackfoot_icon: any;
  blackfoot_x: number;
  blackfoot_y: number;
  radar_mode: number;
  map_size_x: number;
  map_size_y: number;
  contact_data: ContactData[];
  radar_blip_icons: string;
  blackfoot_dir: number;
};

type ContactData = {
  name: string;
  icon: string;
  position_x: number;
  position_y: number;
  contact_ref: string;
};

const HexScrew = () => {
  return (
    <Box p="2px">
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
    </Box>
  );
};

const Sector = () => {
  const { act, data } = useBackend<RadarData>();
  return (
    <Box
      className="RadarSector"
      width="100%"
      height="100%"
      mb="-100%"
      style={{
        border: `2px ${data.radar_mode === 1 ? 'solid' : 'dashed'} ${data.minimap_shown ? 'rgb(0, 0, 0)' : 'rgb(7, 201, 0)'}`,
      }}
    >
      <svg width="100%" height="100%">
        <defs>
          <mask id="hole">
            <rect width="100%" height="100%" fill="green" />
            <circle r="35%" cx="50%" cy="50%" fill="black" />
          </mask>
        </defs>

        <circle
          id="donut"
          r="50%"
          cx="50%"
          cy="50%"
          mask="url(#hole)"
          fillOpacity={0}
        />
      </svg>
    </Box>
  );
};

const SwitchButtonHolder = () => {
  return (
    <Box className="SwitchButtonHolder">
      <Flex height="100%">
        <Flex.Item className="SwitchButton" textAlign="left">
          <Icon name="angle-left" />
        </Flex.Item>
        <Flex.Item className="SwitchButtonDivider" />
        <Flex.Item className="SwitchButton" textAlign="right">
          <Icon name="angle-right" />
        </Flex.Item>
      </Flex>
    </Box>
  );
};

export const VehicleRadar = (props) => {
  const { act, data } = useBackend<RadarData>();

  const topProps = props.topButtons ?? [];
  const topButtons = Array.from({ length: 5 }).map((_, i) => topProps[i] ?? {});

  return (
    <Window width={475} height={500}>
      <Window.Content className="Backdrop">
        <Table width="450px" height="450px" className="RadarPanel">
          <Table.Row>
            <Table.Cell>
              <HexScrew />
            </Table.Cell>
            <Table.Cell verticalAlign="top">
              <Box className="TopButtons">
                <TopButtonsPanel />
              </Box>
            </Table.Cell>
            <Table.Cell align="right">
              <HexScrew />
            </Table.Cell>
          </Table.Row>
          <Table.Row height="82%">
            <Table.Cell>
              <LeftButtonsPanel />
            </Table.Cell>
            <Table.Cell width="82%" verticalAlign="bottom">
              {data.interface_active ? <VehicleRadarDisplay /> : <ScreenOff />}
            </Table.Cell>
            <Table.Cell>
              <RightButtonsPanel />
            </Table.Cell>
          </Table.Row>
          <Table.Row>
            <Table.Cell verticalAlign="bottom">
              <HexScrew />
            </Table.Cell>
            <Table.Cell className="BottomButtons">
              <BottomButtonsPanel />
            </Table.Cell>
            <Table.Cell>
              <HexScrew />
            </Table.Cell>
          </Table.Row>
        </Table>
      </Window.Content>
    </Window>
  );
};

const LeftButtonsPanel = (props) => {
  const { act, data } = useBackend<RadarData>();

  const topProps = props.topButtons ?? [];
  const topButtons = Array.from({ length: 5 }).map((_, i) => topProps[i] ?? {});

  return (
    <Box className="LeftButtons">
      <Box className="ButtonHolderL">
        <Box className="ButtonL" onClick={() => act('power')}>
          POWR
        </Box>
      </Box>
      {data.interface_active ? (
        <>
          <Box className="ButtonHolderL">
            <Box className="ButtonL" onClick={() => act('mode')}>
              MODE
            </Box>
          </Box>
          <Box className="ButtonHolderL">
            <Box className="ButtonL" onClick={() => act('zoom_in')}>
              +
            </Box>
          </Box>
          <Box className="ButtonHolderL">
            <Box className="ButtonL" onClick={() => act('zoom_out')}>
              -
            </Box>
          </Box>
          <Box className="ButtonHolderL">
            <Box className="ButtonL" onClick={() => act('zone_lock')}>
              {data.radar_mode >= 0 && 'ZLCK'}
            </Box>
          </Box>
          <Box className="ButtonHolderL">
            <Box className="ButtonL" onClick={() => act('target_lock')}>
              {data.radar_mode >= 1 && 'TLCK'}
            </Box>
          </Box>
        </>
      ) : (
        Array.from({ length: 5 }).map((_, s) => {
          return (
            <Box className="ButtonHolderL" key={s}>
              <Box className="ButtonL" />
            </Box>
          );
        })
      )}
    </Box>
  );
};

const RightButtonsPanel = (props) => {
  const { act, data } = useBackend<RadarData>();

  const topProps = props.topButtons ?? [];
  const topButtons = Array.from({ length: 5 }).map((_, i) => topProps[i] ?? {});

  return (
    <Box className="RightButtons">
      {data.interface_active && data.radar_mode >= 0 ? (
        <>
          <Box className="ButtonHolderR">
            <Box className="ButtonR" onClick={() => act('blink')}>
              MPUL
            </Box>
          </Box>
          <Box className="ButtonHolderR">
            <Box className="ButtonR">APUL</Box>
          </Box>
          <Box className="ButtonHolderR">
            <Box className="ButtonR">PUL+</Box>
          </Box>
          <Box className="ButtonHolderR">
            <Box className="ButtonR">PUL-</Box>
          </Box>
          <Box className="ButtonHolderR">
            <Box className="ButtonR">CLRT</Box>
          </Box>
          <Box className="ButtonHolderR">
            <Box className="ButtonR">PROX</Box>
          </Box>
        </>
      ) : (
        Array.from({ length: 6 }).map((_, s) => {
          return (
            <Box className="ButtonHolderR" key={s}>
              <Box className="ButtonR" />
            </Box>
          );
        })
      )}
    </Box>
  );
};

const TopButtonsPanel = (props) => {
  const { act, data } = useBackend<RadarData>();

  return (
    <Flex fill={1} justify="space-between" width="98%">
      <Flex.Item>
        <SwitchButtonHolder />
      </Flex.Item>
      <Flex.Item>
        <SwitchButtonHolder />
      </Flex.Item>
      <Flex.Item>
        <Flex width="75px">
          <Flex.Item
            grow
            fontSize="8px"
            textAlign="right"
            pr="5px"
            textColor="rgba(136, 136, 136, 0.64)"
            bold
          >
            <Box>ACTIVE</Box>
            <Box>PASSIVE</Box>
            <Box>OFF</Box>
          </Flex.Item>
          <Flex.Item width="30px" onClick={() => act('switch_radar_mode')}>
            <Box className="RadialSwitch">
              <Box
                className="RadialSwitchNotch"
                style={{
                  transform:
                    `rotate(${data.radar_mode * 30}deg)` +
                    `translate(${data.radar_mode ? -1 : 0}px, ${data.radar_mode * -4.5}px)`,
                }}
              />
            </Box>
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item>
        <SwitchButtonHolder />
      </Flex.Item>
    </Flex>
  );
};

const BottomButtonsPanel = (props) => {
  const { act, data } = useBackend<RadarData>();

  return (
    <Flex>
      <Flex.Item>
        <Box
          className="ButtonB"
          bold
          onClick={() => act('volume', { volume: 'mute' })}
        >
          MUTE
        </Box>
      </Flex.Item>
      <Flex.Item>
        <Box className="SwitchButtonHolder">
          <Flex height="90%">
            <Flex.Item
              className="SwitchButton"
              textAlign="left"
              onClick={() => act('volume', { volume: 'up' })}
            >
              <Icon name="angle-left" />
            </Flex.Item>
            <Flex.Item className="SwitchButtonDivider" />
            <Flex.Item
              className="SwitchButton"
              textAlign="right"
              onClick={() => act('volume', { volume: 'down' })}
            >
              <Icon name="angle-right" />
            </Flex.Item>
          </Flex>
        </Box>
      </Flex.Item>
    </Flex>
  );
};

const ScreenOff = (props) => {
  const { act, data } = useBackend<RadarData>();

  return <Box width="100%" height="100%" className="ScreenOff" />;
};

const VehicleRadarDisplay = (props) => {
  const { act, data } = useBackend<RadarData>();

  let { contact_data } = data;

  return (
    <Box width="100%" height="100%" className="RadarPanelOutline">
      <svg width={0} height={0} style={{ position: `absolute` }}>
        <defs>
          <filter id="colorMeGreen">
            <feColorMatrix
              in="SourceGraphic"
              type="matrix"
              values="-3 0 0 0 0
                0 1 0 0 0
                0 0 -1 0 0
                0 0 0 1 0 "
            />
          </filter>
        </defs>
      </svg>
      {data.radar_mode >= 0 &&
        contact_data &&
        contact_data.map((contact, index) => {
          return (
            <Box
              key={index}
              className="ContactBlip"
              style={{
                left: `${(contact.position_x - data.blackfoot_x + 52) * 3.56 + 52}px`,
                top: `${(data.blackfoot_y - contact.position_y + 52) * 3.56 + 52}px`,
              }}
            >
              <DmIcon icon={data.radar_blip_icons} icon_state={contact.icon} />
            </Box>
          );
        })}
      <Box
        className="RadarMap"
        align="center"
        fontFamily="monospace"
        bold
        textColor="green"
        width="100%"
        height="100%"
        style={
          data.minimap_shown
            ? {
                backgroundImage: `url(${resolveAsset(data.radar_map)})`,
                backgroundPositionX: `${data.blackfoot_x * -3.5 + (data.map_size_x * 1.75 - 265)}px`,
                backgroundPositionY: `${(data.blackfoot_y - data.map_size_y) * 3.5 + (data.map_size_y * 1.6 - 244)}px`,
                filter: `saturate(7.5)` + `invert(1)` + `url(#colorMeGreen)`,
              }
            : {
                backgroundImage: `radial-gradient(ellipse at center, #042208, transparent)`,
                backgroundColor: `rgb(0, 14, 3)`,
                backgroundPositionX: `center`,
                border: `1px ridge rgb(5, 160, 0)`,
              }
        }
      >
        {data.radar_mode >= 0 &&
          Array.from({ length: 4 }).map((_, s) => {
            return Array.from({ length: 12 }).map((_, i) => (
              <Box
                style={{
                  transform:
                    `rotate(${0 + 30 * i}deg)` +
                    `scale(${0.3 * s}, ${0.3 * s})`,
                }}
                key={i}
              >
                <Sector />
              </Box>
            ));
          })}
        <DmIcon
          icon={data.blackfoot_icon}
          icon_state={'vtol'}
          direction={data.blackfoot_dir}
          height="32px"
          style={{
            position: `absolute`,
            transform: `rotate(0deg)`,
          }}
          top="45%"
          left="45.8%"
        />
        <ButtonOverlay />
      </Box>
      <Box
        className="RadarPanelBlank"
        textAlign="center"
        textColor="rgb(5, 165, 0)"
        fontSize="12px"
      >
        <Box width="100%" height="45%">
          <Image
            mt="20%"
            fixBlur
            width="75px"
            height="75px"
            src={resolveAsset('logo_uscm.png')}
            style={{
              filter: `brightness(1)` + `url(#colorMeGreen)` + `saturate(0.95)`,
            }}
            opacity={0.5}
          />
        </Box>

        <Box
          bold
          fontSize="19px"
          className="ScreenDivider"
          inline
          width="80%"
          pt="5px"
        >
          REAPER AQ-133
        </Box>
        <Box fontFamily="monospace">Strategic target acquisition system</Box>

        <Box
          fontFamily="monospace"
          inline
          width="80%"
          className="ScreenDivider"
          mt="7px"
          pt="5px"
        >
          Developed by UA Northridge
        </Box>
        <Box fontFamily="monospace">Property of USCMC Aerospace Command</Box>
      </Box>
    </Box>
  );
};

const ButtonOverlay = (props) => {
  const { act, data } = useBackend<RadarData>();

  return (
    <Table height="100%">
      <Table.Row>
        <Table.Cell colSpan={4}>hi!</Table.Cell>
      </Table.Row>
      <Table.Row height="50%">
        <Table.Cell width="25%" />
        <Table.Cell colSpan={2} width="50%" />
        <Table.Cell width="25%" />
      </Table.Row>
      <Table.Row>
        <Table.Cell className="UIHighlight" verticalAlign="middle">
          <Table>
            <Table.Row>
              <Table.Cell colSpan={2}>hi!</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell className="UIElement">X</Table.Cell>
              <Table.Cell className="UIElement" width="10%" pr="4px">
                {data.blackfoot_x}
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell className="UIElement">4:00:02</Table.Cell>
              <Table.Cell className="UIElement" width="10%" pr="4px">
                <Icon name="clock" />
              </Table.Cell>
            </Table.Row>
          </Table>
        </Table.Cell>
        <Table.Cell colSpan={2} />
        <Table.Cell className="UIHighlight" verticalAlign="middle">
          <Table>
            <Table.Row>
              <Table.Cell colSpan={2}>hi!</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell className="UIElement">PASSIVE RADAR</Table.Cell>
              <Table.Cell className="UIElement" width="10%" pr="4px">
                <Icon name="clock" />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell className="UIElement">4:00:02</Table.Cell>
              <Table.Cell className="UIElement" width="10%" pr="4px">
                <Icon name="clock" />
              </Table.Cell>
            </Table.Row>
          </Table>
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};
