import { marked } from 'marked';
import { createRef, useEffect } from 'react';

import { useBackend } from '../backend';
import { Box, Stack } from '../components';
import { Window } from '../layouts';

type BookData = {
  title: string;
  author: string;
  contents: string;
};

export const Book = () => {
  const { data } = useBackend<BookData>();

  const { title, author, contents } = data;

  const ref = createRef<HTMLDivElement>();

  useEffect(() => {
    ref.current!.innerHTML = marked.parse(contents);
  }, [ref]);

  return (
    <Window width={300} height={480} theme="paper">
      <Window.Content className="Book">
        <Stack vertical>
          <Stack.Item>
            <Box textAlign="center">{title}</Box>
          </Stack.Item>
          <Stack.Item>
            <Box textAlign="center">{author}</Box>
          </Stack.Item>
          <Stack.Item>
            <div ref={ref} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
