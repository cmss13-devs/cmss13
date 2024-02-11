import { useBackend } from '../backend';
import { Section, Button, LabeledList, Flex } from '../components';
import { Window } from '../layouts';

export const PartFabricator = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={900} height={450}>
      <Window.Content>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { points, omnisentrygun_price, Equipment, Ammo } = data;
  return (
    <div>
      <Section>Points: {points}</Section>
      <Flex height="100%" direction="row">
        <Flex.Item>
          <Section title="Equipment">
            <LabeledList>
              {Equipment.map((Equipment) => (
                <LabeledList.Item
                  key={Equipment.name}
                  label={Equipment.name}
                  className="underline"
                  buttons={
                    <Button
                      content={'Fabricate  (' + Equipment.cost + ')'}
                      icon="wrench"
                      tooltip={Equipment.desc}
                      tooltipPosition="left"
                      onClick={() =>
                        act('produce', {
                          index: Equipment.index,
                          is_ammo: Equipment.is_ammo,
                        })
                      }
                    />
                  }
                />
              ))}
            </LabeledList>
          </Section>
        </Flex.Item>
        <Flex.Item>
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
                        content={'Fabricate  (' + omnisentrygun_price + ')'}
                        icon="wrench"
                        tooltip={Ammo.desc}
                        tooltipPosition="left"
                        cost={omnisentrygun_price}
                        onClick={() =>
                          act('produce', {
                            index: Ammo.index,
                            is_ammo: Ammo.is_ammo,
                          })
                        }
                      />
                    ) : (
                      <Button
                        content={'Fabricate  (' + Ammo.cost + ')'}
                        icon="wrench"
                        tooltip={Ammo.desc}
                        tooltipPosition="left"
                        onClick={() =>
                          act('produce', {
                            index: Ammo.index,
                            is_ammo: Ammo.is_ammo,
                          })
                        }
                      />
                    )
                  }
                />
              ))}
            </LabeledList>
          </Section>
        </Flex.Item>
      </Flex>
    </div>
  );
};
