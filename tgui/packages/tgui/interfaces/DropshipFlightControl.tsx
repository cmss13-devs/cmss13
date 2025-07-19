import { useEffect, useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  Icon,
  ProgressBar,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import {
  CancelLaunchButton,
  DisabledScreen,
  type DockingPort,
  InFlightCountdown,
  LaunchButton,
  LaunchCountdown,
  type NavigationProps,
  ShuttleRecharge,
} from './NavigationShuttle';

const DoorStatusEnum = {
  SHUTTLE_DOOR_BROKEN: -1,
  SHUTTLE_DOOR_UNLOCKED: 0,
  SHUTTLE_DOOR_LOCKED: 1,
} as const;

type DoorStatusEnums = (typeof DoorStatusEnum)[keyof typeof DoorStatusEnum];

interface DoorStatus {
  id: string;
  value: DoorStatusEnums;
}

interface AutomatedControl {
  is_automated: 0 | 1;
  hangar_lz: null | string;
  ground_lz: null | string;
}

type ShuttleRef = {
  name: string;
  id: string;
};

interface DropshipNavigationProps extends NavigationProps {
  shuttle_id: string;
  door_status: Array<DoorStatus>;
  has_flight_optimisation?: 0 | 1;
  is_flight_optimised?: 0 | 1;
  can_fly_by?: 0 | 1;
  can_set_automated?: 0 | 1;
  primary_lz?: string;
  automated_control: AutomatedControl;
  has_flyby_skill: 0 | 1;
  playing_launch_announcement_alarm: boolean;
  can_change_shuttle: 0 | 1;
  alternative_shuttles: Array<ShuttleRef>;
  playing_airlock_alarm: 0 | 1;
  opened_inner_airlock: 0 | 1;
  lowered_dropship: 0 | 1;
  opened_outer_airlock: 0 | 1;
  disengaged_clamps: 0 | 1;
  processing: 0 | 1;
  is_airlocked: 0 | 1;
}

const DropshipDoorControl = () => {
  const { data, act } = useBackend<DropshipNavigationProps>();
  const in_flight =
    data.shuttle_mode === 'called' || data.shuttle_mode === 'pre-arrival';
  const disable_door_controls = in_flight;
  return (
    <Section
      m="0"
      mb="6px"
      title="Door Controls"
      buttons={data.door_status
        .filter((x) => x.id === 'all')
        .map((x) => (
          <>
            {x.value === DoorStatusEnum.SHUTTLE_DOOR_UNLOCKED && (
              <Button
                disabled={disable_door_controls}
                width="100%"
                onClick={() =>
                  act('door-control', {
                    interaction: 'force-lock',
                    location: 'all',
                  })
                }
                icon="triangle-exclamation"
              >
                Lockdown
              </Button>
            )}

            {x.value === DoorStatusEnum.SHUTTLE_DOOR_LOCKED && (
              <Button
                disabled={disable_door_controls}
                width="100%"
                onClick={() =>
                  act('door-control', {
                    interaction: 'unlock',
                    location: 'all',
                  })
                }
                icon="triangle-exclamation"
              >
                Lift Lockdown
              </Button>
            )}
          </>
        ))}
    >
      <Stack justify="space-between" className="DoorControlStack">
        {data.door_status
          .filter((x) => x.id !== 'all')
          .map((x) => {
            const name = x.id.substr(0, 1).toLocaleUpperCase() + x.id.substr(1);
            return (
              <Stack.Item key={x.id} grow>
                <>
                  {x.value === DoorStatusEnum.SHUTTLE_DOOR_BROKEN && (
                    <Button disabled icon="ban" width="100%" textAlign="center">
                      No response
                    </Button>
                  )}
                  {x.value === DoorStatusEnum.SHUTTLE_DOOR_UNLOCKED && (
                    <Button
                      disabled={disable_door_controls}
                      width="100%"
                      textAlign="center"
                      onClick={() =>
                        act('door-control', {
                          interaction: 'force-lock',
                          location: x.id,
                        })
                      }
                      icon="door-closed"
                    >
                      Lock {name}
                    </Button>
                  )}
                  {x.value === DoorStatusEnum.SHUTTLE_DOOR_LOCKED && (
                    <Button
                      disabled={disable_door_controls}
                      width="100%"
                      textAlign="center"
                      onClick={() =>
                        act('door-control', {
                          interaction: 'unlock',
                          location: x.id,
                        })
                      }
                      icon="door-open"
                    >
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

const EnableCautionAlarm = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="triangle-exclamation"
      onClick={() => {
        act('airlock_alarm');
        act('button-push');
      }}
    >
      Enable Airlock Caution Alarm
    </Button>
  );
};

const DisableCautionAlarm = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="ban"
      onClick={() => {
        act('airlock_alarm');
        act('button-push');
      }}
    >
      Disable Airlock Caution Alarm
    </Button>
  );
};

const OpenInnerAirlock = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="door-open"
      onClick={() => {
        act('inner_airlock');
        act('button-push');
      }}
    >
      Open Inner Airlock
    </Button>
  );
};

const CloseInnerAirlock = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="door-closed"
      onClick={() => {
        act('inner_airlock');
        act('button-push');
      }}
    >
      Close Inner Airlock
    </Button>
  );
};

const RaiseDropship = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="arrow-up"
      onClick={() => {
        act('airlock_dropship');
        act('button-push');
      }}
    >
      Raise Dropship
    </Button>
  );
};

