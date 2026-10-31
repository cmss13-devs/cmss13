import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, LabeledList, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type DataEntry = {
  name: string;
  desc: string;
  cost: number;
  index: number;
  is_ammo: BooleanLike;
};

type EquipmentCategories = Record<string, DataEntry[]>;

type Data = {
  Equipment: EquipmentCategories;
  Ammo: EquipmentCategories;
  points: number;
  omnisentrygun_price: number;
  BuildQueue: { name: string; cost: number; index: number }[];
};

export const PartFabricator = () => {
  return (
    <Window width={900} height={850}>
      <Window.Content scrollable>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = () => {
  const { act, data } = useBackend<Data>();
  const { points, omnisentrygun_price, Equipment, Ammo, BuildQueue } = data;
  return (
    <div>
      <Section title={`Points: ${points}`}>
        <Flex height="100%" direction="row">
          <Flex.Item grow={1}>
            <Section title="Equipment">
              {Object.entries(Equipment).map(
                ([categoryName, equipmentList]) => (
                  <Box key={categoryName} mb={2}>
                    <Box bold mb={1}>
                      {categoryName}
                    </Box>
                    <LabeledList>
                      {[...equipmentList]
                        .sort((a, b) => a.name.localeCompare(b.name))
                        .map((equipment) => (
                          <LabeledList.Item
                            key={equipment.name}
                            label={equipment.name}
                            className="underline"
                            buttons={
                              <Button
                                icon="wrench"
                                tooltip={equipment.desc}
                                tooltipPosition="left"
                                onClick={() =>
                                  act('produce', {
                                    index: equipment.index,
                                    is_ammo: equipment.is_ammo,
                                  })
                                }
                              >
                                {'Fabricate  (' + equipment.cost + ')'}
                              </Button>
                            }
                          />
                        ))}
                    </LabeledList>
                  </Box>
                ),
              )}
            </Section>
          </Flex.Item>
          <Flex.Item width="2rem" />
          <Flex.Item grow={1}>
            <Section title="Ammo">
              {Object.entries(Ammo).map(([categoryName, ammoList]) => (
                <Box key={categoryName} mb={2}>
                  <Box bold mb={1}>
                    {categoryName}
                  </Box>
                  <LabeledList>
                    {[...ammoList]
                      .sort((a, b) => a.name.localeCompare(b.name))
                      .map((ammo) => {
                        const fabricationCost =
                          ammo.name === 'A/C-49-P Air Deployable Sentry'
                            ? omnisentrygun_price
                            : ammo.cost;
                        return (
                          <LabeledList.Item
                            key={ammo.name}
                            label={ammo.name}
                            className="underline"
                            buttons={
                              <Button
                                icon="wrench"
                                tooltip={ammo.desc}
                                tooltipPosition="left"
                                onClick={() =>
                                  act('produce', {
                                    index: ammo.index,
                                    is_ammo: ammo.is_ammo,
                                  })
                                }
                              >
                                Fabricate ({fabricationCost})
                              </Button>
                            }
                          />
                        );
                      })}
                  </LabeledList>
                </Box>
              ))}
            </Section>
          </Flex.Item>
        </Flex>
      </Section>
      <Section title="Build Queue">
        <Flex height="100%" direction="row">
          <Flex.Item>
            <LabeledList>
              {BuildQueue.map((entry) => (
                <LabeledList.Item
                  key={entry.name}
                  label={`${entry.index}. ${entry.name}`}
                  className="underline"
                >
                  <Button
                    icon="xmark"
                    tooltip={entry.cost}
                    tooltipPosition="left"
                    onClick={() =>
                      act('cancel', {
                        index: entry.index,
                        name: entry.name,
                      })
                    }
                  />
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Flex.Item>
        </Flex>
      </Section>
    </div>
  );
};
