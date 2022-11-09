import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Flex,
  Section,
  Box,
  Tabs,
  Fragment,
  LabeledList,
} from '../components';
import { Window } from '../layouts';

export const TechMemories = (props, context) => {
  const { act, data } = useBackend(context);
  const [clueCategory, setClueCategory] = useLocalState(
    context,
    'clueCategory',
    0
  );

  const { tech_points, theme, clue_categories } = data;

  return (
    <Window width={650} height={700} theme={theme}>
      <Window.Content scrollable>
        <Section title="Tech Points">
          <Box fontSize="16px">{tech_points}</Box>
        </Section>

        <Objectives />

        <Section title="Clues">
          <Tabs fluid>
            {clue_categories.map((clue_category, i) => {
              return (
                <Tabs.Tab
                  key={i}
                  color="blue"
                  selected={i === clueCategory}
                  icon={clue_category.icon}
                  onClick={() => setClueCategory(i)}>
                  {clue_category.name}
                  {!!clue_category.clues.length &&
                    ' (' + clue_category.clues.length + ')'}
                </Tabs.Tab>
              );
            })}
          </Tabs>

          <CluesAdvanced clues={clue_categories[clueCategory].clues} />
        </Section>
      </Window.Content>
    </Window>
  );
};

const CluesAdvanced = (props, context) => {
  const { clues } = props;

  return (
    <Section>
      <Flex direction="column">
        {clues.map((clue) => {
          return (
            <Flex
              key={0}
              className="candystripe"
              justify="space-between"
              px="1rem"
              py=".5rem">
              <Flex.Item>
                {!!clue.color && (
                  <Box inline preserveWhitespace color={clue.color_name}>
                    {clue.color + ' '}
                  </Box>
                )}
                {clue.text}
                {!!clue.itemID && (
                  <Box inline bold preserveWhitespace>
                    {' ' + clue.itemID}
                  </Box>
                )}
                {!!clue.key && (
                  <Fragment>
                    {clue.key_text}
                    <Box inline bold>
                      {clue.key}
                    </Box>
                  </Fragment>
                )}
              </Flex.Item>
              <Flex.Item>{clue.location}</Flex.Item>
            </Flex>
          );
        })}
      </Flex>
    </Section>
  );
};

const Objectives = (props, context) => {
  const { data } = useBackend(context);

  return (
    <Section
      title="Objectives"
      buttons={
        <Button
          content={'Total earned credits: ' + data.total_tech_points}
          backgroundColor="transparent"
        />
      }>
      <LabeledList>
        {data.objectives.map((page) => {
          return (
            <LabeledList.Item label={page.label} key={0}>
              {!!page.content && (
                <Box
                  color={page.content_color ? page.content_color : 'white'}
                  inline
                  preserveWhitespace>
                  {page.content + ' '}
                </Box>
              )}
              {page.content_credits}
            </LabeledList.Item>
          );
        })}
      </LabeledList>
    </Section>
  );
};
