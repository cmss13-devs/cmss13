import { Window } from '../layouts';
import { Manifest } from './common/Manifest';

export const CrewManifest = () => {
  return (
    <Window title={'Crew Manifest'}>
      <Window.Content scrollable>
        <Manifest />
      </Window.Content>
    </Window>
  );
};
