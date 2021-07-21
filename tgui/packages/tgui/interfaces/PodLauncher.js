import { toFixed } from 'common/math';
import { classes } from 'common/react';
import { storage } from 'common/storage';
import { multiline } from 'common/string';
import { createUuid } from 'common/uuid';
import { Component, Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import {
  Box, Button, ByondUi,
  Divider, Input, Knob,
  LabeledControls, NumberInput,
  Section, Flex, Slider,
} from '../components';
import { Window } from '../layouts';

const pod_grey = {
  color: 'grey',
};

export const PodLauncher = (props, context) => {
  return (
    <Window
      title="Supply Pod Menu"
      width={730}
      height={500}
      resizable>
      <PodLauncherContent />
    </Window>
  );
};

const PodLauncherContent = (props, context) => {
  return (
    <Window.Content>
      <Flex direction="column" height="100%">
        <Flex.Item shrink={0}>
          <PodStatusPage />
        </Flex.Item>
        <Flex.Item grow={1}>
          <Flex height="100%">
            <Flex.Item grow={1} shrink={0} basis="14.1em">
              <Flex height="100%" direction="column">
                <Flex.Item grow={1}>
                  <PresetsPage />
                </Flex.Item>
                <Flex.Item>
                  <ReverseMenu />
                </Flex.Item>
                <Flex.Item>
                  <Section>
                    <LaunchPage />
                  </Section>
                </Flex.Item>
              </Flex>
            </Flex.Item>
            <Flex.Item grow={3}>
              <ViewTabHolder />
            </Flex.Item>
            <Flex.Item basis="16em">
              <Flex height="100%" direction="column">
                <Flex.Item>
                  <Timing />
                </Flex.Item>
                <Flex.Item>
                  <Damage />
                </Flex.Item>
                <Flex.Item>
                  <Explosion />
                </Flex.Item>
                <Flex.Item grow={1}>
                  <Container />
                </Flex.Item>
              </Flex>
            </Flex.Item>
          </Flex>
        </Flex.Item>
      </Flex>
    </Window.Content>
  );
};

const TABPAGES = [
  {
    title: 'View Pod',
    component: () => TabPod,
  },
  {
    title: 'View Bay',
    component: () => TabBay,
  },
  {
    title: 'View Dropoff Location',
    component: () => TabDrop,
  },
];

const DELAYS = [
  {
    title: 'Pre',
    id: "drop_time",
    tooltip: 'Time until pod gets to station',
  },
  {
    title: 'Fall',
    id: "dropping_time",
    tooltip: 'Duration of pods\nfalling animation',
  },
  {
    title: 'Open',
    id: "open_time",
    tooltip: 'Time it takes pod to open after landing',
  },
  {
    title: 'Recall',
    id: "return_time",
    tooltip: 'Time for pod to\nleave after opening',
  },
];

const reverse_delays = [
  {
    title: 'Pre',
    id: "drop_time",
    tooltip: 'Time until pod gets to station',
  },
  {
    title: 'Fall',
    id: "dropping_time",
    tooltip: 'Duration of pods\nfalling animation',
  },
  {
    title: 'Open',
    id: "open_time",
    tooltip: 'Time it takes pod to open after landing',
  },
];

const EFFECTS_LOAD = [
  {
    title: 'Launch All Turfs',
    icon: 'globe',
    selected: data => {
      return data["launch_choice"] === data.glob_launch_options.LAUNCH_ALL;
    },
    onClick: context => {
      const { act, data } = useBackend(context);
      act("set_launch_option", { launch_option: "LAUNCH_ALL" });
    },
  },
  {
    title: 'Pick Random Turf',
    icon: 'dice',
    selected: data => {
      return data["launch_choice"] === data.glob_launch_options.LAUNCH_RANDOM;
    },
    onClick: context => {
      const { act, data } = useBackend(context);
      act("set_launch_option", { launch_option: "LAUNCH_RANDOM" });
    },
  },
  {
    divider: 1,
  },
  {
    title: 'Launch Whole Turf',
    icon: 'expand',
    selected: data => {
      return !data["launch_random_item"];
    },
    onClick: context => {
      const { act, data } = useBackend(context);
      act("launch_random_item", { should_do: false });
    },
  },
  {
    title: 'Pick Random Item',
    icon: 'dice',
    selected: data => {
      return data["launch_random_item"];
    },
    onClick: context => {
      const { act, data } = useBackend(context);
      act("launch_random_item", { should_do: true });
    },
  },
  {
    divider: 1,
  },
  {
    title: 'Clone',
    icon: 'clone',
    selected: data => data["launch_clone"],
    onClick: context => {
      const { act, data } = useBackend(context);
      act("launch_clone", { should_do: !data["launch_clone"] });
    },
  },
  {
    title: 'Recall',
    icon: 'redo',
    selected: data => data["should_recall"],
    onClick: context => {
      const { act, data } = useBackend(context);
      act("set_should_recall", { should_do: !data["should_recall"] });
    },
  },
];

const EFFECTS_NORMAL =[
  {
    title: 'Gib',
    icon: 'skull-crossbones',
    selected: data => {
      return data["gib_on_land"];
    },
    onClick: context => {
      const { act, data } = useBackend(context);
      act("set_gib_on_land", { should_do: !data["gib_on_land"] });
    },
  },
  {
    title: 'Stealthy',
    icon: 'eye-slash',
    selected: data => {
      return data["stealth"];
    },
    onClick: context => {
      const { act, data } = useBackend(context);
      act("set_stealth", { should_do: !data["stealth"] });
    },
  },
  {
    title: 'Can Be Opened',
    icon: 'lock-open',
    selected: data => {
      return data["can_be_opened"];
    },
    onClick: context => {
      const { act, data } = useBackend(context);
      act("set_can_be_opened", { should_do: !data["can_be_opened"] });
    },
  },
];

const EFFECTS_ALL = [
  {
    list: EFFECTS_LOAD,
    label: "Load From",
    alt_label: "Load",
    tooltipPosition: "right",
  },
  {
    list: EFFECTS_NORMAL,
    label: "General Effects",
    tooltipPosition: "bottom",
  },
];

const ViewTabHolder = (props, context) => {
  const { act, data } = useBackend(context);
  const [
    tabPageIndex,
    setTabPageIndex,
  ] = useLocalState(context, 'tabPageIndex', 1);
  const { glob_tab_indexes, custom_dropoff, map_ref } = data;
  const TabPageComponent = TABPAGES[tabPageIndex].component();
  return (
    <Section fill title="View" buttons={(
      <>
        {!!custom_dropoff && (
          <Button
            inline
            color="transparent"
            tooltip="View Dropoff Location"
            icon="arrow-circle-down"
            selected={glob_tab_indexes.TAB_DROPOFF === tabPageIndex}
            onClick={() => {
              setTabPageIndex(glob_tab_indexes.TAB_DROPOFF);
              act('set_tab_index', { tab_index: glob_tab_indexes.TAB_DROPOFF });
            }} />
        )}
        <Button
          inline
          color="transparent"
          tooltip="View Pod"
          tooltipPosition="top"
          icon="rocket"
          selected={glob_tab_indexes.TAB_POD === tabPageIndex}
          onClick={() => {
            setTabPageIndex(glob_tab_indexes.TAB_POD);
            act('set_tab_index', { tab_index: glob_tab_indexes.TAB_POD });
          }} />
        <Button
          inline
          color="transparent"
          tooltip="View Source Bay"
          tooltipPosition="top"
          icon="th"
          selected={glob_tab_indexes.TAB_BAY === tabPageIndex}
          onClick={() => {
            setTabPageIndex(glob_tab_indexes.TAB_BAY);
            act('set_tab_index', { tab_index: glob_tab_indexes.TAB_BAY });
          }} />
        <Button
          inline
          color="transparent"
          icon="sync-alt"
          tooltip="Refresh view window in case it breaks"
          tooltipPosition="top"
          onClick={() => {
            setTabPageIndex(tabPageIndex);
            act('refresh_view');
          }}

        />
        <Button
          icon="trash"
          color="transparent"
          tooltip={multiline`
            Clears everything
            from the bay`}
          tooltipOverrideLong
          tooltipPosition="top"
          onClick={() => act('clear_bay')}
        />
      </>
    )}>
      <Flex direction="column" height="100%">
        <Flex.Item>
          <TabPageComponent />
        </Flex.Item>
        <Flex.Item grow={1} mt={1}>
          <ByondUi
            height="100%"
            params={{
              zoom: 0,
              id: map_ref,
              type: 'map',
            }} />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const TabPod = (props, context) => {
  return (
    <Box color="label">
      Note: You can right click on this
      <br />
      blueprint pod and edit vars directly
    </Box>
  );
};

const TabBay = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <>
      <Button
        content="Teleport"
        icon="street-view"
        onClick={() => act('goto_bay')} />
      <Button
        content={data.old_area ? data.old_area.substring(0, 17) : 'Go Back'}
        disabled={!data.old_area}
        icon="undo-alt"
        onClick={() => act('goto_prev_turf')} />
    </>
  );
};

const TabDrop = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <>
      <Button
        content="Teleport"
        icon="street-view"
        onClick={() => act('goto_dropoff')} />
      <Button
        content={data.old_area ? data.old_area.substring(0, 17) : 'Go Back'}
        disabled={!data.old_area}
        icon="undo-alt"
        onClick={() => act('goto_prev_turf')} />
    </>
  );
};

