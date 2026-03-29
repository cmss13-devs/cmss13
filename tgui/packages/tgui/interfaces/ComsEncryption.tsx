import { useEffect, useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  Knob,
  NumberInput,
  ProgressBar,
  RoundGauge,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  cipher_length: number;
  mode: string;
  cards: number;
  punch_card?: number[];
};

type DecoderData = {
  challenge: number[];
} & Data;

type EncoderData = {
  clarity: number;
} & Data;

export const ComsEncryption = (props) => {
  const { act, data } = useBackend<Data>();
  switch (data.mode) {
    case 'decoder':
      return <DecoderPanel />;
    case 'cipher':
      return <CipherPanel />;
    case 'encoder':
      return <EncoderPanel />;
  }
};

const maxOffset = 26;

const DecoderPanel = (props) => {
  const { act, data } = useBackend<DecoderData>();
  const [loadingState, setLoadingState] = useState(-1);

  let timer: NodeJS.Timeout | undefined;
  let loading = -1; // The timer for whatever reason cannot read the loadingState right
  function startLoading() {
    loading = 0;
    setLoadingState(0);
    timer = setInterval(() => {
      if (loading >= 100) {
        // Done loading
        loading = -1;
        setLoadingState(-1);
        clearInterval(timer);
        return;
      }
      // Randomly increase loading value by up to 50%
      let newValue = loading + Math.floor(Math.random() * 50);
      loading = Math.min(newValue, 100);
      setLoadingState(loading);
    }, 1000);
  }

  return (
    <Window width={470} height={190} theme="crtgreen">
      <Window.Content>
        {loadingState !== -1 && (
          <>
            <Section
              title="Decoder"
              minHeight={6.5}
              buttons={
                <Button
                  fluid
                  icon="print"
                  tooltip={data.cards + ' punch cards available'}
                  disabled
                >
                  Print
                </Button>
              }
            >
              <ProgressBar value={loadingState} minValue={0} maxValue={100} />
            </Section>
            <Section minHeight={4}>
              <Button
                disabled
                fluid
                icon="download"
                align="center"
                fontSize="15px"
              >
                Decode current stream
              </Button>
            </Section>
          </>
        )}
        {loadingState === -1 && (
          <>
            <Section
              title="Decoder"
              minHeight={6.5}
              buttons={
                <Button
                  fluid
                  icon="print"
                  tooltip={data.cards + ' punch cards available'}
                  onClick={() => act('print', { data: data.challenge })}
                >
                  Print
                </Button>
              }
            >
              <Flex
                height="100%"
                direction="row"
                wrap="wrap"
                justify="space-between"
              >
                {[...Array(data.cipher_length)].map((_, index) => (
                  <Flex.Item key={index} fontSize="15px">
                    <NumberInput
                      disabled
                      width={5}
                      minValue={0}
                      maxValue={maxOffset}
                      step={1}
                      stepPixelSize={8}
                      value={data.challenge[index]}
                      format={(value) =>
                        '0x' + value.toString(16).padStart(2, '0').toUpperCase()
                      }
                    />
                  </Flex.Item>
                ))}
              </Flex>
            </Section>
            <Section minHeight={4}>
              <Flex direction="row" wrap="wrap" align="center">
                <Flex.Item grow>
                  <Button
                    fluid
                    icon="download"
                    align="center"
                    fontSize="15px"
                    onClick={() => {
                      startLoading();
                      act('generate');
                    }}
                  >
                    Decode current stream
                  </Button>
                </Flex.Item>
              </Flex>
            </Section>
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const CipherPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const [offset, setOffset] = useSharedState('offset', maxOffset);
  const [input, setInput] = useSharedState<number[]>(
    'input',
    Array(data.cipher_length).fill(0),
  );

  useEffect(() => {
    if (data.punch_card && data.punch_card.length === data.cipher_length) {
      setInput(data.punch_card);
    }
  }, [data.punch_card]);

  function handleInput(index: number, value: number) {
    const newInput = input.map((oldValue, i) => {
      if (i === index) {
        return value;
      } else {
        return oldValue;
      }
    });
    setInput(newInput);
  }

  function handleOffset(adjustment: number) {
    // Wrap the offset
    let newValue = (offset + adjustment) % (maxOffset + 1);
    if (newValue < 0) {
      newValue = maxOffset; // Assumption that adjustment would only be 1
    }
    setOffset(newValue);
  }

  function getOutputValue(index: number) {
    return (input[index] + offset) % (maxOffset + 1);
  }

  function getOutputASCII(index: number) {
    let value = getOutputValue(index) + 65; // Align to A again
    if (value === 91) {
      // [ the snowflake for displaying -
      value = 45; // -
    }
    return String.fromCharCode(value);
  }

  function getOutput() {
    let output = Array(data.cipher_length);
    for (let i = 0; i < output.length; i++) {
      output[i] = getOutputValue(i);
    }
    return output;
  }

  return (
    <Window width={470} height={330} theme="crtgreen">
      <Window.Content>
        <Section
          title="Cipher"
          buttons={
            <Button
              fluid
              icon="print"
              tooltip={data.cards + ' punch cards available'}
              onClick={() => act('print', { data: getOutput() })}
            >
              Print
            </Button>
          }
        >
          <Flex
            height="100%"
            direction="row"
            wrap="wrap"
            justify="space-between"
          >
            {[...Array(data.cipher_length)].map((_, index) => (
              <Flex.Item key={index} fontSize="15px">
                <NumberInput
                  value={input[index]}
                  width={5}
                  minValue={0}
                  maxValue={maxOffset}
                  step={1}
                  stepPixelSize={8}
                  format={(value) =>
                    '0x' + value.toString(16).padStart(2, '0').toUpperCase()
                  }
                  onDrag={(value) => handleInput(index, value)}
                />
              </Flex.Item>
            ))}
          </Flex>
        </Section>
        <Section>
          <Flex
            textAlign="center"
            fontSize="15px"
            justify="space-evenly"
            align="center"
          >
            <Flex.Item pr={2}>
              <RoundGauge
                value={offset}
                minValue={0}
                maxValue={maxOffset}
                height={3}
                size={2}
                textAlign="center"
                fontSize="15px"
              />
              <Flex direction="row" justify="space-between">
                <Flex.Item>
                  <Button
                    icon="chevron-left"
                    width={3}
                    onClick={() => handleOffset(-1)}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="chevron-right"
                    width={3}
                    onClick={() => handleOffset(1)}
                  />
                </Flex.Item>
              </Flex>
            </Flex.Item>
            <Flex.Item>
              <Section>
                <Flex direction="row" wrap="wrap">
                  {[...Array(data.cipher_length)].map((_, index) => (
                    <Flex.Item key={index} fontSize="30px">
                      <Box width={3} bold>
                        {getOutputASCII(index)}
                      </Box>
                    </Flex.Item>
                  ))}
                </Flex>
              </Section>
            </Flex.Item>
          </Flex>
        </Section>
        <Section>
          <Flex
            height="100%"
            direction="row"
            wrap="wrap"
            justify="space-between"
          >
            {[...Array(data.cipher_length)].map((_, index) => (
              <Flex.Item key={index} fontSize="15px">
                <NumberInput
                  disabled
                  value={getOutputValue(index)}
                  width={5}
                  minValue={0}
                  maxValue={maxOffset}
                  step={1}
                  stepPixelSize={8}
                  format={(value) =>
                    '0x' + value.toString(16).padStart(2, '0').toUpperCase()
                  }
                />
              </Flex.Item>
            ))}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};

const EncoderPanel = (props) => {
  const { act, data } = useBackend<EncoderData>();
  const [offset, setOffset] = useSharedState('offset', 0);
  const [input, setInput] = useSharedState(
    'input',
    Array(data.cipher_length).fill(0),
  );
  const [pingResult, setPingResult] = useSharedState(
    'pingResult',
    new Array('P', 'O', 'N', 'G'),
  );
  const [loadingState, setLoadingState] = useState(-1);

  useEffect(() => {
    if (data.punch_card && data.punch_card.length === data.cipher_length) {
      setInput(data.punch_card);
    }
  }, [data.punch_card]);

  function handleInput(index: number, value: number) {
    const newInput = input.map((oldValue, i) => {
      if (i === index) {
        return value;
      } else {
        return oldValue;
      }
    });
    setInput(newInput);
  }

  let timer: NodeJS.Timeout | undefined;
  let loading = -1; // The timer for whatever reason cannot read the loading state
  function startLoading() {
    loading = 0;
    setLoadingState(0);
    timer = setInterval(() => {
      if (loading >= 100) {
        // Done loading
        clearInterval(timer);
        return;
      }
      // Randomly increase loading value by up to 50%
      let newValue = loading + Math.floor(Math.random() * 50);
      loading = Math.min(newValue, 100);
      setLoadingState(loading);
    }, 1000);
  }

  // Take a letter of PONG away at intervals of 90, 75, 60, 45
  let ping = new Array('P', 'I', 'N', 'G');
  function performPing() {
    let pong = new Array('P', 'O', 'N', 'G');
    function pickAndReplace() {
      const rand = Math.floor(Math.random() * 4);
      for (let i = 0; i < pong.length; i++) {
        const current = (i + rand) % 4;
        if (pong[current] !== '*') {
          pong[current] = '*';
          return;
        }
      }
    }
    let check = 90;
    while (data.clarity <= check) {
      pickAndReplace();
      check -= 15;
    }
    setPingResult(pong);
  }
  if (loadingState > 0 && loadingState < 100) {
    performPing();
  }

  function confirmResult() {
    loading = -1;
    setLoadingState(-1);
  }

  return (
    <Window width={520} height={200} theme="crtgreen">
      <Window.Content>
        {loadingState !== -1 && (
          <>
            <Section title="Encoder" minHeight={8.5}>
              <ProgressBar
                value={loadingState}
                minValue={0}
                maxValue={100}
                mb={2}
              />
              <Flex direction="row" wrap="wrap" align="center">
                <Flex.Item grow>{}</Flex.Item>
                {ping.map((value, index) => (
                  <Flex.Item key={index} fontSize="16px">
                    <Box width={3} bold>
                      {loadingState < 50 ? '' : value}
                    </Box>
                  </Flex.Item>
                ))}
                <Flex.Item grow={5}>
                  <Box width="100%" align="center">
                    <Icon
                      size={1.5}
                      name={loadingState !== 100 ? 'spinner' : 'satellite-dish'}
                      spin={loadingState !== 100}
                    />
                  </Box>
                </Flex.Item>
                {pingResult.map((value, index) => (
                  <Flex.Item key={index} fontSize="16px">
                    <Box width={3} bold>
                      {loadingState !== 100 ? '' : value}
                    </Box>
                  </Flex.Item>
                ))}
                <Flex.Item grow>{}</Flex.Item>
              </Flex>
            </Section>
            <Section minHeight={4}>
              <Button
                disabled={loadingState !== 100}
                fluid
                align="center"
                fontSize="15px"
                onClick={() => confirmResult()}
              >
                Confirm
              </Button>
            </Section>
          </>
        )}
        {loadingState === -1 && (
          <>
            <Section title="Encoder" minHeight={8.5}>
              <Flex
                textAlign="center"
                fontSize="15px"
                justify="space-evenly"
                align="center"
              >
                <Flex.Item pr={2}>
                  <Knob
                    value={offset}
                    minValue={0}
                    maxValue={maxOffset}
                    step={1}
                    stepPixelSize={8}
                    suppressFlicker
                    size={1}
                    onDrag={(_, value) => setOffset(value)}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Flex
                    height="100%"
                    direction="row"
                    wrap="wrap"
                    justify="space-between"
                  >
                    {[...Array(data.cipher_length)].map((_, index) => (
                      <Flex.Item key={index} fontSize="15px">
                        <NumberInput
                          value={input[index]}
                          width={5}
                          minValue={0}
                          maxValue={maxOffset}
                          step={1}
                          stepPixelSize={8}
                          format={(value) =>
                            '0x' +
                            value.toString(16).padStart(2, '0').toUpperCase()
                          }
                          onDrag={(value) => handleInput(index, value)}
                        />
                      </Flex.Item>
                    ))}
                  </Flex>
                </Flex.Item>
              </Flex>
            </Section>
            <Section minHeight={4}>
              <Flex direction="row" wrap="wrap" align="center">
                <Flex.Item grow>
                  <Button
                    fluid
                    icon="upload"
                    align="center"
                    fontSize="15px"
                    onClick={() => {
                      startLoading();
                      act('submit', { solution: input, offset: offset });
                    }}
                  >
                    Submit new encoding
                  </Button>
                </Flex.Item>
              </Flex>
            </Section>
          </>
        )}
      </Window.Content>
    </Window>
  );
};
