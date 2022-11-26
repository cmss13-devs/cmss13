import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

interface DockingPort {
  id: string;
  name: string;
}

interface NavigationProps {
  destinations: DockingPort[];
}

export const NavigationShuttle = (props, context) => {
  const { data, act } = useBackend<NavigationProps>(context);
  return (
    <Window>
      <Window.Content>
        <Section title="Destinations">
          <Stack vertical>
            {data.destinations.map((x) => (
              <Stack.Item key={x.id}>
                <Button onClick={() => act('move', { target: x.id })}>
                  {x.name}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
