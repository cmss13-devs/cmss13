import { map } from 'common/collections';
import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { Section, Table } from '../components';
import { Window } from '../layouts';

export const HiveLeaders = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    queens,
    leaders
  } = data;
  return (
    <Window
      title={"Hive Leaders"}
      theme="hive_status"
      resizable
      width={250}
      height={350}
    >
      <Window.Content>
        <Section>
          <Table className="xeno_list">
            <Table.Row header className="xenoListRow">
              <Table.Cell width="100px">Designation</Table.Cell>
              <Table.Cell width="150px">Caste</Table.Cell>
            </Table.Row>

            <Table.Row className="xenoListRow">
              <Table.Cell width="250px">Queen</Table.Cell>
            </Table.Row>

            {map((entry, i) => (
              <Table.Row key={i} >
                <Table.Cell>{entry.designation}</Table.Cell>
                <Table.Cell>{entry.caste_type}</Table.Cell>
              </Table.Row>
            ))(queens)}

            <Table.Row className="xenoListRow">
              <Table.Cell width="250px">Leaders</Table.Cell>
            </Table.Row>

            {map((entry, i) => (
              <Table.Row key={i} >
                <Table.Cell>{entry.designation}</Table.Cell>
                <Table.Cell>{entry.caste_type}</Table.Cell>
              </Table.Row>
            ))(leaders)}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
