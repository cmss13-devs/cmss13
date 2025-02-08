import { useBackend } from '../backend';
import { Box, Button, Flex, Input, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export const Centrifuge = () => {
  const { act, data } = useBackend();

  return (
    <Window width={300} height={270} theme="weyland">
      <Window.Content scrollable>
        <Section title="Centrifuge controls">
          <Flex direction="column">
            <Flex.Item>
              Label :{' '}
              <Input
                placeholder="No label"
                value={data.label}
                width="210px"
                onInput={(e, value) =>
                  act('setlabel', {
                    name: value,
                  })
                }
              />
              <Box height="10px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                fluid
                icon={data.mode ? 'equals' : 'arrows-split-up-and-left'}
                onClick={() => act('togglemode')}
              >
                {data.mode ? 'Mode : distribute' : 'Mode : split'}
              </Button>
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="flask"
                fluid
                disabled={!data.turing}
                onClick={() => act('togglesource')}
              >
                {data.input_source
                  ? 'Input : Turing Dispenser'
                  : 'Input : Container'}
              </Button>
              <Box width="2px" />
            </Flex.Item>
            {!data.turing && (
              <Flex.Item>
                <Button
                  icon="link"
                  fluid
                  disabled={!data.turing}
                  onClick={() => act('attempt_connection')}
                >
                  Connect a Turing Dispenser
                </Button>
                <Box width="2px" />
              </Flex.Item>
            )}
            <Flex.Item>
              <NoticeBox info>
                {data.turing
                  ? 'Turing Dispenser connected!'
                  : 'No Turing Dispenser connected!'}
              </NoticeBox>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
