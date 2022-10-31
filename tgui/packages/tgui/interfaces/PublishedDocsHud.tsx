import { useBackend } from '../backend';
import { Section, Stack } from '../components';
import { Window } from '../layouts';
import { DocumentLog, CompoundTable } from './ResearchTerminal';

interface TerminalProps {
  "published_documents": DocumentLog;
  "terminal_view": number;
}

export const PublishedDocsHud = (_, context) => {
  const { data } = useBackend<TerminalProps>(context);
  return (
    <Window width={500} height={400} theme="ntos">
      <Window.Content scrollable>
        <Section title="Published Documents">
          <Stack vertical>
            <Stack.Item>
              <CompoundTable
                className="PublishedDocs"
                docs={data.published_documents['XRF Scans'] ?? []}
                timeLabel="Published"
                canPrint={false} />
            </Stack.Item>
          </Stack>
        </Section>

      </Window.Content>
    </Window>);
};
