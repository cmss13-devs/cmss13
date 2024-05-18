import React, { useState } from 'react';
import { useBackend } from '../backend';
import { Box, Button, Section, Tabs, Flex, Icon, Stack, Dropdown, Input } from '../components';
import { Window } from '../layouts';

export const SecRec = (props) => {
  const { act, data } = useBackend();
  const { authenticated, selected_target_name } = data;
  const [selectedTab, setSelectedTab] = useState(1);
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <Window width={450} height={520}>
      <Window.Content scrollable>
        <Box>
          <Tabs fluid={1}>
            <Tabs.Tab
              selected={selectedTab === 1}
              onClick={() => setSelectedTab(1)}>
              Crew Manifest
            </Tabs.Tab>
            {!!authenticated && !!selected_target_name && (
              <>
                <Tabs.Tab
                  selected={selectedTab === 2}
                  onClick={() => setSelectedTab(2)}>
                  Criminal Status
                </Tabs.Tab>
                <Tabs.Tab
                  selected={selectedTab === 3}
                  onClick={() => setSelectedTab(3)}>
                  Criminal History
                </Tabs.Tab>
              </>
            )}
          </Tabs>
          {selectedTab === 1 && (
            <CrewManifest
              searchQuery={searchQuery}
              setSearchQuery={setSearchQuery}
            />
          )}
          {selectedTab === 2 && !!authenticated && !!selected_target_name && (
            <CrimeStat />
          )}
          {selectedTab === 3 && !!authenticated && !!selected_target_name && (
            <CrimeHist />
          )}
        </Box>
      </Window.Content>
    </Window>
  );
};
const CrimeHist = (props) => {
  const { act, data } = useBackend();
  const [selectedTab, setSelectedTab] = useState(1);
  const { incident, notes } = data;

  return (
    <>
      <Section title="Security Record" />
      <Box height={550}>
        <Tabs>
          <Tabs.Tab
            selected={selectedTab === 1}
            onClick={() => setSelectedTab(1)}>
            General Notes
          </Tabs.Tab>
          <Tabs.Tab
            selected={selectedTab === 2}
            onClick={() => setSelectedTab(2)}>
            Incident Report
          </Tabs.Tab>
        </Tabs>
        {selectedTab === 1 && <GeneralNotes act={act} notes={notes} />}
        {selectedTab === 2 && <IncidentReport incident={incident} />}
      </Box>
    </>
  );
};

const GeneralNotes = ({ act, notes }) => (
  <Section>
    <Stack vertical align="start">
      <Stack.Item>{notes.message}</Stack.Item>
      <Stack.Item>
        <Box fluid={1}>{notes.value}</Box>
      </Stack.Item>
      <Stack.Item>
        <Stack vertical py={5}>
          <Stack.Item>New note entry:</Stack.Item>
          <Stack.Item>
            <Input
              fluid={1}
              placeholder={'New entry...'}
              onChange={(e) => {
                const value = e.target.value;
                act('updateStatRecord', {
                  stat: notes.stat,
                  new_value: value,
                });
              }}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  </Section>
);

const IncidentReport = ({ incident }) => (
  <Section>
    <Stack vertical>
      <Stack.Item>Incident Reports:</Stack.Item>
      {incident.value.map((report, index) => (
        <Stack.Item key={index}>
          <Box>{report}</Box>
        </Stack.Item>
      ))}
    </Stack>
  </Section>
);

const CrewManifest = ({ searchQuery, setSearchQuery }) => {
  const { act, data } = useBackend();
  const { human_mob_list, selected_target_name, authenticated, id_name } = data;

  return (
    <>
      <Section
        title={authenticated ? id_name : 'No Card Inserted'}
        buttons={
          <Button
            icon={authenticated ? 'sign-out-alt' : 'sign-in-alt'}
            content={authenticated ? 'Log Out' : 'Log In'}
            color={authenticated ? 'bad' : 'good'}
            onClick={() => {
              act(authenticated ? 'logout' : 'authenticate');
            }}
          />
        }
      />
      {!!authenticated && (
        <Section>
          <Input
            fluid={1}
            placeholder="Search..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
          {human_mob_list
            .filter((record) =>
              record.toLowerCase().includes(searchQuery.toLowerCase())
            )
            .map((record, index) => (
              <Stack
                key={index}
                color={'blue'}
                align={'stretch'}
                justify={'space-between'}
                fluid={1}
                py={2}
                px={5}>
                <Stack.Item>{record}</Stack.Item>
                <Stack.Item>
                  <Button
                    content={
                      selected_target_name === record ? 'unselect' : 'select'
                    }
                    color={selected_target_name === record ? 'bad' : 'white'}
                    onClick={() => {
                      act('selectTarget', {
                        new_user: record,
                      });
                    }}
                  />
                </Stack.Item>
              </Stack>
            ))}
        </Section>
      )}
    </>
  );
};

const CrimeStat = (props) => {
  const { act, data } = useBackend();
  const { general_record, crime_stat } = data;

  return (
    <Section>
      <Box color={colors[crime_stat.value]}>
        <Flex direction="row" align="start" justify="space-between" fill>
          <Flex.Item>
            <Dropdown
              noscroll={1}
              options={crimeStatusOptions}
              selected={crime_stat.value}
              color={colors[crime_stat.value]}
              onSelected={(value) =>
                act('updateStatRecord', {
                  stat: crime_stat.stat,
                  new_value: value,
                })
              }
              displayText={crime_stat.value}
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
  );
};

// Constants
const crimeStatusOptions = ['Arrest', 'None', 'Incarcerated'];

const colors = {
  Arrest: 'red',
  None: 'blue',
  Incarcerated: 'orange',
};
