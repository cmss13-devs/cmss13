import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const BioSyntheticPrinter = () => {
  const { act, data } = useBackend();

  const Working = data.working;

  const PrintingPct =
    1 - (data.printtime - data.worldtime) / data.printingitemtime;

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
        <Section title="Limbs" grow>
          {!!Working && (
            <Box>
              <NoticeBox>Currently printing : {data.printingitem}</NoticeBox>
              <ProgressBar value={PrintingPct} />
              <Divider />
            </Box>
          )}

          <LabeledList vertical>
            {recipes.map((val) => {
              return (
                <LabeledList.Item
                  key={val.recipe_id}
                  label={val.name}
                  onFocus={() =>
                    document.activeElement
                      ? document.activeElement.blur()
                      : false
                  }
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
