import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Flex,
  Icon,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export interface DockingPort {
  id: string;
  name: string;
  available: 0 | 1;
  error: string | null;
}

export interface NavigationProps {
  destinations: DockingPort[];
  doors_locked?: boolean;
  shuttle_mode: string;
  target_destination?: string;
  flight_time: number;
  max_flight_duration: number;
  max_refuel_duration: number;
  max_engine_start_duration: number;
  max_pre_arrival_duration: number;
  must_launch_home: boolean;
  spooling: boolean;
  mission_accomplished: boolean;
  is_disabled: 0 | 1;
  locked_down: 0 | 1;
}

export const CancelLaunchButton = () => {
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    'target_site',
    undefined,
  );
  return (
    <Button
      icon="ban"
      disabled={siteselection === undefined}
      onClick={() => setSiteSelection(undefined)}
    >
      Cancel
    </Button>
  );
};

export const LaunchButton = () => {
  const { act } = useBackend<NavigationProps>();
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    'target_site',
    undefined,
  );
  return (
    <Button
      icon="rocket"
      disabled={siteselection === undefined}
      onClick={() => {
        act('move', { target: siteselection });
        setSiteSelection(undefined);
      }}
    >
      Launch
    </Button>
  );
};

export const DestionationSelection = () => {
  const { data, act } = useBackend<NavigationProps>();
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    'target_site',
    undefined,
  );
  return (
    <Section
      title="Select Destination"
      buttons={
        <>
          <CancelLaunchButton />
          <LaunchButton />
        </>
      }
    >
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
                    }}
                  >
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

export const ShuttleRecharge = () => {
  const { data } = useBackend<NavigationProps>();
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
              value={data.flight_time}
            >
              T-{data.flight_time}s
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

export const LaunchCountdown = () => {
  const { data } = useBackend<NavigationProps>();
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
              value={data.flight_time}
            >
              T-{data.flight_time}s
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

export const InFlightCountdown = () => {
  const { data, act } = useBackend<NavigationProps>();
  return (
    <Section
      title={`In flight: ${data.target_destination}`}
      buttons={
        data.target_destination === 'Flyby' && (
          <Button onClick={() => act('cancel-flyby')}>Cancel</Button>
        )
      }
    >
      <div className="InFlightCountdown">
        <Stack vertical>
          <Stack.Item>
            <span>
              Time until destination: <u>T-{data.flight_time}s</u>.
            </span>
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              maxValue={data.max_flight_duration}
              value={data.flight_time}
            >
              T-{data.flight_time}s
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

const DoorControls = () => {
  const { data, act } = useBackend<NavigationProps>();
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
              icon="triangle-exclamation"
            >
              Lockdown
            </Button>
          )}
          {data.locked_down === 1 && (
            <Button
              disabled={disable_door_controls}
              onClick={() => act('unlock')}
              icon="triangle-exclamation"
            >
              Lift Lockdown
            </Button>
          )}
        </>
      }
    >
      <Stack className="DoorControlStack">
        <Stack.Item>
          <Button
            disabled={disable_normal_control || disable_door_controls}
            onClick={() => act('open')}
            icon="door-open"
          >
            Force Open
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            disabled={disable_normal_control || disable_door_controls}
            onClick={() => act('close')}
            icon="door-closed"
          >
            Force Close
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const DisabledScreen = (props) => {
  const { data } = useBackend<NavigationProps>();

  const disabled_text = data.mission_accomplished
    ? 'Auto-navigation protocol completed - return home complete. Shuttle disabled.'
    : 'The shuttle has had an error. Contact your nearest system administrator to resolve the issue.';

  return (
    <Box className="DisabledScreen">
      <div>
        <span>{disabled_text}</span>
      </div>
    </Box>
  );
};

const LaunchHome = (props) => {
  const { data, act } = useBackend<NavigationProps>();

  return (
    <Section title="Automatic Return Enabled" className="DestinationSelector">
      <Button.Confirm
        fluid
        confirmContent={'One-way navigation enabled - confirm?'}
        onClick={() => act('launch_home')}
      >
        Return Home
      </Button.Confirm>
    </Section>
  );
};

const SpoolingDimmer = (props) => {
  const { data, act } = useBackend<NavigationProps>();

  return (
    <Dimmer>
      <Stack>
        <Stack.Item>
          <Box>Spooling...</Box>
        </Stack.Item>
        <Stack.Item>
          <Icon name={'spinner'} spin />
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};

const DestinationOptions = (props) => {
  const { data, act } = useBackend<NavigationProps>();

  if (data.must_launch_home) {
    return (
      <>
        <LaunchHome />
        <DestionationSelection />
      </>
    );
  } else {
    return <DestionationSelection />;
  }
};

const RenderScreen = (props) => {
  const { data } = useBackend<NavigationProps>();
  return (
    <>
      {!!data.spooling && <SpoolingDimmer />}
      {data.shuttle_mode === 'idle' && <DestinationOptions />}
      {data.shuttle_mode === 'igniting' && <LaunchCountdown />}
      {data.shuttle_mode === 'recharging' && <ShuttleRecharge />}
      {data.shuttle_mode === 'called' && <InFlightCountdown />}
      <DoorControls />
    </>
  );
};

export const NavigationShuttle = (props) => {
  const { data } = useBackend<NavigationProps>();
  return (
    <Window theme="crtlobby" height={505} width={700}>
      <Window.Content className="NavigationMenu">
        {data.is_disabled === 1 && <DisabledScreen />}
        {data.is_disabled === 0 && <RenderScreen />}
      </Window.Content>
    </Window>
  );
};
