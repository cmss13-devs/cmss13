import { KEY_ESCAPE } from 'common/keycodes';
import { toFixed } from 'common/math';
import { classes } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  Input,
  NoticeBox,
  ProgressBar,
  Section,
  Tooltip,
} from '../components';
import { BoxProps } from '../components/Box';
import { Table, TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

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
  stock_listing_partials?: Array<number>;
  show_points?: boolean;
  current_m_points?: number;
  reagents?: number;
  reagents_max?: number;
}

interface VenableItem {
  readonly record: VendingRecord;
}

interface RecordNameProps extends BoxProps {
  readonly record: VendingRecord;
}

const DescriptionTooltip = (props: RecordNameProps) => {
  const { record } = props;
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;

  return (
    <Tooltip
      position="bottom-start"
      // className={classes(['Tooltip', props.className])}
      content={
        <NoticeBox
          info
          className={classes([
            'Description',
            isRecommended && 'RecommendedDescription',
            isMandatory && 'MandatoryDescription',
          ])}
        >
          <ItemDescriptionViewer
            desc={record.prod_desc ?? ''}
            name={record.prod_name}
            isRecommended={isRecommended}
            isMandatory={isMandatory}
          />
        </NoticeBox>
      }
    >
      {props.children}
    </Tooltip>
  );
};

interface VendButtonProps extends BoxProps {
  readonly isRecommended: boolean;
  readonly isMandatory: boolean;
  readonly available: boolean;
  readonly onClick: () => any;
}

const VendButton = (props: VendButtonProps, _) => {
  return (
    <Button
      className={classes([
        'VendButton',
        props.isRecommended && 'RecommendedVendButton',
        props.isMandatory && 'MandatoryVendButton',
      ])}
      preserveWhitespace
      icon={props.available ? 'circle-down' : 'xmark'}
      onMouseDown={(e) => {
        e.preventDefault();
        if (props.available) {
          props.onClick();
        }
      }}
      textAlign="center"
      disabled={!props.available}
    >
      {props.children}
    </Button>
  );
};

const VendableItemRow = (props: VenableItem) => {
  const { data, act } = useBackend<VendingData>();
  const { record } = props;

  const quantity = data.stock_listing[record.prod_index - 1];
  const available = quantity > 0;
  const partial_quantity =
    data.stock_listing_partials?.[record.prod_index - 1] ?? 0;
  const partialDesignation = partial_quantity > 0 ? '*' : '';
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;

  return (
    <>
      <TableCell className="IconCell" verticalAlign="top">
        <span
          className={classes([`Icon`, `vending32x32`, `${props.record.image}`])}
        />
      </TableCell>

      <TableCell minWidth="3rem">
        <span className={classes(['Text', !available && 'Failure'])}>
          {quantity}
          {partialDesignation}
        </span>
      </TableCell>

      <TableCell className="ButtonCell">
        <VendButton
          isRecommended={isRecommended}
          isMandatory={isMandatory}
          available={available}
          onClick={() => act('vend', record)}
        >
          {record.prod_name}
        </VendButton>
      </TableCell>

      <TableCell>
        <DescriptionTooltip record={record}>
          <Icon
            name="circle-info"
            className={classes(['RegularItemText', 'SmallIcon'])}
          />
        </DescriptionTooltip>
      </TableCell>
    </>
  );
};

const VendableClothingItemRow = (props: {
  readonly record: VendingRecord;
  readonly hasCost: boolean;
}) => {
  const { data, act } = useBackend<VendingData>();
  const { record, hasCost } = props;

  const quantity = data.stock_listing[record.prod_index - 1];
  const available = quantity > 0;
  const isMandatory = record.prod_color === VENDOR_ITEM_MANDATORY;
  const isRecommended = record.prod_color === VENDOR_ITEM_RECOMMENDED;
  const cost = record.prod_cost;

  return (
    <>
      <TableCell className="IconCell" verticalAlign="top">
        <span
          className={classes([`Icon`, `vending32x32`, `${props.record.image}`])}
        />
      </TableCell>

      {hasCost && (
        <TableCell className="Cost">
          <span className={classes(['Text'])}>
            {cost === 0 ? '' : `${cost}P`}
          </span>
        </TableCell>
      )}

      <TableCell>
        <VendButton
          isRecommended={isRecommended}
          isMandatory={isMandatory}
          available={available}
          onClick={() => act('vend', record)}
        >
          {record.prod_name}
        </VendButton>
      </TableCell>

      <TableCell className="IconCell">
        <DescriptionTooltip record={record}>
          <Icon
            name="circle-info"
            className={classes(['ShowDesc', 'RegularItemText', 'SmallIcon'])}
          />
        </DescriptionTooltip>
      </TableCell>
    </>
  );
};

