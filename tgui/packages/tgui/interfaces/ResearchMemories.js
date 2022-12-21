import { useBackend, useLocalState } from '../backend';
import {
  Flex,
  Section,
  Box,
  Tabs,
  LabeledList,
} from '../components';
import { Window } from '../layouts';

export const ResearchMemories = (props, context) => {
  const { act, data } = useBackend(context);
  const [clueCategory, setClueCategory] = useLocalState(
    context,
    'clueCategory',
    0
  );

  const { clearance, research_credits, theme, clue_categories } = data;

  return (
    <Window width={650} height={700} theme={theme}>
      <Window.Content scrollable>
        <Section title={'Clearance: ' + clearance}>
          <Flex.Item>
            {'Research Credits: ' + research_credits}
          </Flex.Item>
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
                {clue.text}
              </Flex.Item>
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
      title="Objectives">
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
