import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Button,
  LabeledList,
  Modal,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';

type StatsData = {
  stats: Stats[];
};

type Stats = {
  title: string;
  total_kills: number;
  human_kills_total: number;
  xeno_kills_total: number;
  total_deaths: number;
  steps_walked: number;
  total_friendly_fire: number;
  total_revives: number;
  total_lives_saved: number;
  total_shots: number;
  total_shots_hit: number;
  total_hits: number;
  niche_stats: Statistic[];
  castes: CasteStat[];
  abilities_used: Statistic[];
  human_kill_feed: Statistic[];
  xeno_kill_feed: Statistic[];
};

type Statistic = {
  name: string;
  value: number;
};

type CasteStat = {
  name: string;
  stats: Stats;
};

export const RoundStats = (props) => {
  const { data } = useBackend<StatsData>();
  const { stats } = data;
  const [tab, setTab] = useState(!!stats && stats[0]);
  const [modal, setModal] = useState();

  const typeToIcon = (type: string) => {
    switch (type) {
      case 'Человек':
        return 'person-rifle';
      case 'Ксеноморф':
        return 'spaghetti-monster-flying';
    }
  };

  return (
    <Window
      width={400}
      height={500}
      theme={tab.title === 'Человек' ? 'crtgreen' : 'crtxeno'}
    >
      {!stats ? (
        <Window.Content>Увы... Статистики нет.</Window.Content>
      ) : (
        <Window.Content>
          {!!modal && (
            <KillFeedData
              title={modal[0]}
              killfeed={modal[1]}
              setModal={setModal}
            />
          )}
          <Stack fill vertical>
            <Stack.Item>
              <Tabs p={0} fluid textAlign="center">
                {stats.map((stat) => (
                  <Tabs.Tab
                    key={stat.title}
                    icon={typeToIcon(stat.title)}
                    selected={stat === tab}
                    onClick={() => setTab(stat)}
                  >
                    {stat.title}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Stack.Item>
            <Stack.Item grow overflowY="auto">
              <RoundStatsContent
                selectedTab={tab}
                modal={modal}
                setModal={setModal}
              />
            </Stack.Item>
          </Stack>
        </Window.Content>
      )}
    </Window>
  );
};

export const RoundStatsContent = (props) => {
  const { data } = useBackend<StatsData>();
  const { selectedTab, setModal } = props;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <RegularStatData
          total_kills={selectedTab.total_kills}
          human_kills_total={selectedTab.human_kills_total}
          xeno_kills_total={selectedTab.xeno_kills_total}
          total_deaths={selectedTab.total_deaths}
          steps_walked={selectedTab.steps_walked}
          human_kill_feed={selectedTab.human_kill_feed}
          xeno_kill_feed={selectedTab.xeno_kill_feed}
          setModal={setModal}
        />
      </Stack.Item>
      {!!selectedTab?.niche_stats && (
        <Stack.Item>
          <OtherStatData niche_stats={selectedTab.niche_stats} />
        </Stack.Item>
      )}
      <Stack.Item grow>
        {selectedTab.castes ? (
          <XenoStatData
            total_hits={selectedTab.total_hits}
            castes={selectedTab.castes}
          />
        ) : (
          <HumanStatData
            total_friendly_fire={selectedTab.total_friendly_fire}
            total_revives={selectedTab.total_revives}
            total_lives_saved={selectedTab.total_lives_saved}
            total_shots={selectedTab.total_shots}
            total_shots_hit={selectedTab.total_shots_hit}
          />
        )}
      </Stack.Item>
    </Stack>
  );
};

const RegularStatData = (props) => {
  const { data } = useBackend<Stats>();

  const {
    total_kills,
    human_kills_total,
    xeno_kills_total,
    total_deaths,
    steps_walked,
    human_kill_feed,
    xeno_kill_feed,
    setModal,
  } = props;

  return (
    <Section title="Общая статистика">
      <Stack fill vertical mt={-1} mb={-1.33}>
        <Stack.Item>
          <LabeledList>
            {steps_walked && (
              <LabeledList.Item label="Шагов сделано">
                {steps_walked}
              </LabeledList.Item>
            )}
            {!!total_kills && (
              <LabeledList.Item label="Всего убито">
                {total_kills}
              </LabeledList.Item>
            )}

            {!!total_deaths && (
              <LabeledList.Item label="Количество смертей">
                {total_deaths}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Stack.Item>
        {(!!human_kill_feed || !!xeno_kill_feed) && (
          <Stack.Item>
            <Stack fill textAlign="center">
              {!!human_kill_feed && (
                <Stack.Item grow>
                  <Button
                    fluid
                    mb={1}
                    onClick={() => setModal(['Убито людей', human_kill_feed])}
                  >
                    {`Убито людей: ${human_kills_total}`}
                  </Button>
                </Stack.Item>
              )}
              {!!xeno_kill_feed && (
                <Stack.Item grow>
                  <Button
                    fluid
                    mb={1}
                    onClick={() =>
                      setModal(['Убито ксеноморфов', xeno_kill_feed])
                    }
                  >
                    {`Убито ксеноморфов: ${xeno_kills_total}`}
                  </Button>
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

const OtherStatData = (props) => {
  const { data } = useBackend<Stats>();
  const { niche_stats } = props;

  return (
    <Section title="Прочая статистика">
      <Stack fill vertical mt={-1} mb={-1.33}>
        <LabeledList>
          {niche_stats.map((niche_stat) => (
            <LabeledList.Item key={niche_stat.name} label={niche_stat.name}>
              {niche_stat.value}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Stack>
    </Section>
  );
};

const HumanStatData = (props) => {
  const { data } = useBackend<Stats>();
  const {
    total_friendly_fire,
    total_revives,
    total_lives_saved,
    total_shots,
    total_shots_hit,
  } = props;

  return (
    <Section title="Статистика человека">
      <Stack fill vertical mt={-1} mb={-1.33}>
        <LabeledList>
          {!!total_shots && (
            <LabeledList.Item label="Выстрелов сделано">
              {total_shots}
            </LabeledList.Item>
          )}
          {!!total_shots && (
            <LabeledList.Item label="Точность">
              {Math.round((total_shots_hit / total_shots) * 100) + `%`}
            </LabeledList.Item>
          )}
          {!!total_friendly_fire && (
            <LabeledList.Item label="Попаданий по своим">
              {total_friendly_fire}
            </LabeledList.Item>
          )}
          {!!total_revives && (
            <LabeledList.Item label="Количество воскрешений">
              {total_revives}
            </LabeledList.Item>
          )}
          {!!total_lives_saved && (
            <LabeledList.Item label="Людей реанимировано">
              {total_lives_saved}
            </LabeledList.Item>
          )}
        </LabeledList>
      </Stack>
    </Section>
  );
};

const XenoStatData = (props) => {
  const { data } = useBackend<Stats>();
  const { total_hits, castes } = props;
  const [selectedCaste, setCaste] = useState(castes[0] || null);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section fitted title="Статистика ксеноморфа">
          <Stack fill vertical>
            {!!total_hits && (
              <Stack.Item>
                <LabeledList.Item label="Попаданий когтями">
                  {total_hits}
                </LabeledList.Item>
              </Stack.Item>
            )}
            <Stack.Item>
              <Tabs m={0} mb={-0.5}>
                {castes?.map((caste) => (
                  <Tabs.Tab
                    key={caste.name}
                    selected={selectedCaste?.name === caste.name}
                    onClick={() => setCaste(caste)}
                  >
                    {caste.name}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow mt={0}>
        <Section fill scrollable>
          <XenoCasteStats
            key={selectedCaste.name}
            stats={selectedCaste.stats}
          />
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const XenoCasteStats = (props) => {
  const { data } = useBackend<Stats>();
  const { stats } = props;

  return (
    <Stack fill vertical m={1}>
      {!!stats.total_hits && (
        <LabeledList.Item label="Попаданий когтями">
          {stats.total_hits}
        </LabeledList.Item>
      )}
      <RegularStatData
        total_kills={stats.total_kills}
        human_kills_total={stats.human_kills_total}
        xeno_kills_total={stats.xeno_kills_total}
        total_deaths={stats.total_deaths}
        steps_walked={stats.steps_walked}
        niche_stats={stats.niche_stats}
        human_kill_feed={stats.human_kill_feed}
        xeno_kill_feed={stats.xeno_kill_feed}
      />
      {!!stats.abilities_used && (
        <Section title="Способности">
          <Stack fill vertical mt={-1} mb={-1.33}>
            <LabeledList>
              {stats.abilities_used.map((ability) => (
                <LabeledList.Item key={ability.name} label={ability.name}>
                  {ability.value}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Stack>
        </Section>
      )}
    </Stack>
  );
};

const KillFeedData = (props) => {
  const { data } = useBackend<Statistic>();
  const { title, killfeed, setModal } = props;

  return (
    <Modal p={1} width="80vw" height="50vh">
      <Section
        fill
        scrollable
        title={title}
        buttons={
          <Button
            icon="times"
            color="red"
            m={-0.2}
            onClick={() => setModal(null)}
          />
        }
      >
        <Stack fill vertical mt={-1} mb={-1.33}>
          <LabeledList>
            {killfeed.map((kills) => (
              <LabeledList.Item key={kills.name} label={kills.name}>
                {kills.value}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Stack>
      </Section>
    </Modal>
  );
};
