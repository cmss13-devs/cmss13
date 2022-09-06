import { useBackend } from '../backend';
import { Button, Section, Flex } from '../components';
import { Window } from '../layouts';

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
  const { act } = useBackend(context);
  const { record } = props;
  const available = record.prod_available > 0

  return (
    <Flex align="stretch" justify="space-between">
      <Flex.Item grow={1}>
        {record.prod_name}
      </Flex.Item>
      <Flex.Item>
        <Button
          fluid={1}
          onClick={() => act('vend', record)}
          disabled={!available}>
          {available ? "vend" : "sold out"}
        </Button>
      </Flex.Item>
    </Flex>)
}

type VendingCategory = {
  category: string,
  records: VendingRecord[]
}

export const VendingSorted = (_, context) => {
  const { data } = useBackend<VendingData>(context);
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
  }

  return (<Window width={500} height={700}>
    <Window.Content scrollable>
        {vendingmap.map((x, i) => (
          <Section title={x.category} key={i}>
            <Flex direction="column">
              {x.records.map(record => (
                <Flex.Item mb={1} key={record.prod_index}>
                  <VendableItem record={record}/>
                </Flex.Item>)
              )}
            </Flex>
          </Section>
        ))}
    </Window.Content>
  </Window>)
}
