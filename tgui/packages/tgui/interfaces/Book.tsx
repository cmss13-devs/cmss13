import { marked } from 'marked';
import { createRef, useEffect, useState } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Image, Stack } from '../components';
import { Window } from '../layouts';

type BookData = {
  title: string;
  author: string;
  contents: string;
};

const replacementRegex = /^\t*/gm;

export const Book = () => {
  const { data } = useBackend<BookData>();

  const { title, author, contents } = data;

  const ref = createRef<HTMLDivElement>();

  const [pages, setPages] = useState<Element[][]>([]);
  const [page, setPage] = useState(0);

  useEffect(() => {
    const toParse = contents.trim().replaceAll(replacementRegex, '');

    ref.current!.innerHTML = marked.parse(toParse);

    const rect = ref.current!.getBoundingClientRect();

    if (rect.height < 630) {
      return;
    }

    let page = 0;
    const pages: Element[][] = [];

    const list = ref.current!.children;
    for (let i = 0; i < list.length; i++) {
      const limit = (page + 1) * 630;
      const element = list[i];

      const elementRect = element.getBoundingClientRect();
      console.log(elementRect);
      if (elementRect.top > limit) {
        page++;
      }

      const existingPage = pages.at(page);
      if (existingPage) {
        existingPage.push(element);
      } else {
        pages.splice(page, 0, [element]);
      }
    }

    setPages(pages);
  }, []);

  useEffect(() => {
    ref.current!.innerHTML = '';

    const selectedPage = pages[page];

    if (!selectedPage) {
      return;
    }

    for (const element of selectedPage) {
      ref.current!.appendChild(element);
    }
  }, [page, pages]);

  return (
    <Window width={650} height={700} theme="paper" scrollbars={false}>
      <Window.Content className="Book">
        <Stack vertical fill>
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <Image
                  src={resolveAsset('logo_uscm.png')}
                  height={4}
                  fixBlur={false}
                />
              </Stack.Item>
              <Stack.Item>
                <Stack vertical justify="center" fill>
                  <Stack.Item>
                    <Box fontSize="24px">{title}</Box>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <Stack vertical justify="center" fill>
                  <Stack.Item pt={2}>
                    <Box>{author}</Box>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Box className="PaperDivider TopDivider" />
          <Stack vertical justify="space-between" fill>
            <Stack.Item>
              <div ref={ref} />
            </Stack.Item>
            <Stack.Item>
              <Box className="PaperDivider BottomDivider" />
            </Stack.Item>
          </Stack>
          {pages.length && (
            <>
              {page + 1 >= pages.length && (
                <Box
                  className="PageTurn Backward"
                  onClick={() => setPage((page) => page - 1)}
                />
              )}
              {page + 1 < pages.length && (
                <Box
                  className="PageTurn Forward"
                  onClick={() => {
                    setPage((page) => page + 1);
                    console.log(page);
                  }}
                />
              )}
            </>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
