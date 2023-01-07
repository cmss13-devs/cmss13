import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, LabeledList, Section, Table, Tabs } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

interface ShuttleData {
  name: string;
  id: string;
  timer: string;
  timeleft: string;
  can_fast_travel: 0 | 1;
  can_fly: 0 | 1;
  mode: string;
  status: string;
  is_disabled: 0 | 1;
  has_disable: 0 | 1;
}

interface ShuttleTemplate {
  name: string;
  shuttle_id: string;
  description: string;
  admin_notes: string;
}

interface ShutteManipulatorData {
  shuttles: Array<ShuttleData>;
  template_data: Array<ShuttleTemplate>;
  templates: Array<ShuttleTemplate>;
  selected?: ShuttleTemplate;
  existing_shuttle?: ShuttleData;
}

export const ShuttleManipulator = (props, context) => {
  const [tab, setTab] = useLocalState(context, 'tab', 1);
  return (
    <Window title="Shuttle Manipulator" width={800} height={600} theme="admin">
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            Status
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            Templates
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
            Modification
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <ShuttleManipulatorStatus />}
        {tab === 2 && <ShuttleManipulatorTemplates />}
        {tab === 3 && <ShuttleManipulatorModification />}
      </Window.Content>
    </Window>
  );
};

const ShuttleManipulatorStatus = (props, context) => {
  const { act, data } = useBackend<ShutteManipulatorData>(context);
  const shuttles = data.shuttles ?? [];
  return (
    <Section>
      <Table>
        <TableRow>
          <TableCell>Actions</TableCell>
          <TableCell>Shuttle Name</TableCell>
          <TableCell>ID</TableCell>
          <TableCell>Status</TableCell>
          <TableCell>Mode</TableCell>
        </TableRow>
        {shuttles.map((shuttle) => (
          <Table.Row key={shuttle.id}>
            <Table.Cell>
              <Button
                content="JMP"
                key={shuttle.id}
                onClick={() =>
                  act('jump_to', {
                    type: 'mobile',
                    id: shuttle.id,
                  })
                }
              />
              <Button
                content="Fly"
                key={shuttle.id}
                disabled={!shuttle.can_fly}
                onClick={() =>
                  act('fly', {
                    id: shuttle.id,
                  })
                }
              />
              {shuttle.has_disable === 1 && shuttle.is_disabled === 0 && (
                <Button
                  content="Disable"
                  key={shuttle.id}
                  disabled={!shuttle.can_fly}
                  onClick={() =>
                    act('lock', {
                      id: shuttle.id,
                    })
                  }
                />
              )}
              {shuttle.has_disable === 1 && shuttle.is_disabled === 1 && (
                <Button
                  content="Enable"
                  key={shuttle.id}
                  disabled={!shuttle.can_fly}
                  onClick={() =>
                    act('unlock', {
                      id: shuttle.id,
                    })
                  }
                />
              )}
            </Table.Cell>
            <Table.Cell>{shuttle.name}</Table.Cell>
            <Table.Cell>{shuttle.id}</Table.Cell>
            <Table.Cell>{shuttle.status}</Table.Cell>
            <Table.Cell>
              {shuttle.mode}
              {!!shuttle.timer && (
                <>
                  ({shuttle.timeleft})
                  <Button
                    content="Fast Travel"
                    key={shuttle.id}
                    disabled={!shuttle.can_fast_travel}
                    onClick={() =>
                      act('fast_travel', {
                        id: shuttle.id,
                      })
                    }
                  />
                </>
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const ShuttleManipulatorTemplates = (props, context) => {
  const { act, data } = useBackend<ShutteManipulatorData>(context);
  const templateObject = data.template_data;
  const selected = data.selected;
  const [selectedTemplateId, setSelectedTemplateId] = useLocalState(
    context,
    'templateId',
    templateObject[0]?.shuttle_id ?? 0
  );
  const actualTemplate = templateObject.find(
    (x) => x.shuttle_id === selectedTemplateId
  );
  return (
    <Section>
      <Flex>
        <Flex.Item>
          <Tabs vertical>
            {templateObject.map((template) => (
              <Tabs.Tab
                key={template.shuttle_id}
                selected={selectedTemplateId === template.shuttle_id}
                onClick={() => setSelectedTemplateId(template.shuttle_id)}>
                {template.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Flex.Item>
        <Flex.Item>
          <Box width={2} />
        </Flex.Item>
        <Flex.Item grow={1} basis={0}>
          {actualTemplate && (
            <Section
              title={actualTemplate.name}
              key={actualTemplate.shuttle_id}
              buttons={
                <Button
                  content={
                    actualTemplate.shuttle_id === selected?.shuttle_id
                      ? 'Selected'
                      : 'Select'
                  }
                  selected={actualTemplate.shuttle_id === selected?.shuttle_id}
                  onClick={() =>
                    act('select_template', {
                      shuttle_id: actualTemplate.shuttle_id,
                    })
                  }
                />
              }>
              <LabeledList>
                <LabeledList.Item label="Description">
                  {actualTemplate.description ?? 'None'}
                </LabeledList.Item>
                <LabeledList.Item label="Admin Notes">
                  {actualTemplate.admin_notes ?? 'None'}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          )}
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const ShuttleManipulatorModification = (props, context) => {
  const { act, data } = useBackend<ShutteManipulatorData>(context);
  const selected = data.selected;
  const existingShuttle = data.existing_shuttle;
  return (
    <Section>
      {selected ? (
        <>
          <Section title={selected.name}>
            {(!!selected.description || !!selected.admin_notes) && (
              <LabeledList>
                {!!selected.description && (
                  <LabeledList.Item label="Description">
                    {selected.description}
                  </LabeledList.Item>
                )}
                {!!selected.admin_notes && (
                  <LabeledList.Item label="Admin Notes">
                    {selected.admin_notes}
                  </LabeledList.Item>
                )}
              </LabeledList>
            )}
          </Section>
          {existingShuttle ? (
            <Section title={'Existing Shuttle: ' + existingShuttle.name}>
              <LabeledList>
                <LabeledList.Item
                  label="Status"
                  buttons={
                    <Button
                      content="Jump To"
                      onClick={() =>
                        act('jump_to', {
                          type: 'mobile',
                          id: existingShuttle.id,
                        })
                      }
                    />
                  }>
                  {existingShuttle.status}
                  {!!existingShuttle.timer && <>({existingShuttle.timeleft})</>}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ) : (
            <Section title="Existing Shuttle: None" />
          )}
          <Section title="Status">
            <Button
              content="Load"
              color="good"
              onClick={() =>
                act('load', {
                  shuttle_id: selected.shuttle_id,
                })
              }
            />
            <Button
              content="Preview"
              onClick={() =>
                act('preview', {
                  shuttle_id: selected.shuttle_id,
                })
              }
            />
            <Button
              content="Replace"
              color="bad"
              onClick={() =>
                act('replace', {
                  shuttle_id: selected.shuttle_id,
                })
              }
            />
          </Section>
        </>
      ) : (
        'No shuttle selected'
      )}
    </Section>
  );
};
