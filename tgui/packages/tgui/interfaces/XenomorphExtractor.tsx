import { useState } from 'react';
import { useBackend } from 'tgui/backend';
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
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Upgrade = {
  name: string;
  desc: string;
  cost: number;
  ref: string;
  category: string;
  clearance: number;
  price_change: number;
};

type Data = {
  points: number;
  current_clearance: number;
  is_x_level: boolean;
  organ: boolean;
  caste?: string;
  value?: number;
  categories: string[];
  upgrades: Upgrade[];
};

export const XenomorphExtractor = () => {
  const { act, data } = useBackend<Data>();

  const {
    organ,
    points,
    upgrades,
    caste,
    value,
    categories,
    current_clearance,
    is_x_level,
  } = data;
  const dropdownOptions = categories;
  const [selectedTab, setSelectedTab] = useState('NONE');

  return (
    <Window width={850} height={800} theme="crtyellow">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Stack vertical>
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
          </Stack.Item>
          <Stack.Item>
            <Section title="Biological Material">
              {!organ ? (
                <NoticeBox danger>
                  Recepticle is empty, analyzing is impossible!
                </NoticeBox>
              ) : (
                <NoticeBox info>Biomass accepted. Ready to analyze.</NoticeBox>
              )}
            </Section>
          </Stack.Item>
          <Divider />
          <Stack.Item>
            <Section title={<span> Select Technology to print.</span>}>
              <Box ml={1}>
                <Dropdown
                  selected={selectedTab}
                  options={dropdownOptions}
                  color={'#876500'}
                  onSelected={(value) => setSelectedTab(value)}
                />
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              <Flex grow direction="row">
                <Flex.Item>
                  <Box m={2} bold>
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
                                <Box preserveWhitespace>
                                  {' '}
                                  <Button
                                    fluid
                                    icon="print"
                                    tooltip={upgrades.desc}
                                    tooltipPosition="left"
                                    onClick={() =>
                                      act('produce', {
                                        ref: upgrades.ref,
                                      })
                                    }
                                  >
                                    Print ({upgrades.cost})
                                  </Button>
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
                                    in cost by {upgrades.price_change} each
                                    purchase
                                  </Box>
                                )}
                                {upgrades.price_change === 0 && (
                                  <Box>
                                    <Divider />
                                    This technology will not change its value
                                    with purchase.
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
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