const LowerDropship = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="arrow-down"
      onClick={() => {
        act('airlock_dropship');
        act('button-push');
      }}
    >
      Lower Dropship
    </Button>
  );
};

const OpenOuterAirlock = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="door-open"
      onClick={() => {
        act('outer_airlock');
        act('button-push');
      }}
    >
      Open Outer Airlock
    </Button>
  );
};

const CloseOuterAirlock = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="door-closed"
      onClick={() => {
        act('outer_airlock');
        act('button-push');
      }}
    >
      Close Outer Airlock
    </Button>
  );
};

const DisengageClamps = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="rocket"
      onClick={() => {
        act('clamps');
        act('button-push');
      }}
    >
      Disengage Clamps
    </Button>
  );
};

const EngageClamps = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="rocket"
      onClick={() => {
        act('clamps');
        act('button-push');
      }}
    >
      Engage Clamps
    </Button>
  );
};

const Processing = () => {
  return <Button icon="ban">Processing...</Button>;
};

const DropshipAirlockSelect = () => {
  const { data } = useBackend<DropshipNavigationProps>();
  return (
    <Section title="Dropship Airlock Control">
      <Stack vertical className="DestinationSelector">
        <Stack.Item>
          {data.processing ? (
            <Processing />
          ) : !data.playing_airlock_alarm ? (
            <EnableCautionAlarm />
          ) : (
            <DisableCautionAlarm />
          )}
        </Stack.Item>
        <Stack.Item>
          {data.processing ? (
            <Processing />
          ) : !data.opened_inner_airlock ? (
            <OpenInnerAirlock />
          ) : (
            <CloseInnerAirlock />
          )}
        </Stack.Item>
        <Stack.Item>
          {data.processing ? (
            <Processing />
          ) : !data.lowered_dropship ? (
            <LowerDropship />
          ) : (
            <RaiseDropship />
          )}
        </Stack.Item>
        <Stack.Item>
          {data.processing ? (
            <Processing />
          ) : !data.opened_outer_airlock ? (
            <OpenOuterAirlock />
          ) : (
            <CloseOuterAirlock />
          )}
        </Stack.Item>
        <Stack.Item>
          {data.processing ? (
            <Processing />
          ) : !data.disengaged_clamps ? (
            <DisengageClamps />
          ) : (
            <EngageClamps />
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const DropshipDestinationSelection = () => {
  const { data, act } = useBackend<DropshipNavigationProps>();
  const [siteselection, setSiteSelection] = useSharedState<string | undefined>(
    'target_site',
    undefined,
  );
  return (
    <Section m="0" mb="6px" title="Flight Controls">
      <Stack justify="space-evenly">
        <Stack.Item align="center">
          <CancelLaunchButton />
        </Stack.Item>
        <Stack.Item>
          <Divider vertical />
        </Stack.Item>
        <Stack.Item align="center">
          <LaunchButton />
        </Stack.Item>
      </Stack>
      <Divider />
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
  readonly options: DockingPort[];
  readonly onClick: (value: string) => void;
  readonly selected?: string;
  readonly applyFilter?: boolean;
  readonly availableOnly?: boolean;
}

const DestinationSelector = (props: DestinationProps) => {
  const { data } = useBackend<DropshipNavigationProps>();
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
                  onClick={() => props.onClick(x.id)}
                >
                  {x.name}
                </Button>
              </Flex.Item>
            </Flex>
          </Stack.Item>
        ))}
    </>
  );
};

export const TouchdownCooldown = () => {
  const { data } = useBackend<NavigationProps>();
  return (
    <Section
      m="0"
      mb="6px"
      title={`Final Approach: ${data.target_destination}`}
    >
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

const AutopilotConfig = () => {
  const { data, act } = useBackend<DropshipNavigationProps>();
  const [automatedHangar, setAutomatedHangar] = useSharedState<
    string | undefined
  >('autopilot_hangar', undefined);
  const [automatedLZ, setAutomatedLZ] = useSharedState<string | undefined>(
    'autopilot_groundside',
    undefined,
  );
  return (
    <Section
      m="0"
      mb="6px"
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
              }
            >
              Enable
            </Button>
          )}
          {data.automated_control.is_automated === 1 && (
            <Button onClick={() => act('disable-automate')}>Disable</Button>
          )}
        </>
      }
    >
      <Stack vertical className="DestinationSelector">
        <Stack.Item>From</Stack.Item>
        <DestinationSelector
          options={data.destinations.filter((x) =>
            data.automated_control.is_automated
              ? x.id === data.automated_control.hangar_lz
              : true,
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
              : true,
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

const StopLaunchAnnouncementAlarm = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="ban"
      onClick={() => {
        act('stop_playing_launch_announcement_alarm');
        act('button-push');
      }}
    >
      Stop Alarm
    </Button>
  );
};

const PlayLaunchAnnouncementAlarm = () => {
  const { act } = useBackend<NavigationProps>();
  return (
    <Button
      icon="rocket"
      onClick={() => {
        act('play_launch_announcement_alarm');
        act('button-push');
      }}
    >
      Start Alarm
    </Button>
  );
};

const LaunchAnnouncementAlarm = () => {
  const { data } = useBackend<DropshipNavigationProps>();
  return (
    <Section
      m="0"
      fitted
      title="Launch Announcement Alarm"
      buttons={
        !data.playing_launch_announcement_alarm ? (
          <PlayLaunchAnnouncementAlarm />
        ) : (
          <StopLaunchAnnouncementAlarm />
        )
      }
    />
  );
};

const DropshipButton = (props: {
  readonly shipId: string;
  readonly shipName: string;
  readonly disable: boolean;
  readonly onClick: () => void;
}) => {
  const { act, data } = useBackend<DropshipNavigationProps>();
  const match = props.shipId === data.shuttle_id;

  return (
    <Button
      width="30%"
      textAlign="center"
      disabled={match || props.disable}
      onClick={() => {
        act('change_shuttle', { new_shuttle: props.shipId });
        act('button-push');
        props.onClick();
      }}
    >
      {match && '['}
      {props.shipName}
      {match && ']'}
    </Button>
  );
};

const DropshipSelector = () => {
  const { data } = useBackend<DropshipNavigationProps>();
  const [refreshTimeout, setRefreshTimeout] = useState<
    NodeJS.Timeout | undefined
  >(undefined);

  useEffect(() => {
    if (refreshTimeout) {
      return () => clearTimeout(refreshTimeout);
    }
    return () => {};
  }, [refreshTimeout]);

  return (
    <Section m="0" mb="6px" title="Select Dropship">
      <Stack justify="space-evenly">
        {data.alternative_shuttles
          .sort((a, b) => a.id.localeCompare(b.id))
          .map((x) => (
            <DropshipButton
              key={x.id}
              shipId={x.id}
              shipName={x.name}
              disable={refreshTimeout !== undefined}
              onClick={() => {
                const freeze = setTimeout(
                  () => setRefreshTimeout(undefined),
                  2000,
                );
                setRefreshTimeout(freeze);
              }}
            />
          ))}
      </Stack>
    </Section>
  );
};

const RenderScreen = () => {
  const { data } = useBackend<DropshipNavigationProps>();
  return (
    <Section fill scrollable>
      {data.is_airlocked === 1 && <DropshipAirlockSelect />}
      {data.alternative_shuttles.length > 0 && <DropshipSelector />}
      {data.shuttle_mode === 'idle' && <DropshipDestinationSelection />}
      {data.shuttle_mode === 'idle' && data.can_set_automated === 1 && (
        <AutopilotConfig />
      )}
      {data.shuttle_mode === 'igniting' && <LaunchCountdown />}
      {data.shuttle_mode === 'pre-arrival' && <TouchdownCooldown />}
      {data.shuttle_mode === 'recharging' && <ShuttleRecharge />}
      {data.shuttle_mode === 'recharging' && data.can_set_automated === 1 && (
        <AutopilotConfig />
      )}
      {data.shuttle_mode === 'called' && data.target_destination && (
        <InFlightCountdown />
      )}
      {data.shuttle_mode === 'called' && !data.target_destination && (
        <DropshipDestinationSelection />
      )}
      {data.door_status.length > 0 && <DropshipDoorControl />}
      {data.alternative_shuttles.length === 0 && <LaunchAnnouncementAlarm />}
    </Section>
  );
};

const DropshipDisabledScreen = () => {
  const { data } = useBackend<DropshipNavigationProps>();
  return (
    <>
      {data.alternative_shuttles.length > 0 && <DropshipSelector />}
      <DisabledScreen />
    </>
  );
};

export const DropshipFlightControl = () => {
  const { data } = useBackend<DropshipNavigationProps>();
  return (
    <Window theme="crtgreen" height={550} width={700}>
      <Window.Content className="NavigationMenu">
        {data.is_disabled === 0 ? <RenderScreen /> : <DropshipDisabledScreen />}
      </Window.Content>
    </Window>
  );
};
