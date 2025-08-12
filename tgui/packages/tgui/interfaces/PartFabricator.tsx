import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Button, Flex, LabeledList, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type DataEntry = {
  name: string;
  desc: string;
  cost: number;
  index: number;
  is_ammo: BooleanLike;
};

type EquipmentCategories = {
  [key: string]: DataEntry[];
};

type Data = {
  Equipment: EquipmentCategories;
  Ammo: DataEntry[];
  points: number;
  omnisentrygun_price: number;
  BuildQueue: { name: string; cost: number; index: number }[];
};

export const PartFabricator = (props) => {
  return (
    <Window width={900} height={850}>
      <Window.Content scrollable>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { points, omnisentrygun_price, Equipment, Ammo, BuildQueue } = data;
  return (
    <div>
      <Section>
        <Section>Points: {points}</Section>
        <Flex height="100%" direction="row">
          <Flex.Item grow={1}>
            <Section title="Equipment">
              {Object.entries(Equipment).map(
                ([categoryName, equipmentList]) => (
                  <Section key={categoryName} title={categoryName}>
                    <LabeledList>
                      {equipmentList.map((equipment) => (
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
                  </Section>
                ),
              )}
            </Section>
          </Flex.Item>
          <Flex.Item width="2rem" />
          <Flex.Item grow={1}>
            <Section title="Ammo">
              <LabeledList>
                {Ammo.map((Ammo) => (
                  <LabeledList.Item
                    key={Ammo.name}
                    label={Ammo.name}
                    className="underline"
                    buttons={
                      Ammo.name === 'A/C-49-P Air Deployable Sentry' ? (
                        <Button
                          icon="wrench"
                          tooltip={Ammo.desc}
                          tooltipPosition="left"
                          onClick={() =>
                            act('produce', {
                              index: Ammo.index,
                              is_ammo: Ammo.is_ammo,
                            })
                          }
                        >
                          {'Fabricate  (' + omnisentrygun_price + ')'}
                        </Button>
                      ) : (
                        <Button
                          icon="wrench"
                          tooltip={Ammo.desc}
                          tooltipPosition="left"
                          onClick={() =>
                            act('produce', {
                              index: Ammo.index,
                              is_ammo: Ammo.is_ammo,
                            })
                          }
                        >
                          {'Fabricate  (' + Ammo.cost + ')'}
                        </Button>
                      )
                    }
                  />
                ))}
              </LabeledList>
            </Section>
          </Flex.Item>
        </Flex>
      </Section>
      <Section>
        <Section title="Build Queue:" />
        <Flex height="100%" direction="row">
          <Flex.Item>
            <LabeledList>
              {BuildQueue.map((Entry) => (
                <LabeledList.Item
                  key={Entry.name}
                  label={Entry.index + '. ' + Entry.name}
                  className="underline"
                >
                  <Button
                    icon="xmark"
                    tooltip={Entry.cost}
                    tooltipPosition="left"
                    onClick={() =>
                      act('cancel', {
                        index: Entry.index,
                        name: Entry.name,
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
