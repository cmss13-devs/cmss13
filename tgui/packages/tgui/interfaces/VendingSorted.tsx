import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Section,
  Flex,
  Box,
  Tooltip,
  Input,
  NoticeBox,
  Icon,
} from '../components';
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
};

type VendingRecord = {
  prod_index: number;
  prod_name: string;
  prod_available: number;
  prod_initial: number;
  prod_color?: number;
  prod_icon: IconRecord;
  prod_desc?: string;
};

type VendingCategory = {
  name: string;
  items: VendingRecord[];
};

type VendingData = {
  vendor_name: string;
  theme: string;
  displayed_categories: VendingCategory[];
  stock_listing: Array<number>;
};

type VenableItem = {
  record: VendingRecord;
};

type RecordNameProps = {
  record: VendingRecord;
};

const RecordName = (props: RecordNameProps) => {
  const { record } = props;
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;

  const description = record.prod_desc;

  const display_text = () => {
    return (
      <span
        className={classes([
          'VendingSorted__Text',
          'VendingSorted__RegularItemText',
          'VendingSorted__HideDesc',
          isMandatory && 'VendingSorted__MandatoryItemText',
          isRecommended && 'VendingSorted__RecommendedItemText',
        ])}>
        {record.prod_name}{' '}
        {description && (
          <Icon name="circle-info" className="VendingSorted__ShowDesc" />
        )}
      </span>
    );
  };

  if (!description) {
    return display_text();
  }
  return (
    <Tooltip
      position="bottom-start"
      content={
        <NoticeBox info className="VendingSorted__Description">
          <ItemDescriptionViewer
            desc={record.prod_desc ?? ''}
            name={record.prod_name}
          />
        </NoticeBox>
      }>
      {display_text()}
    </Tooltip>
  );
};

const VendableItem = (props: VenableItem, context) => {
  const { data, act } = useBackend<VendingData>(context);
  const { record } = props;

  const quantity = data.stock_listing[record.prod_index - 1];
  const available = quantity > 0;
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;

  return (
    <Flex
      align="center"
      justify="space-between"
      align-items="stretch"
      className="VendingSorted__ItemBox">
      <Flex.Item>
        <img
          className="VendingSorted__Icon"
          alt={record.prod_name}
          src={record.prod_icon.href}
        />
      </Flex.Item>

      <Flex.Item justify="right">
        <Button
          className={classes([
            'VendingSorted__Button',
            'VendingSorted__VendButton',
            isRecommended && 'VendingSorted__RecommendedVendButton',
            isMandatory && 'VendingSorted__MandatoryVendButton',
          ])}
          preserveWhitespace
          icon={available ? 'circle-down' : 'xmark'}
          onClick={() => act('vend', record)}
          textAlign="center"
          disabled={!available}
        />
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>

      <Flex.Item width={2}>
        <span
          className={classes([
            'VendingSorted__Text',
            !available && 'VendingSorted__Failure',
          ])}>
          {quantity}
        </span>
      </Flex.Item>

      <Flex.Item grow={1}>
        <RecordName record={record} />
      </Flex.Item>
    </Flex>
  );
};

type VendingCategoryProps = {
  category: VendingCategory;
};

type DescriptionProps = {
  desc: string;
  name: string;
};

const ItemDescriptionViewer = (props: DescriptionProps, context) => {
  return (
    <Section title={props.name}>
      <span>{props.desc}</span>
    </Section>
  );
};

export const ViewVendingCategory = (props: VendingCategoryProps, context) => {
  const { category } = props;
  const [searchTerm, _] = useLocalState(context, 'searchTerm', '');
  const searchFilter = (x: VendingRecord) =>
    x.prod_name.toLocaleLowerCase().includes(searchTerm.toLocaleLowerCase());

  const filteredCategories = category.items.filter(searchFilter);
  if (filteredCategories.length === 0) {
    return null;
  }

  return (
    <Section
      title={category.name ?? ''}
      className="VendingSorted__CategorySection">
      <Flex direction="column" className="VendingSorted__ItemFlex">
        {filteredCategories
          .sort((a, b) => a.prod_name.localeCompare(b.prod_name))
          .map((record, i) => {
            const isLast = filteredCategories.length - 1 === i;
            return (
              <Flex.Item mb={1.2} key={record.prod_index}>
                <VendableItem record={record} />
                {!isLast && <hr className="VendingSorted__ItemSeparator" />}
              </Flex.Item>
            );
          })}
      </Flex>
    </Section>
  );
};

const getTheme = (value: string | number): string => {
  switch (value) {
    case THEME_UPP:
      return 'abductor';
    case THEME_CLF:
      return 'retro';
    case THEME_COMP:
      return 'weyland';
    default:
      return 'usmc';
  }
};

export const VendingSorted = (_, context) => {
  const { data } = useBackend<VendingData>(context);
  const categories = data.displayed_categories ?? [];
  const [searchTerm, setSearchTerm] = useLocalState(context, 'searchTerm', '');
  const isEmpty = categories.length === 0;
  return (
    <Window height={800} width={400} theme={getTheme(data.theme)}>
      <Window.Content scrollable>
        {!isEmpty && (
          <Box className={classes(['VendingSorted__SearchBox'])}>
            <Flex
              align="center"
              justify="space-between"
              align-items="stretch"
              className="Section__title">
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
        )}

        {isEmpty && (
          <NoticeBox danger className="VendingSorted__ItemContainer">
            Nothing in here seems to be for you. If this is a mistake contact
            your local administrator.
          </NoticeBox>
        )}

        {!isEmpty && (
          <Box className="VendingSorted__ItemContainer">
            <Flex direction="column">
              {categories.map((category, i) => (
                <Flex.Item key={i} className={'VendingSorted__Category'}>
                  <ViewVendingCategory category={category} />
                </Flex.Item>
              ))}
              <Flex.Item height={15}>&nbsp;</Flex.Item>
            </Flex>
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};
