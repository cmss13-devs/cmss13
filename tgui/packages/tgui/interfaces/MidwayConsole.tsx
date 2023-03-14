import { capitalizeAll } from 'common/string';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

interface MidwayProps {
  current_state: string;
  current_mode: string;
  current_beacons: string[];
}

export const MidwayConsole = (_props, context) => {
  const { act, data } = useBackend<MidwayProps>(context);

  return (
    <Window
      width={250}
      height={290}
      title={'Gettysburg Navigation'}
      theme={'crtyellow'}>
      <Window.Content>
        <MidwayStatus />
        <MidwayAstro />
        <MidwayGround />
      </Window.Content>
    </Window>
  );
};

export const MidwayStatus = (_props, context) => {
  const { act, data } = useBackend<MidwayProps>(context);
  const { current_state, current_mode } = data;

  return (
    <Section title={'Dropship Status'}>
      <LabeledList>
        <LabeledList.Item label="Location">
          {capitalizeAll(current_state)}
        </LabeledList.Item>
        <LabeledList.Item label="Status">
          {capitalizeAll(current_mode)}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const MidwayAstro = (_props, context) => {
  const { act, data } = useBackend<MidwayProps>(context);
  const { current_state, current_mode } = data;

  return (
    <Section title={'Astronavigation'}>
      <Stack>
        <Stack.Item grow>
          <Button
            content={'Take Off'}
            onClick={() => act('take_off')}
            fluid
            disabled={current_state !== 'on ship' || current_mode !== 'idle'}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            content={'Return to Ship'}
            onClick={() => act('to_ship')}
            disabled={
              current_state !== 'in atmosphere' || current_mode !== 'idle'
            }
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const MidwayGround = (_props, context) => {
  const { act, data } = useBackend<MidwayProps>(context);
  const { current_state, current_mode } = data;

  return (
    <Section title={'Ground Controls'}>
      <Stack vertical>
        <Stack.Item>
          <Stack>
            <Stack.Item grow>
              <Button
                content={'View Ground'}
                onClick={() => act('view_ground')}
                fluid
                disabled={
                  current_state !== 'in atmosphere' || current_mode !== 'idle'
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content={'Take Off'}
                onClick={() => act('take_off')}
                fluid
                disabled={
                  current_state !== 'on ground' || current_mode !== 'idle'
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          {data.current_beacons.length && (
            <>
              <p>Available Beacons:</p>
              <Box>
                {data.current_beacons.map((x) => {
                  return <p key={x}>{x}</p>;
                })}
              </Box>
            </>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
