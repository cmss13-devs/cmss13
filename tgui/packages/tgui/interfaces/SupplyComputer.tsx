import { randomPick, randomProb } from 'common/random';
import { BooleanLike } from 'common/react';
import { capitalizeFirst } from 'common/string';
import { useEffect, useState } from 'react';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  DmIcon,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type SupplyComputerData = {
  categories: string[];
  contraband_categories: string[];
  all_items: Pack[];
  current_order: OrderPack[];
  used_points: number;
  points: number;
  used_dollars: number;
  dollars: number;
  requests: Order[];
  pending: Order[];
  black_market: BooleanLike;
  shuttle_status: string;
  can_launch: BooleanLike;
  can_force: BooleanLike;
  can_cancel: BooleanLike;

  mendoza_status: BooleanLike;
  locked_out: BooleanLike;

  logo: string;
};

type Pack = {
  name: string;
  cost: number;
  dollar_cost: number;
  contains: Item[];
  icon: Icon;
  category: string;
  type: string;
};

type OrderPack = {
  quantity: number;
} & Pack;

type Order = {
  order_num: string;
  contents: OrderPack[];
  ordered_by: string;
  approved_by: string;
  reason?: string;
};

type Item = {
  name: string;
  quantity: number;
  icon: Icon;
};

type Icon = {
  icon: string;
  icon_state: string;
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

  const { all_items } = data;

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
            <SideButtons
              menu={menu}
              allCategories={validCategories}
              selectedCategory={selectedCategory}
              setMenu={setMenu}
              setCategory={setCategory}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Options menu={menu} category={selectedCategory} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const SideButtons = (props: {
  readonly menu: MenuOptions;
  readonly allCategories: string[];
  readonly selectedCategory: string;
  readonly setMenu: (_) => void;
  readonly setCategory: (_) => void;
}) => {
  const { menu, allCategories, selectedCategory, setMenu, setCategory } = props;

  const { data, act } = useBackend<SupplyComputerData>();

  const {
    pending,
    requests,
    points,
    used_points,
    black_market,
    used_dollars,
    shuttle_status,
    can_launch,
    can_cancel,
    can_force,
  } = data;

  return (
    <Stack vertical>
      <Stack.Item>
        <Section>
          <Stack vertical>
            <Stack.Item>Supply Budget: ${points * 100}</Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item grow>
                  <Button
                    fluid
                    icon="dolly"
                    disabled={!can_launch}
                    onClick={() => act('send')}
                  >
                    {capitalizeFirst(shuttle_status)}
                  </Button>
                </Stack.Item>
                {!!(can_cancel || can_force) && (
                  <Stack.Item>
                    {!!can_force && (
                      <Button
                        icon="gauge-high"
                        tooltip="Force"
                        onClick={() => act('force_launch')}
                      />
                    )}
                    {!!can_cancel && (
                      <Button
                        icon="ban"
                        tooltip="Cancel"
                        onClick={() => act('cancel_launch')}
                      />
                    )}
                  </Stack.Item>
                )}
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                onClick={() => setMenu(MenuOptions.CurrentOrder)}
                selected={menu === MenuOptions.CurrentOrder}
                icon="basket-shopping"
              >
                Current Order: ${used_points * 100}
                {used_dollars > 0 ? ` (WY$${used_dollars})` : ''}
              </Button>
              <Divider />
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                onClick={() => setMenu(MenuOptions.Requests)}
                selected={menu === MenuOptions.Requests}
                icon="hand-holding-dollar"
              >
                Requests
                {requests.length > 0 ? ` (${requests.length})` : ''}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                onClick={() => setMenu(MenuOptions.Pending)}
                selected={menu === MenuOptions.Pending}
                icon="clipboard-list"
              >
                Pending Orders
                {pending.length > 0 ? ` (${pending.length})` : ''}
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section scrollable height="490px">
          <Stack vertical height="470px">
            {allCategories.sort().map((category) => (
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
  );
};

const Options = (props: {
  readonly menu: MenuOptions;
  readonly category?: string;
}) => {
  const { menu, category } = props;

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
      return <CurrentOrder />;

    case MenuOptions.BlackMarket:
      return (
        <Stack vertical justify="space-around" align="center" height="100%">
          <BlackMarketMenu />
        </Stack>
      );

    case MenuOptions.Pending:
      return <PendingOrder />;

    case MenuOptions.Requests:
      return <Requests />;
  }
};

const CurrentOrder = () => {
  const { act } = useBackend();

  return (
    <Section
      title="Current Order"
      scrollable
      height="650px"
      buttons={
        <>
          <Button
            icon="money-bill-1"
            onClick={() => {
              act('place_order');
            }}
          >
            Place Order
          </Button>
          <Button
            icon="trash"
            onClick={() => {
              act('discard_cart');
            }}
          >
            Discard Order
          </Button>
        </>
      }
    >
      <Box height="610px">
        <RenderCart />
      </Box>
    </Section>
  );
};

const PendingOrder = () => {
  const { data } = useBackend<SupplyComputerData>();

  const { pending } = data;

  return (
    <Section title="Pending Orders" scrollable height="650px">
      <Stack vertical height="610px">
        {pending.map((order) => (
          <RenderOrder order={order} key={order.order_num} />
        ))}
      </Stack>
    </Section>
  );
};

const Requests = () => {
  const { data } = useBackend<SupplyComputerData>();

  const { requests } = data;

  return (
    <Section title="Requests" scrollable height="650px">
      <Stack vertical height="610px">
        {requests.map((order) => (
          <RenderOrder order={order} key={order.order_num} request />
        ))}
      </Stack>
    </Section>
  );
};

const RenderOrder = (props: {
  readonly order: Order;
  readonly request?: boolean;
}) => {
  const { order, request } = props;

  const { act } = useBackend();

  return (
    <Stack.Item>
      <Collapsible title={`Order #${order.order_num}`} open={request}>
        <Stack vertical>
          <Stack justify="space-between">
            <Stack.Item>
              <Stack.Item>
                <Stack>
                  <Stack.Item bold>Ordered By:</Stack.Item>
                  <Stack.Item>{order.ordered_by}</Stack.Item>
                </Stack>
              </Stack.Item>
              {order.approved_by && order.ordered_by !== order.approved_by && (
                <Stack.Item pt={1}>
                  <Stack>
                    <Stack.Item>Approved By</Stack.Item>
                    <Stack.Item>{order.approved_by}</Stack.Item>
                  </Stack>
                </Stack.Item>
              )}
              <Stack.Item pt={1}>
                <Stack>
                  <Stack.Item bold>Total Cost:</Stack.Item>
                  <Stack.Item>
                    $
                    {order.contents.reduce(
                      (curr, next) => curr + next.cost * next.quantity,
                      0,
                    ) * 100}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack.Item>
            {request && (
              <Stack.Item>
                <Button
                  icon="check"
                  onClick={() =>
                    act('change_order', {
                      ordernum: order.order_num,
                      order_status: 'approve',
                    })
                  }
                >
                  Approve
                </Button>
                <Button
                  icon="xmark"
                  onClick={() =>
                    act('change_order', {
                      ordernum: order.order_num,
                      order_status: 'deny',
                    })
                  }
                >
                  Deny
                </Button>
              </Stack.Item>
            )}
          </Stack>
          <Stack.Divider />
          {order.contents.map((ordered) => (
            <RenderPack
              pack={ordered}
              orderedQuantity={ordered.quantity}
              key={ordered.name}
            />
          ))}
        </Stack>
      </Collapsible>
    </Stack.Item>
  );
};

const BlackMarketMenu = () => {
  const { data } = useBackend<SupplyComputerData>();

  const { contraband_categories, dollars, mendoza_status, locked_out, logo } =
    data;

  const [blackmarketCategory, setBlackMarketCategory] = useState<
    string | false
  >(false);

  if (locked_out) {
    return (
      <Section title="Seizure Notice">
        <Stack vertical>
          <Stack.Item>
            <Stack justify="center">
              <img src={logo} />
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack justify="center">Unauthorized Access Removed.</Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack justify="center">
              This console is currently under CMB investigation.
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack justify="center">Thank you for your cooperation.</Stack>
          </Stack.Item>
        </Stack>
      </Section>
    );
  }

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
          <MendozaDialogue />
        )}
      </Stack.Item>
      {mendoza_status && (
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
      )}
    </>
  );
};

