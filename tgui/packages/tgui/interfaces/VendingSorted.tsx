import { useBackend, useLocalState } from '../backend';
import { Button, Section, Flex, Box, Tooltip, Input, NoticeBox, Icon } from '../components';
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
  stock_listing: Array<number>;
}

type VenableItem = {
  record: VendingRecord
}

const VendableItem = (props: VenableItem, context) => {
  const { data, act } = useBackend<VendingData>(context);
  const { record } = props;
  const available = record.prod_available > 0;
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;
  return (
    <Flex align="center" justify="space-between" align-items="stretch" className="VendingSorted__ItemBox">
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
          {record.prod_name} <Icon name="circle-info" />
        </span>
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>

      <Flex.Item width={5}>
        <span className={classes(['VendingSorted__Text', !available && 'VendingSorted__Failure'])}>
          {data.stock_listing[record.prod_index - 1]}
        </span>
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>
      <Flex.Item justify="right">
        <Button
          className={classes(["VendingSorted__Button", 'VendingSorted__VendButton'])}
          preserveWhitespace
          icon={available ? "eject" : "xmark"}
          onClick={() => act('vend', record)}
          textAlign="center"
          disabled={!available} />
      </Flex.Item>
    </Flex>);
};

type VendingCategoryProps = {
  category: VendingCategory;
}

type DescriptionProps = {
  desc: string;
  name: string;
}

const ItemDescriptionViewer = (props: DescriptionProps, context) => {
  return (<Section title={props.name}>
    <span>{props.desc}</span>
  </Section>);
};

export const ViewVendingCategory = (props: VendingCategoryProps, context) => {
  const { data } = useBackend<VendingData>(context);
  const { category } = props;
  const [searchTerm, _] = useLocalState(context, 'searchTerm', "");
  const searchFilter = (x: VendingRecord) =>
    x.prod_name.toLocaleLowerCase().includes(searchTerm.toLocaleLowerCase());

  const filteredCategories = category.items.filter(searchFilter);
  if (filteredCategories.length === 0) {
    return null;
  }

  return (
    <Section title={category.name ?? ""} className="VendingSorted__CategorySection">
      <Flex direction="column" className="VendingSorted__ItemFlex">
        {filteredCategories
          .sort((a, b) => a.prod_name.localeCompare(b.prod_name))
          .map((record, i) =>
          {
            const isLast = (filteredCategories.length - 1) === i;
            return (
              <Flex.Item mb={1} key={record.prod_index}>
                <Tooltip
                  position="bottom"
                  content={<NoticeBox
                    info
                    className="VendingSorted__Description"
                  > <ItemDescriptionViewer desc={record.prod_desc ?? ""} name={record.prod_name} />
                           </NoticeBox>}
                >
                  <VendableItem record={record} />
                </Tooltip>
                {!isLast && <hr className="VendingSorted__ItemSeparator" />}
              </Flex.Item>);
          }
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
                autoFocus
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
              <Flex.Item key={i} className={"VendingSorted__Category"}>
                <ViewVendingCategory category={category} />
              </Flex.Item>))}
          </Flex>
        </Box>
      </Window.Content>

    </Window>);
};
