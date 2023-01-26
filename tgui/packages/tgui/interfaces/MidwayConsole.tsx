import { capitalizeAll } from 'common/string';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';
import { createLogger } from '../logging';

interface MidwayProps {
  current_state: string;
  current_mode: string;
}

export const MidwayConsole = (_props, context) => {
  const { act, data } = useBackend<MidwayProps>(context);
  const { current_state, current_mode } = data;
  const logger = createLogger('guh');

  return (
    <Window
      width={220}
      height={340}
      title={'Gettysburg Navigation'}
      theme={'crtyellow'}>
      <Window.Content>
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
        <Section title={'Astronavigation'}>
          <Stack>
            <Stack.Item grow>
              <Button
                content={'Take Off'}
                onClick={() => act('take_off')}
                fluid
                disabled={
                  current_state !== 'on ship' || current_mode !== 'idle'
                }
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
        <Section title={'Ground Controls'}>
          <Stack vertical>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Button
                    content={'Initiate Landing'}
                    onClick={() => act('land_on_ground')}
                    fluid
                    disabled={
                      current_state !== 'in atmosphere' ||
                      current_mode !== 'idle'
                    }
                  />
                </Stack.Item>
                <Stack.Item grow>
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
              <Button
                content={'View Ground'}
                onClick={() => act('view_ground')}
                fluid
                disabled={
                  current_state !== 'in atmosphere' || current_mode !== 'idle'
                }
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
