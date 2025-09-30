import { type BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

import { Box, Button, Flex, Icon } from '../components';

type Data = {
  boundaries: number[];
  difficulty: number;
  field: Cell[][];
  game_state: number;
  settings_unlocked: BooleanLike;
};

type Cell = {
  cell_type: number;
  state: string;
  unique_cell_id: number;
  flagged: BooleanLike;
};

export const Minesweeper = () => {
  const { act, data } = useBackend<Data>();

  const { boundaries, difficulty, field, game_state } = data;
  const ColoredMineList = [
    '#1d1dcfff',
    '#008000',
    '#ad0000ff',
    '#652d6eff',
    '#740000ff',
    '#00aaaaff',
    '#800080',
    '#2e2d2dff',
  ];
  return (
    <Window
      width={350 + 11 * boundaries[0]}
      height={420 + 11.5 * boundaries[1]}
      theme="weyland"
    >
      <Window.Content scrollable>
        <Button>Total landmines: {difficulty}</Button>
        <Button
          style={{
            position: 'relative',
            left: '1%',
          }}
          tooltip={
            'Change the difficulty of the field. Doesnt apply until next field is made. Current boundaries are ' +
            boundaries[0] +
            ':' +
            boundaries[1]
          }
          onClick={() => act('change_difficulty')}
          tooltipPosition="bottom"
        >
          X
        </Button>
        <Button
          style={{
            position: 'relative',
            left: '15%',
          }}
          onClick={() => act('restart')}
        >
          Restart...
        </Button>
        <Button
          style={{
            position: 'relative',
            left: '15%',
          }}
          tooltip={
            'Uncover all clear tiles to win. A number on the tile means there is a landmine somewhere next to it, including diagonally. Flagging is provided with right click. '
          }
          tooltipPosition="bottom"
        >
          ?
        </Button>
        <Flex justify={'space-evenly'}>
          {field.map((fieldC, colIndex) => (
            <Flex.Item key={colIndex} grow>
              {fieldC.map((cell, rowIndex) => (
                <div key={rowIndex}>
                  <Button
                    style={{
                      aspectRatio: '1',
                      width: '100%',
                    }}
                    fluid
                    onContextMenu={(e) => {
                      e.preventDefault();
                      act('flag', { id: cell.unique_cell_id });
                    }}
                    backgroundColor={
                      cell.cell_type === -1 && cell.state === 'open '
                        ? '#FF0000'
                        : null
                    }
                    onClick={() => {
                      if (!cell.flagged) {
                        act('open_cell', { id: cell.unique_cell_id });
                      }
                    }}
                    disabled={
                      cell.state === 'open' || game_state === 1 ? true : false
                    }
                  >
                    <Box
                      style={{
                        position: 'absolute',
                        top: '50%',
                        left: '50%',
                        transform: 'translate(-50%, -50%)',
                      }}
                      color={
                        cell.cell_type > 0
                          ? ColoredMineList[cell.cell_type - 1]
                          : null
                      }
                    >
                      {cell.state === 'open' ? (
                        cell.cell_type === -1 ? (
                          <Icon ml={1} size={2} name="bug" />
                        ) : cell.cell_type === -2 ? null : (
                          <h1 style={{ fontSize: '30px' }}>{cell.cell_type}</h1>
                        )
                      ) : !!cell.flagged === true ? (
                        <Icon ml={1} size={2} name="flag" color="#db0000ff" />
                      ) : null}
                    </Box>
                  </Button>
                </div>
              ))}
            </Flex.Item>
          ))}
        </Flex>
      </Window.Content>
    </Window>
  );
};
