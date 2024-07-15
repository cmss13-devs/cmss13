import { Fragment } from 'react';
import { useBackend } from '../backend';
import { Section, Button, LabeledList, Box, Stack, NoticeBox } from '../components';
import { Window } from '../layouts';

export const BotanyExtractor = () => {
  const { act, data } = useBackend();

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
                content={disk ? 'Eject ' + disk : 'Eject disk'}
                disabled={!disk}
                onClick={() => act('eject_disk')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                content={seed ? 'Eject ' + seed : 'Eject seed packet'}
                disabled={!seed}
                onClick={() => act('eject_packet')}
              />
            </Stack.Item>
            {!!seed && (
              <Stack.Item>
                <Button.Confirm
                  fluid
                  icon="industry"
                  content={'Process ' + seed + "'s genome"}
                  confirmContent="Are you sure? This will destroy the seeds."
                  disabled={!seed}
                  onClick={() => act('scan_genome')}
                />
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
                    <LabeledList.Item label={entry.mask} key={entry}>
                      <Button
                        content="Extract gene"
                        icon="download"
                        disabled={!disk || degraded}
                        onClick={() => act('get_gene', { gene: entry.tag })}
                      />
                    </LabeledList.Item>
                  );
                })}
              </LabeledList>
              <Box height="10px" />
              <Button.Confirm
                fluid
                icon="snowplow"
                content="Clear buffer"
                disabled={!hasGenetics}
                onClick={() => act('clear_buffer')}
              />
            </>
          )) || <NoticeBox danger>No genetic data stored!</NoticeBox>}
        </Section>
      </Window.Content>
    </Window>
  );
};
