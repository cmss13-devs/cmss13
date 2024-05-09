import { useBackend, useLocalState } from '../backend';
import { Box, Button, Stack, Input, Dropdown, Section, Tabs, Flex, Icon } from '../components';
import { Window } from '../layouts';

export const MedMod = (props) => {
  const [tab2, setTab2] = useLocalState('tab2', 1);
  return (
    <Window width={450} height={520} resizable>
      <Window.Content>
        <Box>
          <Tabs fluid={1}>
            <Tabs.Tab selected={tab2 === 1} onClick={() => setTab2(1)}>
              Health Status
            </Tabs.Tab>
            <Tabs.Tab selected={tab2 === 2} onClick={() => setTab2(2)}>
              Medical Record
            </Tabs.Tab>
          </Tabs>
          {tab2 === 1 && <HealthStatus />}
          {tab2 === 2 && <MedicalRecord />}
        </Box>
      </Window.Content>
    </Window>
  );
};

export const MedicalRecord = (props) => {
  const { act, data } = useBackend();
  const [tab, setTab] = useLocalState('tab', 1);
  const {
    authenticated,
    name,
    has_id,
    notes,
    health,
    death,
    mental,
    disease,
    disability,
    autopsy,
    existingReport,
  } = data;
  return (
    <>
      <Section
        title="Medical Record"
        buttons={
          <Button icon="print" content="Print" onClick={() => act('print')} />
        }
      />
      {!!has_id && !!authenticated && (
        <Box height={550}>
          <Tabs>
            <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
              Medical Notes
            </Tabs.Tab>
            <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
              Autopsy Report
            </Tabs.Tab>
          </Tabs>
          {tab === 1 && ( // to do, just map it instead.
            <Section>
              <Stack vertical align="start">
                <Stack.Item>General Notes:</Stack.Item>
                <Stack.Item>
                  <Input
                    value={notes}
                    fluid={1}
                    onChange={(e, value) =>
                      act('updateStatRecord', {
                        stat_type: statType.MEDICAL, // yes, it's hardcoded. Fix later.
                        stat: stat.NOTES,
                        new_value: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>Psychiatric History:</Stack.Item>
                <Stack.Item>
                  <Input
                    value={mental}
                    fluid={1}
                    onChange={(e, value) =>
                      act('updateStatRecord', {
                        stat_type: statType.GENERAL,
                        stat: stat.MENTAL,
                        new_value: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>Disease History:</Stack.Item>
                <Stack.Item>
                  <Input
                    value={disease}
                    fluid={1}
                    onChange={(e, value) =>
                      act('updateStatRecord', {
                        stat_type: statType.MEDICAL,
                        stat: stat.DISEASE, // we hardcode around here boyoz.
                        new_value: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>Disability History:</Stack.Item>
                <Stack.Item>
                  <Input
                    value={disability}
                    fluid={1}
                    onChange={(e, value) =>
                      act('updateStatRecord', {
                        stat_type: statType.MEDICAL,
                        stat: stat.DISABILITY,
                        new_value: value,
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            </Section>
          )}
          {tab === 2 && ( // should I have used a table instead of stack hell? Probably.
            <Section>
              <Stack justify="space-between" vertical>
                {health == 'Deceased' && !existingReport && (
                  <Stack.Item>
                    <Stack vertical align="start" py={1}>
                      <Stack.Item>Autopsy Notes:</Stack.Item>
                      <Stack.Item>
                        <Input
                          value={autopsy}
                          fluid={1}
                          onChange={(e, value) =>
                            act('updateStatRecord', {
                              stat_type: statType.MEDICAL,
                              stat: stat.AUTOPSY, // spaghetti noodle code will get fixed eventually, I promise.
                              new_value: value,
                            })
                          }
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Stack justify="space-between" py={2}>
                          <Stack.Item>
                            <Stack>
                              <Stack.Item>Cause Of Death:</Stack.Item>
                              <Stack.Item>
                                <Dropdown
                                  noscroll={1}
                                  options={deathOptions}
                                  selected={death}
                                  color={'red'}
                                  onSelected={(value) =>
                                    act('selectCauseOfDeath', { death: value })
                                  }
                                  displayText={death ? death : "NONE"}
                                />
                              </Stack.Item>
                            </Stack>
                          </Stack.Item>
                          <Stack.Item>
                            <Button
                              icon={'file'}
                              content={'Submit Report'}
                              color={'red'}
                              onClick={() => {
                                act('submitReport');
                              }}
                            />
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                )}
                <Stack.Item>
                  <Stack align="center" justify="space-around" vertical>
                    <Stack.Item>
                      <Icon name="user" size={8} color={colors[health]} />
                    </Stack.Item>
                    {existingReport ? (
                      <Stack.Item py={2}>
                        The autopsy report for {name} has been submitted.
                      </Stack.Item>
                    ) : health !== 'Deceased' ? (
                      <Stack.Item py={2}>
                        he patient must be marked as deceased to create an
                        autopsy report.
                      </Stack.Item>
                    ) : (
                      <Stack.Item py={2}>
                        Please submit the following information to create an
                        autopsy report.
                      </Stack.Item>
                    )}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          )}
        </Box>
      )}
    </>
  );
};

export const HealthStatus = (props) => {
  const { act, data } = useBackend();
  const {
    authenticated,
    id_owner,
    has_id,
    id_name,
    name,
    sex,
    age,
    bloodType,
    health,
  } = data;
  return (
    <>
      <Section
        title={has_id && authenticated ? id_owner : 'No Card Inserted'}
        buttons={
          <Button
            icon={authenticated ? 'sign-out-alt' : 'sign-in-alt'}
            content={authenticated ? 'Log Out' : 'Log In'}
            color={authenticated ? 'bad' : 'good'}
            onClick={() => {
              act(authenticated ? 'logout' : 'authenticate');
            }}
          />
        }>
        <Button
          fluid
          icon="eject"
          content={id_name}
          onClick={() => act('eject')}
        />
      </Section>
      {!!has_id && !!authenticated && (
        <Section>
          <Box color={colors[health]}>
            <Flex direction="row" align="start" justify="space-between" fill>
              <Flex.Item>
                <Dropdown
                  noscroll={1}
                  options={healthStatusOptions}
                  selected={health}
                  color={colors[health]}
                  onSelected={(value) =>
                    act('selectHealthStatus', { health: value })
                  }
                  displayText={health}
                />
              </Flex.Item>
              <Flex.Item>
                <Stack vertical>
                  <Stack.Item>Name: {name}</Stack.Item>
                  <Stack.Item>Sex: {sex}</Stack.Item>
                  <Stack.Item>Age: {age}</Stack.Item>
                  <Stack.Item>Blood Type: {bloodType}</Stack.Item>
                </Stack>
              </Flex.Item>
              <Flex.Item>
                <Icon name="user" size={8} />
              </Flex.Item>
            </Flex>
          </Box>
        </Section>
      )}
    </>
  );
};

// ----- const-------- //
const healthStatusOptions = ['Unfit', 'Deceased', 'Active'];

const deathOptions = [
  'Organ Failure',
  'Decapitation',
  'Burn Trauma',
  'Bullet Wound',
  'Blunt Force Trauma',
  'Blood Loss',
  'Disease',
];

const colors = {
  'Deceased': 'red',
  'Active': 'blue',
  'Unfit': 'yellow',
};

// i'll do it with a list instead, hardcoded for now.
const statType = {
  MEDICAL: 1,
  GENERAL: 0,
};

// stats that have input strings.
const stat = {
  AUTOPSY: 'a_stat',
  NOTES: 'notes',
  MENTAL: 'm_stat',
  DISEASE: 'cdi',
  DISABILITY: 'mi_dis',
};
// ----- const -------- //
