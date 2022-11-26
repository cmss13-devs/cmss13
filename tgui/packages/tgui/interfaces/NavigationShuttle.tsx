import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

interface NavigationProps {
  destinations: string[];
}

export const NavigationShuttle = (props, context) => {
  const { data, act } = useBackend<NavigationProps>(context);
  return (
    <Window>
      <Window.Content>
        <Section title="Destinations">
          {data.destinations.map((x) => (
            <Button key={x} onClick={() => act('move', { target: x })}>
              {x}
            </Button>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
