import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, ByondUi, Button, Flex, Icon, Input, ProgressBar, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { Component } from 'inferno';

type SelectedState = [string, string];
type SelectionState = [string, string[]];

interface ElectricalSpec {
  charge: number;
  max_charge: number;
}

interface SentrySpec {
  selection_state: SelectedState[];
  selection_menu: SelectionState[];
  rounds: number;
  name: string;
  area: string;
  active: 0 | 1;
  index: number;
  engaged: number;
  nickname: string;
}

interface SentryData {
  sentry: SentrySpec[];
  sentry_static: SentrySpec[];
  screen_state: 0 | 1;
  electrical: ElectricalSpec;
  mapRef: string;
  camera_target?: string;
}

const SelectionGroup = (
  props: { data: SelectionState; sentry_index: number; selected?: string },
  context
) => {
  const { act } = useBackend<SentryData>(context);
  const comparisonstr = props.selected ?? '';
  return (
    <Flex direction="column" className="SelectionMenu" fill>
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
              className={classes([isSelected && 'Selected'])}>
              {x}
            </Button>
          </Flex.Item>
        );
      })}
    </Flex>
  );
};

const SelectionMenu = (props: { data: SentrySpec }, context) => {
  const getSelected = (category: string) => {
    const output = props.data.selection_state.find((x) => x[0] === category);
    return output === undefined ? undefined : output[1];
  };
  return (
    <Flex wrap justify="center" fill>
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

const getSanitisedName = (name: string) => name.substring(0, name.length - 11);
const sanitiseArea = (name: string) =>
  name.substring(name.includes('the') ? 4 : 0).trim();

const ConfigurationTitleSection = (props: { data: SentrySpec }, context) => {
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

const StatusTitleSection = (props: { data: SentrySpec }, context) => {
  const getSanitisedName = (name: string) =>
    name.substring(0, name.length - 11);
  const sanitiseArea = (name: string) =>
    name.substring(name.includes('the') ? 4 : 0).trim();
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

const GunMenu = (props: { data: SentrySpec }, context) => {
  const { act } = useBackend<SentryData>(context);
  const isEngaged = props.data.engaged > 1;
  return (
    <Flex direction="column">
      <Flex.Item>
        <Box className="EngagedBox">
          <Stack>
            <Stack.Item align="center">
              <span>Rounds Remaining</span>
            </Stack.Item>
            <Stack.Item align="center">
              <Icon name="play" />
            </Stack.Item>
            <Stack.Item align="center" className="AmmoBoundingBox">
              <span>{props.data.rounds}</span>
            </Stack.Item>
          </Stack>
        </Box>
      </Flex.Item>
      <Flex.Item>
        <Box className="EngagedBox">
          {props.data.active === 0 && <span>Offline</span>}
          {props.data.active === 1 && <span>Online</span>}
        </Box>
      </Flex.Item>
      <Flex.Item>
        <Box
          height="3rem"
          className={classes(['EngagedBox', isEngaged && 'EngagedWarningBox'])}>
          {!isEngaged && <span>Not Engaged</span>}
          {isEngaged && <span>ENGAGED</span>}
        </Box>
      </Flex.Item>
      <Flex.Item>
        <Stack>
          <Stack.Item>
            <Button
              icon="video"
              onClick={() => act('set-camera', { index: props.data.index })}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="bullhorn"
              onClick={() => act('ping', { index: props.data.index })}
            />
          </Stack.Item>
        </Stack>
      </Flex.Item>
    </Flex>
  );
};

const EmptyDisplay = (_, context) => {
  return (
    <Box className="EmptyDisplay">
      <Stack vertical>
        <Stack.Item>
          <span>No sentry detected</span>
        </Stack.Item>
        <Stack.Item>
          <span>Connect the computer to a sentry gun to continue.</span>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const InputGroup = (
  props: {
    index: number;
    label: string;
    category: string;
    startingValue: string;
  },
  context
) => {
  const { data, act } = useBackend<SentryData>(context);
  const [categoryValue, setCategoryValue] = useLocalState(
    context,
    `${props.index} ${props.category}`,
    props.startingValue
  );
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
          }>
          Commit
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const SentryGunConfiguration = (props: { data: SentrySpec }, context) => {
  const { data, act } = useBackend<SentryData>(context);
  const [showConfig, setShowConfig] = useLocalState(context, 'showConf', true);
  return (
    <Stack vertical>
      <Stack.Item className="TitleBox">
        <Flex justify="space-between" align-items="center">
          <Flex.Item>
            <Box width={7} />
          </Flex.Item>
          <Flex.Item>
            <ConfigurationTitleSection data={props.data} />
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

const SentryGunStatus = (props: { data: SentrySpec }, context) => {
  const [showConfig, setShowConfig] = useLocalState(context, 'showConf', true);
  return (
    <Stack vertical>
      <Stack.Item className="TitleBox">
        <Flex justify="space-between" align-items="center">
          <Flex.Item>
            <Box width={13} />
          </Flex.Item>
          <Flex.Item>
            <StatusTitleSection data={props.data} />
          </Flex.Item>
          <Flex.Item align="center">
            <Button onClick={() => setShowConfig(true)}>Configuration</Button>
          </Flex.Item>
        </Flex>
      </Stack.Item>
      <Stack.Item className="TitleBox">
        <GunMenu data={props.data} />
      </Stack.Item>
    </Stack>
  );
};

interface TimedCallbackProps {
  time: number;
  callback: () => void;
}

interface TimedCallbackState {
  timeout?: NodeJS.Timeout;
}

class CallbackHandler extends Component<
  TimedCallbackProps,
  TimedCallbackState
> {
  timeout?: NodeJS.Timeout;
  constructor(props: TimedCallbackProps) {
    super(props);
  }

  componentDidMount() {
    this.timeout = setTimeout(() => this.props.callback(), this.props.time);
  }

  componentWillUnmount() {
    if (this.state?.timeout) {
      clearTimeout(this.state.timeout);
    }
  }
  render() {
    return <div />;
  }
}

const ShowSingleSentry = (props: { data: SentrySpec }, context) => {
  const [showConfig, setShowConfig] = useLocalState(context, 'showConf', true);
  return (
    <>
      {showConfig && <SentryGunConfiguration data={props.data} />}
      {!showConfig && <SentryGunStatus data={props.data} />}
    </>
  );
};

const ShowSentryCard = (props: { data: SentrySpec }, context) => {
  const displayName =
    props.data.nickname.length === 0 ? props.data.index : props.data.nickname;
  return (
    <Stack vertical className={classes(['SentryCard', 'SentryBox'])}>
      <Stack.Item align="center">
        <span>
          {displayName}: {sanitiseArea(props.data.area)}
        </span>
      </Stack.Item>
      <Stack.Item align="center">
        <GunMenu data={props.data} />
      </Stack.Item>
    </Stack>
  );
};

const ShowAllSentry = (props: { data: SentrySpec[] }, context) => {
  return (
    <Flex>
      {props.data.map((x) => (
        <Flex.Item key={x.index}>
          <ShowSentryCard data={x} />
        </Flex.Item>
      ))}
    </Flex>
  );
};

const SentryCamera = (_, context) => {
  const { data, act } = useBackend<SentryData>(context);
  return (
    <Stack vertical>
      <Stack.Item>
        <Flex>
          <Flex.Item>Name: Area</Flex.Item>
          <Flex.Item>
            <Button onClick={() => act('clear-camera', {})}>Close</Button>
          </Flex.Item>
        </Flex>
      </Stack.Item>
      <Stack.Item>
        <ByondUi
          className="CameraConsole__map"
          params={{
            id: data.mapRef,
            type: 'map',
          }}
        />
      </Stack.Item>
    </Stack>
  );
};

const SentryTabMenu = (
  props: {
    sentrySpecs: SentrySpec[];
    selected?: number;
    setSelected: (d) => void;
  },
  context
) => {
  return (
    <Tabs>
      {props.sentrySpecs.map((x, index) => (
        <Tabs.Tab
          key={x.index}
          selected={props.selected === index}
          onClick={() => props.setSelected(index)}>
          {x.nickname.length === 0 ? x.index : x.nickname}
        </Tabs.Tab>
      ))}
      <Tabs.Tab
        selected={props.selected === undefined}
        onClick={() => props.setSelected(undefined)}>
        All
      </Tabs.Tab>
    </Tabs>
  );
};

const PowerLevel = (_, context) => {
  const { data } = useBackend<SentryData>(context);
  return (
    <ProgressBar
      minValue={0}
      maxValue={data.electrical.max_charge}
      value={data.electrical.charge}>
      {((data.electrical.charge / data.electrical.max_charge) * 100).toFixed(2)}{' '}
      %
    </ProgressBar>
  );
};

export const SentryGunUI = (_, context) => {
  const { data, act } = useBackend<SentryData>(context);
  const sentrykeys =
    data.sentry.length === 0
      ? []
      : Array.from(Array(data.sentry.length).keys());
  const sentrySpecs: SentrySpec[] = sentrykeys.map((x) => {
    return { ...data.sentry[x], ...data.sentry_static[x] };
  });

  const [selectedSentry, setSelectedSentry] = useLocalState<undefined | number>(
    context,
    'selected',
    sentrySpecs.length > 0 ? 0 : undefined
  );

  const validSelection =
    sentrySpecs.length === 0
      ? false
      : (selectedSentry ?? 0) < sentrySpecs.length;

  return (
    <Window theme="crtyellow">
      <Window.Content className="SentryGun">
        <Flex justify="space-between" align-items="center">
          <Flex.Item>
            <SentryTabMenu
              sentrySpecs={sentrySpecs}
              selected={selectedSentry}
              setSelected={setSelectedSentry}
            />
          </Flex.Item>
          <Flex.Item align="center">
            <PowerLevel />
          </Flex.Item>
        </Flex>

        {data.screen_state === 0 && (
          <div>
            <CallbackHandler
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
                  <ShowSingleSentry data={sentrySpecs[selectedSentry ?? 0]} />
                )}
                {selectedSentry === undefined && (
                  <ShowAllSentry data={sentrySpecs} />
                )}
              </>
            )}
          </>
        )}
        {data.camera_target !== null && <SentryCamera />}
      </Window.Content>
    </Window>
  );
};
