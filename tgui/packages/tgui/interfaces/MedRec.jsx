import { Fragment, useState } from 'react';
import { useBackend } from '../backend';
import { Box, Button, Stack, Input, Dropdown, Section, Tabs, Flex, Icon } from '../components';
import { Window } from '../layouts';

export const MedRec = (props) => {
  const [selectedTab, setSelectedTab] = useState(1);
  return (
    <Window width={450} height={520} resizable>
      <Window.Content>
        <Box>
          <Tabs fluid={1}>
            <Tabs.Tab
              selected={selectedTab === 1}
              onClick={() => setSelectedTab(1)}>
              Health Status
            </Tabs.Tab>
            <Tabs.Tab
              selected={selectedTab === 2}
              onClick={() => setSelectedTab(2)}>
              Medical Record
            </Tabs.Tab>
          </Tabs>
          {selectedTab === 1 && <HealthStatus />}
          {selectedTab === 2 && <MedicalRecord />}
        </Box>
      </Window.Content>
    </Window>
  );
};

const MedicalRecord = (props) => {
  const { act, data } = useBackend();
  const [selectedTab, setSelectedTab] = useState(1);
  const { authenticated, has_id } = data;

  return (
    <>
      <Section
        title="Security Record"
        buttons={
          <Button icon="print" content="Print" onClick={() => act('print')} />
        }
      />
      {!!has_id && !!authenticated && (
        <Box height={550}>
          <Tabs>
            <Tabs.Tab
              selected={selectedTab === 1}
              onClick={() => setSelectedTab(1)}>
              Medical Notes
            </Tabs.Tab>
            <Tabs.Tab
              selected={selectedTab === 2}
              onClick={() => setSelectedTab(2)}>
              Autopsy Report
            </Tabs.Tab>
          </Tabs>
          {selectedTab === 1 && <MedicalNotes />}
          {selectedTab === 2 && <AutopsyReport />}
        </Box>
      )}
    </>
  );
};

const MedicalNotes = (props) => {
  const { act, data } = useBackend();
  const { medical_record } = data;

  return (
    <Section>
      {medical_record.map((record, index) => (
        <Fragment key={index}>
          <Stack vertical align="start">
            <Stack.Item>{record.message}</Stack.Item>
            <Stack.Item>
              <Input
                value={record.value}
                fluid={1}
                onChange={(e, value) =>
                  act('updateStatRecord', {
                    stat_type: record.stat_type,
                    stat: record.stat,
                    new_value: value,
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Fragment>
      ))}
    </Section>
  );
};

const AutopsyReport = (props) => {
  const { act, data } = useBackend();
  const { health, autopsy, existingReport, death, id_name } = data;

  return (
    <Section>
      <Stack justify="space-between" vertical>
        {health.value === 'Deceased' && !existingReport && (
          <Stack.Item>
            <Stack vertical align="start" py={1}>
              <Stack.Item>{autopsy.message}</Stack.Item>
              <Stack.Item>
                <Input
                  value={autopsy.value}
                  fluid={1}
                  onChange={(e, value) =>
                    act('updateStatRecord', {
                      stat_type: autopsy.stat_type,
                      stat: autopsy.stat,
                      new_value: value,
                    })
                  }
                />
              </Stack.Item>
              <Stack.Item>
                <Stack justify="space-between" py={2}>
                  <Stack.Item>
                    <Stack>
                      <Stack.Item>{death.message}</Stack.Item>
                      <Stack.Item>
                        <Dropdown
                          noscroll={1}
                          options={deathOptions}
                          selected={death.value}
                          color={'red'}
                          onSelected={(value) =>
                            act('updateStatRecord', {
                              stat_type: death.stat_type,
                              stat: death.stat,
                              new_value: value,
                            })
                          }
                          displayText={death.value ? death.value : 'NONE'}
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
              <Icon name="user" size={8} color={colors[health.value]} />
            </Stack.Item>
            {existingReport ? (
              <Stack.Item py={2}>
                The autopsy report for {id_name} has been submitted.
              </Stack.Item>
            ) : health.value !== 'Deceased' ? (
              <Stack.Item py={2}>
                The patient must be marked as deceased to create an autopsy
                report.
              </Stack.Item>
            ) : (
              <Stack.Item py={2}>
                Please submit the following information to create an autopsy
                report.
              </Stack.Item>
            )}
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const HealthStatus = (props) => {
  const { act, data } = useBackend();
  const { authenticated, has_id, id_name, general_record, health } = data;

  return (
    <>
      <Section
        title={has_id && authenticated ? id_name : 'No Card Inserted'}
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
          <Box color={colors[health.value]}>
            <Flex direction="row" align="start" justify="space-between" fill>
              <Flex.Item>
                <Dropdown
                  noscroll={1}
                  options={healthStatusOptions}
                  selected={health.value}
                  color={colors[health.value]}
                  onSelected={(value) =>
                    act('updateStatRecord', {
                      stat_type: health.stat_type,
                      stat: health.stat,
                      new_value: value,
                    })
                  }
                  displayText={health.value}
                />
              </Flex.Item>
              <Flex.Item>
                <Stack vertical>
                  {general_record.map(({ value, message }, index) => (
                    <Stack.Item key={index}>
                      {message} {value}
                    </Stack.Item>
                  ))}
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

// Constants
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
