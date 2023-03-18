import { useBackend, useSharedState } from '../backend';
import { Window } from '../layouts';
import { Box, Button, Flex, Icon, ProgressBar, Section, Stack } from '../components';
import { LaunchButton, CancelLaunchButton, DisabledScreen, InFlightCountdown, LaunchCountdown, NavigationProps, ShuttleRecharge, DockingPort } from './NavigationShuttle';

interface DoorStatus {
  id: string;
  value: 0 | 1;
}

interface AutomatedControl {
  is_automated: 0 | 1;
  hangar_lz: null | string;
  ground_lz: null | string;
}

interface DropshipNavigationProps extends NavigationProps {
  door_status: Array<DoorStatus>;
  has_flight_optimisation?: 0 | 1;
  is_flight_optimised?: 0 | 1;
  flight_configuration: 'flyby' | 'ferry';
  can_fly_by?: 0 | 1;
  can_set_automated?: 0 | 1;
  primary_lz?: string;
  automated_control: AutomatedControl;
  has_flyby_skill: 0 | 1;
}

const DropshipDoorControl = (_, context) => {
  const { data, act } = useBackend<DropshipNavigationProps>(context);
  const in_flight =
    data.shuttle_mode === 'called' || data.shuttle_mode === 'pre-arrival';
  const disable_door_controls = in_flight;
  const disable_normal_control = data.locked_down === 1;
  return (
    <Section
      title="Door Controls"
      buttons={data.door_status
        .filter((x) => x.id === 'all')
        .map((x) => (
          <>
            {x.value === 0 && (
              <Button
                disabled={disable_door_controls}
                onClick={() =>
                  act('door-control', { interaction: 'lock', location: 'all' })
                }
                icon="triangle-exclamation">
                Lockdown
              </Button>
            )}

            {x.value === 1 && (
              <Button
                disabled={disable_door_controls}
                onClick={() =>
                  act('door-control', {
                    interaction: 'unlock',
                    location: 'all',
                  })
                }
                icon="triangle-exclamation">
                Lift Lockdown
              </Button>
            )}
          </>
        ))}>
      <Stack className="DoorControlStack">
        {data.door_status
          .filter((x) => x.id !== 'all')
          .map((x) => {
            const name = x.id.substr(0, 1).toLocaleUpperCase() + x.id.substr(1);
            return (
              <Stack.Item key={x.id}>
                <>
                  {x.value === 0 && (
                    <Button
                      onClick={() =>
                        act('door-control', {
                          interaction: 'lock',
                          location: x.id,
                        })
                      }
                      icon="door-closed">
                      Lock {name}
                    </Button>
                  )}
                  {x.value === 1 && (
                    <Button
                      disabled={disable_door_controls}
                      onClick={() =>
                        act('door-control', {
                          interaction: 'unlock',
                          location: x.id,
                        })
                      }
                      icon="door-open">
                      Unlock {name}
                    </Button>
                  )}
                </>
              </Stack.Item>
            );
          })}
      </Stack>
    </Section>
  );
};

export const DropshipDestinationSelection = (_, context) => {
  const { data, act } = useBackend<DropshipNavigationProps>(context);
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    context,
    'target_site',
    undefined
  );
  return (
    <Section
      title="Ferry Controls"
      buttons={
        <>
          <CancelLaunchButton />
          <LaunchButton />
        </>
      }>
      <Stack vertical className="DestinationSelector">
        <DestinationSelector
          options={data.destinations}
          selected={siteselection}
          onClick={(value) => {
            setSiteSelection(value);
            act('button-push');
          }}
        />
      </Stack>
    </Section>
  );
};

interface DestinationProps {
  options: DockingPort[];
  onClick: (value: string) => void;
  selected?: string;
  applyFilter?: boolean;
  availableOnly?: boolean;
}

