import { randomPick, randomProb } from 'common/random';
import { BooleanLike } from 'common/react';
import { storage } from 'common/storage';
import { capitalizeFirst } from 'common/string';
import { debounce } from 'common/timer';
import { ReactNode, useEffect, useState } from 'react';

import { resolveAsset } from '../assets';
import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button as NativeButton,
  Collapsible,
  Divider,
  DmIcon,
  Flex,
  Image,
  Input,
  Modal,
  NumberInput,
  Section,
  Stack,
} from '../components';
import { ButtonCheckbox } from '../components/Button';
import { Window } from '../layouts';
import { LoadingScreen } from './common/LoadingToolbox';

type SupplyComputerData = {
  all_items: Pack[];

  categories: string[];
  valid_categories: string[];
  categories_to_objects: { [category: string]: Pack[] };
  contraband_categories: string[];

  system_message: string;
  shuttle_status: string;
  can_launch?: BooleanLike;
  can_force?: BooleanLike;
  can_cancel?: BooleanLike;

  current_order: OrderPack[];
  requests?: Order[];
  pending?: Order[];

  points: number;
  used_points?: number;

  dollars?: number;
  used_dollars?: number;

  black_market?: BooleanLike;
  mendoza_status?: BooleanLike;
  locked_out?: BooleanLike;
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
  const [menu, setMenu] = useState(MenuOptions.Categories);

  const [selectedCategory, setCategory] = useState('Ammo');
  const [modal, setDisplayModal] = useState<ReactNode | false>(false);

  const [theme, setTheme] = useState<string | false>();

  const { data, act } = useBackend<SupplyComputerData>();

  const { system_message } = data;

  useEffect(() => {
    storage
      .get('supply-comp-theme')
      .then((theme) => setTheme(theme ?? 'crtbrown'));
  }, []);

  useEffect(() => {
    if (system_message?.length) {
      setDisplayModal(
        <Section title="System Message">
          <Stack vertical p={3}>
            <Stack.Item>{system_message}</Stack.Item>
            <Stack.Item pt={2}>
              <Button
                fluid
                onClick={() => {
                  act('acknowledged');
                  setDisplayModal(null);
                }}
              >
                Acknowledge
              </Button>
            </Stack.Item>
          </Stack>
        </Section>,
      );
    }
  }, [system_message]);

  if (!theme) {
    return (
      <Window>
        <Window.Content>
          <LoadingScreen />
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={1050} height={700} theme={theme}>
      <Window.Content>
        {!!modal && <Modal>{modal}</Modal>}
        <Stack>
          <Stack.Item>
            <SideButtons
              menu={menu}
              selectedCategory={selectedCategory}
              setMenu={setMenu}
              setCategory={setCategory}
              setModal={setDisplayModal}
              theme={theme}
              setTheme={setTheme}
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
  readonly selectedCategory: string;
  readonly theme: string;
  readonly setMenu: (_) => void;
  readonly setCategory: (_) => void;
  readonly setModal: (_) => void;
  readonly setTheme: (_) => void;
}) => {
  const {
    menu,
    selectedCategory,
    setMenu,
    setCategory,
    setModal,
    theme,
    setTheme,
  } = props;

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
    valid_categories,
  } = data;

  const chooseTheme = (theme: string) => {
    setTheme(theme);
    storage.set('supply-comp-theme', theme);
    setModal(false);
  };

  return (
    <Stack vertical>
      <Stack.Item>
        <Section>
          <Stack vertical>
            <Stack.Item>
              <Stack justify="space-between">
                <Stack.Item>Supply Budget: ${points * 100}</Stack.Item>
                <Stack.Item>
                  <Button
                    icon="gear"
                    onClick={() =>
                      setModal(
                        <Section title="Settings">
                          <Stack p={2}>
                            <ButtonCheckbox
                              checked={theme === 'crtbrown'}
                              onClick={() => chooseTheme('crtbrown')}
                            >
                              CRT: Brown
                            </ButtonCheckbox>
                            <ButtonCheckbox
                              checked={theme === 'crtgreen'}
                              onClick={() => chooseTheme('crtgreen')}
                            >
                              CRT: Green
                            </ButtonCheckbox>
                            <ButtonCheckbox
                              checked={theme === 'weyland_yutani'}
                              onClick={() => chooseTheme('weyland_yutani')}
                            >
                              wyOS
                            </ButtonCheckbox>
                          </Stack>
                        </Section>,
                      )
                    }
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
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
                    <Stack>
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
                    </Stack>
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
                Current Order{used_points ? `: $${used_points * 100}` : ''}
                {used_dollars && used_dollars > 0
                  ? ` (WY$${used_dollars})`
                  : ''}
              </Button>
              <Divider />
            </Stack.Item>
            {!!requests && (
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
            )}
            {!!pending && (
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
            )}
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section scrollable height="470px">
          <Stack vertical height="450px">
            <Input
              placeholder="Search..."
              fluid
              expensive
              onInput={(_, val) => {
                if (val.length > 0) {
                  setCategory(val);
                  setMenu(MenuOptions.Categories);
                } else {
                  setCategory(valid_categories[0]);
                }
              }}
            />
            {valid_categories.sort().map((category) => (
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

  const { categories } = useBackend<SupplyComputerData>().data;

  switch (menu) {
    case MenuOptions.Categories:
      return (
        <Section
          title={categories.includes(category!) ? category : 'Search'}
          scrollable
          height="650px"
        >
          <Box height="610px">
            <RenderCategory category={category!} categories={categories} />
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
  const { act, data } = useBackend<SupplyComputerData>();

  const { used_points } = data;

  const [reason, setReason] = useState('');

  const requester = used_points === undefined;

  return (
    <Section
      title="Current Order"
      scrollable
      height="650px"
      buttons={
        <Stack>
          {requester && (
            <Input
              placeholder="Reason..."
              onChange={(_, val) => setReason(val)}
            />
          )}
          <Button
            icon="money-bill-1"
            onClick={() => {
              requester
                ? act('request_cart', { reason: reason })
                : act('place_order');
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
        </Stack>
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
        {pending!.map((order) => (
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
        {requests!.map((order) => (
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
      <Collapsible title={`Order #${order.order_num}`} open>
        <Stack vertical>
          <Stack justify="space-between">
            <Stack.Item>
              <Stack.Item>
                <Stack>
                  <Stack.Item bold>Ordered By:</Stack.Item>
                  <Stack.Item>{order.ordered_by}</Stack.Item>
                </Stack>
              </Stack.Item>
              {!!order.reason && (
                <Stack.Item pt={1}>
                  <Stack>
                    <Stack.Item bold>Reason:</Stack.Item>
                    <Stack.Item>{order.reason}</Stack.Item>
                  </Stack>
                </Stack.Item>
              )}
              {order.approved_by && order.ordered_by !== order.approved_by && (
                <Stack.Item pt={1}>
                  <Stack>
                    <Stack.Item bold>Approved By:</Stack.Item>
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
                <Stack>
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
                </Stack>
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

  const { contraband_categories, dollars, mendoza_status, locked_out } = data;

  const [blackmarketCategory, setBlackMarketCategory] = useState<
    string | false
  >(false);

  if (locked_out) {
    return (
      <Section title="Seizure Notice">
        <Stack vertical>
          <Stack.Item>
            <Stack justify="center">
              <Image src={resolveAsset('logo_cmb.png')} />
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
              <RenderCategory
                category={blackmarketCategory}
                categories={contraband_categories}
              />
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

const RenderCategory = (props: {
  readonly category: string;
  readonly categories: string[];
}) => {
  const { category, categories } = props;

  const { data } = useBackend<SupplyComputerData>();
  const { all_items, categories_to_objects } = data;

  const validCategory = categories.includes(category);
  const relevant_items = validCategory
    ? categories_to_objects[category]
    : all_items.filter(
        (pack) =>
          !pack.dollar_cost &&
          pack.name.toLowerCase().includes(category.toLowerCase()),
      );

  return (
    <Stack vertical>
      {relevant_items.map((item) => (
        <>
          <RenderPack key={item.name} pack={item} />
          <Divider />
        </>
      ))}
    </Stack>
  );
};

const changeAmount = debounce((type, quantity) => {
  useBackend().act('adjust_cart', { pack: type, to: quantity });
}, 250);

const RenderPack = (props: {
  readonly pack: Pack;
  readonly orderedQuantity?: number;
}) => {
  const { pack: item, orderedQuantity } = props;

  const { act, data } = useBackend<SupplyComputerData>();

  const { current_order, points, dollars, used_dollars, used_points } = data;

  const [viewContents, setViewContents] = useState(false);

  const [savedQuantity, setSavedQuantity] = useState(0);

  useEffect(() => {
    const options = current_order.find((pack) => pack.type === item.type);
    setSavedQuantity(options?.quantity ?? 0);
  }, [current_order]);

  const changeQuantity = (increment: boolean) => {
    setSavedQuantity((saved) => {
      const newValue = saved + (increment ? 1 : -1);
      const existing = data.current_order.find(
        (thing) => item.type === thing.type,
      );
      if (existing) {
        existing.quantity = newValue;
      } else {
        data.current_order.push({
          ...item,
          quantity: newValue,
        });
      }
      changeAmount(item.type, newValue);
      return newValue;
    });
  };

  let orderMore = true;
  if (item.dollar_cost) {
    if (used_dollars !== undefined) {
      orderMore =
        current_order.reduce(
          (prev, curr) => prev + curr.dollar_cost * curr.quantity,
          0,
        ) +
          item.dollar_cost <=
        dollars!;
    }
  }

  if (item.cost) {
    if (used_points !== undefined) {
      orderMore =
        current_order.reduce(
          (prev, curr) => prev + curr.cost * curr.quantity,
          0,
        ) +
          item.cost <=
        points;
    }
  }

  return (
    <Stack.Item key={item.name}>
      <Stack>
        {orderedQuantity ? (
          <Stack.Item>
            <Box p={1} width="30px" textAlign="right" inline>
              {orderedQuantity}x
            </Box>
          </Stack.Item>
        ) : (
          <Stack.Item p={1} verticalAlign="top">
            <Flex>
              <Flex.Item pr={1}>
                <Button
                  icon={'xmark'}
                  onClick={() => {
                    act('adjust_cart', { pack: item.type, to: 'min' });
                    setSavedQuantity(0);
                  }}
                  disabled={!savedQuantity}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon={'minus'}
                  onClick={() => {
                    changeQuantity(false);
                  }}
                  disabled={!savedQuantity}
                />
              </Flex.Item>
              <Flex.Item>
                <NumberInput
                  value={savedQuantity}
                  minValue={0}
                  maxValue={99}
                  step={1}
                  onChange={(val) => {
                    act('adjust_cart', { pack: item.type, to: val });
                    setSavedQuantity(val);
                  }}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon={'plus'}
                  onClick={() => {
                    changeQuantity(true);
                  }}
                  disabled={!orderMore}
                />
              </Flex.Item>
            </Flex>
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
                    <Stack.Item width={orderedQuantity ? '575px' : '500px'}>
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
                <Divider />
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

const Button = (props) => {
  const { act } = useBackend();

  return (
    <Box onClick={() => act('keyboard')}>
      <NativeButton {...props} />
    </Box>
  );
};
