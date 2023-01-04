import { useBackend, useLocalState } from '../backend';
import { Section, Flex, ProgressBar, Box, Button, Tabs, Stack, Input } from '../components';
import { capitalize } from 'common/string';
import { Window } from '../layouts';
import { ElectricalPanel } from './common/ElectricalPanel';
import { Fragment } from 'inferno';
import { createLogger } from '../logging';

export const Autolathe = (_props, context) => {
  const { act, data } = useBackend(context);

  const {
    materials,
    capacity,
    queued,
    printables,
    selectable_categories,
    queuemax,
    theme,
  } = data;

  return (
    <Window width={600} height={600} theme={theme}>
      <Window.Content scrollable>
        <MaterialsData />
        {queued && <QueueList />}
        <PrintablesSection />
      </Window.Content>
    </Window>
  );
};

const MaterialsData = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    materials,
    capacity,
    queued,
    printables,
    selectable_categories,
    queuemax,
  } = data;

  return (
    <Section title="Materials">
      <Flex direction="row" grow>
        {Object.keys(materials).map((category) => (
          <Flex.Item key={category} grow>
            <ProgressBar
              width="99%"
              value={materials[category] / capacity[category]}>
              <Box textAlign="center">
                {capitalize(category)}: {materials[category]}/
                {capacity[category]}
              </Box>
            </ProgressBar>
          </Flex.Item>
        ))}
      </Flex>
      <CurrentlyMaking />
    </Section>
  );
};

const CurrentlyMaking = (props, context) => {
  const { act, data } = useBackend(context);
  const { currently_making } = data;

  return currently_making ? (
    <Fragment>
      <Box height="5px" />
      <Button
        fluid
        textAlign="center"
        content={
          'Currently making: ' +
          capitalize(currently_making.name) +
          (currently_making.multiplier > 1
            ? ' (x' + currently_making.multiplier + ')'
            : '')
        }
      />
    </Fragment>
  ) : null;
};

const QueueList = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    materials,
    capacity,
    queued,
    printables,
    selectable_categories,
    queuemax,
  } = data;

  return (
    <Section title="Queue">
      <Flex direction="column">
        {queued.map((item) => {
          return (
            <Flex.Item key={item}>
              <Flex direction="row">
                <Flex.Item>
                  <Button
                    content={
                      item.index +
                      ': ' +
                      capitalize(item.name) +
                      (item.multiplier > 1 ? ' (x' + item.multiplier + ')' : '')
                    }
                  />
                  <Box width="5px" />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="xmark"
                    tooltip="Remove"
                    onClick={() =>
                      act('cancel', {
                        index: item.index,
                        name: item.name,
                        multiplier: item.multiplier,
                      })
                    }
                  />
                </Flex.Item>
              </Flex>
            </Flex.Item>
          );
        })}
      </Flex>
    </Section>
  );
};

// the below all has to be in one section due to the categories and search params
const PrintablesSection = (props, context) => {
  const { act, data } = useBackend(context);

  const logger = createLogger('autolathe');

  const {
    materials,
    capacity,
    queued,
    printables,
    selectable_categories,
    queuemax,
  } = data;

  const [currentSearch, setSearch] = useLocalState(
    context,
    'current_search',
    ''
  );

  const categories = [];
  for (let i = 0; i < printables.length; i++) {
    let data = printables[i];
    if (categories.includes(data.recipe_category)) continue;

    categories.push(data.recipe_category);
  }

  const [currentCategory, setCategory] = useLocalState(
    context,
    'current_category',
    'All'
  );

  const filteredPrintables = printables.filter(
    (val) =>
      (val.recipe_category === currentCategory || currentCategory === 'All') &&
      val.name.toLowerCase().match(currentSearch)
  );

  return (
    <Section fill>
      <Stack vertical fill>
        {selectable_categories.length > 2 && ( // check that it isn't just one category and "all"
          <Stack.Item>
            <Tabs fluid>
              {selectable_categories.map((val) => (
                <Tabs.Tab
                  selected={val === currentCategory}
                  onClick={() => setCategory(val)}
                  key={val}>
                  {val}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
        )}
        <Stack.Item>
          <Input
            fluid
            value={currentSearch}
            placeholder="Search for an item"
            onInput={(e, value) => setSearch(value.toLowerCase())}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Flex direction="column">
            {filteredPrintables.map((val, index) => {
              return (
                <Flex.Item key={index}>
                  <Box>
                    <Flex direction="row">
                      <Flex.Item grow>
                        <Button
                          fluid
                          content={capitalize(val.name)}
                          disabled={!val.can_make}
                          color={val.hidden ? 'red' : null}
                          onClick={() =>
                            act('make', {
                              index: val.index,
                              multiplier: 1,
                            })
                          }>
                          {' (' + // sorry for this shitcode, also yes this will break if an autolathe uses more than 2 material types
                            (val.materials[Object.keys(materials)[0]] &&
                            val.materials[Object.keys(materials)[1]]
                              ? val.materials[Object.keys(materials)[0]] +
                              ', ' +
                              val.materials[Object.keys(materials)[1]]
                              : val.materials[Object.keys(materials)[0]]
                                ? val.materials[Object.keys(materials)[0]]
                                : val.materials[Object.keys(materials)[1]]) +
                            ') '}
                        </Button>
                      </Flex.Item>

                      {(val.has_multipliers && (
                        <Fragment>
                          <Box width="2.5px" />
                          <Flex.Item>
                            <Flex direction="row">
                              {Object.keys(val.multipliers).map((entry) => (
                                <Flex.Item key={entry}>
                                  <Button
                                    content={'x' + entry}
                                    onClick={() =>
                                      act('make', {
                                        index: val.index,
                                        multiplier: entry,
                                      })
                                    }
                                  />
                                </Flex.Item>
                              ))}
                            </Flex>
                          </Flex.Item>
                        </Fragment>
                      )) ||
                        null}
                    </Flex>
                  </Box>
                  <Box height="2.5px" />
                </Flex.Item>
              );
            })}
          </Flex>
          <Box height="10px" />
          <ElectricalPanel />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
