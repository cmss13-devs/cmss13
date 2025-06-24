import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';

import { Box, Button, Flex, Icon } from '../components';

type Data = {
  boundaries: number[];
  difficulty: number;
  field: Cell[][];
  game_state: number;
};

type Cell = {
  cell_type: number;
  state: string;
  unique_cell_id: number;
};

export const Minesweeper = () => {
  const { act, data } = useBackend<Data>();

  const { boundaries, difficulty, field, game_state } = data;

  return (
    <Window width={650} height={850} theme="weyland">
      <Window.Content scrollable>
        <Button
          style={{
            position: 'relative',
            left: '70%',
          }}
          onClick={() => act('restart')}
        >
          Restart...
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
                    backgroundColor={
                      cell.cell_type === -1 && cell.state === 'open '
                        ? '#FF0000'
                        : null
                    }
                    onClick={() =>
                      act('open_cell', { id: cell.unique_cell_id })
                    }
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
                    >
                      {cell.state === 'open' ? (
                        cell.cell_type === -1 ? (
                          <Icon ml={0.5} size={2} name="land-mine-on" />
                        ) : cell.cell_type === -2 ? null : (
                          <h2>{cell.cell_type}</h2>
                        )
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
