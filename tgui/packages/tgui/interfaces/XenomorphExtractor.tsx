import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
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

type Queue = {
  name: string;
  id: string;
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
  print_queue: Queue[];
  is_processing: boolean;
};

export const XenomorphExtractor = () => {
  const { act, data } = useBackend<Data>();
  const BulkPrint = [2, 5, 10]; // simple but effective
  const dropdownOptions = data.categories;
  const [selectedTab, setSelectedTab] = useSharedState('NONE', 'None');

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
                    disabled={!data.organ}
                    onClick={() => act('eject_organ')}
                  >
                    {!data.organ
                      ? 'Eject Biomass'
                      : 'Eject ' + data.caste + ' biomass'}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    icon="eject"
                    disabled={!data.organ}
                    onClick={() => act('process_organ')}
                  >
                    {!data.organ
                      ? 'Process Biomass'
                      : 'Process Biomass, Expected value : ' + data.value}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <NoticeBox info>Biological Matter : {data.points}</NoticeBox>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Biological Material">
              {!data.organ ? (
                <NoticeBox danger>
                  Recepticle is empty, analyzing is impossible!
                </NoticeBox>
              ) : (
                <NoticeBox info>Biomass accepted. Ready to analyze.</NoticeBox>
              )}
            </Section>
          </Stack.Item>
          <Collapsible
            title={'Process Queue'}
            buttons={
              <Button
                onClick={() => act('toggle_processing')}
                bold
                icon={data.is_processing ? 'pause' : 'play'}
              >
                {data.is_processing ? 'STOP' : 'START'}
              </Button>
            }
          >
            <Section mx={3}>
              <Flex direction={'column-reverse'}>
                {data.print_queue === null ? (
                  <span>
                    <Box>Queue is empty</Box>
                  </span>
                ) : (
                  data.print_queue.map((print_queue) => (
                    <>
                      <Flex.Item key={print_queue.name}>
                        <Box bold italic>
                          {print_queue.name}
                          <Button
                            fluid
                            onClick={() =>
                              act('remove_from_queue', {
                                upgrade_id: print_queue.id,
                              })
                            }
                            bold
                            ml={100}
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
          </Collapsible>
          <Divider />
          <Stack.Item>
            <Section title={<span> Select Technology to print.</span>}>
              <Box ml={1}>
                <Dropdown
                  selected={selectedTab}
                  options={dropdownOptions}
                  color={'#876500'}
                  onSelected={(value) => setSelectedTab(value)}
                  dropdownTextColor="#ffbf00"
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
                        {data.upgrades.map((upgrades) =>
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
                                      mr={'1px'}
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
