import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  Flex,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const XenomorphExtractor = () => {
  const { act, data } = useBackend();
  const BulkPrint = [2, 5, 10]; // simple but effective
  const {
    organ,
    points,
    upgrades,
    caste,
    value,
    categories,
    print_queue,
    is_processing,
  } = data;
  const dropdownOptions = categories;
  const [selectedTab, setSelectedTab] = useState('NONE');

  return (
    <Window width={850} height={800} theme="crtyellow">
      <Window.Content scrollable>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!organ}
                onClick={() => act('eject_organ')}
              >
                {!organ ? 'Eject Biomass' : 'Eject ' + caste + ' biomass'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!organ}
                onClick={() => act('process_organ')}
              >
                {!organ
                  ? 'Process Biomass'
                  : 'Process Biomass, Expected value : ' + value}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <NoticeBox info>Biological Matter : {points}</NoticeBox>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Biological Material">
          {!organ ? (
            <NoticeBox danger>
              Recepticle is empty, analyzing is impossible!
            </NoticeBox>
          ) : (
            <NoticeBox notice>Biomass accepted. Ready to analyze.</NoticeBox>
          )}
        </Section>
        <Section
          title="Process Queue"
          buttons={
            <Button
              onClick={() => act('toggle_processing')}
              bold
              icon={is_processing ? 'pause' : 'play'}
            >
              {is_processing ? 'STOP' : 'START'}
            </Button>
          }
        >
          <Flex direction={'column-reverse'}>
            {print_queue === null ? (
              <span>
                <Box>Queue is empty</Box>
              </span>
            ) : (
              print_queue.map((print_queue) => (
                <>
                  <Flex.Item key={print_queue.name}>
                    <Box bold italic>
                      {print_queue.name}
                      <Button
                        fluid
                        onClick={() => act('stop_processing')}
                        bold
                        ml={120}
                        top={'-5px'}
                        textAlign={'center'}
                      >
                        Cancel
                      </Button>
                    </Box>
                  </Flex.Item>
                  <Divider />
                </>
              ))
            )}
          </Flex>
        </Section>
        <Divider />
        <Section title={<span> Select Technology to print.</span>}>
          <Box ml={1}>
            <Dropdown
              selected={selectedTab}
              options={dropdownOptions}
              onSelected={(value) => setSelectedTab(value)}
            />
          </Box>
          <Flex height="200%" direction="row">
            <Flex.Item>
              <Box m={2} bold mb={1}>
                {selectedTab !== 'NONE' && (
                  <LabeledList>
                    {upgrades.map((upgrades) =>
                      upgrades.category === selectedTab ? (
                        <LabeledList.Item
                          key={upgrades.name}
                          label={
                            <Box width={25}>
                              <h3 style={{ color: '#ffbf00' }}>
                                {upgrades.name}
                              </h3>
                            </Box>
                          }
                          buttons={
                            <Box preserveWhitespace mb={4}>
                              {' '}
                              <Button
                                fluid
                                icon="print"
                                tooltip={upgrades.desc}
                                tooltipPosition="left"
                                onClick={() =>
                                  act('produce', {
                                    ref: upgrades.ref,
                                    amount: 1,
                                  })
                                }
                              >
                                Print ({upgrades.cost})
                              </Button>
                              <Divider />
                              {BulkPrint.map((buttons) => (
                                <Button
                                  key={buttons}
                                  mr={'3px'}
                                  width={'35px'}
                                  tooltip={upgrades.desc}
                                  tooltipPosition="left"
                                  textAlign="center"
                                  onClick={() =>
                                    act('produce', {
                                      ref: upgrades.ref,
                                      amount: buttons,
                                    })
                                  }
                                >
                                  x{buttons}
                                </Button>
                              ))}
                            </Box>
                          }
                        >
                          <Box mb={0.8}>
                            Clearance{' '}
                            {upgrades.clearance === 6
                              ? '5X'
                              : upgrades.clearance}{' '}
                            Required
                            {upgrades.price_change !== 0 && (
                              <Box>
                                <Divider />
                                This technology will{' '}
                                {upgrades.price_change > 0
                                  ? 'increase'
                                  : 'decrease'}{' '}
                                in cost by {upgrades.price_change} each purchase
                              </Box>
                            )}
                            {upgrades.price_change === 0 && (
                              <Box>
                                <Divider />
                                This technology will not change its value with
                                purchase.
                              </Box>
                            )}
                          </Box>
                        </LabeledList.Item>
                      ) : null,
                    )}
                  </LabeledList>
                )}
              </Box>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
