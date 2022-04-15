import { useBackend } from '../backend';
import { Section, Button, LabeledList, Flex } from '../components';
import { Window } from '../layouts';

export const PartFabricator = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={750}
      height={450}
    >
      <Window.Content>
        <GeneralPanel />
      </Window.Content>
    </Window>
  );
};

const GeneralPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { points, Equipment, Ammo } = data;

  return (
    <div>
      <Section>
        Points: {points}
      </Section>
      <Flex height="100%" direction="row">
        <Flex.Item>
          <Section title="Equipment">
            <LabeledList>
              {Equipment.map(Equipment => (
                <LabeledList.Item
                  key={Equipment.name}
                  label={Equipment.name}
                  className="underline"
                  buttons={(
                    <Button
                      content={"Fabricate  (" + Equipment.cost + ")"}
                      icon="wrench"
                      tooltip={Equipment.desc}
                      tooltipPosition="left"
                      onClick={() => act('produce', {
                        path: Equipment.path,
                        cost: Equipment.cost,
                      })}
                    />
                  )}
                />
              ))}
            </LabeledList>
          </Section>
        </Flex.Item>
        <Flex.Item>
          <Section title="Ammo">
            <LabeledList>
              {Ammo.map(Ammo => (
                <LabeledList.Item
                  key={Ammo.name}
                  label={Ammo.name}
                  className="underline"
                  buttons={(
                    <Button
                      content={"Fabricate  (" + Ammo.cost + ")"}
                      icon="wrench"
                      tooltip={Ammo.desc}
                      tooltipPosition="left"
                      onClick={() => act('produce', {
                        path: Ammo.path,
                        cost: Ammo.cost,
                      })}
                    />
                  )}
                />
              ))}
            </LabeledList>
          </Section>
        </Flex.Item>
      </Flex>
    </div>
  );
};
