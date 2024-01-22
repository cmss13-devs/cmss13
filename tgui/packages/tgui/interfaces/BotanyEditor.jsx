import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Section, Button, Stack, LabeledList, NoticeBox } from '../components';
import { Window } from '../layouts';

export const BotanyEditor = (_props, context) => {
  const { act, data } = useBackend(context);

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
                content={disk ? 'Eject ' + disk : 'Eject disk'}
                disabled={!disk}
                onClick={() => act('eject_disk')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                content={seed ? 'Eject ' + seed : 'Eject target seeds'}
                disabled={!seed}
                onClick={() => act('eject_packet')}
              />
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Buffered Genetic Data">
          <Fragment>
            {!disk && (
              <NoticeBox danger>
                No disk! Genetic data cannot be applied.
              </NoticeBox>
            )}
            {!seed && (
              <NoticeBox danger>No seeds to apply genetic data to!</NoticeBox>
            )}
          </Fragment>
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
                  content="Apply gene mods"
                  disabled={!seed || degraded}
                  onClick={() => act('apply_gene')}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
