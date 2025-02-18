import { useState } from 'react';

import { useBackend } from '../backend';
import { Collapsible, Input, Section, Stack } from '../components';
import { Window } from '../layouts';

export const ModpacksList = (props, context) => {
  return (
    <Window width={500} height={550}>
      <Window.Content>
        <Stack fill vertical>
          <ModpacksListContent />
        </Stack>
      </Window.Content>
    </Window>
  );
};

type ModpacksData = {
  modpacks: Modpack[];
};

type Modpack = {
  name: string;
  desc: string;
  author: string;
};

export const ModpacksListContent = (props, context) => {
  const { act, data } = useBackend<ModpacksData>();
  const { modpacks } = data;

  const [searchText, setSearchText] = useState('');

  const searchBar = (
    <Input
      placeholder="Искать модпак по имени, описанию или автору..."
      fluid
      onInput={(e, value) => setSearchText(value)}
    />
  );

  return (
    <>
      <Stack.Item>
        <Section fill title="Фильтры">
          {searchBar}
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title={
            searchText.length > 0
              ? `Результаты поиска "${searchText}"`
              : `Все модификации - ${modpacks.length}`
          }
        >
          <Stack fill vertical>
            <Stack.Item>
              {modpacks
                .filter(
                  (modpack) =>
                    modpack.name &&
                    (searchText.length > 0
                      ? modpack.name
                          .toLowerCase()
                          .includes(searchText.toLowerCase()) ||
                        modpack.desc
                          .toLowerCase()
                          .includes(searchText.toLowerCase()) ||
                        modpack.author
                          .toLowerCase()
                          .includes(searchText.toLowerCase())
                      : true),
                )
                .map((modpack) => (
                  <Collapsible key={modpack.name} title={modpack.name}>
                    <Section title="Описание">{modpack.desc}</Section>
                    <Section title="Авторы">{modpack.author}</Section>
                  </Collapsible>
                ))}
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </>
  );
};
