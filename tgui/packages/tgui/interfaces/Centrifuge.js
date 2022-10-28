import { useBackend } from '../backend';
import { Section, Flex, Button, Box, Input, NoticeBox } from '../components';
import { Window } from '../layouts';

export const Centrifuge = (_props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window width={300} height={270} theme="weyland">
      <Window.Content scrollable>
        <Section title="Pod controls">
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
            </Flex.Item>
            <Flex.Item>
              <Button
                content={data.mode ? 'Mode : distribute' : 'Mode : split'}
                fluid
                icon={data.mode ? 'equals' : 'arrows-split-up-and-left'}
                onClick={() => act('togglemode')}
              />
              <Box width="2px" />
            </Flex.Item>
            <Flex.Item>
              <Button
                content={
                  data.input_source
                    ? 'Input : Turing Dispenser'
                    : 'Input : Container'
                }
                icon="flask"
                fluid
                disabled={!data.turing}
                onClick={() => act('togglesource')}
              />
              <Box width="2px" />
            </Flex.Item>
            {!data.turing && (
              <Flex.Item>
                <Button
                  content="Connect a Turing Dispenser"
                  icon="link"
                  fluid
                  disabled={!data.turing}
                  onClick={() => act('attempt_connection')}
                />
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
