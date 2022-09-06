import { useBackend } from '../backend';
import { Button, Section, Flex, NoticeBox, Table } from '../components';
import { Loader } from './common/Loader';
import { Window } from '../layouts';
import { logger } from '../logging';
import { TableCell, TableRow } from '../components/Table';

type VendingProps = {

}

type VendingRecord = {
  prod_index: number,
  prod_name: string,
  prod_amount: number,
  prod_available: number,
  prod_color?: number
}

type VendingData = {
  vendor_name: string,
  theme: string,
  displayed_records: VendingRecord[]
}

type VenableItem = {
  record: VendingRecord
}

const VendableItem = (props: VenableItem, context) => {
  return <Flex.Item direction="row">

  </Flex.Item>
}

type VendingCategory = {
  category: string,
  records: VendingRecord[]
}

export const VendingSorted = (props: VendingProps, context) => {
  logger.info("render")
  const { act, data } = useBackend<VendingData>(context);
  const vendingmap = new Array<VendingCategory>();
  let currentCategory:VendingCategory|null = null;

  for (var i of data.displayed_records) {
    if (i.prod_amount === -1) {
      const newCategory: VendingCategory = {
        category: i.prod_name,
        records: []
      }
      currentCategory = newCategory
      vendingmap.push(newCategory)
      continue;
    }
    if (currentCategory === null) {
      const newCategory: VendingCategory = {
        category: "",
        records: []
      }
      currentCategory = newCategory
      vendingmap.push(newCategory)
    }

    currentCategory.records.push(i)
    //logger.info(currentCategory.records)
  }

  return <Window>
    <Window.Content scrollable>
      {vendingmap.map(x => <Section title={x.category}>
        <Table>
          {x.records.map(record =>
            <TableRow>
              <TableCell>
                {record.prod_name}
              </TableCell>
              <TableCell>
                <Button
                  onClick={() => act('vend', record)}
                  disabled={record.prod_available === 0}>
                  vend
                </Button>
              </TableCell>
            </TableRow>
          )}
        </Table>
        </Section>)}
    </Window.Content>
  </Window>
}