const DestinationSelector = (props: DestinationProps, context) => {
  const { data } = useBackend<DropshipNavigationProps>(context);
  return (
    <>
      {props.options
        .filter((x) => (props.applyFilter === false ? true : x.available === 1))
        .map((x) => (
          <Stack.Item key={x.id}>
            <Flex align="center">
              {props.selected === x.id && (
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
                  disabled={
                    props.availableOnly === false ? false : x.available === 0
                  }
                  icon={x.id === data.primary_lz ? 'home' : undefined}
                  iconPosition="right"
                  onClick={() => props.onClick(x.id)}>
                  {x.name}
                </Button>
              </Flex.Item>
            </Flex>
          </Stack.Item>
        ))}
    </>
  );
};

const FlybyControl = (props, context) => {
  const { act, data } = useBackend<DropshipNavigationProps>(context);
  return (
    <Section
      title="Flight Controls"
      className="flybyControl"
      buttons={
        <>
          {data.flight_configuration === 'flyby' && (
            <Button icon="road" onClick={() => act('set-ferry')}>
              Set ferry
            </Button>
          )}
          {data.has_flyby_skill === 1 && data.flight_configuration === 'ferry' && (
            <Button icon="jet-fighter" onClick={() => act('set-flyby')}>
              Set flyby
            </Button>
          )}
          {data.has_flyby_skill === 1 && data.shuttle_mode === 'called' && (
            <Button onClick={() => act('cancel-flyby')}>cancel flyby</Button>
          )}
          {data.has_flyby_skill === 1 && data.shuttle_mode === 'idle' && (
            <Button
              icon="rocket"
              disabled={data.flight_configuration === 'ferry'}
              onClick={() => act('move')}>
              Launch
            </Button>
          )}
        </>
      }
    />
  );
};

export const TouchdownCooldown = (_, context) => {
  const { data } = useBackend<NavigationProps>(context);
  return (
    <Section title={`Final Approach: ${data.target_destination}`}>
      <div className="InFlightCountdown">
        <Stack vertical>
          <Stack.Item>
            <span>
              Time until landing: <u>T-{data.flight_time}s</u>.
            </span>
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              maxValue={data.max_pre_arrival_duration}
              value={data.flight_time}>
              T-{data.flight_time}s
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </div>
    </Section>
  );
};

const AutopilotConfig = (props, context) => {
  const { data, act } = useBackend<DropshipNavigationProps>(context);
  const [automatedHangar, setAutomatedHangar] = useSharedState<
    string | undefined
  >(context, 'autopilot_hangar', undefined);
  const [automatedLZ, setAutomatedLZ] = useSharedState<string | undefined>(
    context,
    'autopilot_groundside',
    undefined
  );
  return (
    <Section
      title="Autopilot Control"
      buttons={
        <>
          {data.automated_control.is_automated === 0 && (
            <Button
              onClick={() =>
                act('set-automate', {
                  hangar_id: automatedHangar,
                  ground_id: automatedLZ,
                  delay: 30,
                })
              }>
              Enable
            </Button>
          )}
          {data.automated_control.is_automated === 1 && (
            <Button onClick={() => act('disable-automate')}>Disable</Button>
          )}
        </>
      }>
      <Stack vertical className="DestinationSelector">
        <Stack.Item>From</Stack.Item>
        <DestinationSelector
          options={data.destinations.filter((x) =>
            data.automated_control.is_automated
              ? x.id === data.automated_control.hangar_lz
              : true
          )}
          selected={automatedHangar}
          applyFilter={false}
          availableOnly={false}
          onClick={(value) => {
            setAutomatedHangar(value);
            act('button-push');
          }}
        />
        <Stack.Item>
          <hr />
        </Stack.Item>
        <Stack.Item>To</Stack.Item>
        <DestinationSelector
          options={data.destinations.filter((x) =>
            data.automated_control.is_automated
              ? x.id === data.automated_control.ground_lz
              : true
          )}
          selected={automatedLZ}
          applyFilter={false}
          availableOnly={false}
          onClick={(value) => {
            setAutomatedLZ(value);
            act('button-push');
          }}
        />
      </Stack>
    </Section>
  );
};

const RenderScreen = (props, context) => {
  const { data } = useBackend<DropshipNavigationProps>(context);
  return (
    <>
      {data.can_set_automated === 1 && <AutopilotConfig />}
      {data.can_fly_by === 1 &&
        (data.shuttle_mode === 'idle' || data.shuttle_mode === 'called') && (
          <FlybyControl />
        )}
      {data.shuttle_mode === 'idle' &&
        data.flight_configuration !== 'flyby' && (
          <DropshipDestinationSelection />
        )}
      {data.shuttle_mode === 'igniting' && <LaunchCountdown />}
      {data.shuttle_mode === 'pre-arrival' && <TouchdownCooldown />}
      {data.shuttle_mode === 'recharging' && <ShuttleRecharge />}
      {data.shuttle_mode === 'called' && data.target_destination && (
        <InFlightCountdown />
      )}
      {data.shuttle_mode === 'called' && !data.target_destination && (
        <DropshipDestinationSelection />
      )}
      {data.door_status.length > 0 && <DropshipDoorControl />}
    </>
  );
};

export const DropshipFlightControl = (props, context) => {
  const { data } = useBackend<DropshipNavigationProps>(context);
  return (
    <Window theme="crtgreen" height={500} width={700}>
      <Window.Content className="NavigationMenu">
        {data.is_disabled === 1 && <DisabledScreen />}
        {data.is_disabled === 0 && <RenderScreen />}
      </Window.Content>
    </Window>
  );
};
