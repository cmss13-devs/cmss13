import { map } from 'common/collections';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const InfoPanel = () => {
  const { data } = useBackend();
  const { clearance, credits, status } = data;
  return (
    <Box height={12} width={35} fontSize={0.5}>
      <Section fill>
        <Flex direction={'column'} wrap={'wrap'} color={'#cfcfcf'}>
          <Flex.Item>
            <ProgressBar
              value={credits}
              minValue={1}
              maxValue={60}
              ranges={{
                good: [40, Infinity],
                average: [15, 40],
                bad: [-Infinity, 15],
              }}
            >
              <h4>RESEARCH CREDITS: {credits}</h4>
            </ProgressBar>
          </Flex.Item>
          <Flex.Item>
            <h3>STATUS: {status}</h3>
          </Flex.Item>
          <Flex.Item>
            <h3>RESEARCH CLEARANCE: {clearance}</h3>
          </Flex.Item>
          <Flex.Item>
            <h3>RESEARCH CLEARANCE: {clearance}</h3>
          </Flex.Item>
        </Flex>
      </Section>
    </Box>
  );
};

export const Controls = (props) => {
  const { act, data } = useBackend();
  const { selectedMode, setSelectedMode } = props;
  const { mode_data, can_simulate, can_eject_target, can_eject_reference } =
    data;
  return (
    <Flex>
      <Flex.Item mr={1} fontSize={1.2} height={12} width={13}>
        <Stack vertical>
          <Stack.Item>
            <Button
              fluid
              onClick={() => {
                act('simulate');
              }}
              disabled={!can_simulate}
            >
              SIMULATE
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              fluid
              onClick={() => {
                act('eject_target');
              }}
              disabled={!can_eject_target}
            >
              EJECT TARGET
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              fluid
              onClick={() => {
                act('eject_reference');
              }}
              disabled={!can_eject_reference}
            >
              EJECT REFERENCE
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button fluid>COMPLEXITY</Button>
          </Stack.Item>
        </Stack>
      </Flex.Item>
      <Flex.Item fontSize={1.2} height={12} width={13}>
        <Stack vertical>
          {mode_data.map((mode_data, id) => (
            <Stack.Item key={id}>
              <Button
                fluid
                onClick={() => {
                  act('change_mode', { mode_id: mode_data.mode_id });
                  setSelectedMode(mode_data.mode_id);
                }}
                tooltip={mode_data.desc}
                icon={mode_data.icon}
                disabled={mode_data.mode_id === selectedMode}
              >
                {mode_data.name}
              </Button>
            </Stack.Item>
          ))}
        </Stack>
      </Flex.Item>
    </Flex>
  );
};

export const ModeChange = (props) => {
  const { act, data } = useBackend();
  const { selectedMode } = props;
  const { target_data } = data;
  const [selectedProperty, setSelectedProperty] = useSharedState(false);
  return (
    (target_data && (
      <Flex ml={3} fontSize={1.2} width={50} height={20} mt={5}>
        <Flex.Item>
          {map(target_data, (property, key) =>
            key <= 3 ? (
              <Stack vertical>
                <Stack.Item mx={2} my={0.5}>
                  <Button
                    width={10}
                    textAlign={'center'}
                    onClick={() => {
                      act('select_property', {
                        property_code: property.code,
                      });
                      setSelectedProperty(property.code);
                    }}
                    selected={selectedProperty === property.code ? true : false}
                  >
                    {property.code} {property.level}
                  </Button>
                </Stack.Item>
              </Stack>
            ) : (
              false
            ),
          )}
        </Flex.Item>
        <Flex.Item>
          {map(target_data, (property, key) =>
            key > 3 ? (
              <Stack vertical>
                <Stack.Item mx={2} my={0.5}>
                  <Button
                    width={10}
                    textAlign={'center'}
                    onClick={() => {
                      act('select_property', {
                        property_code: property.code,
                      });
                      setSelectedProperty(property.code);
                    }}
                    selected={selectedProperty === property.code ? true : false}
                  >
                    {property.code} {property.level}
                  </Button>
                </Stack.Item>
              </Stack>
            ) : (
              false
            ),
          )}
        </Flex.Item>
        <Flex.Item ml={3}>
          {map(
            target_data,
            (property, key) =>
              property.code === selectedProperty && (
                <Section title={property.name}>{property.desc}</Section>
              ),
          )}
        </Flex.Item>
      </Flex>
    )) || (
      <Box my={3} mx={3}>
        <NoticeBox>No data inserted!</NoticeBox>
      </Box>
    )
  );
};

export const ModeRelate = (props) => {
  const { act, data } = useBackend();
  const { selectedMode } = props;
  const { target_data } = data;
  return <Box>relate</Box>;
};

export const ModeCreate = (props) => {
  const { act, data } = useBackend();
  const { selectedMode } = props;
  const { mode_data, can_simulate, can_eject_target, can_eject_reference } =
    data;
  return <Box>Create here</Box>;
};

export const ChemSimulator = () => {
  const { act, data } = useBackend();
  const { clearance, credits, status } = data;
  const [selectedMode, setSelectedMode] = useSharedState(1);
  return (
    <Window width={800} height={450} theme={'weyland'}>
      <Window.Content scrollable>
        <Flex m={1}>
          <Flex.Item>
            <InfoPanel />
          </Flex.Item>
          <Flex.Item mx={2}>
            <Controls
              selectedMode={selectedMode}
              setSelectedMode={setSelectedMode}
            />
          </Flex.Item>
        </Flex>
        <Divider />
        {selectedMode === 1 && <ModeChange selectedMode={selectedMode} />}
        {selectedMode === 2 && <ModeChange selectedMode={selectedMode} />}
        {selectedMode === 3 && <ModeRelate />}
        {selectedMode === 4 && <ModeCreate />}
      </Window.Content>
    </Window>
  );
};
