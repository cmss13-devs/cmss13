import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Recipe = { recipe_id: string; name: string; time: number; metal: number };

type Data = {
  recipes: Recipe[];
  metal_max: number;
  working: BooleanLike;
  metal_amt: number;
  printtime: number;
  worldtime: number;
  printingitem?: string;
  printingitemtime?: number;
};

export const BioSyntheticPrinter = () => {
  const { act, data } = useBackend<Data>();

  const { printingitemtime } = data;

  const Working = data.working;

  const PrintingPct = printingitemtime
    ? 1 - (data.printtime - data.worldtime) / printingitemtime
    : 0;

  const recipes = data.recipes;

  return (
    <Window width={400} height={320}>
      <Window.Content scrollable>
        <Section
          title="Stored metal"
          buttons={
            <Button
              onClick={() => act('eject')}
              disabled={data.metal_amt < 100}
            >
              Eject all
            </Button>
          }
        >
          <ProgressBar value={data.metal_amt} maxValue={data.metal_max}>
            <Box textAlign="center">
              {data.metal_amt}/{data.metal_max} metal stored
            </Box>
          </ProgressBar>
        </Section>
        <Section title="Limbs" fill>
          {!!Working && (
            <Box>
              <NoticeBox>Currently printing : {data.printingitem}</NoticeBox>
              <ProgressBar value={PrintingPct} />
              <Divider />
            </Box>
          )}

          <LabeledList>
            {recipes.map((val) => {
              return (
                <LabeledList.Item
                  key={val.recipe_id}
                  label={val.name}
                  buttons={
                    <Button
                      color="good"
                      disabled={data.metal_amt < val.metal || !!Working}
                      textAlign="center"
                      onClick={() => act('print', { recipe_id: val.recipe_id })}
                    >
                      print
                    </Button>
                  }
                >
                  <Box>
                    {val.metal} metal, {val.time / 10} seconds
                  </Box>
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
