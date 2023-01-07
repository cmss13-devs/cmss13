import { useBackend } from '../backend';
import { Section, ProgressBar, Box, Flex, NoticeBox, Button, LabeledList, NumberInput } from '../components';
import { Window } from '../layouts';

export const Autodispenser = (_props, context) => {
  const { act, data } = useBackend(context);
  const {
    energy,
    status,
    error,
    multiplier,
    cycle_limit,
    automode,
    linked_storage,
    networked_storage,
    smartlink,
    outputmode,
    buffervolume,
    buffermax,
    output_container,
    output_totalvol,
    output_maxvol,
    output_color,
    input_container,
    memory,
    box,
  } = data;

  const energyPct = energy / 100;
  const outputPct = output_totalvol / output_maxvol;

  const memoryEmpty = memory === 'Empty';
  const boxEmpty = box === 'Empty';

  let statusmessage = 'ERROR';

  switch (status) {
    case 0:
      statusmessage = 'IDLE';
      break;
    case 1:
      statusmessage = 'RUNNING';
      break;
    case 2:
      statusmessage = 'FINISHED';
      break;
  }

  let outputmessage = 'ERROR';
  let outputicon;

  switch (outputmode) {
    case 0:
      outputmessage = 'CONTAINER';
      outputicon = 'flask';
      break;
    case 1:
      outputmessage = 'SMARTFRIDGE';
      outputicon = 'box';
      break;
    case 2:
      outputmessage = 'CENTRIFUGE';
      outputicon = 'industry';
      break;
  }

  return (
    <Window width={600} height={600} theme="weyland">
      <Window.Content scrollable>
        <Flex direction="row">
          <Flex.Item grow>
            <Section title="Turing dispenser controls">
              <ProgressBar
                width="100%"
                value={energyPct}
                ranges={{
                  bad: [-Infinity, 0.1],
                  average: [0.1, 0.33],
                  good: [0.33, Infinity],
                }}>
                <Box textAlign="right">Energy: {energy}%</Box>
              </ProgressBar>
              <Box height="5px" />
              <NoticeBox color={error ? 'red' : null}>
                Status: {statusmessage} {error ? error : null}
              </NoticeBox>
              <Button.Confirm
                content="Clear memory"
                icon="trash"
                fluid
                disabled={memoryEmpty}
                onClick={() => act('clearmemory')}
              />
              <Button
                content="Run program"
                icon="play"
                tooltip={
                  memoryEmpty
                    ? !boxEmpty
                      ? 'This will run from the box.'
                      : !output_container && outputmode === 0
                        ? 'No output beaker loaded!'
                        : 'No box loaded or memory saved!'
                    : 'This will run from memory.'
                }
                fluid
                disabled={
                  (memoryEmpty && boxEmpty) ||
                  (!output_container && outputmode === 0)
                }
                onClick={() => act('runprogram')}
              />
              <Box height="5px" />
              <NoticeBox color={input_container ? null : 'red'}>
                {input_container
                  ? 'Input box: ' + input_container
                  : 'No input box loaded!'}
              </NoticeBox>
              {(!memoryEmpty && (
                <Button.Confirm
                  content="Save box to memory"
                  tooltip="This will overwrite the current saved box"
                  icon="floppy-disk"
                  fluid
                  disabled={!input_container}
                  onClick={() => act('saveprogram')}
                />
              )) || (
                <Button
                  content="Save box to memory"
                  icon="floppy-disk"
                  fluid
                  disabled={!input_container}
                  onClick={() => act('saveprogram')}
                />
              )}
              <Button
                content="Eject box"
                icon="eject"
                fluid
                disabled={!input_container}
                onClick={() => act('ejectI')}
              />
              <Box height="5px" />
              {outputmode === 0 && (
                <NoticeBox color={output_container ? null : 'red'}>
                  {output_container
                    ? 'Output: ' + output_container + '.'
                    : 'No output beaker loaded!'}
                </NoticeBox>
              )}
              {outputmode === 1 && (
                <NoticeBox>
                  {networked_storage && smartlink
                    ? 'Bottling to networked smartfridge.'
                    : 'Bottling to smartfridge.'}
                </NoticeBox>
              )}
              {outputmode === 2 && (
                <NoticeBox>
                  {status === 2
                    ? 'Output: Internal buffer:' +
                    buffervolume +
                    'u / ' +
                    buffermax +
                    'u.'
                    : 'Awaiting centrifuge.'}
                </NoticeBox>
              )}
              {output_container && outputmode === 0 && (
                <>
                  <ProgressBar
                    width="100%"
                    value={outputPct}
                    color={output_color ? output_color : 'blue'}>
                    <Box textAlign="right">
                      Beaker vol: {output_totalvol}u/{output_maxvol}u
                    </Box>
                  </ProgressBar>
                  <Box height="5px" />
                </>
              )}
              {outputmode === 0 && (
                <Button.Confirm
                  content="Flush beaker"
                  tooltip={
                    output_container
                      ? 'This will flush ' + output_container + "'s contents."
                      : null
                  }
                  icon="trash"
                  fluid
                  disabled={!output_container}
                  onClick={() => act('dispose')}
                />
              )}
              {(output_container || outputmode === 0) && (
                <Button
                  content="Eject beaker"
                  icon="eject"
                  fluid
                  disabled={!output_container}
                  onClick={() => act('ejectO')}
                />
              )}
            </Section>
            <Section title="Settings">
              <LabeledList>
                <LabeledList.Item label="Program multiplier">
                  <NumberInput
                    width="4em"
                    step={0.1}
                    minValue={0.1}
                    maxValue={10}
                    value={multiplier}
                    onChange={(e, value) =>
                      act('set_multiplier', { set_multiplier: `${value}` })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Program cycles">
                  <NumberInput
                    width="4em"
                    step={1}
                    minValue={1}
                    maxValue={100}
                    value={cycle_limit}
                    onChange={(e, value) =>
                      act('set_cycles', { set_cycles: `${value}` })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
              <Box height="5px" />
              <Button
                content={'Autorun: ' + (automode ? 'enabled' : 'disabled')}
                icon={automode ? 'repeat' : 'dice-one'}
                fluid
                onClick={() => act('toggleauto')}
              />
              <Button
                content={'Smartlink: ' + (smartlink ? 'enabled' : 'disabled')}
                icon={smartlink ? 'link' : 'link-slash'}
                fluid
                onClick={() => act('togglesmart')}
              />
              <Button
                content={'Outputting to: ' + outputmessage}
                icon={outputicon}
                fluid
                onClick={() => act('toggleoutput')}
              />
            </Section>
          </Flex.Item>
          <Flex.Item>
            <Box width="5px" />
          </Flex.Item>
          <Flex.Item grow>
            <Section title="Memory Program">
              {(!memoryEmpty && (
                <Flex direction="column">
                  {Object.keys(memory).map((entry) => (
                    <Flex.Item key={entry}>
                      <Box>
                        {memory[entry]['name']}, {memory[entry]['amount']}u
                      </Box>
                    </Flex.Item>
                  ))}
                </Flex>
              )) || <NoticeBox danger>Nothing saved to memory!</NoticeBox>}
            </Section>
            <Section title="Box Program">
              {(!boxEmpty && (
                <Flex direction="column">
                  {Object.keys(box).map((entry) => (
                    <Flex.Item key={entry}>
                      <Box>
                        {box[entry]['name']}, {box[entry]['amount']}u
                      </Box>
                    </Flex.Item>
                  ))}
                </Flex>
              )) || <NoticeBox danger>No box loaded!</NoticeBox>}
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
