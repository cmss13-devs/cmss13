import { map } from 'common/collections';
import { useBackend } from 'tgui/backend';
import { Icon, Section, Table } from 'tgui/components';
import { Window } from 'tgui/layouts';

type HiveEntry = { designation: string; caste_type: string };

type Data = { queens: HiveEntry[]; leaders: HiveEntry[] };

export const HiveLeaders = (props) => {
  const { act, data } = useBackend<Data>();
  const { queens, leaders } = data;
  return (
    <Window title={'Hive Leaders'} theme="hive_status" width={250} height={350}>
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
              <Table.Cell colSpan={3} p={1}>
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
              <Table.Cell colSpan={3} p={1}>
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
