import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Button, Flex, Stack } from '../components';
import { Window } from '../layouts';

type SelectedState = [string, string];
type SelectionState = [string, string[]];

interface SentryData {
  sentry_name: string;
  selection_state: SelectedState[];
  selection_menu: SelectionState[];
  rounds: number;
}

const SelectionGroup = (
  props: { data: SelectionState; selected?: string },
  context
) => {
  const { act } = useBackend<SentryData>(context);
  const comparisonstr = props.selected ?? '';
  return (
    <Flex direction="column" className="SelectionMenu">
      <Flex.Item className="Title">
        <span>{props.data[0]}</span>
      </Flex.Item>
      {props.data[1].map((x) => {
        const isSelected = comparisonstr.localeCompare(x) === 0;
        return (
          <Flex.Item key={x}>
            <Button
              onClick={() => act(props.data[0], { action: x })}
              className={classes([isSelected && 'Selected'])}>
              {x}
            </Button>
          </Flex.Item>
        );
      })}
    </Flex>
  );
};

const SelectionMenu = (_, context) => {
  const { data, act } = useBackend<SentryData>(context);
  const getSelected = (category: string) => {
    const output = data.selection_state.find((x) => x[0] === category);
    return output === undefined ? undefined : output[1];
  };
  return (
    <Flex wrap justify="center">
      {data.selection_menu.map((x) => (
        <Flex.Item key={x[0]} className="SelectionFlexItem" flex-grow={1}>
          <SelectionGroup data={x} selected={getSelected(x[0])} />
        </Flex.Item>
      ))}
    </Flex>
  );
};

const TurretTitleSection = (_, context) => {
  return (
    <Stack vertical>
      <Stack.Item className="TitleText">
        <span>UA 571-C</span>
      </Stack.Item>
      <Stack.Item className="TitleText">
        <span>REMOTE SENTRY WEAPON SYSTEM</span>
      </Stack.Item>
    </Stack>
  );
};

const GunMenu = (_, context) => {
  const { data, act } = useBackend<SentryData>(context);
  return (
    <Stack vertical>
      <Stack.Item>
        <Stack>
          <Stack.Item>Rounds Remaining</Stack.Item>
          <Stack.Item className="SentryBox">{data.rounds}</Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const SentryGunUI = (_, context) => {
  const { data, act } = useBackend<SentryData>(context);

  return (
    <Window theme="crtyellow">
      <Window.Content className="SentryGun">
        <Stack vertical>
          <Stack.Item className="SentryBox">
            <TurretTitleSection />
          </Stack.Item>
          <Stack.Item className="SentryBox">
            <SelectionMenu />
          </Stack.Item>
          <Stack.Item className="SentryBox">
            <TurretTitleSection />
          </Stack.Item>
          <Stack.Item className="SentryBox">
            <GunMenu />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
