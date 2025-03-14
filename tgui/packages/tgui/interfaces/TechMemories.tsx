import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, LabeledList, Section, Tabs } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Clue = {
  text: string;
  itemID: string;
  location: string;
  color?: string;
  color_name?: string;
  key?: string;
  key_text?: string;
};

type ClueCategory = {
  name: string;
  icon: string;
  clues: Array<Clue>;
};

type ObjectiveData = {
  label: string;
  content_credits: string;
  content: string;
  content_color: string;
};

type TechProps = {
  clue_categories: Array<ClueCategory>;
  tech_points: number;
  total_tech_points: number;
  objectives: Array<ObjectiveData>;
  theme: string;
};

export const TechMemories = () => {
  const { config, data } = useBackend<TechProps>();
  const [clueCategory, setClueCategory] = useState(0);
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

const CluesAdvanced = (props: { readonly clues: Array<Clue> }) => {
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
                  <>
                    {clue.key_text}
                    <Box inline bold>
                      {clue.key}
                    </Box>
                  </>
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

const Objectives = (props) => {
  const { data } = useBackend<TechProps>();

  return (
    <Section
      title="Objectives"
      buttons={
        <Button backgroundColor="transparent">
          {'Total earned credits: ' + data.total_tech_points}
        </Button>
      }
    >
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
