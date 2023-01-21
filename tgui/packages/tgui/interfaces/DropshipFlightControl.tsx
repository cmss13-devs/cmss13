import { useBackend, useSharedState } from '../backend';
import { Window } from '../layouts';
import { Button, Flex, Section, Stack } from '../components';
import { Box, LaunchButton, CancelLaunchButton, Icon, DisabledScreen, InFlightCountdown, LaunchCountdown, NavigationProps, ShuttleRecharge } from './NavigationShuttle';

interface DoorStatus {
  id: string;
  value: 0 | 1;
}

interface DropshipNavigationProps extends NavigationProps {
  door_status: Array<DoorStatus>;
  has_flight_optimisation?: 0 | 1;
  is_flight_optimised?: 0 | 1;
  flight_configuration: 'flyby' | 'ferry';
  can_fly_by?: 0 | 1;
}

const DropshipDoorControl = (_, context) => {
  const { data, act } = useBackend<DropshipNavigationProps>(context);
  const in_flight = data.shuttle_mode === 'called';
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
  const { data, act } = useBackend<NavigationProps>(context);
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

const FlybyControl = (props, context) => {
  const { act, data } = useBackend<DropshipNavigationProps>(context);
  return (
    <Section
      title="Flyby Controls"
      className="flybyControl"
      buttons={
        <>
          {data.flight_configuration === 'flyby' && (
            <Button icon="road" onClick={() => act('set-ferry')}>
              Set ferry
            </Button>
          )}
          {data.flight_configuration === 'ferry' && (
            <Button icon="jet-fighter" onClick={() => act('set-flyby')}>
              Set flyby
            </Button>
          )}
          {data.shuttle_mode === 'called' && (
            <Button onClick={() => act('cancel-flyby')}>cancel flyby</Button>
          )}
          {data.shuttle_mode === 'idle' && (
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

const RenderScreen = (props, context) => {
  const { data } = useBackend<DropshipNavigationProps>(context);
  return (
    <>
      {data.can_fly_by === 1 &&
        (data.shuttle_mode === 'idle' || data.shuttle_mode === 'called') && (
          <FlybyControl />
        )}
      {data.shuttle_mode === 'idle' &&
        data.flight_configuration !== 'flyby' && (
          <DropshipDestinationSelection />
        )}
      {data.shuttle_mode === 'igniting' && <LaunchCountdown />}
      {data.shuttle_mode === 'recharging' && <ShuttleRecharge />}
      {data.shuttle_mode === 'called' && <InFlightCountdown />}
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
