import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Icon, Flex, NoticeBox, Section, Stack, Tabs } from '../components';
import { BoxProps } from '../components/Box';
import { Table, TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

interface MachineElectrical {
  electrified: number;
  panel_open: number;
  wires: WireSpec[];
}

interface WireSpec {
  desc: string;
  cut: number;
}

interface SmartFridgeData {
  secure: number;
  transfer_mode: number;
  locked: number;
  electrical: MachineElectrical;
  storage: {
    contents: StorageItem[];
    networked: StorageItem[];
  };
  networked: number;
}

interface StorageItem {
  index: number;
  display_name: string;
  vend: number;
  quantity: number;
  item: string;
  image: string;
  category: string;
}

const ContentsTable = (
  props: { isLocal: boolean; items: StorageItem[] },
  context
) => {
  return (
    <Table className="ContentsTable">
      {props.items
        .sort((a, b) => a.display_name.localeCompare(b.display_name))
        .map((x) => (
          <TableRow key={x.display_name} className="ContentRow">
            <ContentItem item={x} isLocal={props.isLocal} />
          </TableRow>
        ))}
    </Table>
  );
};

const Contents = (
  props: { isLocal: boolean; items: StorageItem[]; title: string },
  context
) => {
  const [tabIndex, setTabIndex] = useLocalState(context, 'contentsTab', 'all');
  const allItems = props.items;

  if (allItems.length === 0) {
    return (
      <Section title={props.title}>
        <span>No items present</span>
      </Section>
    );
  }

  const categories = new Map<string, StorageItem[]>();
  categories.set('all', allItems);
  allItems.forEach((x) => {
    const categoryArray = categories.get(x.category) ?? new Array();
    categoryArray.push(x);
    categories.set(x.category, categoryArray);
  });

  const categoryIterable = Array.from(categories.entries());
  return (
    <Section title={props.title}>
      <Tabs fill fluid>
        {categoryIterable
          .sort((a, b) => a[0].localeCompare(b[0]))
          .map((value) => {
            const key = value[0];
            const items = value[1];
            return (
              <Tabs.Tab
                key={key}
                selected={tabIndex === key}
                onClick={() => setTabIndex(key)}>
                {key} ({items.length})
              </Tabs.Tab>
            );
          })}
      </Tabs>

      {categoryIterable.map((x) => {
        if (tabIndex !== x[0]) {
          return undefined;
        }
        return (
          <ContentsTable key={x[0]} isLocal={props.isLocal} items={x[1]} />
        );
      })}
    </Section>
  );
};

const ContentItem = (
  props: { isLocal: boolean; item: StorageItem },
  context
) => {
  const { data, act } = useBackend<SmartFridgeData>(context);
  const { item } = props;
  return (
    <>
      <TableCell className="ItemIconCell">
        <span
          className={classes(['ItemIcon', `vending32x32`, `${item.image}`])}
        />
      </TableCell>
      <TableCell className="ItemIconCell">{item.quantity}</TableCell>
      <TableCell>
        <Button
          className="VendButton"
          preserveWhitespace
          textAlign="center"
          icon="circle-down"
          onClick={() => act('vend', { 'index': item.index, 'amount': 1 })}>
          {item.display_name}
        </Button>
      </TableCell>
      <TableCell>
        {props.isLocal && <Button icon="upload">Send to Network</Button>}
        {!props.isLocal && <Button icon="download">Get from Network</Button>}
      </TableCell>
      <TableCell>
        <Icon name="circle-info" />
      </TableCell>
    </>
  );
};

const ElectricalPanelClosed = (props: BoxProps, context) => {
  const { data } = useBackend<SmartFridgeData>(context);
  return (
    <NoticeBox
      className={classes([
        'PanelClosed',
        'ElectricalSafetySign',
        props.className,
      ])}>
      <Flex
        direction="column"
        justify="space-between"
        fill
        className="ElectricalSafetySign">
        <Flex.Item>
          <Flex justify="space-between">
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
          </Flex>
        </Flex.Item>
        <Flex.Item className="WarningIcon">
          <Flex justify="space-around">
            <Flex.Item>
              <Icon name="bolt" />
            </Flex.Item>
            <Flex.Item>
              <span>Electrical hazard authorised personnel only</span>
            </Flex.Item>
            <Flex.Item>
              <Icon name="bolt" />
            </Flex.Item>
          </Flex>
        </Flex.Item>
        <Flex.Item>
          <Flex justify="space-between">
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
            <Flex.Item>
              <Icon name="circle-xmark" />
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
    </NoticeBox>
  );
};

const WireControl = (props: { wire: WireSpec }, context) => {
  return (
    <>
      <TableCell className="Test">{props.wire.desc}</TableCell>
      <TableCell>
        {props.wire.cut === 0 && <Button icon="scissors">cut</Button>}
        {props.wire.cut === 1 && <Button icon="wrench">fix</Button>}
      </TableCell>
    </>
  );
};

const ElectricalPanelOpen = (props: BoxProps, context) => {
  const { data } = useBackend<SmartFridgeData>(context);
  return (
    <Box className={classes(['PanelOpen', props.className])}>
      <Flex
        direction="column"
        justify="space-between"
        fill
        className="ElectricalSafetySign">
        <Flex.Item>
          <Table vertical className="WirePanel">
            {data.electrical.wires.map((x) => (
              <TableRow key={x.desc} className="Test">
                <WireControl wire={x} />
              </TableRow>
            ))}
          </Table>
        </Flex.Item>
        <Flex.Item>
          <NoticeBox className="OpenSafetySign" />
        </Flex.Item>
      </Flex>
    </Box>
  );
};

const ElectricalPanel = (props, context) => {
  const { data } = useBackend<SmartFridgeData>(context);
  const isOpen = data.electrical.panel_open === 1;
  return (
    <div className={classes(['ElectricalAccessPanel'])}>
      {!isOpen && (
        <>
          <div>
            <ElectricalPanelClosed />
          </div>
          <div>
            <ElectricalPanelOpen />
          </div>
        </>
      )}
      {isOpen && (
        <>
          <div>
            <ElectricalPanelOpen />
          </div>
          <div>
            <ElectricalPanelClosed />
          </div>
        </>
      )}
    </div>
  );
};

export const SmartFridge = (_, context) => {
  const { data } = useBackend<SmartFridgeData>(context);
  return (
    <Window theme="weyland">
      <Window.Content className="SmartFridge" scrollable>
        <Stack vertical>
          {data.secure && (
            <Stack.Item>
              <NoticeBox>Smart fridge is secure</NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item>
            <Contents title="Contents" isLocal items={data.storage.contents} />
          </Stack.Item>
          {data.networked === 1 && (
            <Stack.Item>
              <Contents
                title="Networked"
                isLocal={false}
                items={data.storage.networked}
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
