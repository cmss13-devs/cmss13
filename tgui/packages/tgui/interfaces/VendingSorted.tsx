import { useBackend, useLocalState } from '../backend';
import { Button, Section, Flex, Box, Tooltip, Input } from '../components';
import { Window } from '../layouts';
import { classes } from 'common/react';

const THEME_COMP = 0;
const THEME_USCM = 1;
const THEME_CLF = 2;
const THEME_UPP = 3;

const VENDOR_ITEM_REGULAR = 1;
const VENDOR_ITEM_MANDATORY = 2;
const VENDOR_ITEM_RECOMMENDED = 3;

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
  const { act } = useBackend(context);
  const { record } = props;
  const available = record.prod_available > 0;
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;

  return (
    <Flex align="center" justify="space-between" align-items="stretch">
      <Flex.Item>
        <img className="VendingSorted__Icon" src={record.prod_icon.href} />
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>

      <Flex.Item grow={1}>
        <span className={classes([
          'VendingSorted__Text',
          'VendingSorted__RegularItemText',
          isMandatory && 'VendingSorted__MandatoryItemText',
          isRecommended && 'VendingSorted__RecommendedItemText',
        ])}>
          {record.prod_name}
        </span>
      </Flex.Item>

      <Flex.Item width={5}>
        <span className={classes(['VendingSorted__Text'])}>
          {record.prod_amount}
        </span>
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>

      <Flex.Item justify="right">
        <Button
          className={classes(["VendingSorted__Button", 'VendingSorted__VendButton'])}
          preserveWhitespace
          icon={available ? "eject" : null}
          onClick={() => act('vend', record)}
          textAlign="center"
          disabled={!available}
          content={available ? "vend" : "SOLD OUT"} />
      </Flex.Item>
    </Flex>);
};

type VendingCategoryProps = {
  category: VendingCategory;
}

export const ViewVendingCategory = (props: VendingCategoryProps, context) => {
  const { category } = props;
  const [searchTerm, _] = useLocalState(context, 'searchTerm', "");
  const searchFilter = (x: VendingRecord) =>
    x.prod_name.toLocaleLowerCase().includes(searchTerm.toLocaleLowerCase());

  const filteredCategories = category.items.filter(searchFilter);
  if (filteredCategories.length === 0) {
    return null;
  }

  return (
    <Section title={category.name ?? ""}>
      <Flex direction="column">
        {filteredCategories.map(record => (
          <Flex.Item mb={1} key={record.prod_index}>
            <Tooltip position="bottom" content={record.prod_desc}>
              <VendableItem record={record} />
            </Tooltip>
          </Flex.Item>)
        )}
      </Flex>
    </Section>);

};


const getTheme = (value: string | number): string => {
  switch (value) {
    case THEME_UPP:
      return "abductor";
    case THEME_CLF:
      return "retro";
    case THEME_COMP:
      return "weyland";
    default:
      return "usmc";
  }
};

export const VendingSorted = (_, context) => {
  const { data } = useBackend<VendingData>(context);
  const categories = data.displayed_categories ?? [];
  const [searchTerm, setSearchTerm] = useLocalState(context, 'searchTerm', "");
  return (
    <Window
      width={600}
      height={700}
      theme={getTheme(data.theme)}
    >
      <Window.Content scrollable>
        <Box className={classes([
          "VendingSorted__SearchBox",
        ])}>
          <Flex align="center" justify="space-between" align-items="stretch" className="Section__title">
            <Flex.Item>
              <span className="Section__titleText">Search</span>
            </Flex.Item>
            <Flex.Item>
              <Input
                value={searchTerm}
                onInput={(_, value) => setSearchTerm(value)}
                width="160px"
              />
            </Flex.Item>
          </Flex>
        </Box>

        <Box className="VendingSorted__ItemContainer">
          <Flex direction="column">
            {categories.map((category, i) => (
              <Flex.Item key={i} className="VendingSorted__Category">
                <ViewVendingCategory category={category} />
              </Flex.Item>))}
          </Flex>
        </Box>
      </Window.Content>

    </Window>);
};
