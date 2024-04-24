import { useBackend } from '../backend';
import { Section, Button, Stack, NoticeBox, LabeledList, Flex, Box } from '../components';
import { Window } from '../layouts';

export const XenomorphExtractor = (_props, context) => {
  const { act, data } = useBackend(context);

  const { organ, points, upgrades, caste, value } = data;

  return (
    <Window width={600} height={650} theme="crtyellow">
      <Window.Content scrollable>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                content={
                  !organ ? 'Eject Biomass' : 'Eject ' + caste + ' biomass'
                }
                disabled={!organ}
                onClick={() => act('eject_organ')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                content={
                  !organ
                    ? 'Process Biomass'
                    : 'Process Biomass, Expected value : ' + value
                }
                disabled={!organ}
                onClick={() => act('process_organ')}
              />
            </Stack.Item>
            <Stack.Item>
              <NoticeBox info>Biological Matter : {points}</NoticeBox>
            </Stack.Item>
          </Stack>
        </Section>
        <Section title="Biological Material">
          {!organ && (
            <NoticeBox danger>
              Recepticle is empty, analyzing is impossible!
            </NoticeBox>
          )}
        </Section>
        <Flex height="200%" direction="row">
          <Flex.Item>
            <Section title="Available technologies:">
              <LabeledList>
                {upgrades.map((upgrades) => (
                  <LabeledList.Item
                    key={upgrades.name}
                    label={<NoticeBox>{upgrades.name}</NoticeBox>}
                    buttons={
                      <Box>
                        <Button
                          fluid={1}
                          content={'Print ' + '  (' + upgrades.cost + ')'}
                          icon="print"
                          tooltip={upgrades.desc}
                          tooltipPosition="left"
                          onClick={() =>
                            act('produce', {
                              ref: upgrades.ref,
                              cost: upgrades.cost,
                              varia: upgrades.vari,
                            })
                          }
                        />
                      </Box>
                    }
                  />
                ))}
              </LabeledList>
            </Section>
          </Flex.Item>
        </Flex>
        {!!organ && (
          <Section title="Source Material">
            <NoticeBox>Biomass detected, Ready to process</NoticeBox>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
