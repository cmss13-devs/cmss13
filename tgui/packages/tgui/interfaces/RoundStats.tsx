import { useBackend } from '../backend';
import { Collapsible, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

export const RoundStats = (props) => {
  return (
    <Window width={500} height={550}>
      <Window.Content>
        <Stack fill vertical>
          <RoundStatsContent />
        </Stack>
      </Window.Content>
    </Window>
  );
};

type StatsData = {
  stats: Stats[];
};

type Stats = {
  title: string;
  total_kills: number;
  total_deaths: number;
  steps_walked: number;
  humans_killed: number;
  xenos_killed: number;
  total_friendly_fire: number;
  total_revives: number;
  total_lives_saved: number;
  total_shots: number;
  total_shots_hit: number;
  total_hits: number;
};

export const RoundStatsContent = (props, context) => {
  const { data } = useBackend<StatsData>();
  const { stats } = data;

  return (
    <Section fill scrollable title={`Ваша статистика за раунд`}>
      <Stack fill vertical>
        <Stack.Item grow>
          {stats.map((stat) => (
            <Collapsible key={stat.title} title={stat.title}>
              <LabeledList>
                {!!stat.steps_walked && (
                  <LabeledList.Item label="Шагов сделано">
                    {stat.steps_walked}
                  </LabeledList.Item>
                )}
                {!!stat.total_kills && (
                  <LabeledList.Item label="Всего убито">
                    {stat.total_kills}
                  </LabeledList.Item>
                )}
                {!!stat.humans_killed && (
                  <LabeledList.Item label="Убито людей">
                    {stat.humans_killed}
                  </LabeledList.Item>
                )}
                {!!stat.xenos_killed && (
                  <LabeledList.Item label="Убито ксеноморфов">
                    {stat.xenos_killed}
                  </LabeledList.Item>
                )}
                {!!stat.total_shots && (
                  <LabeledList.Item label="Выстрелов сделано">
                    {stat.total_shots}
                  </LabeledList.Item>
                )}
                {!!stat.total_shots && (
                  <LabeledList.Item label="Точность">
                    {Math.round(
                      (stat.total_shots_hit / stat.total_shots) * 100,
                    ) + `%`}
                  </LabeledList.Item>
                )}
                {!!stat.total_friendly_fire && (
                  <LabeledList.Item label="Попаданий по своим">
                    {stat.total_friendly_fire}
                  </LabeledList.Item>
                )}
                {!!stat.total_deaths && (
                  <LabeledList.Item label="Количество смертей">
                    {stat.total_deaths}
                  </LabeledList.Item>
                )}
                {!!stat.total_revives && (
                  <LabeledList.Item label="Количество воскрешений">
                    {stat.total_revives}
                  </LabeledList.Item>
                )}
                {!!stat.total_lives_saved && (
                  <LabeledList.Item label="Людей реанимировано">
                    {stat.total_lives_saved}
                  </LabeledList.Item>
                )}
                {!!stat.total_hits && (
                  <LabeledList.Item label="Попаданий когтями">
                    {stat.total_hits}
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Collapsible>
          ))}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
