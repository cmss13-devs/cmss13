import { useBackend } from '../backend';
import { Button, LabeledList, Section, Slider, Flex, Box } from '../components';
import { Window } from '../layouts';

export const AcidVest = (_props, context) => {
  const { act, data } = useBackend(context);

  const damageList = data.configList.Damage;
  const vitalsList = data.configList.Vitals;
  const conditionsList = data.configList.Conditions;

  const injectLogic = data.inject_logic;
  const injectThreshold = data.inject_damage_threshold;
  const injectAmount = data.inject_amount;

  const Ormode = injectLogic === 'OR' ? true : false;

  return (
    <Window width={400} height={550} theme="ntos">
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Injection Amount">
              <Slider
                inline
                maxValue={30}
                minValue={1}
                value={injectAmount}
                onChange={(e, value) =>
                  act('set_inject_amount', { value: value })
                }
                mt={1}
                stepPixelSize={10}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Damage Threshold">
              <Slider
                inline
                maxValue={200}
                minValue={1}
                value={injectThreshold}
                onChange={(e, value) =>
                  act('set_inject_damage_threshold', { value: value })
                }
                mt={1}
                stepPixelSize={2}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Configuration">
              <Button
                content={injectLogic}
                onClick={() => act('inject_logic')}
                icon={Ormode ? 'question' : 'plus'}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Configuration">
          <Flex direction="row" grow>
            <Flex.Item>
              <Section title="Damage">
                <Flex direction="column" grow>
                  {Object.keys(damageList).map((category) => (
                    <Flex.Item key={category}>
                      <Button.Checkbox
                        fontSize="1.2rem"
                        content={category}
                        checked={!!damageList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Damage',
                            config_value: damageList[category]['value'],
                          })
                        }
                      />
                    </Flex.Item>
                  ))}
                </Flex>
              </Section>
            </Flex.Item>
            <Box width="10px" />
            <Flex.Item>
              <Section title="Conditions">
                <Flex direction="column" grow>
                  {Object.keys(conditionsList).map((category) => (
                    <Flex.Item key={category}>
                      <Button.Checkbox
                        fontSize="1.2rem"
                        content={category}
                        checked={!!conditionsList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Conditions',
                            config_value: conditionsList[category]['value'],
                          })
                        }
                      />
                    </Flex.Item>
                  ))}
                </Flex>
              </Section>
            </Flex.Item>
            <Box width="10px" />
            <Flex.Item>
              <Section title="Vitals">
                <Flex direction="column" grow>
                  {Object.keys(vitalsList).map((category) => (
                    <Flex.Item key={category}>
                      <Button.Checkbox
                        fontSize="1.2rem"
                        content={category}
                        checked={!!vitalsList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Vitals',
                            config_value: vitalsList[category]['value'],
                          })
                        }
                      />
                    </Flex.Item>
                  ))}
                </Flex>
              </Section>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
