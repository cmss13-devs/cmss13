import { useBackend } from '../backend';
import { ByondUi } from '../components';
import { Window } from '../layouts';

interface TacMapProps {
  mapRef: string;
}

export const TacticalMap = (props, context) => {
  const { data, act } = useBackend<TacMapProps>(context);
  return (
    <Window title={'Tactical Map'} theme="usmc" width={650} height={680}>
      <Window.Content>
        <ByondUi
          params={{
            id: data.mapRef,
            type: 'map',
          }}
          class="TacticalMap"
        />
      </Window.Content>
    </Window>
  );
};
