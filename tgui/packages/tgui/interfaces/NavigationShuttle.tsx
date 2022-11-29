import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

interface DockingPort {
  id: string;
  name: string;
  available: 0 | 1;
  error: string | null;
}

interface NavigationProps {
  destinations: DockingPort[];
}

const SHUTTLE_ALREADY_DOCKED = 'we are already docked';

export const NavigationShuttle = (props, context) => {
  const { data, act } = useBackend<NavigationProps>(context);
  const currentLocation = data.destinations.find(
    (x) => x.error?.localeCompare(SHUTTLE_ALREADY_DOCKED) === 0
  );
  return (
    <Window>
      <Window.Content>
        <Section title="Destinations">
          <Stack vertical>
            {data.destinations
              .filter((x) => x.available === 1)
              .map((x) => (
                <Stack.Item key={x.id}>
                  <Button
                    disabled={x.available === 0}
                    onClick={() => act('move', { target: x.id })}>
                    {x.name}
                  </Button>
                </Stack.Item>
              ))}
          </Stack>
        </Section>
        <Section title="Door Controls">
          <Stack>
            <Stack.Item>
              <Button onClick={() => act('open')}>Open</Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('close')}>Close</Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('lock')}>Lock</Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('unlock')}>Unlock</Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
