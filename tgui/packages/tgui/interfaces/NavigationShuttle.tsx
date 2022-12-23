import { useBackend, useLocalState } from '../backend';
import { Box, Button, Icon, Flex, Section, Stack } from '../components';
import { Window } from '../layouts';

interface DockingPort {
  id: string;
  name: string;
  available: 0 | 1;
  error: string | null;
}

interface NavigationProps {
  destinations: DockingPort[];
  doors_locked?: boolean;
}

const SHUTTLE_ALREADY_DOCKED = 'we are already docked';

const CancelLaunchButton = (_, context) => {
  const { act } = useBackend<NavigationProps>(context);
  const [siteselection, setSiteSelection] = useLocalState<string | undefined>(
    context,
    'target_site',
    undefined
  );
  return (
    <Button
      disabled={siteselection === undefined}
      onClick={() => setSiteSelection(undefined)}>
      Cancel
    </Button>
  );
};

const LaunchButton = (_, context) => {
  const { act } = useBackend<NavigationProps>(context);
  const [siteselection] = useLocalState<string | undefined>(
    context,
    'target_site',
    undefined
  );
  return (
    <Button
      disabled={siteselection === undefined}
      onClick={() => act('move', { target: siteselection })}>
      Launch
    </Button>
  );
};

export const NavigationShuttle = (props, context) => {
  const { data, act } = useBackend<NavigationProps>(context);
  const [siteselection, setSiteSelection] = useLocalState<string | undefined>(
    context,
    'target_site',
    undefined
  );
  const currentLocation = data.destinations.find(
    (x) => x.error?.localeCompare(SHUTTLE_ALREADY_DOCKED) === 0
  );
  return (
    <Window theme="crtblue">
      <Window.Content className="NavigationMenu">
        <Section
          title="Select Destination"
          buttons={
            <>
              <CancelLaunchButton />
              <LaunchButton />
            </>
          }>
          <Stack vertical>
            {data.destinations
              .filter((x) => x.available === 1)
              .map((x) => (
                <Stack.Item key={x.id}>
                  <Flex align="center">
                    {siteselection === x.id && (
                      <>
                        <Flex.Item>
                          <Icon name="play" />
                        </Flex.Item>
                        <Flex.Item>
                          <Box width={1} />
                        </Flex.Item>
                      </>
                    )}
                    <Flex.Item>
                      <Button
                        disabled={x.available === 0}
                        onClick={() => setSiteSelection(x.id)}>
                        {x.name}
                      </Button>
                    </Flex.Item>
                  </Flex>
                </Stack.Item>
              ))}
          </Stack>
        </Section>
        <Section
          title="Door Controls"
          buttons={
            <Button onClick={() => act('lockdown')} icon="triangle-exclamation">
              Lockdown
            </Button>
          }>
          <Stack>
            <Stack.Item>
              <Button onClick={() => act('open')} icon="door-open">
                Force Open
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('close')} icon="door-closed">
                Force Close
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('lock')} icon="lock">
                Lock
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('unlock')} icon="lock-open">
                Unlock
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
