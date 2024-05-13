import { Fragment } from 'react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Tabs, Flex, Icon, Stack, Dropdown } from '../components';
import { Window } from '../layouts';
// just trying to get this to work, i'll fix it up later and implement your suggested changes paul.

export const SecRec = (props) => {
  const [tab2, setTab2] = useLocalState('tab2', 1);
  return (
    <Window width={450} height={520}>
      <Window.Content scrollable>
        <Box>
          <Tabs fluid={1}>
            <Tabs.Tab selected={tab2 === 1} onClick={() => setTab2(1)}>
              Crew Manifest
            </Tabs.Tab>
            <Tabs.Tab selected={tab2 === 2} onClick={() => setTab2(2)}>
              Criminal Status
            </Tabs.Tab>
            <Tabs.Tab selected={tab2 === 3} onClick={() => setTab2(2)}>
              Criminal History
            </Tabs.Tab>
          </Tabs>
          {tab2 === 1 && <CrewManifest />}
          {tab2 === 2 && <CrimeStat />}
          {/* {tab2 === 3 && <CrimeHist />} */}
        </Box>
      </Window.Content>
    </Window>
  );
};

// export const CrimeHist = (props) => {
//   const { act, data } = useBackend();
//   const [tab, setTab] = useLocalState('tab', 1);
//   const { authenticated, has_id, id_name, security_record, selected_target } =
//     data;
//   return (
//     <>
//       <Section
//         title="Security Record"
//         buttons={
//           <Button icon="print" content="Print" onClick={() => act('print')} />
//         }
//       />
//       {!!has_id && !!authenticated && (
//         <Box height={550}>
//           <Tabs>
//             <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
//               Medical Notes
//             </Tabs.Tab>
//             <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
//               Autopsy Report
//             </Tabs.Tab>
//           </Tabs>
//           {tab === 1 && (
//             <Section>
//               <Stack vertical align="start">
//                 {medical_record.map((record, index) => (
//                   <Fragment key={index}>
//                     <Stack.Item>{record[3]}</Stack.Item>
//                     <Stack.Item>
//                       <Input
//                         value={record[2]}
//                         fluid={1}
//                         onChange={(e, value) =>
//                           act('updateStatRecord', {
//                             stat_type: record[0],
//                             stat: record[1],
//                             new_value: value,
//                           })
//                         }
//                       />
//                     </Stack.Item>
//                   </Fragment>
//                 ))}
//               </Stack>
//             </Section>
//           )}
//           {tab === 2 && ( // should I have used a table instead of stack hell? Probably.
//             <Section>
//               <Stack justify="space-between" vertical>
//                 {health[2] == 'Deceased' && !existingReport && (
//                   <Stack.Item>
//                     <Stack vertical align="start" py={1}>
//                       <Stack.Item>{autopsy[3]}</Stack.Item>
//                       <Stack.Item>
//                         <Input
//                           value={autopsy[2]}
//                           fluid={1}
//                           onChange={(e, value) =>
//                             act('updateStatRecord', {
//                               stat_type: autopsy[0],
//                               stat: autopsy[1],
//                               new_value: value,
//                             })
//                           }
//                         />
//                       </Stack.Item>
//                       <Stack.Item>
//                         <Stack justify="space-between" py={2}>
//                           <Stack.Item>
//                             <Stack>
//                               <Stack.Item>{death[3]}</Stack.Item>
//                               <Stack.Item>
//                                 <Dropdown
//                                   noscroll={1}
//                                   options={deathOptions}
//                                   selected={death[2]}
//                                   color={'red'}
//                                   onSelected={(value) =>
//                                     act('updateStatRecord', {
//                                       stat_type: death[0],
//                                       stat: death[1],
//                                       new_value: value,
//                                     })
//                                   }
//                                   displayText={death[2] ? death[2] : 'NONE'}
//                                 />
//                               </Stack.Item>
//                             </Stack>
//                           </Stack.Item>
//                           <Stack.Item>
//                             <Button
//                               icon={'file'}
//                               content={'Submit Report'}
//                               color={'red'}
//                               onClick={() => {
//                                 act('submitReport');
//                               }}
//                             />
//                           </Stack.Item>
//                         </Stack>
//                       </Stack.Item>
//                     </Stack>
//                   </Stack.Item>
//                 )}
//                 <Stack.Item>
//                   <Stack align="center" justify="space-around" vertical>
//                     <Stack.Item>
//                       <Icon name="user" size={8} color={colors[health[2]]} />
//                     </Stack.Item>
//                     {existingReport ? (
//                       <Stack.Item py={2}>
//                         The autopsy report for {id_name} has been submitted.
//                       </Stack.Item>
//                     ) : health[2] !== 'Deceased' ? (
//                       <Stack.Item py={2}>
//                         The patient must be marked as deceased to create an
//                         autopsy report.
//                       </Stack.Item>
//                     ) : (
//                       <Stack.Item py={2}>
//                         Please submit the following information to create an
//                         autopsy report.
//                       </Stack.Item>
//                     )}
//                   </Stack>
//                 </Stack.Item>
//               </Stack>
//             </Section>
//           )}
//         </Box>
//       )}
//     </>
//   );
// };

// TODO - IMPLEMENT SEARCH BAR.
export const CrewManifest = (props) => {
  const { act, data } = useBackend();
  const { human_mob_list } = data;

  return (
    <Section
      title="Crew Manifest"
      buttons={
        <Button
          icon="print"
          content="Print"
          onClick={() =>
            act('PRG_print', {
              mode: 0,
            })
          }
        />
      }>
      <Stack vertical>
        {human_mob_list.map((record, index) => (
          <Stack.Item key={index}>{record}</Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

export const CrimeStat = (props) => {
  const { act, data } = useBackend();
  const {
    authenticated,
    has_id,
    id_name,
    general_record = [],
    security_record = [],
    selected_target_named,
  } = data;

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
        }
      />
      {!!has_id &&
        !!authenticated &&
        !!selected_target_named &&
        !!general_record.length &&
        !!security_record.length && (
          <Section>
            <Box color={colors[security_record.crime_stat]}>
              <Flex direction="row" align="start" justify="space-between" fill>
                <Flex.Item>
                  <Dropdown
                    noscroll={1}
                    options={crimeStatusOptions}
                    selected={security_record.crime_stat}
                    color={colors[security_record.crime_stat]}
                    onSelected={(value) =>
                      act('updateStatRecord', {
                        stat: security_record.stat,
                        new_value: value,
                      })
                    }
                    displayText={security_record.crime_stat}
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

// ----- const -------- //
const crimeStatusOptions = ['Arrest', 'None', 'Incarcerated'];

const colors = {
  Arrest: 'red',
  None: 'blue',
  Incarcerated: 'yellow',
};