const PodStatusPage = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section fill width="100%">
      <Flex>
        {EFFECTS_ALL.map((list, i) => (
          <Fragment key={i}>
            <Flex.Item ml={1}>
              <Box bold color="label" mb={1}>
                {list.label}:
              </Box>
              <Box>
                <Flex>
                  {list.list.map((effect, j) => (
                    <Flex.Item key={j}>
                      {effect.divider && (
                        <span style={pod_grey}><b>|</b></span>
                      )}
                      {!effect.divider &&(
                        <Button
                          tooltip={effect.title}
                          tooltipPosition={list.tooltipPosition}
                          tooltipOverrideLong
                          icon={effect.icon}
                          content={effect.content}
                          selected={effect.selected
                            ? effect.selected(data)
                            : false}
                          onClick={() => {
                            if (effect.onClick) {
                              effect.onClick(context);
                            }
                          }}
                          style={{
                            'vertical-align': 'middle',
                            'margin-left': (j !== 0 ? '1px' : '0px'),
                            'margin-right': (
                              j !== list.list.length-1 ? '1px' : '0px'
                            ),
                            'border-radius': '5px',
                          }} />
                      )}
                    </Flex.Item>
                  ))}
                </Flex>
              </Box>
            </Flex.Item>
          </Fragment>
        ))}
      </Flex>
    </Section>
  );
};

const ReverseMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const [
    tabPageIndex,
    setTabPageIndex,
  ] = useLocalState(context, 'tabPageIndex', 1);
  const { glob_tab_indexes, target_mode } = data;
  const {
    TARGET_MODE_DROPOFF,
    TARGET_MODE_NONE,
  } = data.glob_target_mode;
  return (
    <Section
      fill
      height="100%"
      title="Reverse"
    >
      <Flex fill direction="column">
        <Flex.Item maxHeight="20px">
          <Button
            content="Dropoff Turf"
            selected={target_mode === TARGET_MODE_DROPOFF}
            tooltip={multiline`
              Where the pods
              go after being recalled`}
            tooltipOverrideLong
            tooltipPosition="bottom-right"
            onClick={() => {
              if (data.target_mode === TARGET_MODE_DROPOFF) {
                act("set_target_mode", {
                  target_mode: TARGET_MODE_NONE,
                });
              } else {
                act('set_target_mode', {
                  target_mode: TARGET_MODE_DROPOFF,
                });
              }
            }} />
          <Button
            inline
            icon="trash"
            disabled={!data.custom_dropoff}
            tooltip={multiline`
              Clears the custom dropoff
              location.`}
            tooltipOverrideLong
            tooltipPosition="bottom"
            onClick={() => {
              act('clear_dropoff');
              if (tabPageIndex === glob_tab_indexes.TAB_DROPOFF) {
                setTabPageIndex(glob_tab_indexes.TAB_POD);
                act('set_tab_index', { tab_index: glob_tab_indexes.TAB_POD });
              }
            }} />
        </Flex.Item>
      </Flex>

    </Section>
  );
};

class PresetsPage extends Component {
  constructor() {
    super();
    this.state = {
      presets: [],
    };
  }

  async componentDidMount() {
    // This warning is generally considered OK to ignore in this context
    // eslint-disable-next-line react/no-did-mount-set-state
    this.setState({
      presets: await this.getPresets(),
    });
  }

  saveDataToPreset(id, data) {
    storage.set("cm_podlauncher_preset_" + id, data);
  }

  async loadDataFromPreset(id, context) {
    const { act } = useBackend(this.context);
    act("load_preset", {
      payload: await storage.get("cm_podlauncher_preset_" + id),
    });
  }

  newPreset(presetName, hue, data) {
    let { presets } = this.state;
    if (!presets) {
      presets = [];
      presets.push("hi!");
    }
    const id = createUuid();
    const thing = { id, title: presetName, hue };
    presets.push(thing);
    storage.set("cm_podlauncher_presetlist", presets);
    this.saveDataToPreset(id, data);
  }

