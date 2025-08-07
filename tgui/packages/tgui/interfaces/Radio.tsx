import { toFixed } from 'common/math';
import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui/components';
import { RADIO_CHANNELS } from 'tgui/constants';
import { Window } from 'tgui/layouts';

type Data = {
  broadcasting: BooleanLike;
  listening: BooleanLike;
  frequency: number;
  minFrequency: number;
  maxFrequency: number;
  freqlock: BooleanLike;
  channels: { name: string; status: BooleanLike; hotkey: string }[];
  command: number;
  useCommand: BooleanLike;
  subspace: BooleanLike;
  subspaceSwitchable: BooleanLike;
  headset: false;
};

export const Radio = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    freqlock,
    frequency,
    minFrequency,
    maxFrequency,
    listening,
    broadcasting,
    command,
    useCommand,
    subspace,
    subspaceSwitchable,
  } = data;

  const radioChannels = data.channels;

  const tunedChannel = RADIO_CHANNELS.find(
    (channel) => channel.freq === frequency,
  );

  // Calculate window height
  let height = 106;
  if (subspace) {
    if (radioChannels.length > 0) {
      height += radioChannels.length * 21 + 6;
    } else {
      height += 24;
    }
  }
  return (
    <Window width={360} height={height}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Frequency">
              {(freqlock && (
                <Box inline color="light-gray">
                  {toFixed(frequency / 10, 1) + ' kHz'}
                </Box>
              )) || (
                <NumberInput
                  animated
                  unit="kHz"
                  step={0.2}
                  stepPixelSize={10}
                  minValue={minFrequency / 10}
                  maxValue={maxFrequency / 10}
                  value={frequency / 10}
                  format={(value) => toFixed(value, 1)}
                  onDrag={(value) =>
                    act('frequency', {
                      adjust: value - frequency / 10,
                    })
                  }
                />
              )}
              {tunedChannel && (
                <Box inline color={tunedChannel.color} ml={2}>
                  [{tunedChannel.name}]
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Audio">
              <Button
                textAlign="center"
                width="37px"
                icon={listening ? 'volume-up' : 'volume-mute'}
                selected={listening}
                onClick={() => act('listen')}
              />
              <Button
                textAlign="center"
                width="37px"
                icon={broadcasting ? 'microphone' : 'microphone-slash'}
                selected={broadcasting}
                onClick={() => act('broadcast')}
              />
              {!!command && (
                <Button
                  ml={1}
                  icon="bullhorn"
                  selected={useCommand}
                  onClick={() => act('command')}
                >
                  {`High volume ${useCommand ? 'ON' : 'OFF'}`}
                </Button>
              )}
              {!!subspaceSwitchable && (
                <Button
                  ml={1}
                  icon="bullhorn"
                  selected={subspace}
                  onClick={() => act('subspace')}
                >
                  {`Subspace Tx ${subspace ? 'ON' : 'OFF'}`}
                </Button>
              )}
            </LabeledList.Item>
            {!!subspace && (
              <LabeledList.Item label="Channels">
                {radioChannels.length === 0 && (
                  <Box inline color="bad">
                    No encryption keys installed.
                  </Box>
                )}
                {radioChannels.map((channel) => (
                  <Box key={channel.name}>
                    <Button
                      icon={channel.status ? 'check-square-o' : 'square-o'}
                      selected={channel.status}
                      onClick={() =>
                        act('channel', {
                          channel: channel.name,
                        })
                      }
                    >
                      {channel.name + ' ' + channel.hotkey}
                    </Button>
                  </Box>
                ))}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
