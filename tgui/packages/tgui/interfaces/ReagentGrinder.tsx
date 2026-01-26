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
      <Window.Content scrollable>
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
                      <Button
                        icon="eject"
                        content="Detach"
                        onClick={() => act('detach')}
                      />
                    ) : null
                  }
                >
                  {!isBeakerLoaded ? (
                    <Box color="bad">No beaker attached.</Box>
                  ) : hasBeakerContents ? (
                    <LabeledList>
                      {beakerContents.map((reagent, index) => (
                        <LabeledList.Item key={reagent.id} label={reagent.name}>
                          <Box inline>{reagent.volume} units</Box>
                          {hasStorage ? (
                            <Button
                              ml={1}
                              icon="wine-bottle"
                              content="Bottle"
                              onClick={() => act('bottle', { id: reagent.id })}
                            />
                          ) : null}
                          <Button
                            ml={1}
                            icon="trash"
                            content="Dispose"
                            color="bad"
                            onClick={() => act('dispose', { id: reagent.id })}
                          />
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
                        content="Grind"
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
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="blender"
                        content="Juice"
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
                      />
                    </Stack.Item>
                  </Stack>
                  <Button
                    mt={1}
                    fluid
                    icon="sign-out-alt"
                    content="Eject Chamber Contents"
                    disabled={!hasChamberContents}
                    onClick={() => act('eject')}
                  />
                  {canConnect ? (
                    <Button
                      mt={1}
                      fluid
                      icon="link"
                      content="Connect to Smartfridge"
                      onClick={() => act('connect')}
                    />
                  ) : null}
                </Section>
              </Stack.Item>
            </>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
