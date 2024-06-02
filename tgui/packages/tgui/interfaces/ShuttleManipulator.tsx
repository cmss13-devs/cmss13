import { map } from 'common/collections';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, Flex, LabeledList, Section, Table, Tabs } from '../components';
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
  id: string;
  port_id: string;
  description: string;
  admin_notes: string;
}

interface TemplateGroup {
  port_id: string;
  templates: Array<ShuttleTemplate>;
}

interface ShuttleManipulatorData {
  shuttles: Array<ShuttleData>;
  templates: Record<string, TemplateGroup>;
  selected?: ShuttleTemplate;
  existing_shuttle?: ShuttleData;
}

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
  const { act, data } = useBackend<ShuttleManipulatorData>();
  const shuttles = data.shuttles ?? [];
  return (
    <Section>
      <Table>
        {shuttles.map((shuttle, i) => (
          <Table.Row key={i}>
            <Table.Cell width="11rem">
              <Button
                onClick={() =>
                  act('jump_to', {
                    id: shuttle.id,
                  })
                }
              >
                JMP
              </Button>
              <Button
                disabled={!shuttle.can_fly}
                onClick={() =>
                  act('fly', {
                    id: shuttle.id,
                  })
                }
              >
                Fly
              </Button>
              {shuttle.has_disable === 1 && shuttle.is_disabled === 0 && (
                <Button
                  disabled={!shuttle.can_fly}
                  onClick={() =>
                    act('lock', {
                      id: shuttle.id,
                    })
                  }
                >
                  Disable
                </Button>
              )}
              {shuttle.has_disable === 1 && shuttle.is_disabled === 1 && (
                <Button
                  disabled={!shuttle.can_fly}
                  onClick={() =>
                    act('unlock', {
                      id: shuttle.id,
                    })
                  }
                >
                  Enable
                </Button>
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
                    disabled={!shuttle.can_fast_travel}
                    onClick={() =>
                      act('fast_travel', {
                        id: shuttle.id,
                      })
                    }
                  >
                    Fast Travel
                  </Button>
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
  const { act, data } = useBackend<ShuttleManipulatorData>();
  const templateObject = data.templates;
  const selected = data.selected;
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
            const isSelected = actualTemplate.id === selected?.id;
            return (
              <Section
                title={actualTemplate.name}
                height="2rem"
                key={actualTemplate.id}
                buttons={
                  <Button
                    selected={isSelected}
                    onClick={() =>
                      act('select_template', {
                        id: actualTemplate.id,
                      })
                    }
                  >
                    {isSelected ? 'Selected' : 'Select'}
                  </Button>
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
  const { act, data } = useBackend<ShuttleManipulatorData>();
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
                      onClick={() =>
                        act('jump_to', {
                          id: existingShuttle.id,
                        })
                      }
                    >
                      Jump To
                    </Button>
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
              color="good"
              onClick={() =>
                act('load', {
                  id: selected.id,
                })
              }
            >
              Load
            </Button.Confirm>
            <Button
              onClick={() =>
                act('preview', {
                  id: selected.id,
                })
              }
            >
              Preview
            </Button>
            <Button
              color="bad"
              onClick={() =>
                act('replace', {
                  id: selected.id,
                })
              }
            >
              Replace
            </Button>
          </Section>
        </>
      ) : (
        'No shuttle template selected.'
      )}
    </Section>
  );
};
