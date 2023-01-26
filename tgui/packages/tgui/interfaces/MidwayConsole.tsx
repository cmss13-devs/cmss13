import { useBackend } from '../backend';
import { Button, Stack } from '../components';
import { Window } from '../layouts';

interface GettyProps {
  at_ship: 0 | 1;
  on_land: 0 | 1;
  transiting: 0 | 1;

  land_to_air_locked: 0 | 1;
  air_to_ship_locked: 0 | 1;
}

export const MidwayConsole = (_props, context) => {
  const { act, data } = useBackend<GettyProps>(context);
  const { at_ship } = data;

  return (
    <Window width={220} height={340} title={'Gettysburg Navigation'}>
      <Stack direction={'column'}>
        <Stack>
          <Stack.Item>
            <Button content={'Take Off'} onClick={() => act('from_ship')} />
          </Stack.Item>
          <Stack.Item>
            <Button content={'Return to Ship'} onClick={() => act('to_ship')} />
          </Stack.Item>
        </Stack>
        <Stack>
          <Stack.Item>
            <Button
              content={'View Ground'}
              onClick={() => act('view_ground')}
            />
          </Stack.Item>
        </Stack>
      </Stack>
    </Window>
  );
};
