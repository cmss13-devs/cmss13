import type { BooleanLike } from 'common/react';
import { marked } from 'marked';
import { createRef, useEffect, useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Box, Button, Image, Stack, TextArea } from 'tgui/components';
import { Window } from 'tgui/layouts';

type BookData = {
  title: string;
  author: string;
  contents: string;

  preview: BooleanLike;
};

const replacementRegex = /^\t*/gm;
const imageRegex = /src="\/([^ ]*)"/gm;

export const Book = () => {
  const { data, act } = useBackend<BookData>();

  const { contents, preview } = data;

  const ref = createRef<HTMLDivElement>();

  const [overrideContents, setOverrideContents] = useState<
    string | undefined
  >();

  const [pages, setPages] = useState<Element[][]>([]);
  const [page, setPage] = useState(0);

  useEffect(() => {
    let toParse = marked.parse(
      (overrideContents ? overrideContents : contents)
        .trim()
        .replaceAll(replacementRegex, ''),
    );

    const matches = Array.from(toParse.matchAll(imageRegex));
    for (const match of matches) {
      const asset = resolveAsset(match[1]);
      toParse = toParse.replace(match[0], `src="${asset}"`);
    }

    ref.current!.innerHTML = toParse;

    const rect = ref.current!.getBoundingClientRect();

    let page = 0;
    const pages: Element[][] = [];

    const list = ref.current!.children;
    for (let i = 0; i < list.length; i++) {
      const limit = (page + 1) * (670 - rect.top);
      const element = list[i];

      const elementRect = element.getBoundingClientRect();

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
  }, [overrideContents]);

  useEffect(() => {
    // Remove with 516
    if (Byond.TRIDENT) {
      ref.current!.textContent = '';
    } else {
      ref.current!.innerHTML = '';
    }

    const selectedPage = pages[page];

    if (!selectedPage) {
      return;
    }

    for (const element of selectedPage) {
      ref.current!.appendChild(element);
    }
  }, [page, pages]);

  const [previewing, setPreviewing] = useState(false);

  return (
    <Window
      width={650 + (previewing ? 500 : 0)}
      height={700}
      theme="paper"
      scrollbars={false}
    >
      <Window.Content className="Book">
        <Stack fill>
          <Stack.Item>
            <Stack vertical fill width="640px">
              <Stack.Item>
                <Stack justify="space-between">
                  <Stack.Item width="500px">
                    <BookHeader />
                  </Stack.Item>
                  {!!preview && (
                    <Stack.Item align="flex-end">
                      <Button
                        icon="eye"
                        onClick={() =>
                          setPreviewing((previewing) => !previewing)
                        }
                      >
                        Preview
                      </Button>
                    </Stack.Item>
                  )}
                </Stack>
              </Stack.Item>
              <Box className="PaperDivider TopDivider" />
              <Stack vertical justify="space-between" fill>
                <Stack.Item>
                  <div ref={ref} />
                </Stack.Item>
                <Box
                  className="PaperDivider BottomDivider"
                  position="absolute"
                  width="98%"
                  bottom="0"
                  left="8px"
                />
              </Stack>
              {pages.length && (
                <>
                  {page > 0 && (
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
                      }}
                      style={{ right: previewing ? '455px' : '' }}
                    />
                  )}
                </>
              )}
            </Stack>
          </Stack.Item>
          {!!preview && (
            <Stack.Item>
              <TextArea
                value={
                  overrideContents ||
                  contents.trim().replaceAll(replacementRegex, '')
                }
                onInput={(_, val) => setOverrideContents(val)}
                onEnter={(_, val) => act('new_contents', { contents: val })}
                width="490px"
                height="660px"
                scrollbar
              />
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const BookHeader = () => {
  const { data } = useBackend<BookData>();
  const { title, author } = data;

  return (
    <Stack>
      <Stack.Item>
        <Image
          src={resolveAsset('logo_uscm.png')}
          height={4}
          fixBlur={false}
          className="HeaderImage"
        />
      </Stack.Item>
      <Stack.Item width="500px">
        <Stack vertical justify="center" fill>
          <Stack.Item>
            <Box fontSize="24px">{title}</Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack vertical justify="flex-end" fill>
          <Stack.Item pt={2}>
            <Box>{author}</Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
