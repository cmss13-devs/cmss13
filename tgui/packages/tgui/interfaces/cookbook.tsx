import { createSearch, decodeHtmlEntities } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, DmIcon, Input, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  categories: string[];
  current_category: string;
  recipes: string[];
  search_text: string;
};

export const cookbook = (props) => {
  const { act, data } = useBackend<Data>();

  const [recipeList, setRecipeList] = useState(data.recipes);
  const [searchText, setSearchText] = useState(data.search_text);

  return (
    <Window
      title="Pans and Dishes: Your Way Around the Marine Kitchens"
      width={600}
      height={600}
    >
      <Window.Content scrollable>
        <Box>
          {data.categories.sort().map((category, i) => (
            <Button
              key={i}
              onClick={() =>
                act('set_category', { name: category, search_text: searchText })
              }
            >
              {category}
            </Button>
          ))}
          {data.current_category && (
            <Section
              title={data.current_category}
              buttons={
                <Input
                  width="200px"
                  placeholder={`Search ${data.current_category}`}
                  onInput={(e, value) => setSearchText(value)}
                  value={searchText}
                />
              }
            >
              <Stack vertical>
                {data.recipes
                  .filter(
                    createSearch(searchText, (recipe) => {
                      /** ignore the errors it all works for some reason */
                      return (
                        recipe.name +
                        '|' +
                        recipe.container +
                        '|' +
                        recipe.instructions.toString()
                      );
                    }),
                  )
                  .sort((a, b) => a?.name.localeCompare(b?.name))
                  .map((recipe, i) => (
                    <Stack.Item key={i}>
                      <Section title={decodeHtmlEntities(recipe.name)}>
                        <Stack>
                          <Stack.Item>
                            <DmIcon
                              icon={recipe.icon}
                              icon_state={recipe.icon_state}
                              style={{ width: '64px', height: '64px' }}
                            />
                          </Stack.Item>
                          <Stack.Item>
                            {recipe.container}:
                            <ol>
                              {recipe.instructions.map((instruction, j) => (
                                <li key={`${i}-${j}`}>{instruction}</li>
                              ))}
                            </ol>
                          </Stack.Item>
                        </Stack>
                      </Section>
                    </Stack.Item>
                  ))}
              </Stack>
            </Section>
          )}
        </Box>
      </Window.Content>
    </Window>
  );
};
