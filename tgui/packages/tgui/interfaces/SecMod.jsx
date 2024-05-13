import { Fragment } from 'react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Stack, Section, Tabs, Flex, Icon } from '../components';
import { Window } from '../layouts';
// just trying to get this to work, i'll fix it up later and implement your suggested changes paul.

export const SecMod = (props) => {
  const [tab2, setTab2] = useLocalState('tab2', 1);
  return (
    <Window width={450} height={520} resizable>
      <Window.Content scrollable>
        <Box>
          <Tabs fluid={1}>
            <Tabs.Tab selected={tab2 === 1} onClick={() => setTab2(1)}>
              Criminal Status
            </Tabs.Tab>
            {/* <Tabs.Tab selected={tab2 === 2} onClick={() => setTab2(2)}>
              Security Log
            </Tabs.Tab> */}
          </Tabs>
          {/* {tab2 === 2 && <SecurityRecord />} */}
          {tab2 === 1 && <CrewStatus />}
        </Box>
      </Window.Content>
    </Window>
  );
};

// export const SecurityRecord = (props) => {
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

// TODO: UTILIZE OBJECTS.
export const CrewStatus = (props) => {
  const { act, data } = useBackend();
  const {
    authenticated,
    has_id,
    id_name,
    general_record,
    security_record,
    selected_target_name,
  } = data;

  return (
    <>
      <Section
        title={!!has_id && !!authenticated ? id_name : 'No Card Inserted'}
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
      {!!has_id && !!authenticated && (
        <Section>
          {general_record.map((record, index) => (
            <Button
              key={index}
              // onClick={() =>
              //   act('selectTarget', {
              //     new_user: record[0][0],
              //   })
              // }
            >
              <Box
              // color={
              //   selected_target_name == record[0][0] && security_record
              //     ? colors[security_record[0][1]]
              //     : 'white'
              // }
              >
                <Flex
                  direction="row"
                  align="start"
                  justify="space-between"
                  fill>
                  {/* {!!selected_target_name == record[0][0] &&
                    security_record &
                    (
                      <Flex.Item>
                        <Dropdown
                          noscroll={1}
                          options={crimeStatusOptions}
                          selected={security_record[0][1]} // first element in the list is the crime stat.
                          color={colors[security_record[0][1]]}
                          onSelected={(value) =>
                            act('updateStatRecord', {
                              stat: security_record[0][0],
                              new_value: value,
                            })
                          }
                          displayText={security_record[0][1]}
                        />
                      </Flex.Item>
                    )} */}
                  <Flex.Item>
                    <Stack vertical>
                      {record.map(([value, label], idx) => (
                        <Stack.Item key={idx}>
                          {label} {value}
                        </Stack.Item>
                      ))}
                    </Stack>
                  </Flex.Item>
                  <Flex.Item>
                    <Icon name="user" size={8} />
                  </Flex.Item>
                </Flex>
              </Box>
            </Button>
          ))}
        </Section>
      )}
    </>
  );
};

// ------- const-------- //
const crimeStatusOptions = ['Arrest', 'None', 'Incarcerated'];

const colors = {
  'Arrest': 'red',
  'None': 'blue',
  'Incarcerated': 'yellow',
};

// ----- const -------- //
