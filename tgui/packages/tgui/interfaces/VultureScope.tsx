import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, ColorBox, Flex, Stack, Icon, Input, LabeledList, Section, Table, Divider, ProgressBar } from '../components';
import { Window } from '../layouts';

type ScopeData = {
  offset_x: Number;
  offset_y: Number;
  valid_offset_dirs: Array<String>;
  valid_adjust_dirs: Array<String>;
  scope_cooldown: BooleanLike;
  breath_cooldown: BooleanLike;
  breath_recharge: Number;
};

enum Direction {
  North = 1,
  NorthEast = 5,
  East = 4,
  SouthEast = 6,
  South = 2,
  SouthWest = 10,
  West = 8,
  NorthWest = 9,
}

const DirectionAbbreviation: Record<Direction, string> = {
  [Direction.North]: 'N',
  [Direction.NorthEast]: 'NE',
  [Direction.East]: 'E',
  [Direction.SouthEast]: 'SE',
  [Direction.South]: 'S',
  [Direction.SouthWest]: 'SW',
  [Direction.West]: 'W',
  [Direction.NorthWest]: 'NW',
};

const OffsetAdjuster = (props, context) => {
  const { act, data } = useBackend<ScopeData>(context);
  return (
    <div
      style={{
        'flex': '1',
        'margin-right': '20px',
      }}>
      <Section title="Offset">
        <Box>
          <Stack vertical>
            <Flex>
              <OffsetDirection dir={Direction.NorthWest} />
              <OffsetDirection dir={Direction.North} />
              <OffsetDirection dir={Direction.NorthEast} />
            </Flex>
            <Flex>
              <OffsetDirection dir={Direction.West} />
              <Flex.Item grow={1} basis={0}>
                <Button
                  disabled={true}
                  textAlign="center"
                  color="yellow"
                  lineHeight={3}
                  m={-0.2}
                  fluid>
                  <Icon name="arrows-alt" size={1.5} m="0%" />
                </Button>
              </Flex.Item>
              <OffsetDirection dir={Direction.East} />
            </Flex>
            <Flex>
              <OffsetDirection dir={Direction.SouthWest} />
              <OffsetDirection dir={Direction.South} />
              <OffsetDirection dir={Direction.SouthEast} />
            </Flex>
          </Stack>
        </Box>
      </Section>
    </div>
  );
};

const OffsetDirection = (props, context) => {
  const { dir } = props;
  const { data, act } = useBackend<ScopeData>(context);
  return (
    <Flex.Item grow={1} basis={0}>
      <Button
        content={DirectionAbbreviation[dir]}
        tooltip={`Adjusts the scope's offset to the ${DirectionAbbreviation[dir]}`}
        disabled={
          data.valid_offset_dirs.indexOf(dir) == -1 || data.scope_cooldown
        }
        textAlign="center"
        onClick={() => act('adjust_dir', { offset_dir: dir })}
        color="yellow"
        lineHeight={3}
        m={-0.2}
        fluid
      />
    </Flex.Item>
  );
};

const PositionAdjuster = (props, context) => {
  const { act, data } = useBackend<ScopeData>(context);
  return (
    <div style={{ 'flex': '1' }}>
      <Section title="Position" textAlign="right">
        <Box>
          <Stack vertical>
            <Flex>
              <ScopePosition dir={Direction.NorthWest} />
              <ScopePosition dir={Direction.North} />
              <ScopePosition dir={Direction.NorthEast} />
            </Flex>
            <Flex>
              <ScopePosition dir={Direction.West} />
              <Flex.Item grow={1} basis={0}>
                <Button
                  disabled={true}
                  textAlign="center"
                  color="yellow"
                  lineHeight={3}
                  m={-0.2}
                  fluid>
                  <Icon name="arrows-alt" size={1.5} m="0%" />
                </Button>
              </Flex.Item>
              <ScopePosition dir={Direction.East} />
            </Flex>
            <Flex>
              <ScopePosition dir={Direction.SouthWest} />
              <ScopePosition dir={Direction.South} />
              <ScopePosition dir={Direction.SouthEast} />
            </Flex>
          </Stack>
        </Box>
      </Section>
    </div>
  );
};

const ScopePosition = (props, context) => {
  const { dir } = props;
  const { data, act } = useBackend<ScopeData>(context);
  return (
    <Flex.Item grow={1} basis={0}>
      <Button
        content={DirectionAbbreviation[dir]}
        tooltip={`Adjusts the scope's position to the ${DirectionAbbreviation[dir]}`}
        disabled={
          data.valid_adjust_dirs.indexOf(dir) == -1 || data.scope_cooldown
        }
        textAlign="center"
        onClick={() => act('adjust_position', { position_dir: dir })}
        color="red"
        lineHeight={3}
        m={-0.2}
        fluid
      />
    </Flex.Item>
  );
};

const BreathButton = (props, context) => {
  const { dir } = props;
  const { data, act } = useBackend<ScopeData>(context);
  return (
    <Section title="Breathing" textAlign="center">
      <Flex.Item grow={1} basis={0}>
        <Button
          content="Hold Breath"
          tooltip="Hold your breath for a short time, removing scope drift."
          disabled={data.breath_cooldown}
          textAlign="center"
          onClick={() => act('hold_breath')}
          color="green"
          lineHeight={3}
          m={-0.2}
          fluid
        />
      </Flex.Item>
      <div style={{ 'padding': '6px' }} />
      <Flex.Item>
        <ProgressBar
          minValue={0}
          maxValue={1}
          value={data.breath_recharge}
          ranges={{
            good: [0.8, Infinity],
            average: [0.5, 0.8],
            bad: [-Infinity, 0.5],
          }}>
          Recharge
        </ProgressBar>
      </Flex.Item>
    </Section>
  );
};

export const VultureScope = (props, context) => {
  const { act, data } = useBackend<ScopeData>(context);
  return (
    <Window title="Scope Configuration" width={325} height={350}>
      <Window.Content>
        <Section title="Scope Adjustments">
          <div style={{ 'display': 'flex' }}>
            <OffsetAdjuster />
            <PositionAdjuster />
          </div>
        </Section>
        <BreathButton />
      </Window.Content>
    </Window>
  );
};
