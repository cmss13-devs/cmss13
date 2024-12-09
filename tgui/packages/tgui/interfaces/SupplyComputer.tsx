import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, DmIcon, Section, Stack } from '../components';
import { Window } from '../layouts';

type Order = {
  order_num: string;
  item: string;
  ordered_by: string;
  approved_by: string;
};

type Icon = {
  icon: string;
  icon_state: string;
};

type Item = {
  name: string;
  quantity: number;
  icon: Icon;
};

type CurrentOrderPack = {
  quantity: number;
} & Pack;

type Pack = {
  name: string;
  cost: number;
  dollar_cost: number;
  contains: Item[];
  icon: Icon;
  category: string;
  type: string;
};

type SupplyComputerData = {
  categories: string[];
  contraband_categories: string[];
  all_items: Pack[];
  current_order: CurrentOrderPack[];
  used_points: number;
  points: number;
  used_dollars: number;
  dollars: number;
  requests: Order[];
  pending: Order[];
  black_market: BooleanLike;
};

enum MenuOptions {
  Categories,
  CurrentOrder,
  Requests,
  Pending,
  BlackMarket,
}

export const SupplyComputer = () => {
  const { data } = useBackend<SupplyComputerData>();

  const {
    categories,
    points,
    used_points,
    black_market,
    used_dollars,
    all_items,
  } = data;

  const [menu, setMenu] = useState(MenuOptions.Categories);

  const validCategories: string[] = [];

  all_items.forEach((pack) => {
    if (
      !validCategories.includes(pack.category) &&
      !pack.dollar_cost &&
      pack.category?.length > 0
    ) {
      validCategories.push(pack.category);
    }
  });

  const [selectedCategory, setCategory] = useState(validCategories[0]);

  return (
    <Window width={1050} height={700} theme="crtgreen">
      <Window.Content>
        <Stack>
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                <Section>
                  <Stack vertical>
                    <Stack.Item>Supply Budget: ${points * 100}</Stack.Item>
                    <Stack.Item>
                      <Button
                        fluid
                        onClick={() => setMenu(MenuOptions.CurrentOrder)}
                        selected={menu === MenuOptions.CurrentOrder}
                      >
                        Current Order: ${used_points * 100}
                        {used_dollars > 0 ? ` (WY$${used_dollars})` : ''}
                      </Button>
                      <hr />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        fluid
                        onClick={() => setMenu(MenuOptions.Requests)}
                        selected={menu === MenuOptions.Requests}
                      >
                        Requests
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        fluid
                        onClick={() => setMenu(MenuOptions.Pending)}
                        selected={menu === MenuOptions.Pending}
                      >
                        Pending Orders
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section scrollable height="505px">
                  <Stack vertical height="480px">
                    {validCategories.sort().map((category) => (
                      <Stack.Item key={category}>
                        <Button
                          fluid
                          onClick={() => {
                            setMenu(MenuOptions.Categories);
                            setCategory(category);
                          }}
                          selected={
                            menu === MenuOptions.Categories &&
                            category === selectedCategory
                          }
                        >
                          {category}
                        </Button>
                      </Stack.Item>
                    ))}
                    {!!black_market && (
                      <Stack.Item>
                        <Button
                          fluid
                          onClick={() => setMenu(MenuOptions.BlackMarket)}
                          color="red"
                        >
                          {'$E4RR301¿'}
                        </Button>
                      </Stack.Item>
                    )}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Options menu={menu} category={selectedCategory} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Options = (props: {
  readonly menu: MenuOptions;
  readonly category?: string;
}) => {
  const { menu, category } = props;

  const { data } = useBackend<SupplyComputerData>();

  const { pending } = data;

  switch (menu) {
    case MenuOptions.Categories:
      return (
        <Section title={category} scrollable height="650px">
          <Box height="610px">
            <RenderCategory category={category!} />
          </Box>
        </Section>
      );

    case MenuOptions.CurrentOrder:
      return (
        <Section
          title="Current Order"
          scrollable
          height="650px"
          buttons={
            <>
              <Button>Place Order</Button>
              <Button>Discard Order</Button>
            </>
          }
        >
          <Box height="610px">
            <RenderCart />
          </Box>
        </Section>
      );

    case MenuOptions.BlackMarket:
      return (
        <Stack vertical justify="space-around" align="center" height="100%">
          <BlackMarketMenu />
        </Stack>
      );

    case MenuOptions.Pending:
      return (
        <Section title="Pending Orders" scrollable height="650px">
          <Stack vertical>
            {pending.map((order) => (
              <Stack.Item key={order.order_num}>
                <Stack>
                  <Stack.Item>#{order.order_num}</Stack.Item>
                  <Stack.Item>{order.item}</Stack.Item>
                  <Stack.Item>{order.ordered_by}</Stack.Item>
                </Stack>
                <hr />
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      );
  }
};

const BlackMarketMenu = () => {
  const { data } = useBackend<SupplyComputerData>();

  const { contraband_categories, dollars } = data;

  const [blackmarketCategory, setBlackMarketCategory] = useState<
    string | false
  >(false);

  return (
    <>
      <Box
        position="absolute"
        right="20px"
        top="20px"
        p={2}
        style={{ border: '1px solid' }}
      >
        WY${dollars}
      </Box>
      <Stack.Item>
        {blackmarketCategory ? (
          <Section fitted height="330px" scrollable>
            <Box height="310px">
              <RenderCategory category={blackmarketCategory} />
            </Box>
          </Section>
        ) : (
          <RenderFirstTimeBlackMarket />
        )}
      </Stack.Item>
      <Stack.Item>
        <Stack>
          {contraband_categories.map((category) => (
            <Stack.Item key={category}>
              <Button
                onClick={() => {
                  setBlackMarketCategory(category);
                }}
                selected={category === blackmarketCategory}
              >
                {category}
              </Button>
            </Stack.Item>
          ))}
        </Stack>
      </Stack.Item>
    </>
  );
};

const RenderFirstTimeBlackMarket = () => {
  return (
    <Stack vertical justify="center" width="400px">
      <Stack.Item>
        {
          "Hold on- holy shit, what? Hey, hey! Finally! I've set THAT circuit board for replacement shipping off god knows who long ago. I had totally given up on it."
        }
      </Stack.Item>
      <Stack.Item>
        {'You probably have some questions, yes, yes... let me answer them.'}
      </Stack.Item>
      <Stack.Item>
        {
          "Name's Mendoza, Cargo Technician. Formerly, I suppose. I tripped into this stupid pit god knows how long ago. A crate of mattresses broke my fall, thankfully. The fuckin' MPs never even bothered to look for me! They probably wrote off my file as a friggin' clerical error. Bastards, all of them.... but I've got a plan. I'm gonna smuggle all these ASRS goods out of the ship next time it docks. I'm gonna sell them, and use the money to sue the fuck out of the USCM! Imagine the look on their faces! Mendoza, the little CT, in court as they lose all their fuckin' money!"
        }
      </Stack.Item>
      <Stack.Item>
        {
          "I do need... money. You wouldn't believe the things I've seen here. There's an aisle full of auto-doc crates, and that's the least of it. Here's the deal. There are certain... things that I need to pawn off for my plan. Anything valuable will do. Minerals, gold, unique items... lower them in the ASRS elevator. Can't come back on it, the machinery's too damn dangerous. But in exchange for those valuables.. I'll give you... things. Confiscated equipment, 'Medicine', all the crap I've stumbled upon here. The items will be delivered via the ASRS lift. Check the first item for a jury-rigged scanner, it'll tell you if I give a damn about whatever you're scanning or not."
        }
      </Stack.Item>
      <Stack.Item>
        {
          "I'll repeat, just to clear it up since you chucklefucks can't do anything right."
        }
      </Stack.Item>
      <Stack.Item>
        <b>
          {
            'Insert cash, buy my scanner, get valuables, bring them down the lift, gain dollars, buy contraband.'
          }
        </b>
      </Stack.Item>
    </Stack>
  );
};

const RenderCart = () => {
  const { data } = useBackend<SupplyComputerData>();

  const { current_order } = data;

  return (
    <Stack vertical>
      <Stack.Item>
        {current_order.map((ordered) => (
          <RenderPack key={ordered.name} pack={ordered} />
        ))}
      </Stack.Item>
    </Stack>
  );
};

const RenderCategory = (props: { readonly category: string }) => {
  const { category } = props;

  const { data } = useBackend<SupplyComputerData>();
  const { all_items } = data;

  const relevant_items = all_items.filter((pack) => pack.category === category);

  return (
    <Stack vertical>
      {relevant_items.map((item) => (
        <>
          <RenderPack key={item.name} pack={item} />
          <hr />
        </>
      ))}
    </Stack>
  );
};

const RenderPack = (props: { readonly pack: Pack }) => {
  const { pack: item } = props;

  const { act, data } = useBackend<SupplyComputerData>();

  const { current_order, points, used_points, dollars, used_dollars } = data;

  const [viewContents, setViewContents] = useState(false);

  const options = current_order.filter((pack) => pack.type === item.type);
  let quantity = 0;
  if (options[0]) {
    quantity = options[0].quantity;
  }

  return (
    <Stack.Item key={item.name}>
      <Stack>
        <Stack.Item p={1} verticalAlign="top">
          <Button
            icon={'backward-fast'}
            onClick={() => act('adjust_cart', { pack: item.type, to: 'min' })}
            disabled={!quantity}
          />
          <Button
            icon={'backward'}
            onClick={() =>
              act('adjust_cart', { pack: item.type, to: 'decrement' })
            }
            disabled={!quantity}
          />
          <Box p={1} inline>
            {quantity}
          </Box>
          <Button
            icon={'forward'}
            onClick={() =>
              act('adjust_cart', { pack: item.type, to: 'increment' })
            }
            disabled={
              item.dollar_cost
                ? used_dollars + item.dollar_cost > dollars
                : used_points + item.cost > points
            }
          />
          <Button
            icon={'forward-fast'}
            onClick={() => act('adjust_cart', { pack: item.type, to: 'max' })}
            disabled={
              item.dollar_cost
                ? used_dollars + item.dollar_cost > dollars
                : used_points + item.cost > points
            }
          />
        </Stack.Item>
        <Stack.Item p={1} width={3} align="right" verticalAlign="middle">
          {item.dollar_cost ? `WY$${item.dollar_cost}` : `$${item.cost}00`}
        </Stack.Item>

        <Stack.Item p={1}>
          <Stack vertical>
            <Stack.Item>
              <Stack justify="space-between">
                <Stack.Item>
                  <Stack>
                    <Stack.Item>
                      {item.icon && (
                        <DmIcon
                          icon={item.icon.icon}
                          icon_state={item.icon.icon_state}
                          width="32px"
                        />
                      )}
                    </Stack.Item>
                    <Stack.Item width="500px">{item.name}</Stack.Item>
                  </Stack>
                </Stack.Item>
                {item.contains.length > 0 && (
                  <Stack.Item>
                    <Button
                      onClick={() => setViewContents(!viewContents)}
                      align="right"
                      icon="info"
                    />
                  </Stack.Item>
                )}
              </Stack>
            </Stack.Item>
            {viewContents && (
              <Stack.Item>
                <hr />
                <Stack vertical>
                  {item.contains.map((item) => (
                    <Stack.Item key={item.name}>
                      <Stack>
                        {item.icon && (
                          <Stack.Item>
                            <DmIcon
                              icon={item.icon.icon}
                              icon_state={item.icon.icon_state}
                              width="20px"
                            />
                          </Stack.Item>
                        )}
                        <Stack.Item>{item.quantity}x</Stack.Item>
                        <Stack.Item>{item.name}</Stack.Item>
                      </Stack>
                    </Stack.Item>
                  ))}
                </Stack>
              </Stack.Item>
            )}
          </Stack>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};