const MendozaDialogue = () => {
  const [firstTime, setSeen] = useSharedState('mendoza', true);
  const [stateFirst] = useState(firstTime);

  const { data } = useBackend<SupplyComputerData>();

  const { mendoza_status } = data;

  useEffect(() => {
    setSeen(false);
  });

  const mendozaDialogues = [
    "Sometimes I... hear things down 'ere. Crates bein' opened, shufflin', sometimes.. even breathing and chewin'. Even when the ASRS is on maintenance mode. Last month I swear I glimped some shirtless madman runnin' by at the edge of my screen. This place is haunted.",
    "You know how I said there was a full aisle of autodoc crates? I just found another! This one has body scanners, sleepers, WeyMeds.. why the fuck aren't these on the supply list? Why are they here to begin with?",
    "You know, this place is a real fuckin' massive safety hazard. Nobody does maintenance on this part of the ship. Ever since that colony operation in Schomberg cost us half the damn cargo hold, nothin' here quite works properly. Mechanical arms dropping crates in random places, from way too high up, knockin' shelves over.. it's fuckin' embarrassin'! I pity the damn' scrappers that'll be trying to salvage something from this junkyard of a ship once it's scuttled.",
    "I still can't believe the whole ship's fucking supply of HEAP blew up. Some fuckin' moron decided our EXPLOSIVE AMMUNITION should be stored right next to the ship's hull. Even with the explosion concerns aside that's our main damn type of ammunition! What the hell are marines usin' this operation? Softpoint? Jesus. I do see a few scattered HEAP magazines every so often, but I know better than to throw them on the lift. Chances are some wet-behind-the-ears greenhorn is goin' to nab it and blow his fellow marines to shreds.",
    "Wanna know a secret? I'm the one pushin' all those crates with crap on the ASRS lift. Not because I know you guys need surplus SMG ammunition or whatever. The fuckin' crates are taking up way too much space here. Why do we have HUNDREDS of mortar shells? By god, it's almost like a WW2 historical reenactment in here!",
    "You know... don't tell anyone, but I actually really like blue-flavored Souto for some reason. Not the diet version, that cyan junk's as nasty as any other flavor, but... there's just somethin' about that blue-y goodness. If you see any, I wouldn't mind havin' them thrown down the elevator.",
    "If you see any, er.. 'elite' equipment, be sure to throw it down here. I know a few people that'd offer quite the amount of money for a USCM commander's gun, or pet. Even the armor is worth a fortune. Don't kill yourself doin' it, though. Hell, any kind of wildlife too, actually! Anythin' that isn't a replicant animal is worth a truly ridiculous sum back on Terra, I'll give ya quite the amount of points for 'em. As long as it isn't plannin' on killing me.",
  ];

  const [pickedDialogue, setPicked] = useState('');

  useEffect(() => {
    if (randomProb(30)) {
      setPicked(randomPick(mendozaDialogues));
    }
  }, []);

  if (!mendoza_status) {
    return (
      <Stack vertical justify="center" width="400px">
        <Stack.Item>.......</Stack.Item>
      </Stack>
    );
  }

  return stateFirst ? (
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
  ) : (
    <Stack vertical justify="center" width="400px">
      <Stack.Item>{pickedDialogue}</Stack.Item>
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

const RenderPack = (props: {
  readonly pack: Pack;
  readonly orderedQuantity?: number;
}) => {
  const { pack: item, orderedQuantity } = props;

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
        {orderedQuantity ? (
          <Stack.Item>
            <Box p={1} inline>
              {orderedQuantity}x
            </Box>
          </Stack.Item>
        ) : (
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
        )}
        <Stack.Item p={1} width={3} align="right" verticalAlign="middle">
          {item.dollar_cost ? `WY$${item.dollar_cost}` : `$${item.cost * 100}`}
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
                    <Stack.Item width={orderedQuantity ? '600px' : '500px'}>
                      {item.name}
                    </Stack.Item>
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
