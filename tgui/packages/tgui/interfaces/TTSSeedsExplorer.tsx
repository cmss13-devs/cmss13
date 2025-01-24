import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  BlockQuote,
  Button,
  Dropdown,
  Input,
  LabeledList,
  Section,
  Stack,
  Table,
  VirtualList,
} from '../components';
import { Window } from '../layouts';

type Seed = {
  name: string;
  category: string;
  gender: string;
  provider: string;
  required_donator_level: number;
};

type Provider = {
  name: string;
  is_enabled: BooleanLike;
};

type TTSData = {
  character_gender: string;
  selected_seed: string;
  phrases: string[];
  providers: Provider[];
  seeds: Seed[];
};

const gendersIcons = {
  Мужской: {
    icon: 'mars',
    color: 'blue',
  },
  Женский: {
    icon: 'venus',
    color: 'purple',
  },
  Любой: {
    icon: 'venus-mars',
    color: 'white',
  },
};

const getCheckboxGroup = (
  itemsList,
  selectedList,
  setSelected,
  contentKey: string | null = null,
) => {
  return itemsList.map((item) => {
    const title = (contentKey && item[contentKey]) ?? item;
    return (
      <Button.Checkbox
        key={title}
        checked={selectedList.includes(item)}
        content={title}
        onClick={() => {
          if (selectedList.includes(item)) {
            setSelected(
              selectedList.filter(
                (i) => ((contentKey && i[contentKey]) ?? i) !== item,
              ),
            );
          } else {
            setSelected([item, ...selectedList]);
          }
        }}
      />
    );
  });
};

export const TTSSeedsExplorer = () => {
  return (
    <Window width={1000} height={685}>
      <Window.Content>
        <TTSExplorerContent />
      </Window.Content>
    </Window>
  );
};

const TTSExplorerContent = (props) => {
  const { data } = useBackend<TTSData>();
  const {
    providers,
    seeds,
    selected_seed,
    phrases,
    // character_gender,
  } = data;

  const donator_level = 5; // Placeholder

  const categories = seeds
    .map((seed) => seed.category)
    .filter((category, i, a) => a.indexOf(category) === i);
  const genders = seeds
    .map((seed) => seed.gender)
    .filter((gender, i, a) => a.indexOf(gender) === i);

  const [selectedProviders, setSelectedProviders] = useState(providers);
  const [selectedGenders, setSelectedGenders] = useState(genders);
  const [selectedCategories, setSelectedCategories] = useState(categories);
  const [selectedPhrase, setSelectedPhrase] = useState(phrases[0]);
  const [searchtext, setSearchtext] = useState('');

  let providerCheckboxes = getCheckboxGroup(
    providers,
    selectedProviders,
    setSelectedProviders,
    'name',
  );
  let genderesCheckboxes = getCheckboxGroup(
    genders,
    selectedGenders,
    setSelectedGenders,
  );
  let categoriesCheckboxes = getCheckboxGroup(
    categories,
    selectedCategories,
    setSelectedCategories,
  );

  let phrasesSelect = (
    <Dropdown
      options={phrases}
      selected={selectedPhrase.replace(/(.{60})..+/, '$1...')}
      onSelected={(value) => setSelectedPhrase(value)}
    />
  );

  let searchBar = (
    <Input
      placeholder="Название..."
      width="100%"
      onInput={(e, value) => setSearchtext(value)}
    />
  );

  const availableSeeds = seeds
    .sort((a, b) => {
      const aname = a.name.toLowerCase();
      const bname = b.name.toLowerCase();
      if (aname > bname) {
        return 1;
      }
      if (aname < bname) {
        return -1;
      }
      return 0;
    })
    .filter(
      (seed) =>
        selectedProviders.some((provider) => provider.name === seed.provider) &&
        selectedGenders.includes(seed.gender) &&
        selectedCategories.includes(seed.category) &&
        seed.name.toLowerCase().includes(searchtext.toLowerCase()),
    );

  return (
    <Stack fill>
      <Stack.Item basis={'40%'}>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Фильтры">
              <LabeledList>
                <LabeledList.Item label="Провайдеры">
                  {providerCheckboxes}
                </LabeledList.Item>
                <LabeledList.Item label="Пол">
                  {genderesCheckboxes}
                </LabeledList.Item>
                <LabeledList.Item label="Фраза">
                  {phrasesSelect}
                </LabeledList.Item>
                <LabeledList.Item label="Поиск">{searchBar}</LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title="Категории"
              buttons={
                <>
                  <Button
                    icon="times"
                    disabled={selectedCategories.length === 0}
                    onClick={() => setSelectedCategories([])}
                  >
                    Убрать всё
                  </Button>
                  <Button
                    icon="check"
                    disabled={selectedCategories.length === categories.length}
                    onClick={() => setSelectedCategories(categories)}
                  >
                    Выбрать всё
                  </Button>
                </>
              }
            >
              {categoriesCheckboxes}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <BlockQuote>
                <Stack.Item>
                  {`Для поддержания и развития сообщества в условиях растущих расходов часть голосов пришлось сделать доступными только за материальную поддержку сообщества.`}
                </Stack.Item>
                <Stack.Item mt={1} italic>
                  {`Подробнее об этом можно узнать в нашем Discord-сообществе.`}
                </Stack.Item>
              </BlockQuote>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill vertical>
          <Section
            fill
            scrollable
            title={`Голоса (${availableSeeds.length}/${seeds.length})`}
          >
            <Table>
              <VirtualList>
                {availableSeeds.map((seed) => {
                  return (
                    <SeedRow
                      key={seed.name}
                      seed={seed}
                      selectedSeed={selected_seed}
                      selected_phrase={selectedPhrase}
                      donator_level={donator_level}
                    />
                  );
                })}
              </VirtualList>
            </Table>
          </Section>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const SeedRow = (props: {
  readonly seed: Seed;
  readonly selectedSeed: string;
  readonly selected_phrase: string;
  readonly donator_level: number;
}) => {
  const { seed, selectedSeed, selected_phrase, donator_level } = props;
  const { act } = useBackend();
  return (
    <Table.Row
      backgroundColor={selectedSeed === seed.name ? 'green' : 'transparent'}
    >
      <Table.Cell collapsing textAlign="center">
        <Button
          fluid
          color={selectedSeed === seed.name ? 'green' : 'transparent'}
          onClick={() => act('select_voice', { seed: seed.name })}
        >
          {selectedSeed === seed.name ? 'Выбрано' : 'Выбрать'}
        </Button>
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <Button
          fluid
          icon="music"
          color={selectedSeed === seed.name ? 'green' : 'transparent'}
          tooltip="Прослушать пример"
          onClick={() =>
            act('listen', { seed: seed.name, phrase: selected_phrase })
          }
        />
      </Table.Cell>
      <Table.Cell bold textColor={'white'}>
        {seed.name}
      </Table.Cell>
      <Table.Cell
        opacity={selectedSeed === seed.name ? 0.5 : 0.25}
        textAlign="left"
      >
        {seed.category}
      </Table.Cell>
    </Table.Row>
  );
};