interface VendingCategoryProps {
  readonly category: VendingCategory;
  readonly searchTerm: string;
}

interface DescriptionProps {
  readonly desc: string;
  readonly name: string;
  readonly isMandatory: boolean;
  readonly isRecommended: boolean;
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

export const ViewVendingCategory = (props: VendingCategoryProps) => {
  const { data } = useBackend<VendingData>();
  const { vendor_type } = data;
  const { category, searchTerm } = props;
  const searchFilter = (x: VendingRecord) =>
    x.prod_name.toLocaleLowerCase().includes(searchTerm.toLocaleLowerCase());

  const filteredCategories = category.items.filter(searchFilter);
  if (filteredCategories.length === 0) {
    return null;
  }

  const displayName = category.name ?? '';
  const displayCost =
    vendor_type === 'clothing' || vendor_type === 'gear'
      ? filteredCategories.find((x) => x.prod_cost !== 0) !== undefined
      : true;

  return (
    <Section title={displayName}>
      <Table className="ItemTable">
        {filteredCategories.map((record, i) => {
          return (
            <TableRow
              key={record.prod_index}
              height="30px"
              className={classes([
                'VendingItem',
                i % 2 ? 'VendingFlexAlt' : undefined,
              ])}
            >
              {vendor_type === 'sorted' && <VendableItemRow record={record} />}
              {(vendor_type === 'clothing' || vendor_type === 'gear') && (
                <VendableClothingItemRow
                  record={record}
                  hasCost={displayCost}
                />
              )}
            </TableRow>
          );
        })}
      </Table>
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

export const VendingSorted = () => {
  const { data, act } = useBackend<VendingData>();
  if (data === undefined) {
    return (
      <Window height={800} width={450}>
        no data!
      </Window>
    );
  }
  const categories = data.displayed_categories ?? [];
  const [searchTerm, setSearchTerm] = useState('');
  const isEmpty = categories.length === 0;
  const show_points = data.show_points ?? false;
  const points = data.current_m_points ?? 0;
  const reagents = data.reagents ?? 0;
  const reagents_max = data.reagents_max ?? 0;
  return (
    <Window height={800} width={450} theme={getTheme(data.theme)}>
      <Window.Content
        scrollable
        className="Vendor"
        onKeyDown={(event: any) => {
          const keyCode = window.event ? event.which : event.keyCode;
          if (keyCode === KEY_ESCAPE) {
            act('cancel');
          }
        }}
      >
        {!isEmpty && !show_points && (
          <Box className={classes(['SearchBox'])}>
            <Flex
              align="center"
              justify="space-between"
              align-items="stretch"
              className="Section__title"
            >
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
            {reagents_max > 0 && (
              <Flex
                align="center"
                justify="space-between"
                align-items="stretch"
              >
                <Flex.Item>
                  <span className="Section__content">Reagents</span>
                </Flex.Item>
                <Flex.Item grow>
                  <ProgressBar value={reagents} maxValue={reagents_max}>
                    {toFixed(reagents) + ' units'}
                  </ProgressBar>
                </Flex.Item>
              </Flex>
            )}
          </Box>
        )}

        {!isEmpty && show_points && (
          <Box className={classes(['SearchBox'])}>
            <Flex
              align="center"
              justify="space-between"
              align-items="stretch"
              className="Section__title"
            >
              <Flex.Item>
                <span className="Section__titleText">Points Remaining</span>
              </Flex.Item>
              <Flex.Item>
                <span>{points}</span>
              </Flex.Item>
            </Flex>
          </Box>
        )}

        {isEmpty && (
          <NoticeBox danger className="ItemContainer">
            Nothing in here seems to be for you. If this is a mistake contact
            your local administrator.
          </NoticeBox>
        )}

        {!isEmpty && (
          <Box className="ItemContainer">
            <Flex direction="column" fill={1}>
              {categories.map((category, i) => (
                <Flex.Item key={i} className="Category">
                  <ViewVendingCategory
                    searchTerm={searchTerm}
                    category={category}
                  />
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
