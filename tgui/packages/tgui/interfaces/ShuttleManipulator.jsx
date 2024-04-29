import { map } from 'common/collections';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, Flex, LabeledList, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';

export const ShuttleManipulator = (props) => {
  const [tab, setTab] = useState(1);

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

export const ShuttleManipulatorStatus = (props) => {
  const { act, data } = useBackend();
  const shuttles = data.shuttles || [];
  return (
    <Section>
      <Table>
        {shuttles.map((shuttle) => (
          <Table.Row key={shuttle.id}>
            <Table.Cell width="11rem">
              <Button
                content="JMP"
                key={shuttle.id}
                onClick={() =>
                  act('jump_to', {
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

export const ShuttleManipulatorTemplates = (props) => {
  const { act, data } = useBackend();
  const templateObject = data.templates || {};
  const selected = data.selected || {};
  const [selectedTemplateId, setSelectedTemplateId] = useState(
    Object.keys(templateObject)[0],
  );
  const actualTemplates = templateObject[selectedTemplateId]?.templates || [];

  return (
    <Section>
      <Flex>
        <Flex.Item>
          <Tabs vertical>
            {map(templateObject, (template, templateId) => (
              <Tabs.Tab
                key={templateId}
                selected={selectedTemplateId === templateId}
                onClick={() => setSelectedTemplateId(templateId)}
              >
                {template.port_id ?? 'Uncategorized'}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Flex.Item>
        <Flex.Item grow basis={0} ml={2}>
          {actualTemplates.map((actualTemplate) => {
            const isSelected = actualTemplate.id === selected.id;
            return (
              <Section
                title={actualTemplate.name}
                height="2rem"
                key={actualTemplate.id}
                buttons={
                  <Button
                    content={isSelected ? 'Selected' : 'Select'}
                    selected={isSelected}
                    onClick={() =>
                      act('select_template', {
                        id: actualTemplate.id,
                      })
                    }
                  />
                }
              >
                {(!!actualTemplate.description ||
                  !!actualTemplate.admin_notes) && (
                  <LabeledList>
                    {!!actualTemplate.description && (
                      <LabeledList.Item label="Description">
                        {actualTemplate.description}
                      </LabeledList.Item>
                    )}
                    {!!actualTemplate.admin_notes && (
                      <LabeledList.Item label="Admin Notes">
                        {actualTemplate.admin_notes}
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                )}
              </Section>
            );
          })}
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const ShuttleManipulatorModification = (props) => {
  const { act, data } = useBackend();
  const selected = data.selected;
  const existingShuttle = data.existing_shuttle;
  return (
    <Section>
      {selected ? (
        <>
          <Section
            title={'Template: ' + selected.name + ' (' + selected.id + ')'}
          >
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
            <Section
              title={
                'Existing Shuttle: ' +
                existingShuttle.name +
                ' (' +
                existingShuttle.id +
                ')'
              }
            >
              <LabeledList>
                <LabeledList.Item
                  label="Status"
                  buttons={
                    <Button
                      content="Jump To"
                      onClick={() =>
                        act('jump_to', {
                          id: existingShuttle.id,
                        })
                      }
                    />
                  }
                >
                  {existingShuttle.status}
                  {!!existingShuttle.timer && <>({existingShuttle.timeleft})</>}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ) : (
            <Section title="Existing Shuttle: None" />
          )}
          <Section title="Template Actions">
            <Button.Confirm
              content="Load"
              color="good"
              onClick={() =>
                act('load', {
                  id: selected.id,
                })
              }
            />
            <Button
              content="Preview"
              onClick={() =>
                act('preview', {
                  id: selected.id,
                })
              }
            />
            <Button
              content="Replace"
              color="bad"
              onClick={() =>
                act('replace', {
                  id: selected.id,
                })
              }
            />
          </Section>
        </>
      ) : (
        'No shuttle template selected.'
      )}
    </Section>
  );
};
