import { map } from 'common/collections';

import { useBackend } from '../backend';
import { Icon, Section, Table } from '../components';
import { Window } from '../layouts';

export const HiveLeaders = (props) => {
  const { act, data } = useBackend();
  const { queens, leaders } = data;
  return (
    <Window
      title={'Hive Leaders'}
      theme="hive_status"
      resizable
      width={250}
      height={350}
    >
      <Window.Content>
        <Section>
          <Table className="xeno_list">
            <Table.Row header className="xenoListRow">
              <Table.Cell width="5%" className="noPadCell" />
              <Table.Cell textAlign="left">Designation</Table.Cell>
              <Table.Cell textAlign="left">Caste</Table.Cell>
            </Table.Row>

            <Table.Row
              className="xenoListRow"
              backgroundColor="xeno"
              height="25px"
              lineHeight="5px"
            >
              <Table.Cell colspan={3} p={1}>
                Queen
              </Table.Cell>
            </Table.Row>

            {map(queens, (entry, i) => (
              <Table.Row key={i}>
                <Table.Cell className="noPadCell">
                  <div unselectable="on" className="leaderIcon">
                    <Icon name="star" ml={0.2} />
                  </div>
                </Table.Cell>
                <Table.Cell>{entry.designation}</Table.Cell>
                <Table.Cell>{entry.caste_type}</Table.Cell>
              </Table.Row>
            ))}

            <Table.Row
              className="xenoListRow"
              backgroundColor="xeno"
              height="25px"
              lineHeight="5px"
            >
              <Table.Cell colspan={3} p={1}>
                Leaders
              </Table.Cell>
            </Table.Row>

            {map(leaders, (entry, i) => (
              <Table.Row key={i}>
                <Table.Cell className="noPadCell">
                  <div unselectable="on" className="leaderIcon">
                    <Icon name="star" ml={0.2} />
                  </div>
                </Table.Cell>
                <Table.Cell>{entry.designation}</Table.Cell>
                <Table.Cell>{entry.caste_type}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
