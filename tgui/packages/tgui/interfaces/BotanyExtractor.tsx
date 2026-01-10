import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  geneMasks: { tag: string; mask: string }[];
  degradation: number;
  disk: string | null;
  seed: string | BooleanLike;
  hasGenetics: BooleanLike;
  sourceName: string | BooleanLike;
};

export const BotanyExtractor = () => {
  const { act, data } = useBackend<Data>();

  const { disk, seed, geneMasks, degradation, hasGenetics, sourceName } = data;

  const degraded = degradation >= 100;

  return (
    <Window width={400} height={450} theme="weyland">
      <Window.Content scrollable>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!disk}
                onClick={() => act('eject_disk')}
              >
                {disk ? 'Eject ' + disk : 'Eject disk'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!seed}
                onClick={() => act('eject_packet')}
              >
                {seed ? 'Eject ' + seed : 'Eject seed packet'}
              </Button>
            </Stack.Item>
            {!!seed && (
              <Stack.Item>
                <Button.Confirm
                  fluid
                  icon="industry"
                  confirmContent="Are you sure? This will destroy the seeds."
                  disabled={!seed}
                  onClick={() => act('scan_genome')}
                >
                  {'Process ' + seed + "'s genome"}
                </Button.Confirm>
              </Stack.Item>
            )}
          </Stack>
        </Section>
        <Section title="Buffered Genetic Data">
          {(!!hasGenetics && (
            <>
              {!disk && (
                <NoticeBox danger>
                  No disk! Genetic data cannot be extracted.
                </NoticeBox>
              )}
              {degraded && (
                <NoticeBox danger>
                  Genetic data too degraded to extract!
                </NoticeBox>
              )}
              <LabeledList>
                <LabeledList.Item label="Source">{sourceName}</LabeledList.Item>
                <LabeledList.Item label="Gene Decay">
                  {!degraded ? degradation + '%' : '#!ERROR%'}
                </LabeledList.Item>
                {geneMasks.map((entry) => {
                  return (
                    <LabeledList.Item label={entry.mask} key={entry.tag}>
                      <Button
                        icon="download"
                        disabled={!disk || degraded}
                        onClick={() => act('get_gene', { gene: entry.tag })}
                      >
                        Extract gene
                      </Button>
                    </LabeledList.Item>
                  );
                })}
              </LabeledList>
              <Box height="10px" />
              <Button.Confirm
                fluid
                icon="snowplow"
                disabled={!hasGenetics}
                onClick={() => act('clear_buffer')}
              >
                Clear buffer
              </Button.Confirm>
            </>
          )) || <NoticeBox danger>No genetic data stored!</NoticeBox>}
        </Section>
      </Window.Content>
    </Window>
  );
};
