import { classes } from 'common/react';
import { capitalizeAll } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import { ElectricalPanel } from './common/ElectricalPanel';

type VendingData = {
  department: string;
  product_records: ProductRecord[];
  coin_records: CoinRecord[];
  hidden_records: HiddenRecord[];
  user: UserData;
  stock: StockItem[];
  extended_inventory: boolean;
  access: boolean;
  categories: Record<string, Category>;
  checking_id: boolean;
};

type Category = {
  icon: string;
};

type ProductRecord = {
  path: string;
  name: string;
  price: number;
  max_amount: number;
  ref: string;
  category: string;
};

type CoinRecord = ProductRecord & {
  premium: boolean;
};

type HiddenRecord = ProductRecord & {
  premium: boolean;
};

type UserData = {
  name: string;
  cash: number;
  job?: string;
};

type StockItem = {
  name: string;
  amount: number;
  colorable: boolean;
};

const getInventory = () => {
  const { data } = useBackend<VendingData>();
  const {
    product_records = [],
    coin_records = [],
    hidden_records = [],
    extended_inventory,
  } = data;

  if (extended_inventory) {
    return [...product_records, ...coin_records, ...hidden_records];
  }

  return [...product_records, ...coin_records];
};

export const Vending = (props) => {
  const { data } = useBackend<VendingData>();
  const { categories } = data;

  const [selectedCategory, setSelectedCategory] = useState<string>(
    Object.keys(categories)[0],
  );

  const inventory = getInventory();

  const filteredCategories = Object.fromEntries(
    Object.entries(categories).filter(([categoryName]) => {
      return inventory.find((product) => {
        if ('category' in product) {
          return product.category === categoryName;
        } else {
          return false;
        }
      });
    }),
  );

  return (
    <Window width={450} height={600}>
      <Window.Content className={'vending-goods'}>
        <Stack fill vertical>
          <Stack.Item>
            <UserDetails />
          </Stack.Item>
          <Stack.Item grow>
            <ProductDisplay selectedCategory={selectedCategory} />
          </Stack.Item>

          {Object.keys(filteredCategories).length > 1 && (
            <Stack.Item>
              <CategorySelector
                categories={filteredCategories}
                selectedCategory={selectedCategory!}
                onSelect={setSelectedCategory}
              />
            </Stack.Item>
          )}
          <Stack.Item>
            <ElectricalPanel />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Displays user details if an ID is present and the user is on the station */
export const UserDetails = (props) => {
  const { data } = useBackend<VendingData>();
  const { user, checking_id } = data;

  if (!user) {
    return (
      <NoticeBox>No ID detected! Contact your nearest supervisor.</NoticeBox>
    );
  }
  return (
    <Section>
      <Stack>
        <Stack.Item>
          <Icon name="id-card" size={3} mr={1} />
        </Stack.Item>
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="User">
              {checking_id ? user.name : 'UNKNOWN'}
            </LabeledList.Item>
            <LabeledList.Item label="Occupation">
              {checking_id ? user.job || 'Unemployed' : 'UNKNOWN'}
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

/** Displays  products in a section, with user balance at top */
const ProductDisplay = (props: {
  readonly selectedCategory: string | null;
}) => {
  const { data } = useBackend<VendingData>();
  const { selectedCategory } = props;
  const { stock, user, checking_id } = data;

  const inventory = getInventory();

  const display_value = user && checking_id;

  return (
    <Section
      fill
      scrollable
      title="Products"
      buttons={
        !!display_value && (
          <Box fontSize="16px" color="green">
            ${(user && user.cash) || 0} <Icon name="coins" color="gold" />
          </Box>
        )
      }
    >
      <Table>
        {inventory
          .filter((product) => {
            if ('category' in product) {
              return product.category === selectedCategory;
            } else {
              return true;
            }
          })
          .map((product) => (
            <VendingRow
              key={product.name}
              product={product}
              productStock={stock[product.name]}
            />
          ))}
      </Table>
    </Section>
  );
};

/** An individual listing for an item.
 * Uses a table layout. Labeledlist might be better,
 * but you cannot use item icons as labels currently.
 */
const VendingRow = (props) => {
  const { data } = useBackend<VendingData>();
  const { product, productStock } = props;
  const { access, user, checking_id } = data;
  const remaining = productStock.amount;
  const denied = checking_id && (!user || !access);
  const disabled =
    denied || remaining === 0 || (checking_id && product.price > user?.cash);

  return (
    <Table.Row>
      <Table.Cell collapsing>
        <ProductImage product={product} />
      </Table.Cell>
      <Table.Cell bold>{capitalizeAll(product.name)}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <ProductStock product={product} remaining={remaining} />
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <ProductButton disabled={disabled} product={product} denied={denied} />
      </Table.Cell>
    </Table.Row>
  );
};

/** Displays the product image. Displays a default if there is none. */
const ProductImage = (props) => {
  const { product } = props;

  return (
    <span
      className={classes(['goods-vending32x32', product.path, 'product-image'])}
    />
  );
};

/** Displays a colored indicator for remaining stock */
const ProductStock = (props) => {
  const { product, remaining } = props;

  return (
    <Box
      color={
        (remaining <= 0 && 'bad') ||
        (remaining <= product.max_amount / 2 && 'average') ||
        'good'
      }
    >
      {remaining} left
    </Box>
  );
};

/** The main button to purchase an item. */
const ProductButton = (props) => {
  const { act, data } = useBackend<VendingData>();
  const { denied, disabled, product } = props;
  const { checking_id } = data;

  const price = product.price && checking_id ? '$' + product.price : 'FREE';
  return (
    <Button
      fluid
      disabled={disabled}
      tooltip={denied ? 'Access Denied' : ''}
      onClick={() =>
        act('vend', {
          ref: product.ref,
        })
      }
    >
      {product.category === 'Premium' ? 'COIN' : price}
    </Button>
  );
};

const CATEGORY_COLORS = {
  Contraband: 'red',
  Premium: 'yellow',
};

const CategorySelector = (props: {
  readonly categories: Record<string, Category>;
  readonly selectedCategory: string;
  readonly onSelect: (category: string) => void;
}) => {
  const { categories, selectedCategory, onSelect } = props;

  return (
    <Section>
      <Stack fill>
        <Stack.Item>
          {Object.entries(categories).map(([name, category]) => (
            <Button
              key={name}
              selected={name === selectedCategory}
              color={CATEGORY_COLORS[name]}
              icon={category.icon}
              onClick={() => onSelect(name)}
            >
              {name}
            </Button>
          ))}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
