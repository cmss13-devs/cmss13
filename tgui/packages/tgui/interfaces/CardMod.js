import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Stack, Input, Section, Tabs, Table } from '../components';
import { Window } from '../layouts';
import { AccessList } from './common/AccessList';
import { map } from 'common/collections';

export const CardMod = (props, context) => {
  const [tab2, setTab2] = useLocalState(context, 'tab2', 1);
  return (
    <Window
      width={450}
      height={520}
      resizable>
      <Window.Content scrollable>
        <Box>
          <Tabs
            fluid={1}>
            <Tabs.Tab
              selected={tab2 === 1}
              onClick={() => setTab2(1)}>
              Access Modifcation
            </Tabs.Tab>
            <Tabs.Tab
              selected={tab2 === 2}
              onClick={() => setTab2(2)}>
              Crew Manifest
            </Tabs.Tab>
          </Tabs>
          {tab2 === 1 && (
            <CardContent />
          )}
          {tab2 === 2 && (
            <CrewManifest />
          )}
        </Box>
      </Window.Content>
    </Window>
  );
};

export const CrewManifest = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    manifest = {},
  } = data;
  return (
    <Section
      title="Crew Manifest"
      buttons={(
        <Button
          icon="print"
          content="Print"
          onClick={() => act('PRG_print', {
            mode: 0,
          })} />
      )}>
      {map((entries, department) => (
        <Section
          key={department}
          level={2}
          title={department}>
          <Table>
            {entries.map(entry => (
              <Table.Row
                key={entry.name}
                className="candystripe">
                <Table.Cell bold>
                  {entry.name}
                </Table.Cell>
                <Table.Cell>
                  ({entry.rank})
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      ))(manifest)}
    </Section>
  );
};


export const CardContent = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab, setTab] = useLocalState(context, 'tab', 1);
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
  const [
    selectedDepartment,
    setSelectedDepartment,
  ] = useLocalState(context, 'department', Object.keys(jobs)[0]);
  const departmentJobs = jobs[selectedDepartment] || [];
  return (
    <Fragment>
      <Section
        title={has_id && authenticated
          ? (
            <Input
              value={id_owner}
              width="250px"
              onInput={(e, value) => act('PRG_edit', {
                name: value,
              })} />
          )
          : (id_owner || 'No Card Inserted')}
        buttons={(
          <Fragment>
            <Button
              icon="print"
              content="Print"
              disabled={!has_id || !authenticated}
              onClick={() => act('PRG_print', {
                mode: 1,
              })} />
            <Button
              icon={authenticated ? "sign-out-alt" : "sign-in-alt"}
              content={authenticated ? "Log Out" : "Log In"}
              color={authenticated ? "bad" : "good"}
              onClick={() => {
                act(authenticated ? 'PRG_logout' : 'PRG_authenticate');
              }} />
          </Fragment>
        )}>
        <Button
          fluid
          icon="eject"
          content={id_name}
          onClick={() => act('PRG_eject')} />
        Linked Account:
        <Input
          value={id_account}
          width="150px"
          onInput={(e, value) => act('PRG_account', {
            account: value,
          })} />
      </Section>
      {(!!has_id && !!authenticated) && (
        <Box>
          <Tabs>
            <Tabs.Tab
              selected={tab === 1}
              onClick={() => setTab(1)}>
              Access
            </Tabs.Tab>
            <Tabs.Tab
              selected={tab === 2}
              onClick={() => setTab(2)}>
              Jobs
            </Tabs.Tab>
          </Tabs>
          {tab === 1 && (
            <AccessList
              accesses={regions}
              selectedList={access_on_card}
              accessMod={ref => act('PRG_access', {
                access_target: ref,
              })}
              grantAll={() => act('PRG_grantall')}
              denyAll={() => act('PRG_denyall')}
              grantDep={dep => act('PRG_grantregion', {
                region: dep,
              })}
              denyDep={dep => act('PRG_denyregion', {
                region: dep,
              })} />
          )}
          {tab === 2 && (
            <Section
              title={id_rank}
              buttons={(
                <Button.Confirm
                  icon="exclamation-triangle"
                  content="Terminate"
                  color="bad"
                  onClick={() => act('PRG_terminate')} />
              )}>
              <Button.Input
                fluid
                content="Custom..."
                onCommit={(e, value) => act('PRG_assign', {
                  assign_target: 'Custom',
                  custom_name: value,
                })} />
              <Stack>
                <Stack.Item>
                  <Tabs vertical>
                    {Object.keys(jobs).map(department => (
                      <Tabs.Tab
                        key={department}
                        selected={department === selectedDepartment}
                        onClick={() => setSelectedDepartment(department)}>
                        {department}
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Stack.Item>
                <Stack.Item grow={1}>
                  {departmentJobs.map(job => (
                    <Button
                      fluid
                      key={job.job}
                      content={job.display_name}
                      onClick={() => act('PRG_assign', {
                        assign_target: job.job,
                      })} />
                  ))}
                </Stack.Item>
              </Stack>
            </Section>
          )}
        </Box>
      )}
    </Fragment>
  );
};
