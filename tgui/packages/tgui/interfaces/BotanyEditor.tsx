import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  disk: string | null;
  sourceName: string | BooleanLike;
  locus: string[] | BooleanLike;
  seed: string | BooleanLike;
  degradation: number;
};

export const BotanyEditor = () => {
  const { act, data } = useBackend<Data>();

  const { disk, seed, degradation, sourceName, locus } = data;

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
                {seed ? 'Eject ' + seed : 'Eject target seeds'}
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Buffered Genetic Data">
          <>
            {!disk && (
              <NoticeBox danger>
                No disk! Genetic data cannot be applied.
              </NoticeBox>
            )}
            {!seed && (
              <NoticeBox danger>No seeds to apply genetic data to!</NoticeBox>
            )}
          </>
          {!!disk && (
            <LabeledList>
              <LabeledList.Item label="Source">{sourceName}</LabeledList.Item>
              <LabeledList.Item label="Locus">{locus}</LabeledList.Item>
            </LabeledList>
          )}
        </Section>
        {!!seed && (
          <Section title="Source Material">
            {degraded && (
              <NoticeBox danger>Genetic data too degraded to edit!</NoticeBox>
            )}
            <LabeledList>
              <LabeledList.Item label="Target">{seed}</LabeledList.Item>
              <LabeledList.Item label="Gene Decay">
                {!degraded ? degradation + '%' : '#!ERROR%'}
              </LabeledList.Item>
              <LabeledList.Item>
                <Button
                  fluid
                  icon="download"
                  disabled={!seed || degraded}
                  onClick={() => act('apply_gene')}
                >
                  Apply gene mods
                </Button>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