  async getPresets() {
    let thing = await storage.get("cm_podlauncher_presetlist");
    if (thing === undefined) {
      thing = [];
    }
    return thing;
  }

  deletePreset(deleteID) {
    const { presets } = this.state;
    for (let i = 0; i < presets.length; i++) {
      if (presets[i].id === deleteID) {
        presets.splice(i, 1);
      }
    }
    storage.set("cm_podlauncher_presetlist", presets);
  }
  render() {
    const { presets } = this.state;
    const { act, data } = useBackend(this.context);
    const [
      presetIndex,
      setSelectedPreset,
    ] = useLocalState(this.context, 'presetIndex', 0);
    const [
      settingName,
      setEditingNameStatus,
    ] = useLocalState(this.context, 'settingName', 0);
    const [newNameText, setText] = useLocalState(this.context, 'newNameText', "");
    const [hue, setHue] = useLocalState(this.context, 'hue', 0);
    return (
      <Section scrollable
        fill
        title="Presets"
        buttons={(
          <>
            {settingName === 0 && (
              <Button
                color="transparent"
                icon="plus"
                tooltip="New Preset"
                onClick={() => setEditingNameStatus(1)} />
            )}
            <Button
              inline
              color="transparent"
              content=""
              icon="download"
              tooltip="Saves preset"
              tooltipOverrideLong
              tooltipPosition="bottom"
              onClick={() => this.saveDataToPreset(presetIndex, data)} />
            <Button
              inline
              color="transparent"
              content=""
              icon="upload"
              tooltip="Loads preset"
              onClick={() => {
                this.loadDataFromPreset(presetIndex);
              }} />
            <Button
              inline
              color="transparent"
              icon="trash"
              tooltip="Deletes the selected preset"
              tooltipPosition="bottom-left"
              onClick={() => this.deletePreset(presetIndex)} />
          </>
        )}>
        {settingName === 1 && (
          <>
            <Button
              inline
              icon="check"
              tooltip="Confirm"
              tooltipPosition="right"
              onClick={() => {
                this.newPreset(newNameText, hue, data);
                setEditingNameStatus(0);
              }} />
            <Button
              inline
              icon="window-close"
              tooltip="Cancel"
              onClick={() => {
                setText("");
                setEditingNameStatus(0);
              }} />
            <span color="label"> Hue: </span>
            <NumberInput
              inline
              animated
              width="40px"
              step={5}
              stepPixelSize={5}
              value={hue}
              minValue={0}
              maxValue={360}
              onChange={(e, value) => setHue(value)} />
            <Input
              inline
              autofocus
              placeholder="Preset Name"
              onChange={(e, value) => setText(value)} />
            <Divider horizontal />
          </>
        )}
        {(!presets || presets.length === 0) && (
          <span style={pod_grey}>
            Click [+] to define a new preset.
            They are persistent across rounds/servers!
          </span>
        )}
        {presets ? presets.map((preset, i) => (
          <Button
            key={i}
            width="100%"
            backgroundColor={`hsl(${preset.hue}, 50%, 50%)`}
            onClick={() => setSelectedPreset(preset.id)}
            content={preset.title}
            style={presetIndex === preset.id ? {
              'border-width': '1px',
              'border-style': 'solid',
              'border-color': `hsl(${preset.hue}, 80%, 80%)`,
            } : ''} />
        )) : ""}
      </Section>
    );
  }
}

const LaunchPage = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    TARGET_MODE_LAUNCH,
    TARGET_MODE_NONE,
  } = data.glob_target_mode;
  return (
    <Button
      fluid
      textAlign="center"
      tooltip={multiline`
        Launches the droppod`}
      tooltipOverrideLong
      selected={data.target_mode === TARGET_MODE_LAUNCH}
      tooltipPosition="top"
      content={(
        <Box
          bold
          fontSize="1.4em"
          lineHeight={3}>
          LAUNCH
        </Box>
      )}
      onClick={() => {
        if (data.target_mode === TARGET_MODE_LAUNCH) {
          act("set_target_mode", {
            target_mode: TARGET_MODE_NONE,
          });
        }
        else {
          act('set_target_mode', {
            target_mode: TARGET_MODE_LAUNCH,
          });
        }
      }}
    />
  );
};

