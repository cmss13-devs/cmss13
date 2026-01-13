import { useBackend } from 'tgui/backend';
import { Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

import {
  CompoundTable,
  type DocumentLog,
  type DocumentRecord,
} from './ResearchTerminal';

interface TerminalProps {
  published_documents: DocumentLog;
  terminal_view: number;
}

export const PublishedDocsHud = () => {
  const { data } = useBackend<TerminalProps>();
  const published = Object.keys(data.published_documents)
    .map((x) => {
      const output = data.published_documents[x] as DocumentRecord[];
      output.forEach((y) => {
        y.category = x;
      });
      return output;
    })
    .flat() as DocumentRecord[];
  return (
    <Window width={500} height={400} theme="ntos">
      <Window.Content scrollable>
        <Section title="Published Documents">
          <Stack vertical>
            <Stack.Item>
              <CompoundTable
                className="PublishedDocs"
                docs={published}
                timeLabel="Published"
                canPrint={false}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
