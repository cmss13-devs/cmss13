import { useBackend } from '../backend';
import { Section, ProgressBar, Button, Box } from '../components';
import { Window } from '../layouts';

export const Disposals = (_props, context) => {
  const { act, data } = useBackend(context);

  const { pressure, mode, flush } = data;

  return (
    <Window width={350} height={150}>
      <Window.Content scrollable>
        <Section>
          <Button
            content={flush ? 'Disengage handle.' : 'Engage handle.'}
            fluid
            icon={flush ? 'trash-arrow-up' : 'trash'}
            onClick={() => act('handle')}
          />
          <Button
            content="Eject contents."
            fluid
            icon="trash-arrow-up"
            onClick={() => act('eject')}
          />
          <Box height="5px" />
          <ProgressBar width="100%" value={pressure / 100} color="good">
            <Box>Pressure: {pressure}%</Box>
          </ProgressBar>
          <Button
            content={mode <= 0 ? 'Engage pump' : 'Disengage pump.'}
            fluid
            icon={mode <= 0 ? 'rotate' : 'power-off'}
            onClick={() => act('pump')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
