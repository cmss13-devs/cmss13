import { filterMap } from 'common/collections';
import { exhaustiveCheck } from 'common/exhaustive';
import { BooleanLike } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Divider, Dropdown, Stack, Tabs } from '../components';
import { Window } from '../layouts';

type CurrentRoundTrait = {
  can_revert: BooleanLike;
  name: string;
  ref: string;
};

type ValidRoundTrait = {
  name: string;
  path: string;
};

type RoundTraitsData = {
  current_traits: CurrentRoundTrait[];
  future_round_traits?: ValidRoundTrait[];
  too_late_to_revert: BooleanLike;
  valid_round_traits: ValidRoundTrait[];
};

enum Tab {
  SetupFutureRoundTraits,
  ViewRoundTraits,
}

const FutureRoundTraitsPage = (props, context) => {
  const { act, data } = useBackend<RoundTraitsData>(context);
  const { future_round_traits } = data;

  const [selectedTrait, setSelectedTrait] = useLocalState<string | null>(
    context,
    'selectedFutureTrait',
    null
  );

  const traitsByName = Object.fromEntries(
    data.valid_round_traits.map((trait) => {
      return [trait.name, trait.path];
    })
  );

  const traitNames = Object.keys(traitsByName);
  traitNames.sort();

  return (
    <Box>
      <Stack fill>
        <Stack.Item grow>
          <Dropdown
            displayText={!selectedTrait && 'Select trait to add...'}
            onSelected={setSelectedTrait}
            options={traitNames}
            selected={selectedTrait}
            width="100%"
          />
        </Stack.Item>

        <Stack.Item>
          <Button
            color="green"
            icon="plus"
            onClick={() => {
              if (!selectedTrait) {
                return;
              }

              const selectedPath = traitsByName[selectedTrait];

              let newRoundTraits = [selectedPath];
              if (future_round_traits) {
                const selectedTraitPaths = future_round_traits.map(
                  (trait) => trait.path
                );

                if (selectedTraitPaths.indexOf(selectedPath) !== -1) {
                  return;
                }

                newRoundTraits = newRoundTraits.concat(...selectedTraitPaths);
              }

              act('setup_future_traits', {
                round_traits: newRoundTraits,
              });
            }}>
            Add
          </Button>
        </Stack.Item>
      </Stack>

      <Divider />

      {Array.isArray(future_round_traits) ? (
        future_round_traits.length > 0 ? (
          <Stack vertical fill>
            {future_round_traits.map((trait) => (
              <Stack.Item key={trait.path}>
                <Stack fill>
                  <Stack.Item grow>{trait.name}</Stack.Item>

                  <Stack.Item>
                    <Button
                      color="red"
                      icon="times"
                      onClick={() => {
                        act('setup_future_traits', {
                          round_traits: filterMap(
                            future_round_traits,
                            (otherTrait) => {
                              if (otherTrait.path === trait.path) {
                                return undefined;
                              } else {
                                return otherTrait.path;
                              }
                            }
                          ),
                        });
                      }}>
                      Delete
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        ) : (
          <>
            <Box>No round traits will run next round.</Box>

            <Box>
              <Button
                color="red"
                icon="times"
                tooltip="The next round will roll round traits randomly, just like normal"
                onClick={() => act('clear_future_traits')}>
                Run Round Traits Normally
              </Button>
            </Box>
          </>
        )
      ) : (
        <>
          <Box>No future round traits are planned.</Box>

          <Box>
            <Button
              color="red"
              icon="times"
              onClick={() =>
                act('setup_future_traits', {
                  round_traits: [],
                })
              }>
              Prevent round traits from running next round
            </Button>
          </Box>
        </>
      )}
    </Box>
  );
};

const ViewRoundTraitsPage = (props, context) => {
  const { act, data } = useBackend<RoundTraitsData>(context);

  return data.current_traits.length > 0 ? (
    <Stack vertical fill>
      {data.current_traits.map((roundTrait) => (
        <Stack.Item key={roundTrait.ref}>
          <Stack fill>
            <Stack.Item grow>{roundTrait.name}</Stack.Item>

            <Stack.Item>
              <Button.Confirm
                content="Revert"
                color="red"
                disabled={data.too_late_to_revert || !roundTrait.can_revert}
                tooltip={
                  (!roundTrait.can_revert && 'This trait is not revertable.') ||
                  (data.too_late_to_revert &&
                    "It's too late to revert round traits, the round has already started.")
                }
                icon="times"
                onClick={() =>
                  act('revert', {
                    ref: roundTrait.ref,
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      ))}
    </Stack>
  ) : (
    <Box>There are no active round traits.</Box>
  );
};

export const RoundTraitsPanel = (props, context) => {
  const [currentTab, setCurrentTab] = useLocalState(
    context,
    'round_traits_tab',
    Tab.ViewRoundTraits
  );

  let currentPage;

  switch (currentTab) {
    case Tab.SetupFutureRoundTraits:
      currentPage = <FutureRoundTraitsPage />;
      break;
    case Tab.ViewRoundTraits:
      currentPage = <ViewRoundTraitsPage />;
      break;
    default:
      exhaustiveCheck(currentTab);
  }

  return (
    <Window title="Modify Round Traits" height={500} width={500}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            icon="eye"
            selected={currentTab === Tab.ViewRoundTraits}
            onClick={() => setCurrentTab(Tab.ViewRoundTraits)}>
            View
          </Tabs.Tab>

          <Tabs.Tab
            icon="edit"
            selected={currentTab === Tab.SetupFutureRoundTraits}
            onClick={() => setCurrentTab(Tab.SetupFutureRoundTraits)}>
            Edit
          </Tabs.Tab>
        </Tabs>

        <Divider />

        {currentPage}
      </Window.Content>
    </Window>
  );
};
