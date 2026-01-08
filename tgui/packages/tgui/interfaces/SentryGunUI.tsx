import { classes } from 'common/react';
import { useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  ByondUi,
  Flex,
  Icon,
  Input,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import { TimedCallback } from './common/TimedCallback';

type SelectedState = [string, string];
type SelectionState = [string, string[]];

interface ElectricalSpec {
  charge: number;
  max_charge: number;
}

interface SentrySpec {
  selection_state: SelectedState[];
  selection_menu: SelectionState[];
  rounds?: number;
  max_rounds?: number;
  name: string;
  area: string;
  active: 0 | 1;
  index: number;
  engaged?: number;
  nickname: string;
  health: number;
  health_max: number;
  kills: number;
  iff_status: string[];
  camera_available: number;
}

interface SentryData {
  sentry: SentrySpec[];
  sentry_static: SentrySpec[];
  screen_state: 0 | 1;
  electrical: ElectricalSpec;
  mapRef: string;
  camera_target?: string;
}

const SelectionGroup = (props: {
  readonly data: SelectionState;
  readonly sentry_index: number;
  readonly selected?: string;
}) => {
  const { act } = useBackend<SentryData>();
  const comparisonstr = props.selected ?? '';
  return (
    <Flex direction="column" className="SelectionMenu" fill={1}>
      <Flex.Item className="Title">
        <span>{props.data[0]}</span>
      </Flex.Item>
      {props.data[1].map((x) => {
        const isSelected = comparisonstr.localeCompare(x) === 0;
        return (
          <Flex.Item key={x} className="Option">
            <Button
              onClick={() =>
                act(props.data[0], { selection: x, index: props.sentry_index })
              }
              className={classes([isSelected && 'Selected'])}
            >
              {x}
            </Button>
          </Flex.Item>
        );
      })}
    </Flex>
  );
};

const SelectionMenu = (props: { readonly data: SentrySpec }) => {
  const getSelected = (category: string) => {
    const output = props.data.selection_state.find((x) => x[0] === category);
    return output === undefined ? undefined : output[1];
  };
  return (
    <Flex wrap justify="center" fill={1}>
      {props.data.selection_menu.map((x) => (
        <Flex.Item key={x[0]} className="SelectionFlexItem">
          <SelectionGroup
            sentry_index={props.data.index}
            data={x}
            selected={getSelected(x[0])}
          />
        </Flex.Item>
      ))}
    </Flex>
  );
};

const getSanitisedName = (name: string) =>
  name.split(' ').slice(0, 2).join(' ');
const sanitiseArea = (name: string) =>
  name.substring(name.includes('the') ? 4 : 0).trim();

const TitleSection = (props: { readonly data: SentrySpec }) => {
  return (
    <Stack vertical className="TitleContainer">
      <Stack.Item className="TitleText">
        <span>
          {getSanitisedName(props.data.name)}: {sanitiseArea(props.data.area)}
        </span>
      </Stack.Item>
      <Stack.Item className="TitleText">
        <Stack>
          <Stack.Item>
            <span>{props.data.active === 0 ? 'INACTIVE' : 'ACTIVE'}</span>
          </Stack.Item>
          <Stack.Item>
            <span>REMOTE SENTRY WEAPON SYSTEM</span>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const GunMenu = (props: { readonly data: SentrySpec }) => {
  const { data, act } = useBackend<SentryData>();
  const isEngaged = props.data.engaged !== undefined && props.data.engaged > 1;
  const iff_info = props.data.selection_state.find(
    (x) => x[0].localeCompare('IFF STATUS') === 0,
  )?.[1];

  const [_, setSelectedSentry] = useSharedState<undefined | number>(
    'selected',
    0,
  );

  const isCritical = props.data.health < props.data.health_max * 0.2;
  const round_rep =
    props.data.rounds !== undefined ? props.data.rounds.toFixed(0) : undefined;
  return (
    <Flex
      direction="column"
      className="GunFlex"
      align="stretch"
      justify="center"
    >
      <Flex.Item>
        <Box className="EngagedBox">
          <Flex justify="space-between">
            <Flex.Item>
              <Button
                disabled={props.data.camera_available === 0}
                icon="video"
                onClick={() => {
                  act('set-camera', { index: props.data.index });
                  data.camera_target = `${props.data.index - 1}`;
                  setSelectedSentry(props.data.index - 1);
                }}
              />
            </Flex.Item>
            <Flex.Item>
              {props.data.active === 0 && <span>Offline</span>}
              {props.data.active === 1 && <span>Online</span>}
            </Flex.Item>
            <Flex.Item>
              <Button
                icon="bullhorn"
                onClick={() => act('ping', { index: props.data.index })}
              />
            </Flex.Item>
          </Flex>
        </Box>
      </Flex.Item>
      <Flex.Item>
        <Box
          className={classes(['EngagedBox', isCritical && 'EngagedWarningBox'])}
        >
          <span>
            Integrity: {props.data.health} / {props.data.health_max}
          </span>
        </Box>
      </Flex.Item>
      {props.data.rounds !== undefined &&
        props.data.max_rounds !== undefined && (
          <Flex.Item>
            <Box className="EngagedBox">
              <Flex justify="center">
                <Flex.Item align="center">
                  <span>Rounds Remaining</span>
                </Flex.Item>
                <Flex.Item>
                  <Box width={1} />
                </Flex.Item>
                <Flex.Item align="center">
                  <Icon name="play" />
                </Flex.Item>
                <Flex.Item
                  align="center"
                  className={classes([
                    'AmmoBoundingBox',
                    props.data.max_rounds * 0.2 > props.data.rounds &&
                      'AmmoBoundingBoxWarning',
                  ])}
                >
                  {round_rep && (
                    <span>
                      {round_rep.length < 3 && '0'}
                      {round_rep.length < 2 && '0'}
                      {round_rep}
                    </span>
                  )}
                </Flex.Item>
              </Flex>
            </Box>
          </Flex.Item>
        )}
      {props.data.engaged !== undefined && (
        <Flex.Item>
          <Box
            height="3rem"
            className={classes([
              'EngagedBox',
              isEngaged && 'EngagedWarningBox',
            ])}
          >
            {!isEngaged && <span>Not Engaged</span>}
            {isEngaged && <span>ENGAGED</span>}
          </Box>
        </Flex.Item>
      )}
      {props.data.engaged !== undefined && (
        <Flex.Item>
          <Box className="EngagedBox">
            <span>Kills: {props.data.kills}</span>
          </Box>
        </Flex.Item>
      )}
      {iff_info && (
        <Flex.Item>
          <Box className="IFFBox">
            <span>IFF: {iff_info}</span>
          </Box>
        </Flex.Item>
      )}
    </Flex>
  );
};

const EmptyDisplay = () => {
  return (
    <Box className="EmptyDisplay">
      <Stack vertical>
        <Stack.Item>
          <span>No sentry detected.</span>
        </Stack.Item>
        <Stack.Item>
          <span>
            Connect the Security Access Tuner with the laptop to load the
            encryption keys. Then connect the Security Access Tuner to a sentry
            gun to continue.
          </span>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const InputGroup = (props: {
  readonly index: number;
  readonly label: string;
  readonly category: string;
  readonly startingValue: string;
}) => {
  const { act } = useBackend<SentryData>();
  const [categoryValue, setCategoryValue] = useState(props.startingValue);
  return (
    <Stack vertical className="SelectionMenu">
      <Stack.Item className="Title">
        <span>{props.label}</span>
      </Stack.Item>
      <Stack.Item>
        <Input
          value={categoryValue}
          onInput={(e, value) => setCategoryValue(value)}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          className="Selected"
          onClick={() =>
            act(props.category, {
              index: props.index,
              selection: categoryValue,
            })
          }
        >
          Commit
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const SentryGunConfiguration = (props: { readonly data: SentrySpec }) => {
  const [_, setShowConfig] = useSharedState('showConf', true);
  return (
    <Stack vertical>
      <Stack.Item className="TitleBox">
        <Flex justify="space-between" align-items="center">
          <Flex.Item>
            <Box width={7} />
          </Flex.Item>
          <Flex.Item>
            <TitleSection data={props.data} />
          </Flex.Item>
          <Flex.Item align="center">
            <Button onClick={() => setShowConfig(false)}>Status</Button>
          </Flex.Item>
        </Flex>
      </Stack.Item>
      <Stack.Item className="TitleBox">
        <SelectionMenu data={props.data} />
      </Stack.Item>
      <Stack.Item className="TitleBox">
        <Flex>
          <Flex.Item>
            <InputGroup
              index={props.data.index}
              label="Name"
              category="nickname"
              startingValue={props.data.nickname}
            />
          </Flex.Item>
        </Flex>
      </Stack.Item>
    </Stack>
  );
};

const SentryGunStatus = (props: { readonly data: SentrySpec }) => {
  const [_, setShowConfig] = useSharedState('showConf', true);
  return (
    <Stack vertical>
      <Stack.Item className="TitleBox">
        <Flex justify="space-between" align-items="center">
          <Flex.Item>
            <Box width={6} />
          </Flex.Item>
          <Flex.Item>
            <TitleSection data={props.data} />
          </Flex.Item>
          <Flex.Item align="center">
            <Button onClick={() => setShowConfig(true)}>Config</Button>
          </Flex.Item>
        </Flex>
      </Stack.Item>
      <Stack.Item>
        <GunMenu data={props.data} />
      </Stack.Item>
    </Stack>
  );
};

const ShowSingleSentry = (props: { readonly data: SentrySpec }) => {
  const [showConfig] = useSharedState('showConf', true);
  return (
    <>
      {showConfig && <SentryGunConfiguration data={props.data} />}
      {!showConfig && <SentryGunStatus data={props.data} />}
    </>
  );
};

const ShowSentryCard = (props: { readonly data: SentrySpec }) => {
  const displayName =
    props.data.nickname.length === 0 ? props.data.index : props.data.nickname;
  return (
    <Stack vertical className={classes(['SentryCard', 'SentryBox'])}>
      <Stack.Item align="center">
        <span className="Title">
          {displayName}: {sanitiseArea(props.data.area)}
        </span>
      </Stack.Item>
      <Stack.Item align="center">
        <GunMenu data={props.data} />
      </Stack.Item>
    </Stack>
  );
};

const ShowAllSentry = (props: { readonly data: SentrySpec[] }) => {
  return (
    <Flex align="space-around" wrap>
      {props.data.map((x) => (
        <Flex.Item key={x.index}>
          <ShowSentryCard data={x} />
        </Flex.Item>
      ))}
    </Flex>
  );
};

const SentryCamera = (props: { readonly sentry_data: SentrySpec[] }) => {
  const { data, act } = useBackend<SentryData>();
  const { sentry_data } = props;
  const sentry = sentry_data.find((x) => {
    const index = x.index?.toString(10) ?? '';
    const targetIndex = data.camera_target?.toString() ?? '';
    return targetIndex.localeCompare(index) === 0;
  });
  const sentry_name = sentry?.name ?? 'Unknown';
  const sentry_area = sentry?.area ?? 'Unknown';

  return (
    <Flex direction="column" align="stretch" className="SentryCameraStack">
      <Flex.Item>
        <Flex justify="space-between" className="TitleBox" align="center">
          <Flex.Item>
            <Box width={5} />
          </Flex.Item>
          <Flex.Item>
            <span>
              {getSanitisedName(sentry_name)}: {sanitiseArea(sentry_area)}
            </span>
          </Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('clear-camera')}>Close</Button>
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item>
        <Box height={1} />
      </Flex.Item>
      {sentry !== undefined && sentry.camera_available === 0 && (
        <>
          <Flex.Item>
            <span>No camera is available on {sentry.name}</span>
          </Flex.Item>
          <Flex.Item>
            <Box height={1} />
          </Flex.Item>
        </>
      )}
      <Flex.Item>
        <Flex justify="center">
          <Flex.Item>
            <ByondUi
              className="CameraBox"
              params={{
                id: data.mapRef,
                type: 'map',
              }}
            />
          </Flex.Item>
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

const SentryTabMenu = (props: {
  readonly sentrySpecs: SentrySpec[];
  readonly selected?: number;
  readonly setSelected: (d) => void;
}) => {
  const { data, act } = useBackend<SentryData>();
  return (
    <Tabs>
      <Tabs.Tab
        selected={props.selected === undefined}
        onClick={() => {
          props.setSelected(undefined);
          act('clear-camera');
        }}
      >
        All
      </Tabs.Tab>
      {props.sentrySpecs.map((x, index) => (
        <Tabs.Tab
          key={x.index}
          selected={props.selected === index}
          textAlign="center"
          minWidth="2%"
          onClick={() => {
            props.setSelected(index);
            if (data.camera_target) {
              act('set-camera', { index: x.index });
            } else {
              act('ui-interact');
            }
          }}
        >
          {x.nickname.length === 0 ? x.index : x.nickname}
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};

const PowerLevel = () => {
  const { data } = useBackend<SentryData>();
  return (
    <ProgressBar
      width="100px"
      minValue={0}
      maxValue={data.electrical.max_charge}
      value={data.electrical.charge}
    >
      {((data.electrical.charge / data.electrical.max_charge) * 100).toFixed(2)}{' '}
      <span>%</span>
    </ProgressBar>
  );
};

export const SentryGunUI = () => {
  const { data, act } = useBackend<SentryData>();
  const sentrykeys =
    data.sentry.length === 0
      ? []
      : Array.from(Array(data.sentry.length).keys());
  const sentrySpecs: Array<SentrySpec> = sentrykeys.map((x) => {
    return { ...data.sentry[x], ...data.sentry_static[x] };
  });

  const [selectedSentry, setSelectedSentry] = useSharedState<
    undefined | number
  >('selected', sentrySpecs.length > 0 ? 0 : undefined);

  const validSelection =
    sentrySpecs.length === 0
      ? false
      : (selectedSentry ?? 0) < sentrySpecs.length;

  return (
    <Window theme="crtyellow" height={700} width={700}>
      <Window.Content className="SentryGun">
        <Section fill scrollable>
          <Stack vertical>
            {data.sentry.length > 0 && (
              <Stack.Item>
                <Flex justify="space-between" align-items="center">
                  <Flex.Item width="85%">
                    <SentryTabMenu
                      sentrySpecs={sentrySpecs}
                      selected={selectedSentry}
                      setSelected={setSelectedSentry}
                    />
                  </Flex.Item>
                  <Flex.Item align="right">
                    <PowerLevel />
                  </Flex.Item>
                </Flex>
              </Stack.Item>
            )}
            <Stack.Item>
              {data.screen_state === 0 && (
                <div>
                  <TimedCallback
                    time={1.5}
                    callback={() => act('screen-state', { state: 1 })}
                  />
                  <div className="TopPanelSlide" />
                  <div className="BottomPanelSlide" />
                </div>
              )}
              {data.camera_target === null && (
                <>
                  {!validSelection && <EmptyDisplay />}
                  {validSelection && (
                    <>
                      {selectedSentry !== undefined && (
                        <ShowSingleSentry data={sentrySpecs[selectedSentry]} />
                      )}
                      {selectedSentry === undefined && (
                        <ShowAllSentry data={sentrySpecs} />
                      )}
                    </>
                  )}
                </>
              )}
              {data.camera_target !== null && (
                <SentryCamera sentry_data={sentrySpecs} />
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
