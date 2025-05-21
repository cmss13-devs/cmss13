import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
  Slider,
} from 'tgui/components';
import { formatPower } from 'tgui/format';
import { Window } from 'tgui/layouts';

// Common power multiplier
const POWER_MUL = 1e3;

type Data = {
  capacity: number;

  capacityPercent: number;
  charge: number;
  inputAttempt: BooleanLike;
  inputting: BooleanLike;
  inputLevel: number;
  inputLevel_text: string;
  inputLevelMax: number;
  inputAvailable: number;
  outputAttempt: BooleanLike;
  outputting: BooleanLike;
  outputLevel: number;
  outputLevel_text: string;
  outputLevelMax: number;
  outputUsed: number;
};

export const Smes = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    capacityPercent,
    capacity,
    charge,
    inputAttempt,
    inputting,
    inputLevel,
    inputLevelMax,
    inputAvailable,
    outputAttempt,
    outputting,
    outputLevel,
    outputLevelMax,
    outputUsed,
  } = data;
  const inputState =
    (capacityPercent >= 100 && 'good') || (inputting && 'average') || 'bad';
  const outputState =
    (outputting && 'good') || (charge > 0 && 'average') || 'bad';
  return (
    <Window width={340} height={350}>
      <Window.Content>
        <Section title="Stored Energy">
          <ProgressBar
            value={capacityPercent * 0.01}
            ranges={{
              good: [0.5, Infinity],
              average: [0.15, 0.5],
              bad: [-Infinity, 0.15],
            }}
          />
        </Section>
        <Section title="Input">
          <LabeledList>
            <LabeledList.Item
              label="Charge Mode"
              buttons={
                <Button
                  icon={inputAttempt ? 'sync-alt' : 'times'}
                  selected={inputAttempt}
                  onClick={() => act('tryinput')}
                >
                  {inputAttempt ? 'Auto' : 'Off'}
                </Button>
              }
            >
              <Box color={inputState}>
                {(capacityPercent >= 100 && 'Fully Charged') ||
                  (inputting && 'Charging') ||
                  'Not Charging'}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Target Input">
              <Flex inline width="100%">
                <Flex.Item>
                  <Button
                    icon="fast-backward"
                    disabled={inputLevel === 0}
                    onClick={() =>
                      act('input', {
                        target: 'min',
                      })
                    }
                  />
                  <Button
                    icon="backward"
                    disabled={inputLevel === 0}
                    onClick={() =>
                      act('input', {
                        adjust: -10000,
                      })
                    }
                  />
                </Flex.Item>
                <Flex.Item grow={1} mx={1}>
                  <Slider
                    value={inputLevel / POWER_MUL}
                    fillValue={inputAvailable / POWER_MUL}
                    minValue={0}
                    maxValue={inputLevelMax / POWER_MUL}
                    step={5}
                    stepPixelSize={4}
                    format={(value) => formatPower(value * POWER_MUL, 1)}
                    onDrag={(e, value) =>
                      act('input', {
                        target: value * POWER_MUL,
                      })
                    }
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="forward"
                    disabled={inputLevel === inputLevelMax}
                    onClick={() =>
                      act('input', {
                        adjust: 10000,
                      })
                    }
                  />
                  <Button
                    icon="fast-forward"
                    disabled={inputLevel === inputLevelMax}
                    onClick={() =>
                      act('input', {
                        target: 'max',
                      })
                    }
                  />
                </Flex.Item>
              </Flex>
            </LabeledList.Item>
            <LabeledList.Item label="Available">
              {formatPower(inputAvailable)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            <LabeledList.Item
              label="Output Mode"
              buttons={
                <Button
                  icon={outputAttempt ? 'power-off' : 'times'}
                  selected={outputAttempt}
                  onClick={() => act('tryoutput')}
                >
                  {outputAttempt ? 'On' : 'Off'}
                </Button>
              }
            >
              <Box color={outputState}>
                {outputting
                  ? 'Sending'
                  : charge > 0
                    ? 'Not Sending'
                    : 'No Charge'}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Target Output">
              <Flex inline width="100%">
                <Flex.Item>
                  <Button
                    icon="fast-backward"
                    disabled={outputLevel === 0}
                    onClick={() =>
                      act('output', {
                        target: 'min',
                      })
                    }
                  />
                  <Button
                    icon="backward"
                    disabled={outputLevel === 0}
                    onClick={() =>
                      act('output', {
                        adjust: -10000,
                      })
                    }
                  />
                </Flex.Item>
                <Flex.Item grow={1} mx={1}>
                  <Slider
                    value={outputLevel / POWER_MUL}
                    minValue={0}
                    maxValue={outputLevelMax / POWER_MUL}
                    step={5}
                    stepPixelSize={4}
                    format={(value) => formatPower(value * POWER_MUL, 1)}
                    onDrag={(e, value) =>
                      act('output', {
                        target: value * POWER_MUL,
                      })
                    }
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="forward"
                    disabled={outputLevel === outputLevelMax}
                    onClick={() =>
                      act('output', {
                        adjust: 10000,
                      })
                    }
                  />
                  <Button
                    icon="fast-forward"
                    disabled={outputLevel === outputLevelMax}
                    onClick={() =>
                      act('output', {
                        target: 'max',
                      })
                    }
                  />
                </Flex.Item>
              </Flex>
            </LabeledList.Item>
            <LabeledList.Item label="Outputting">
              {formatPower(outputUsed)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