const Timing = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section
      fill
      title="Time"
      buttons={(
        <Button
          icon="undo"
          color="transparent"
          tooltip={multiline`
          Reset all pod
          timings/delays`}
          tooltipOverrideLong
          tooltipPosition="top-left"
          onClick={() => {
            act('set_delays', {
              "drop_time": 0,
              "dropping_time": 35,
              "open_time": 30,
              "return_time": 300,
            });
            act('set_reverse_delays', {
              "drop_time": 0,
              "dropping_time": 35,
              "open_time": 30,
            });
          }} />
      )}>
      <DelayHelper
        delay_list={DELAYS}
        title="Normal Timers"
      />
      {!!data.should_recall && (
        <>
          <Divider horizontal />
          <DelayHelper
            delay_list={reverse_delays}
            reverse
            title="Dropoff Timers"
          />
        </>
      )}
    </Section>
  );
};

const DelayHelper = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    delay_list,
    reverse = false,
    title,
  } = props;
  return (
    <>
      <Box color="label" mb={1} width="100%" textAlign="center">
        {title}
      </Box>
      <LabeledControls wrap>
        {delay_list.map((delay, i) => (
          <LabeledControls.Item
            key={i}
            label={delay.title}>
            <Knob
              inline
              step={0.02}
              size={0.75}
              value={(reverse
                ? data.reverse_delays[delay.id]
                : data.delays[delay.id]) / 10}
              unclamped
              minValue={0}
              unit={"s"}
              format={value => toFixed(value, 2)}
              maxValue={30}
              color={((reverse
                ? data.reverse_delays[delay.id]
                : data.delays[delay.id]) / 10)
                > 10 ? "orange" : "default"}
              onDrag={(e, value) => {
                const delay_data = { [delay.id]: Math.max(value * 10, 0) };
                if (reverse) {
                  act('set_reverse_delays', delay_data);
                } else {
                  act('set_delays', delay_data);
                }
              }} />
          </LabeledControls.Item>
        ))}
      </LabeledControls>
    </>
  );
};

const Damage = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section
      fill
      title="Damage"
      buttons={(
        <Button
          icon="undo"
          color="transparent"
          tooltip="Reset damage"
          tooltipOverrideLong
          tooltipPosition="top-left"
          onClick={() => {
            act('set_damage', {
              "damage": 0,
            });
          }} />
      )}>
      <Slider
        value={data.land_damage}
        ranges={{
          bad: [300, Infinity],
          average: [100, 300],
          good: [-Infinity, 100],
        }}
        step={5}
        stepPixelSize={3}
        minValue={0}
        maxValue={500}
        onChange={(e, value) => act("set_damage", { damage: value })}
      />
    </Section>
  );
};

const Explosion = (props, context) => {
  const { act, data } = useBackend(context);
  const [enabled, setEnabled] = useLocalState(context, "explosion_enabled", false);
  return (
    <Section
      fill
      title="Explosion"
      buttons={(
        <Button
          icon="bomb"
          selected={enabled}
          color="transparent"
          tooltip="Toggle explosion"
          tooltipOverrideLong
          tooltipPosition="top-left"
          onClick={() => {
            if (enabled) {
              setEnabled(false);
              act('set_explosive_parameters', {
                "power": 0,
                "falloff": 75,
              });
            } else {
              setEnabled(true);
              act('set_explosive_parameters', {
                "power": 50,
                "falloff": 75,
              });
            }
          }} />
      )}>
      {!!enabled && (
        <>
          <Slider
            value={data.explosion_power}
            ranges={{
              bad: [300, Infinity],
              average: [100, 300],
              good: [-Infinity, 100],
            }}
            unit="Power"
            step={5}
            stepPixelSize={3}
            minValue={0}
            maxValue={500}
            onChange={(e, value) => act("set_explosive_parameters", { power: value })}
          />
          <Slider
            mt={1}
            value={data.explosion_falloff}
            ranges={{
              good: [125, Infinity],
              average: [75, 125],
              bad: [-Infinity, 75],
            }}
            unit="Falloff"
            step={2}
            stepPixelSize={3}
            minValue={0}
            maxValue={200}
            onChange={(e, value) => act("set_explosive_parameters", { falloff: value })}
          />
        </>
      )}
    </Section>
  );
};

const Container = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section
      fill
      title="Container"
    >
      <Slider
        value={data.max_hold_items}
        ranges={{
          bad: [50, Infinity],
          average: [31, 50],
          good: [-Infinity, 31],
        }}
        unit="Max Items"
        step={1}
        stepPixelSize={3}
        minValue={0}
        maxValue={50}
        onChange={(e, value) => act("set_max_hold_items", { max_hold_items: value })}
      />
    </Section>
  );
};
