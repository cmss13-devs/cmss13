import { KEY_ESCAPE } from 'common/keycodes';
import { useBackend, useLocalState } from '../backend';
import { Button, Section, Stack, Flex, Box, Tooltip, Input, NoticeBox, Icon } from '../components';
import { Window } from '../layouts';
import { classes } from 'common/react';
import { BoxProps } from '../components/Box';

const THEME_COMP = 0;
const THEME_USCM = 1;
const THEME_CLF = 2;
const THEME_UPP = 3;

const VENDOR_ITEM_REGULAR = 1;
const VENDOR_ITEM_MANDATORY = 2;
const VENDOR_ITEM_RECOMMENDED = 3;

interface VendingRecord {
  prod_index: number;
  prod_name: string;
  prod_available: number;
  prod_initial: number;
  prod_color?: number;
  prod_desc?: string;
  prod_cost: number;
  image: string;
}

interface VendingCategory {
  name: string;
  items: VendingRecord[];
}

interface VendingData {
  vendor_name: string;
  vendor_type: string;
  theme: string;
  displayed_categories: VendingCategory[];
  stock_listing: Array<number>;
  show_points?: boolean;
  current_m_points?: number;
}

interface VenableItem {
  record: VendingRecord;
}

interface RecordNameProps extends BoxProps{
  record: VendingRecord;
}

const DescriptionTooltip = (props: RecordNameProps, context) => {
  const { record } = props;
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;

  return (
    <Tooltip
      position="bottom-start"
      className={classes(["VendingSorted__Tooltip", props.className])}
      content={(
        <NoticeBox
          info
          className={classes([
            "VendingSorted__Description",
            isRecommended && "VendingSorted_RecommendedDescription",
            isMandatory && "VendingSorted_MandatoryDescription",
          ])}
        >
          <ItemDescriptionViewer
            desc={record.prod_desc ?? ""}
            name={record.prod_name}
            isRecommended={isRecommended}
            isMandatory={isMandatory} />
        </NoticeBox>
      )}
    >
      {props.children}
    </Tooltip>);
};

interface VendButtonProps extends BoxProps{
  isRecommended: boolean;
  isMandatory: boolean;
  available: boolean;
  onClick: () => any;
}

const VendButton = (props: VendButtonProps, _) => {
  return (
    <Button
      className={classes([
        'VendingSorted__VendButton',
        props.isRecommended && 'VendingSorted__RecommendedVendButton',
        props.isMandatory && 'VendingSorted__MandatoryVendButton',
      ])}
      preserveWhitespace
      icon={props.text ? undefined : (props.available ? "circle-down" : "xmark")}
      onMouseDown={(e) => {
        e.preventDefault();
        props.onClick();
      }}
      textAlign="center"
      disabled={!props.available}>
      {props.children}
    </Button>
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
      align-items="center"
    >
      <Flex.Item>
        <span className={classes([
          `VendingSorted__Icon`,
          `vending32x32`,
          `${props.record.image}`,
        ])} />
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>

      <Flex.Item width={2}>
        <span className={classes(['VendingSorted__Text', !available && 'VendingSorted__Failure'])}>
          {quantity}
        </span>
      </Flex.Item>

      <Flex.Item grow={1}>
        <VendButton
          isRecommended={isRecommended}
          isMandatory={isMandatory}
          available={available}
          onClick={() => act('vend', record)}
        >
          {record.prod_name}
        </VendButton>
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>

      <Flex.Item>
        <DescriptionTooltip record={record}>
          <Icon name="circle-info" className={classes(["VendingSorted__RegularItemText"])} />
        </DescriptionTooltip>
      </Flex.Item>
    </Flex>
  );
};

