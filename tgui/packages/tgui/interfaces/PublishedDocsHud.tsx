import { useBackend } from '../backend';
import { Section, Stack } from '../components';
import { Window } from '../layouts';
import { DocumentLog, CompoundTable, DocumentRecord } from './ResearchTerminal';

interface TerminalProps {
  "published_documents": DocumentLog;
  "terminal_view": number;
}

export const PublishedDocsHud = (_, context) => {
  const { data } = useBackend<TerminalProps>(context);
  const published = Object.keys(data.published_documents)
    .map(x => {
      const output = data.published_documents[x] as DocumentRecord[];
      output.forEach(y => { y.category = x; });
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
                canPrint={false} />
            </Stack.Item>
          </Stack>
        </Section>

      </Window.Content>
    </Window>);
};
