import { useBackend } from '../backend';
import { Button, Stack } from '../components';
import { Window } from '../layouts';

interface GettyProps {
  at_ship: Boolean;
  on_land: Boolean;
  transiting: Boolean;

  land_to_air_locked: Boolean;
  air_to_ship_locked: Boolean;
}

export const Minidropship = (_props, context) => {
  const { act, data } = useBackend<GettyProps>(context);
  const { at_ship } = data;

  return (
    <Window width={220} height={340} title={'Gettysburg Navigation'}>
      <Stack>
        <Stack.Item>
          <Button content={at_ship ? 'Take Off' : 'Return to Ship'} />
        </Stack.Item>
      </Stack>
    </Window>
  );
};
