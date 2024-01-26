import { useBackend } from '../backend';
import { Section, Button, Stack, NoticeBox, Box, Flex, LabeledList } from '../components';
import { Window } from '../layouts';

export const XenomorphExtractor = (_props, context) => {
  const { act, data } = useBackend(context);

  const { organ, points, upgrades } = data;

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
                content={'Process Biomass'}
                disabled={!organ}
                onClick={() => act('process_organ')}
              />
            </Stack.Item>
          </Stack>
          <Section>Biological Buffer: {points}</Section>
        </Section>
        <Section title="Biological Material">
          {!organ && (
            <NoticeBox danger>
              Recepticle is empty, analyzing is impossible!
            </NoticeBox>
          )}
        </Section>
        <Flex.Item>
          <Box height="5px" />
          <UpgradesDropdown />
        </Flex.Item>
        {!!organ && (
          <Section title="Source Material">
            <NoticeBox>Biomass detected, Ready to process</NoticeBox>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

const UpgradesDropdown = (props, context) => {
  const { act, data } = useBackend(context);
  const { upgrades } = data;
  <Section title="upgrades">
    <LabeledList>
      {upgrades.map((upgrades) => (
        <LabeledList.Item
          key={upgrades.name}
          label={upgrades.name}
          className="underline"
          buttons={
            <Button
              content={'Print  (' + upgrades.cost * upgrades.vari + ')'}
              icon="print"
              tooltip={upgrades.desc}
              tooltipPosition="left"
              onClick={() =>
                act(
                  'produce'
                  //  path: upgrades.path,
                  //  cost: Equipment.cost,
                )
              }
            />
          }
        />
      ))}
    </LabeledList>
    ;
  </Section>;
};
