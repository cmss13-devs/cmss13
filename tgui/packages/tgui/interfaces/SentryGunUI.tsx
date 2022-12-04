import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { Component } from 'inferno';

type SelectedState = [string, string];
type SelectionState = [string, string[]];

interface SentrySpec {
  selection_state: SelectedState[];
  selection_menu: SelectionState[];
  rounds: number;
  name: string;
  area: string;
  active: 0 | 1;
  index: number;
}

interface SentryData {
  sentry: SentrySpec[];
  sentry_static: SentrySpec[];
  screen_state: 0 | 1;
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

const TurretTitleSection = (props: { data: SentrySpec }, context) => {
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
  return (
    <Stack vertical>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <span>Rounds Remaining</span>
          </Stack.Item>
          <Stack.Item className="SentryBox">
            <span>{props.data.rounds}</span>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
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

const SentryGunDisplay = (props: { data: SentrySpec }, context) => {
  return (
    <Stack vertical>
      <Stack.Item className="SentryBox">
        <TurretTitleSection data={props.data} />
      </Stack.Item>
      <Stack.Item className="SentryBox">
        <SelectionMenu data={props.data} />
      </Stack.Item>
      <Stack.Item className="SentryBox">
        <TurretTitleSection data={props.data} />
      </Stack.Item>
      <Stack.Item className="SentryBox">
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
        <Tabs>
          {sentrykeys.map((x) => (
            <Tabs.Tab
              key={x}
              selected={selectedSentry === x}
              onClick={() => setSelectedSentry(x)}>
              {x}
            </Tabs.Tab>
          ))}
        </Tabs>

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
        {!validSelection && <EmptyDisplay />}
        {validSelection && (
          <SentryGunDisplay data={sentrySpecs[selectedSentry ?? 0]} />
        )}
      </Window.Content>
    </Window>
  );
};
