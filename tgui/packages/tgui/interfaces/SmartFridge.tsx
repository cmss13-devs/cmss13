import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Icon, NoticeBox, Section, Stack, Tabs } from '../components';
import { Table, TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';
import { ElectricalPanel } from './common/ElectricalPanel';

interface SmartFridgeData {
  secure: number;
  transfer_mode: number;
  locked: number;
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
  const [tabIndex, setTabIndex] = useLocalState(
    context,
    `contentsTab_${props.isLocal}`,
    'all'
  );
  const allItems = props.items;

  if (allItems.length === 0) {
    return (
      <Section title={props.title}>
        <NoticeBox danger>No items present!</NoticeBox>
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
            const displayName = `${key
              .substring(0, 1)
              .toUpperCase()}${key.substring(1)}`;
            return (
              <Tabs.Tab
                key={key}
                selected={tabIndex === key}
                onClick={() => setTabIndex(key)}>
                {displayName} ({items.length})
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
  const itemref = { 'index': item.index, 'amount': 1, isLocal: props.isLocal };
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
          onClick={() => act('vend', itemref)}>
          {item.display_name}
        </Button>
      </TableCell>
      {data.networked === 1 && (
        <TableCell>
          <Button
            icon={props.isLocal ? 'upload' : 'download'}
            onClick={() => act('transfer', itemref)}
          />
        </TableCell>
      )}
      <TableCell>
        <Icon name="circle-info" />
      </TableCell>
    </>
  );
};

export const SmartFridge = (_, context) => {
  const { data } = useBackend<SmartFridgeData>(context);
  return (
    <Window theme="weyland" width={400} height={600}>
      <Window.Content className="SmartFridge" scrollable>
        <Stack vertical>
          {data.secure && (
            <Stack.Item>
              <NoticeBox>Smart Fridge is in secure mode</NoticeBox>
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
