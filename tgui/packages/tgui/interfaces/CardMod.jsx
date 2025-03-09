import { Fragment, useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Input,
  NumberInput,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';
import { AccessList } from './common/AccessList';

export const CardMod = (props) => {
  const [tab2, setTab2] = useState(1);
  return (
    <Window width={450} height={520} resizable>
      <Window.Content scrollable>
        <Box>{tab2 === 1 && <CardContent />}</Box>
      </Window.Content>
    </Window>
  );
};

export const CardContent = (props) => {
  const { act, data } = useBackend();
  const [tab, setTab] = useState(1);
  const {
    authenticated,
    regions = [],
    access_on_card = [],
    jobs = {},
    id_rank,
    id_owner,
    has_id,
    id_name,
    id_account,
  } = data;
  const [selectedDepartment, setSelectedDepartment] = useState(
    Object.keys(jobs)[0],
  );
  const departmentJobs = jobs[selectedDepartment] || [];
  return (
    <>
      <Section
        title={
          has_id && authenticated ? (
            <Input
              value={id_owner}
              width="250px"
              onInput={(e, value) =>
                act('PRG_edit', {
                  name: value,
                })
              }
            />
          ) : (
            id_owner || 'No Card Inserted'
          )
        }
        buttons={
          <>
            <Button
              icon="print"
              disabled={!has_id || !authenticated}
              onClick={() =>
                act('PRG_print', {
                  mode: 1,
                })
              }
            >
              Print
            </Button>
            <Button
              icon={authenticated ? 'sign-out-alt' : 'sign-in-alt'}
              color={authenticated ? 'bad' : 'good'}
              onClick={() => {
                act(authenticated ? 'PRG_logout' : 'PRG_authenticate');
              }}
            >
              {authenticated ? 'Log Out' : 'Log In'}
            </Button>
          </>
        }
      >
        <Button fluid icon="eject" onClick={() => act('PRG_eject')}>
          {id_name}
        </Button>
        {!!has_id && !!authenticated && (
          <>
            Linked Account:
            <NumberInput
              step={1}
              value={id_account}
              minValue={111111}
              maxValue={999999}
              width="60px"
              onChange={(value) =>
                act('PRG_account', {
                  account: value,
                })
              }
            />
          </>
        )}
      </Section>
      {!!has_id && !!authenticated && (
        <Box>
          <Tabs>
            <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
              Access
            </Tabs.Tab>
            <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
              Jobs
            </Tabs.Tab>
          </Tabs>
          {tab === 1 && (
            <AccessList
              accesses={regions}
              selectedList={access_on_card}
              accessMod={(ref) =>
                act('PRG_access', {
                  access_target: ref,
                })
              }
              grantAll={() => act('PRG_grantall')}
              denyAll={() => act('PRG_denyall')}
              grantDep={(dep) =>
                act('PRG_grantregion', {
                  region: dep,
                })
              }
              denyDep={(dep) =>
                act('PRG_denyregion', {
                  region: dep,
                })
              }
            />
          )}
          {tab === 2 && (
            <Section
              title={id_rank}
              buttons={
                <Button.Confirm
                  icon="exclamation-triangle"
                  color="bad"
                  onClick={() => act('PRG_terminate')}
                >
                  Terminate
                </Button.Confirm>
              }
            >
              <Button.Input
                fluid
                onCommit={(e, value) =>
                  act('PRG_assign', {
                    assign_target: 'Custom',
                    custom_name: value,
                  })
                }
              >
                Custom...
              </Button.Input>
              <Stack>
                <Stack.Item>
                  <Tabs vertical>
                    {Object.keys(jobs).map((department) => (
                      <Tabs.Tab
                        key={department}
                        selected={department === selectedDepartment}
                        onClick={() => setSelectedDepartment(department)}
                      >
                        {department}
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Stack.Item>
                <Stack.Item grow={1}>
                  {departmentJobs.map((job) => (
                    <Button
                      fluid
                      key={job.job}
                      onClick={() =>
                        act('PRG_assign', {
                          assign_target: job.job,
                        })
                      }
                    >
                      {job.display_name}
                    </Button>
                  ))}
                </Stack.Item>
              </Stack>
            </Section>
          )}
        </Box>
      )}
    </>
  );
};