const VendableClothingItem = (props: VenableItem, context) => {
  const { data, act } = useBackend<VendingData>(context);
  const { record } = props;

  const quantity = data.stock_listing[record.prod_index - 1];
  const available = quantity > 0;
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;
  const cost = record.prod_cost;

  return (
    <Flex
      align="center"
      justify="space-between"
      align-items="center"
    >
      <Flex.Item>
        <span className={classes([
          `VendingSorted__Icon`,
          `vending32x32`,
          `${props.record.image}`,
        ])} />
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>

      {cost !== 0
        && (
          <Flex.Item className="VendingSorted__Cost">
            <span className={classes([
              "VendingSorted__Text",
            ])}>
              {cost === 0 ? undefined : `${cost}P`}
            </span>
          </Flex.Item>
        )}

      <Flex.Item grow={1}>
        <VendButton
          isRecommended={isRecommended}
          isMandatory={isMandatory}
          available={available}
          onClick={() => act('vend', record)}
        >
          {record.prod_name}
        </VendButton>
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>

      <Flex.Item>
        <DescriptionTooltip record={record}>
          <Icon name="circle-info" className={classes(["VendingSorted__ShowDesc", "VendingSorted__RegularItemText"])} />
        </DescriptionTooltip>
      </Flex.Item>

      <Flex.Item>
        <Box className="VendingSorted__Spacer" />
      </Flex.Item>
    </Flex>
  );
};

interface VendingCategoryProps {
  category: VendingCategory;
}

interface DescriptionProps {
  desc: string;
  name: string;
  isMandatory: boolean;
  isRecommended: boolean;
}

const ItemDescriptionViewer = (props: DescriptionProps, _) => {
  const { name, desc, isMandatory, isRecommended } = props;
  const generateTitle = () => {
    if (isMandatory) {
      return `Mandatory: ${name}`;
    }
    if (isRecommended) {
      return `Recommended: ${name}`;
    }
    return name;
  };

  return (
    <Section title={generateTitle()}>
      <span>{desc}</span>
    </Section>
  );
};

export const ViewVendingCategory = (props: VendingCategoryProps, context) => {
  const { data } = useBackend<VendingData>(context);
  const { vendor_type } = data;
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
      <Stack
        vertical
        fill
        className="VendingSorted__CategorySection"
      >
        {filteredCategories
          .sort(data.vendor_type === "clothing" ? undefined : (a, b) => a.prod_name.localeCompare(b.prod_name))
          .map((record, i) =>
          {
            return (
              <Stack.Item
                key={record.prod_index}
                className={classes([
                  "VendingItem",
                  i % 2 ? "VendingFlexAlt" : undefined,
                ])}
              >
                {vendor_type === "sorted" && <VendableItem record={record} />}
                {vendor_type === "clothing" && <VendableClothingItem record={record} />}
              </Stack.Item>
            );
          })}
      </Stack>
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
  const { data, act } = useBackend<VendingData>(context);
  const categories = data.displayed_categories ?? [];
  const [searchTerm, setSearchTerm] = useLocalState(context, 'searchTerm', "");
  const isEmpty = categories.length === 0;
  const show_points = data.show_points ?? false;
  const points = data.current_m_points ?? 0;
  return (
    <Window
      height={800}
      width={400}
      theme={getTheme(data.theme)}
    >
      <Window.Content scrollable
        onKeyDown={(event: any) => {
          const keyCode = window.event ? event.which : event.keyCode;
          if (keyCode === KEY_ESCAPE) {
            act('cancel');
          }
        }}>
        {!isEmpty && !show_points
          && (
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
          )}

        {!isEmpty && show_points && (
          <Box className={classes([
            "VendingSorted__SearchBox",
          ])}>
            <Flex align="center" justify="space-between" align-items="stretch" className="Section__title">
              <Flex.Item>
                <span className="Section__titleText">Points Remaining</span>
              </Flex.Item>
              <Flex.Item>
                <span>{points}</span>
              </Flex.Item>
            </Flex>
          </Box>
        )}

        {isEmpty
          && (
            <NoticeBox danger className="VendingSorted__ItemContainer">
              Nothing in here seems to be for you.
              If this is a mistake contact your local administrator.
            </NoticeBox>
          )}

        {!isEmpty
          && (
            <Box className="VendingSorted__ItemContainer">
              <Flex direction="column" fill>
                {categories.map((category, i) => (
                  <Flex.Item key={i} className="VendingSorted__Category">
                    <ViewVendingCategory category={category} />
                  </Flex.Item>))}
                <Flex.Item height={15}>
                &nbsp;
                </Flex.Item>
              </Flex>
            </Box>
          )}
      </Window.Content>
    </Window>);
};
