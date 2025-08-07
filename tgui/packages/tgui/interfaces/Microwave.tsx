import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, NoticeBox, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Ingredient = {
  name: string;
  count: number;
  measure: string;
};

type BackendContext = {
  operating: BooleanLike;
  broken: BooleanLike;
  dirty: BooleanLike;
  ingredients: Ingredient[];
};

export const Microwave = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const { operating, broken, dirty, ingredients } = data;

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        <Section
          fill
          title="Ingredients"
          buttons={
            <Flex>
              <Button
                height="100%"
                icon="power-off"
                disabled={!!operating || !!dirty || !!broken}
                onClick={() => act('cook')}
              >
                Activate
              </Button>

              <Button
                height="100%"
                icon="eject"
                disabled={!ingredients.length || !!operating}
                onClick={() => act('eject_all')}
              >
                Eject all
              </Button>
            </Flex>
          }
        >
          {!!operating && (
            <NoticeBox
              width="100%"
              textAlign="center"
              p=".5rem"
              fontSize="1.5rem"
            >
              Cooking...
            </NoticeBox>
          )}

          {!!broken && (
            <NoticeBox danger width="100%" textAlign="center" p="1rem">
              Appliance broken. Please contact your local technician.
            </NoticeBox>
          )}

          {!!dirty && (
            <NoticeBox danger width="100%" textAlign="center" p="1rem">
              This microwave is too dirty. Cleaning required.
            </NoticeBox>
          )}

          {!ingredients.length && <Box>None</Box>}

          <Flex direction="column">
            {ingredients.map((ingredient) => {
              return (
                <Flex.Item key={ingredient.name} py=".2rem">
                  <b>{ingredient.name}</b>: {ingredient.count}{' '}
                  {ingredient.measure}
                </Flex.Item>
              );
            })}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
