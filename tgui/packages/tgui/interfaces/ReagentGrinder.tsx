import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

type ReagentGrinderData = {
  inuse: boolean;
  isBeakerLoaded: boolean;
  hasStorage: boolean;
  canConnect: boolean;
  chamberContents: ChamberItem[];
  beakerContents: BeakerReagent[];
};

type ChamberItem = {
  name: string;
  amount: number;
};

type BeakerReagent = {
  name: string;
  volume: number;
  id: string;
};

export const ReagentGrinder = (props: {}) => {
  const { act, data } = useBackend<ReagentGrinderData>();
  const {
    inuse,
    isBeakerLoaded,
    hasStorage,
    canConnect,
    chamberContents,
    beakerContents,
  } = data;

  const hasChamberContents = chamberContents && chamberContents.length > 0;
  const hasBeakerContents = beakerContents && beakerContents.length > 0;
  const canProcess = isBeakerLoaded && hasChamberContents && !inuse;

  return (
    <Window width={450} height={500} theme="nologo">
      <Window.Content>
        <Section fill scrollable>
          <Stack fill vertical>
            <Stack.Item>
              <Section title="Processing Chamber">
                {inuse ? (
                  <Box color="yellow">Processing... Please wait.</Box>
                ) : hasChamberContents ? (
                  <LabeledList>
                    {chamberContents.map((item, index) => (
                      <LabeledList.Item
                        key={`${item.name}-${item.amount}`}
                        label={item.name}
                      >
                        x{item.amount}
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                ) : (
                  <Box color="label">Chamber is empty.</Box>
                )}
              </Section>
            </Stack.Item>

            {!inuse && (
              <>
                <Stack.Item>
                  <Section
                    title="Beaker"
                    buttons={
                      isBeakerLoaded ? (
                        <Button icon="eject" onClick={() => act('detach')}>
                          Detach
                        </Button>
                      ) : null
                    }
                  >
                    {!isBeakerLoaded ? (
                      <Box color="bad">No beaker attached.</Box>
                    ) : hasBeakerContents ? (
                      <LabeledList>
                        {beakerContents.map((reagent, index) => (
                          <LabeledList.Item
                            key={reagent.id}
                            label={reagent.name}
                          >
                            <Box inline>{reagent.volume} units</Box>
                            {hasStorage ? (
                              <Button
                                ml={1}
                                icon="wine-bottle"
                                onClick={() =>
                                  act('bottle', { id: reagent.id })
                                }
                              >
                                Bottle
                              </Button>
                            ) : null}
                            <Button
                              ml={1}
                              icon="trash"
                              color="bad"
                              onClick={() => act('dispose', { id: reagent.id })}
                            >
                              Dispose
                            </Button>
                          </LabeledList.Item>
                        ))}
                      </LabeledList>
                    ) : (
                      <Box color="label">Beaker is empty.</Box>
                    )}
                  </Section>
                </Stack.Item>

                <Stack.Item>
                  <Section title="Controls">
                    <Stack>
                      <Stack.Item grow>
                        <Button
                          fluid
                          icon="mortar-pestle"
                          disabled={!canProcess}
                          tooltip={
                            !canProcess
                              ? !isBeakerLoaded
                                ? 'No beaker attached'
                                : !hasChamberContents
                                  ? 'Chamber is empty'
                                  : 'Currently processing'
                              : null
                          }
                          onClick={() => act('grind')}
                        >
                          Grind
                        </Button>
                      </Stack.Item>
                      <Stack.Item grow>
                        <Button
                          fluid
                          icon="blender"
                          disabled={!canProcess}
                          tooltip={
                            !canProcess
                              ? !isBeakerLoaded
                                ? 'No beaker attached'
                                : !hasChamberContents
                                  ? 'Chamber is empty'
                                  : 'Currently processing'
                              : null
                          }
                          onClick={() => act('juice')}
                        >
                          Juice
                        </Button>
                      </Stack.Item>
                    </Stack>
                    <Button
                      mt={1}
                      fluid
                      icon="sign-out-alt"
                      disabled={!hasChamberContents}
                      onClick={() => act('eject')}
                    >
                      Eject Chamber Contents
                    </Button>
                    {canConnect ? (
                      <Button
                        mt={1}
                        fluid
                        icon="link"
                        onClick={() => act('connect')}
                      >
                        Connect to Smartfridge
                      </Button>
                    ) : null}
                  </Section>
                </Stack.Item>
              </>
            )}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
