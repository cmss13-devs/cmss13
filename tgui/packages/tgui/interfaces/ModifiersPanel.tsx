import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Button, Section, Table } from 'tgui/components';
import { Window } from 'tgui/layouts';

type ModifiersList = {
  all_modifiers: {
    path: string;
    name: string;
    desc: string;
    state: BooleanLike;
  }[];
};

export const ModifiersPanel = (props) => {
  const { data, act } = useBackend<ModifiersList>();
  const { all_modifiers } = data;

  return (
    <Window width={900} height={600} theme="crtblue">
      <Window.Content>
        <Section fill scrollable>
          <Table>
            {all_modifiers.map((modifier, index) => (
              <Table.Row key={index}>
                <Table.Cell
                  bold
                  textAlign="center"
                  verticalAlign="middle"
                  p="4px"
                >
                  {modifier.name}
                </Table.Cell>
                <Table.Cell textAlign="center" verticalAlign="middle" p="4px">
                  {modifier.desc}
                </Table.Cell>
                <Table.Cell textAlign="center" verticalAlign="middle" p="4px">
                  <Button.Checkbox
                    checked={modifier.state}
                    onClick={() =>
                      act('set_modifier_state', {
                        name: modifier.name,
                        path: modifier.path,
                        state: !modifier.state,
                      })
                    }
                  >
                    {modifier.state ? 'Enabled' : 'Disabled'}
                  </Button.Checkbox>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
