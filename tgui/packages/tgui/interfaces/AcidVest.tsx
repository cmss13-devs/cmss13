import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  Section,
  Slider,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type ListEntry = { flag: BooleanLike; value: number };

type Data = {
  configList: {
    Damage: {
      Brute: ListEntry;
      Burn: ListEntry;
      Toxin: ListEntry;
      Oxygen: ListEntry;
      Genetic: ListEntry;
      Heart: ListEntry;
      Liver: ListEntry;
      Lungs: ListEntry;
      Kidneys: ListEntry;
      Brain: ListEntry;
    };
    Conditions: {
      'Vitals Level': ListEntry;
      Bleeding: ListEntry;
      Internal: ListEntry;
      Bloodloss: ListEntry;
      Fracture: ListEntry;
      Splinted: ListEntry;
      'Organ Damage': ListEntry;
      'Organ Failure': ListEntry;
      Death: ListEntry;
      Defibrillation: ListEntry;
      Concussion: ListEntry;
      Intoxication: ListEntry;
      'Foreign Object': ListEntry;
    };
    Vitals: {
      Optimal: ListEntry;
      Nominal: ListEntry;
      Low: ListEntry;
      'Very low': ListEntry;
      Critical: ListEntry;
      Emergency: ListEntry;
    };
  };
  inject_logic: string;
  inject_damage_threshold: number;
  inject_amount: number;
};

export const AcidVest = (_props) => {
  const { act, data } = useBackend<Data>();

  const { configList, inject_logic, inject_damage_threshold, inject_amount } =
    data;

  const damageList = configList.Damage;
  const vitalsList = configList.Vitals;
  const conditionsList = configList.Conditions;

  const injectLogic = data.inject_logic;
  const injectThreshold = data.inject_damage_threshold;
  const injectAmount = data.inject_amount;

  const Ormode = inject_logic === 'OR' ? true : false;

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
                onClick={() => act('inject_logic')}
                icon={Ormode ? 'question' : 'plus'}
              >
                {injectLogic}
              </Button>
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
                        checked={!!damageList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Damage',
                            config_value: damageList[category]['value'],
                          })
                        }
                      >
                        {category}
                      </Button.Checkbox>
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
                        checked={!!conditionsList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Conditions',
                            config_value: conditionsList[category]['value'],
                          })
                        }
                      >
                        {category}
                      </Button.Checkbox>
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
                        checked={!!vitalsList[category]['flag']}
                        onClick={() =>
                          act('configurate', {
                            config_type: 'Vitals',
                            config_value: vitalsList[category]['value'],
                          })
                        }
                      >
                        {category}
                      </Button.Checkbox>
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
