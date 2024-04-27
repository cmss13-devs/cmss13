import { useBackend, useLocalState } from '../backend';
import { Section, Button, Stack, NoticeBox, LabeledList, Flex, Box, Dropdown, Divider } from '../components';
import { Window } from '../layouts';

export const XenomorphExtractor = (_props, context) => {
  const { act, data } = useBackend(context);

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
  const [selectedTab, setSelectedTab] = useLocalState('category', 'NONE');

  return (
    <Window width={600} height={650} theme="crtyellow">
      <Window.Content scrollable>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                content={
                  !organ ? 'Eject Biomass' : 'Eject ' + caste + ' biomass'
                }
                disabled={!organ}
                onClick={() => act('eject_organ')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                content={
                  !organ
                    ? 'Process Biomass'
                    : 'Process Biomass, Expected value : ' + value
                }
                disabled={!organ}
                onClick={() => act('process_organ')}
              />
            </Stack.Item>
            <Stack.Item>
              <NoticeBox info>Biological Matter : {points}</NoticeBox>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Biological Material">
          {!organ && (
            <NoticeBox danger>
              Recepticle is empty, analyzing is impossible!
            </NoticeBox>
          )}
          {organ && <NoticeBox>Biomass detected, Ready to process</NoticeBox>}
        </Section>
        <Divider />
        <Section title={<span> Select Technology to print.</span>}>
          <Box ml={1}>
            <Dropdown
              selected={selectedTab}
              options={dropdownOptions}
              color={'#876500'}
              onSelected={(value) => setSelectedTab(value)}
            />
          </Box>
          <Flex height="200%" direction="row">
            <Flex.Item>
              <Box m={2} bold>
                {selectedTab !== 'NONE' && (
                  <LabeledList>
                    {upgrades.map((upgrades) =>
                      upgrades.category === selectedTab ? (
                        <LabeledList.Item
                          key={upgrades.name}
                          label={
                            <h3 style={{ color: '#ffbf00' }}>
                              {upgrades.name}
                            </h3>
                          }
                          buttons={
                            <Box>
                              <Button
                                fluid={1}
                                content={'Print ' + '  (' + upgrades.cost + ')'}
                                icon="print"
                                tooltip={upgrades.desc}
                                tooltipPosition="left"
                                onClick={() =>
                                  act('produce', {
                                    ref: upgrades.ref,
                                    cost: upgrades.cost,
                                    varia: upgrades.vari,
                                    clearreq: upgrades.clearance,
                                  })
                                }
                              />
                            </Box>
                          }>
                          <Box mb={0.8}>
                            Clearance{' '}
                            {upgrades.clearance === 6
                              ? '5X'
                              : upgrades.clearance}{' '}
                            Required
                          </Box>
                        </LabeledList.Item>
                      ) : null
                    )}
                  </LabeledList>
                )}{' '}
              </Box>
            </Flex.Item>
          </Flex>
        </Section>
        {!!organ && (
          <Section title="Source Material">
            <NoticeBox>Biomass detected, Ready to process</NoticeBox>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
