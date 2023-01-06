import { useBackend, useSharedState } from '../backend';
import { Box, Button, Icon, Flex, Section, Stack, ProgressBar } from '../components';
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
  shuttle_mode: string;
  target_destination?: string;
  flight_time: number;
  max_flight_duration: number;
  max_refuel_duration: number;
  max_engine_start_duration: number;
  is_disabled: 0 | 1;
  locked_down: 0 | 1;
}

const CancelLaunchButton = (_, context) => {
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    context,
    'target_site',
    undefined
  );
  return (
    <Button
      icon="ban"
      disabled={siteselection === undefined}
      onClick={() => setSiteSelection(undefined)}>
      Cancel
    </Button>
  );
};

const LaunchButton = (_, context) => {
  const { act } = useBackend<NavigationProps>(context);
  const [siteselection] = useSharedState<string | undefined>(
    context,
    'target_site',
    undefined
  );
  return (
    <Button
      icon="rocket"
      disabled={siteselection === undefined}
      onClick={() => act('move', { target: siteselection })}>
      Launch
    </Button>
  );
};

const DestionationSelection = (_, context) => {
  const { data, act } = useBackend<NavigationProps>(context);
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    context,
    'target_site',
    undefined
  );
  return (
    <Section
      title="Select Destination"
      buttons={
        <>
          <CancelLaunchButton />
          <LaunchButton />
        </>
      }>
      <Stack vertical className="DestinationSelector">
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
                <Flex.Item grow={1}>
                  <Button
                    disabled={x.available === 0}
                    onClick={() => {
                      setSiteSelection(x.id);
                      act('button-push');
                    }}>
                    {x.name}
                  </Button>
                </Flex.Item>
              </Flex>
            </Stack.Item>
          ))}
      </Stack>
    </Section>
  );
};

const ShuttleRecharge = (_, context) => {
  const { data } = useBackend<NavigationProps>(context);
  return (
    <Section title="Refueling in progress">
      <div className="LaunchCountdown">
        <Stack vertical>
          <Stack.Item>
            <span>
              Ready to launch in <u>T-{data.flight_time}s</u>.
            </span>
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              maxValue={data.max_refuel_duration}
              value={data.flight_time}>
              T-{data.flight_time}s
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

const LaunchCountdown = (_, context) => {
  const { data } = useBackend<NavigationProps>(context);
  return (
    <Section title="Launch in progress">
      <div className="LaunchCountdown">
        <Stack vertical>
          <Stack.Item>
            <span>
              Launching in <u>T-{data.flight_time}s</u> to{' '}
              {data.target_destination}.
            </span>
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              maxValue={data.max_engine_start_duration}
              value={data.flight_time}>
              T-{data.flight_time}s
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

const InFlightCountdown = (_, context) => {
  const { data } = useBackend<NavigationProps>(context);
  return (
    <Section title={`In flight: ${data.target_destination}`}>
      <div className="InFlightCountdown">
        <Stack vertical>
          <Stack.Item>
            <span>
              Time until landing: <u>T-{data.flight_time}s</u>.
            </span>
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              maxValue={data.max_flight_duration}
              value={data.flight_time}>
              T-{data.flight_time}s
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

const DoorControls = (_, context) => {
  const { data, act } = useBackend<NavigationProps>(context);
  const in_flight = data.shuttle_mode === 'called';
  const disable_door_controls = in_flight;
  const disable_normal_control = data.locked_down === 1;
  return (
    <Section
      title="Door Controls"
      buttons={
        <>
          {data.locked_down === 0 && (
            <Button
              disabled={disable_door_controls}
              onClick={() => act('lockdown')}
              icon="triangle-exclamation">
              Lockdown
            </Button>
          )}
          {data.locked_down === 1 && (
            <Button
              disabled={disable_door_controls}
              onClick={() => act('unlock')}
              icon="triangle-exclamation">
              Lift Lockdown
            </Button>
          )}
        </>
      }>
      <Stack className="DoorControlStack">
        <Stack.Item>
          <Button
            disabled={disable_normal_control || disable_door_controls}
            onClick={() => act('open')}
            icon="door-open">
            Force Open
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            disabled={disable_normal_control || disable_door_controls}
            onClick={() => act('close')}
            icon="door-closed">
            Force Close
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const DisabledScreen = (props, context) => {
  return (
    <Box className="DisabledScreen">
      <div>
        <span>
          The shuttle has had an error. Contact your nearest system
          administrator to resolve the issue.
        </span>
      </div>
    </Box>
  );
};

const RenderScreen = (props, context) => {
  const { data } = useBackend<NavigationProps>(context);
  return (
    <>
      {data.shuttle_mode === 'idle' && <DestionationSelection />}
      {data.shuttle_mode === 'igniting' && <LaunchCountdown />}
      {data.shuttle_mode === 'recharging' && <ShuttleRecharge />}
      {data.shuttle_mode === 'called' && <InFlightCountdown />}
      <DoorControls />
    </>
  );
};

export const NavigationShuttle = (props, context) => {
  const { data } = useBackend<NavigationProps>(context);
  return (
    <Window theme="crtgreen" height={500} width={700}>
      <Window.Content className="NavigationMenu">
        {data.is_disabled === 1 && <DisabledScreen />}
        {data.is_disabled === 0 && <RenderScreen />}
      </Window.Content>
    </Window>
  );
};
