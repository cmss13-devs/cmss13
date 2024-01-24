import { useBackend } from '../backend';
import { Section, Button, Stack, LabeledList, NoticeBox } from '../components';
import { Window } from '../layouts';

export const XenomorphExtractor = (_props, context) => {
  const { act, data } = useBackend(context);

  const { organ, points } = data;

  const degraded = degradation >= 100;

  return (
    <Window width={400} height={650} theme="weyland">
      <Window.Content scrollable>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                content={'Eject Biomass'}
                disabled={!organ}
                onClick={() => act('eject_organ')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                content={'Process Organ'}
                disabled={!organ}
                onClick={() => act('process_organ')}
              />
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Biological Material">
          {!organ && (
            <NoticeBox danger>
              Recepticle is empty, analyzing is impossible!
            </NoticeBox>
          )}
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
