import { useBackend, useLocalState } from '../backend';
import { Button, Section, Flex, Box, Tooltip, TextArea, NoticeBox, Input } from '../components';
import { Window } from '../layouts';
import { logger } from '../logging';

const THEME_COMP = 0;
const THEME_USCM = 1;
const THEME_CLF = 2;
const THEME_UPP = 3;

const VENDOR_ITEM_REGULAR = 1
const VENDOR_ITEM_MANDATORY = 2
const VENDOR_ITEM_RECOMMENDED = 3

type IconRecord = {
  icon_sheet: string;
  icon_state: string;
  href: string;
}

type VendingRecord = {
  prod_index: number,
  prod_name: string,
  prod_amount: number,
  prod_available: number,
  prod_initial: number,
  prod_color?: number;
  prod_icon: IconRecord;
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
  const [searchTerm, _] = useLocalState(context, 'searchTerm', "");
  const { act } = useBackend(context);
  const { record } = props;
  const available = record.prod_available > 0
  const color = record.prod_color == null || record.prod_color == VENDOR_ITEM_REGULAR
    ? "white"
    : record.prod_color == VENDOR_ITEM_MANDATORY
      ? "orange"
      : "green";
  if (!record.prod_name.toLocaleLowerCase().includes(searchTerm.toLocaleLowerCase())) {
    return <></>
  }
  const vendstyle = {
    textAlign: 'center',
    margin: '0 auto',
    display: 'block'
  }
  return (
    <Flex align="center" justify="space-between" align-items="stretch">
      <Flex.Item>
        <img src={record.prod_icon.href} style={{width: "150%"}}/>
      </Flex.Item>

      <Flex.Item>
        <Box width={5}/>
      </Flex.Item>

      <Flex.Item grow={1}>
        <span style={{color: color}}>
          {record.prod_name}
        </span>
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
          icon="eject"
          onClick={() => act('vend', record)}
          disabled={!available}
          width="90px">
            {available ? "vend" : "SOLD OUT"}
            </Button>
      </Flex.Item>
    </Flex>)
}

type VendingCategoryProps = {
  category: VendingCategory;
  key: any;
}

export const ViewVendingCategory = (props: VendingCategoryProps, context) => {
  const {category, key} = props;

  return <Section title={category.name ?? ""} key={key}>
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
}


function getTheme(value: string|number): string {
  switch (value) {
    case THEME_UPP:
      return "abductor"
    case THEME_CLF:
      return "retro"
    case THEME_COMP:
      return "weyland"
    default:
      return "usmc"
  }
}

export const VendingSorted = (_, context) => {
  const { data } = useBackend<VendingData>(context);
  const categories = data.displayed_categories ?? []
  const [searchTerm, setSearchTerm] = useLocalState(context, 'searchTerm', "");
  return (<Window
      width={600}
      height={700}
      theme={getTheme(data.theme)}
    >
    <Window.Content scrollable={true}>
      <Box className='Section'>
        <Flex align="center" justify="space-between" align-items="stretch" className="Section__title">
          <Flex.Item>
              <span className="Section__titleText">Search</span>
          </Flex.Item>
          <Flex.Item>
            <Input
                style={{border: '1px solid white', color: 'white'}}

                value={searchTerm}
                onInput={(_, value) => setSearchTerm(value)}
                width="160px"
              />
          </Flex.Item>
        </Flex>
      </Box>
        {categories.map((category, i) => (<ViewVendingCategory category={category} key={i}/>))}
    </Window.Content>
  </Window>)
}
