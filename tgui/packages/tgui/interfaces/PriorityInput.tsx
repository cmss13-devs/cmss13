import { createSearch, decodeHtmlEntities } from 'common/string';
import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui/components';
import { TableCell, TableRow } from 'tgui/components/Table';
import { Window } from 'tgui/layouts';

import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

type Data = {
  items: string[];
  message: string;
  title: string;
  timeout: number;
  theme: string;
};

export const PriorityInput = (props) => {
  const { data } = useBackend<Data>();
  const { items = [], message, timeout, title, theme } = data;

  // The full order of items as displayed. Reordering mutates this.
  const [itemsOrder, setItemsOrder] = useState<string[]>(items);

  // Keep itemsOrder in sync if `items` prop changes.
  useEffect(() => setItemsOrder(items), [items]);

  const [searchQuery, setSearchQuery] = useState('');
  const search = createSearch(searchQuery, (item: string) => item);

  // Filtered view but preserve relative ordering from itemsOrder
  const toDisplay = itemsOrder.filter(search);

  const move = (name: string, dir: -1 | 1) => {
    const idx = itemsOrder.indexOf(name);
    if (idx === -1) return;
    const newIdx = idx + dir;
    if (newIdx < 0 || newIdx >= itemsOrder.length) return;
    const newOrder = [...itemsOrder];
    const [item] = newOrder.splice(idx, 1);
    newOrder.splice(newIdx, 0, item);
    setItemsOrder(newOrder);
  };

  return (
    <Window title={title} width={450} height={340} theme={theme}>
      {!!timeout && <Loader value={timeout} />}
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <NoticeBox info textAlign="center">
              {decodeHtmlEntities(message)}{' '}
            </NoticeBox>
          </Stack.Item>
          <Stack.Item grow mt={0}>
            <Section fill scrollable>
              <Table>
                {toDisplay.map((item, index) => {
                  const origIdx = itemsOrder.indexOf(item);
                  return (
                    <TableRow className="candystripe" key={item}>
                      <TableCell>
                        <Button fluid>{item}</Button>
                      </TableCell>
                      <TableCell>
                        <Stack>
                          <Stack.Item>
                            <Tooltip content="Move up" position="bottom">
                              <Button
                                compact
                                onClick={() => move(item, -1)}
                                disabled={origIdx <= 0}
                                aria-label={`Move ${item} up`}
                              >
                                <Icon name="arrow-up" />
                              </Button>
                            </Tooltip>
                          </Stack.Item>
                          <Stack.Item>
                            <Tooltip content="Move down" position="bottom">
                              <Button
                                compact
                                onClick={() => move(item, 1)}
                                disabled={
                                  origIdx === -1 ||
                                  origIdx >= itemsOrder.length - 1
                                }
                                aria-label={`Move ${item} down`}
                              >
                                <Icon name="arrow-down" />
                              </Button>
                            </Tooltip>
                          </Stack.Item>
                        </Stack>
                      </TableCell>
                    </TableRow>
                  );
                })}
              </Table>
            </Section>
          </Stack.Item>
          <Stack m={1} mb={0}>
            <Stack.Item>
              <Tooltip content="Search" position="bottom">
                <Icon name="search" mt={0.5} />
              </Tooltip>
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                value={searchQuery}
                onInput={(_, value) => setSearchQuery(value)}
              />
            </Stack.Item>
          </Stack>
          <Stack.Item mt={0.7}>
            <Section>
              <InputButtons input={itemsOrder} />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
