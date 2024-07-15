import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Flex, LabeledList, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const ResearchMemories = () => {
  const { data } = useBackend();
  const [clueCategory, setClueCategory] = useState(0);

  const { clearance, research_credits, theme, clue_categories } = data;

  return (
    <Window width={650} height={700} theme={theme}>
      <Window.Content scrollable>
        <Section title={'Clearance: ' + clearance}>
          <Flex.Item>{'Research Credits: ' + research_credits}</Flex.Item>
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
                  onClick={() => setClueCategory(i)}
                >
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

const CluesAdvanced = (props) => {
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
              py=".5rem"
            >
              <Flex.Item>{clue.text}</Flex.Item>
            </Flex>
          );
        })}
      </Flex>
    </Section>
  );
};

const Objectives = (props) => {
  const { data } = useBackend();

  return (
    <Section title="Objectives">
      <LabeledList>
        {data.objectives.map((page) => {
          return (
            <LabeledList.Item label={page.label} key={0}>
              {!!page.content && (
                <Box
                  color={page.content_color ? page.content_color : 'white'}
                  inline
                  preserveWhitespace
                >
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
