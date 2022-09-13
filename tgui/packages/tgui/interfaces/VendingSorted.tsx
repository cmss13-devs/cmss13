import { useBackend } from '../backend';
import { Button, Section, Flex, Box, Tooltip } from '../components';
import { Window } from '../layouts';
import { logger } from '../logging';

const VENDOR_ITEM_REGULAR = 1
const VENDOR_ITEM_MANDATORY = 2
const VENDOR_ITEM_RECOMMENDED = 3

type VendingRecord = {
  prod_index: number,
  prod_name: string,
  prod_amount: number,
  prod_available: number,
  prod_initial: number,
  prod_color?: number;
  prod_icon: string;
  prod_desc?: string;
}

type VendingCategory = {
  name: string;
  items: VendingRecord[];
}

type VendingData = {
  vendor_name: string;
  theme: string;
  displayed_categories: VendingCategory[];
}

type VenableItem = {
  record: VendingRecord
}

const VendableItem = (props: VenableItem, context) => {
  const { act } = useBackend(context);
  const { record } = props;
  const available = record.prod_available > 0
  const color = record.prod_color == null || record.prod_color == VENDOR_ITEM_REGULAR
    ? "white"
    : record.prod_color == VENDOR_ITEM_MANDATORY
      ? "orange"
      : "green";
  const icon = {__html: record.prod_icon}
  return (
    <Flex align="center" justify="space-between" align-items="stretch">
      <Flex.Item grow={1}>
        <span style={{color: color}}>
          {record.prod_name}
        </span>
      </Flex.Item>

      <Flex.Item>
        <div dangerouslySetInnerHTML={icon}/>
      </Flex.Item>

      <Flex.Item>
        <Box width={5}/>
      </Flex.Item>

      <Flex.Item width={5}>
        <span style={{color: color}}>
          {record.prod_amount}
        </span>
      </Flex.Item>

      <Flex.Item>
        <Box width={5}/>
      </Flex.Item>

      <Flex.Item justify="right">
        <Button
          style={{textAlign: 'center'}}
          onClick={() => act('vend', record)}
          disabled={!available}
          width="80px">
          {available ? "vend" : "SOLD OUT"}
        </Button>
      </Flex.Item>
    </Flex>)
}


export const VendingSorted = (_, context) => {
  const { data } = useBackend<VendingData>(context);
  const categories = data.displayed_categories ?? []
  return (<Window width={600} height={700}>
    <Window.Content scrollable={true}>
        {categories.map((category, i) => (
          <Section title={category.name ?? ""} key={i}>
            <Flex direction="column">
              {category.items.map(record => (
                <Flex.Item mb={1} key={record.prod_index}>
                  <Tooltip position="bottom" content={record.prod_desc}>
                    <VendableItem record={record}/>
                  </Tooltip>
                </Flex.Item>)
              )}
            </Flex>
          </Section>
        ))}
    </Window.Content>
  </Window>)
}
