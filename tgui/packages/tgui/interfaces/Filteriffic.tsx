import { toFixed } from 'common/math';
import { numberOfDecimalDigits } from 'common/math';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  ColorBox,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type MasterFilter = {
  alpha: {
    defaults: {
      x: number;
      y: number;
      icon: string;
      render_source: string;
      flags: number;
    };
    flags: {
      MASK_INVERSE: number;
      MASK_SWAP: number;
    };
  };
  angular_blur: {
    defaults: {
      x: number;
      y: number;
      size: number;
    };
  };
  color: {
    defaults: {
      color: string;
      space: number;
    };
    enums: {
      FILTER_COLOR_RGB: number;
      FILTER_COLOR_HSV: number;
      FILTER_COLOR_HSL: number;
      FILTER_COLOR_HCY: number;
    };
  };
  displace: {
    defaults: {
      x: number;
      y: number;
      size: number;
      icon: string;
      render_source: '';
    };
  };
  drop_shadow: {
    defaults: {
      x: number;
      y: number;
      size: number;
      offset: number;
      color: string;
    };
  };
  blur: {
    defaults: {
      size: number;
    };
  };
  layer: {
    defaults: {
      x: number;
      y: number;
      icon: string;
      render_source: string;
      flags: number;
      color: string;
      transform: null | number[];
      blend_mode: number;
    };
    enums: {
      BLEND_DEFAULT: number;
      BLEND_OVERLAY: number;
      BLEND_ADD: number;
      BLEND_SUBTRACT: number;
      BLEND_MULTIPLY: number;
      BLEND_INSET_OVERLAY: number;
    };
  };
  motion_blur: {
    defaults: {
      x: number;
      y: number;
    };
  };
  outline: {
    defaults: {
      size: number;
      color: string;
      flags: number;
    };
    flags: {
      OUTLINE_SHARP: number;
      OUTLINE_SQUARE: number;
    };
  };
  radial_blur: {
    defaults: {
      x: number;
      y: number;
      size: number;
    };
  };
  rays: {
    defaults: {
      x: number;
      y: number;
      size: number;
      color: string;
      offset: number;
      density: number;
      threshold: number;
      factor: number;
      flags: number;
    };
    flags: {
      FILTER_OVERLAY: number;
      FILTER_UNDERLAY: number;
    };
  };
  ripple: {
    defaults: {
      x: number;
      y: number;
      size: number;
      repeat: number;
      radius: number;
      falloff: number;
      flags: number;
    };
    flags: {
      WAVE_BOUNDED: number;
    };
  };
  wave: {
    defaults: {
      x: number;
      y: number;
      size: number;
      offset: number;
      flags: number;
    };
    flags: {
      WAVE_SIDEWAYS: number;
      WAVE_BOUNDED: number;
    };
  };
};

type ActiveFilters = { type: string; priority: number } & Partial<MasterFilter>;

type FilterEntryProps = {
  readonly name: string;
  readonly value: any;
  readonly hasValue: boolean;
  readonly filterName: string;
  readonly filterType: string;
};

export type Data = {
  filter_info: MasterFilter;
  target_name: string;
  target_filter_data: Record<string, ActiveFilters>;
};

const FilterIntegerEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();
  return (
    <NumberInput
      value={value}
      minValue={-500}
      maxValue={500}
      step={1}
      stepPixelSize={5}
      width="39px"
      onDrag={(value) =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: value,
          },
        })
      }
    />
  );
};

const FilterFloatEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();
  const [step, setStep] = useState(0.01);

  return (
    <>
      <NumberInput
        value={value}
        minValue={-500}
        maxValue={500}
        stepPixelSize={4}
        step={step}
        format={(value) => toFixed(value, numberOfDecimalDigits(step))}
        width="80px"
        onDrag={(value) =>
          act('transition_filter_value', {
            name: filterName,
            new_data: {
              [name]: value,
            },
          })
        }
      />
      <Box inline ml={2} mr={1}>
        Step:
      </Box>
      <NumberInput
        minValue={-Infinity}
        maxValue={Infinity}
        value={step}
        step={0.001}
        format={(value) => toFixed(value, 4)}
        width="70px"
        onChange={(value) => setStep(value)}
      />
    </>
  );
};

const FilterTransformEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();

  return (
    <Box>
      {value?.map((current_value: number, current_index: number) => (
        <NumberInput
          key={current_index}
          value={current_value}
          minValue={0}
          maxValue={1}
          step={1}
          onDrag={(new_value) =>
            act('modify_filter_value', {
              name: filterName,
              new_data: {
                [name]: value!.map((x: number, i: number) =>
                  i === current_index ? new_value : x,
                ),
              },
            })
          }
        />
      ))}
    </Box>
  );
};

const FilterTextEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();

  return (
    <Input
      value={value}
      width="250px"
      onChange={(e, value) =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: value,
          },
        })
      }
    />
  );
};

const FilterColorEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="pencil-alt"
        onClick={() =>
          act('modify_color_value', {
            name: filterName,
          })
        }
      />
      <ColorBox color={value} mr={0.5} />
      <Input
        value={value}
        width="90px"
        onChange={(e, value) =>
          act('transition_filter_value', {
            name: filterName,
            new_data: {
              [name]: value,
            },
          })
        }
      />
    </>
  );
};

const FilterIconEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="pencil-alt"
        onClick={() =>
          act('modify_icon_value', {
            name: filterName,
          })
        }
      />
      <Box inline ml={1}>
        {value}
      </Box>
    </>
  );
};

const FilterFlagsEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act, data } = useBackend<Data>();

  const filterInfo = data.filter_info;
  const flags: Record<string, number> = filterInfo[filterType]['flags'];
  return Object.entries(flags).map(([flagName, bitField]) => (
    <Button.Checkbox
      checked={value & bitField}
      onClick={() =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: value ^ bitField,
          },
        })
      }
      key={flagName}
    >
      {flagName}
    </Button.Checkbox>
  ));
};

const FilterEnumEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;
  const { act, data } = useBackend<Data>();

  const filterInfo = data.filter_info;
  const enums: Record<string, number> = filterInfo[filterType]['enums'];
  return Object.entries(enums).map(([enumName, enumNumber]) => (
    <Button.Checkbox
      checked={value === enumNumber}
      onClick={() =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: enumNumber,
          },
        })
      }
      key={enumName}
    >
      {enumName}
    </Button.Checkbox>
  ));
};

const FilterDataEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;

  const filterEntryTypes = {
    int: <FilterIntegerEntry {...props} />,
    float: <FilterFloatEntry {...props} />,
    string: <FilterTextEntry {...props} />,
    color: <FilterColorEntry {...props} />,
    icon: <FilterIconEntry {...props} />,
    flags: <FilterFlagsEntry {...props} />,
    enum: <FilterEnumEntry {...props} />,
    transform: <FilterTransformEntry {...props} />,
  };

  const filterEntryMap = {
    x: 'float',
    y: 'float',
    icon: 'icon',
    render_source: 'string',
    flags: 'flags',
    size: 'float',
    color: 'color',
    offset: 'float',
    radius: 'float',
    falloff: 'float',
    density: 'int',
    threshold: 'float',
    factor: 'float',
    repeat: 'int',
    alpha: 'int',
    space: 'enum',
    blend_mode: 'enum',
    transform: 'transform',
  };

  return (
    <LabeledList.Item label={name}>
      {filterEntryTypes[filterEntryMap[name]] || 'Not Found (This is an error)'}{' '}
      {!hasValue && (
        <Box inline color="average">
          (Default)
        </Box>
      )}
    </LabeledList.Item>
  );
};

const FilterEntry = (props: {
  readonly name: string;
  readonly filterDataEntry: ActiveFilters;
}) => {
  const { act, data } = useBackend<Data>();
  const { name, filterDataEntry } = props;
  const { type, priority, ...restOfProps } = filterDataEntry;

  const filterDefaults = data['filter_info'];

  const targetFilterPossibleKeys = Object.keys(
    filterDefaults[type]['defaults'],
  );

  return (
    <Collapsible
      title={name + ' (' + type + ')'}
      buttons={
        <>
          <NumberInput
            minValue={-Infinity}
            maxValue={Infinity}
            value={priority}
            step={1}
            stepPixelSize={10}
            width="60px"
            onChange={(value) =>
              act('change_priority', {
                name: name,
                new_priority: value,
              })
            }
          />
          <Button.Input
            placeholder={name}
            onCommit={(e, new_name) =>
              act('rename_filter', {
                name: name,
                new_name: new_name,
              })
            }
            width="90px"
          >
            Rename
          </Button.Input>
          <Button.Confirm
            icon="minus"
            onClick={() => act('remove_filter', { name: name })}
          />
        </>
      }
    >
      <Section>
        <LabeledList>
          {targetFilterPossibleKeys.map((entryName) => {
            const defaults = filterDefaults[type]['defaults'];
            const value = restOfProps[entryName] || defaults[entryName];
            const hasValue = value !== defaults[entryName];
            return (
              <FilterDataEntry
                key={entryName}
                filterName={name}
                filterType={type}
                name={entryName}
                value={value}
                hasValue={hasValue}
              />
            );
          })}
        </LabeledList>
      </Section>
    </Collapsible>
  );
};

export const Filteriffic = (props: any) => {
  const { act, data } = useBackend<Data>();
  const name = data.target_name || 'Unknown Object';
  const filters = data.target_filter_data || {};
  const hasFilters = Object.keys(filters).length !== 0;
  const filterDefaults = data['filter_info'];
  const [massApplyPath, setMassApplyPath] = useState('');
  const [hiddenSecret, setHiddenSecret] = useState(false);

  return (
    <Window title="Filteriffic" width={500} height={500}>
      <Window.Content scrollable>
        <NoticeBox danger>
          DO NOT MESS WITH EXISTING FILTERS IF YOU DO NOT KNOW THE CONSEQUENCES.
          YOU HAVE BEEN WARNED.
        </NoticeBox>
        <Section
          title={
            hiddenSecret ? (
              <>
                <Box mr={0.5} inline>
                  MASS EDIT:
                </Box>
                <Input
                  value={massApplyPath}
                  width="100px"
                  onChange={(e, value) => setMassApplyPath(value)}
                />
                <Button.Confirm
                  confirmContent="ARE YOU SURE?"
                  onClick={() => act('mass_apply', { path: massApplyPath })}
                >
                  Apply
                </Button.Confirm>
              </>
            ) : (
              <Box inline onDoubleClick={() => setHiddenSecret(true)}>
                {name}
              </Box>
            )
          }
          buttons={
            <Dropdown
              selected={null}
              icon="plus"
              verticalAlign="bottom"
              displayText="Add Filter"
              noChevron
              options={Object.keys(filterDefaults)}
              onSelected={(value) =>
                act('add_filter', {
                  name: 'default',
                  priority: 10,
                  type: value,
                })
              }
            />
          }
        >
          {!hasFilters ? (
            <Box>No filters</Box>
          ) : (
            Object.entries(filters).map(([name, filterData]) => (
              <FilterEntry
                filterDataEntry={filterData}
                name={name}
                key={name}
              />
            ))
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
