import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Box, Button, ProgressBar, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = { pressure: number; mode: number; flush: BooleanLike };

export const Disposals = () => {
  const { act, data } = useBackend<Data>();

  const { pressure, mode, flush } = data;

  return (
    <Window width={350} height={150}>
      <Window.Content scrollable>
        <Section>
          <Button
            fluid
            icon={flush ? 'trash-arrow-up' : 'trash'}
            onClick={() => act('handle')}
          >
            {flush ? 'Disengage handle.' : 'Engage handle.'}
          </Button>
          <Button fluid icon="trash-arrow-up" onClick={() => act('eject')}>
            Eject contents.
          </Button>
          <Box height="5px" />
          <ProgressBar width="100%" value={pressure / 100} color="good">
            <Box>Pressure: {pressure}%</Box>
          </ProgressBar>
          <Button
            fluid
            icon={mode <= 0 ? 'rotate' : 'power-off'}
            onClick={() => act('pump')}
          >
            {mode <= 0 ? 'Engage pump' : 'Disengage pump.'}
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
