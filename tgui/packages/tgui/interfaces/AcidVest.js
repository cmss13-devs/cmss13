import { useBackend } from '../backend';
import { Button, LabeledList, Section, Slider, Flex } from '../components';
import { Window } from '../layouts';

export const AcidVest = (_props, context) => {
  const { act, data } = useBackend(context);

  const configList = data.configList;
  const injectLogic = data.inject_logic;
  const injectThreshold = data.inject_damage_threshold;
  const injectAmount = data.inject_amount;

  const Ormode = injectLogic === 'OR' ? true : false;

  return (
    <Window width={400} height={320}>
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
          <Flex>
            {Object.keys(configList).map((category) => (
              <Flex.Item key={category}>
                <Section title={category}>
                  <Flex direction="column">
                    {configList[category].map((entry) => (
                      <Flex.Item key={entry}>
                        <Button.Checkbox
                          content={entry}
                          backgroundColor="rgba(40, 40, 40, 255)"
                          width="100%"
                          height="2px"
                          mt="2px"
                        />
                      </Flex.Item>
                    ))}
                  </Flex>
                </Section>
              </Flex.Item>
            ))}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
