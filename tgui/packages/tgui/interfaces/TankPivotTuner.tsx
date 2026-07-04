import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Weapon = {
  ref: string;
  name: string;
  pivot_x: number;
  pivot_y: number;
  selected: BooleanLike;
};

type Data = {
  dir_name: string;
  weapons: Weapon[];
  selected_name: string;
  tuning_label: string;
  pivot_x: number;
  pivot_y: number;
  offset_x: number;
  offset_y: number;
  is_gimballed: BooleanLike;
  gimbal_pivot_x: number;
  gimbal_pivot_y: number;
};

const AXIS_STEPS = [-10, -1, 1, 10];

const AxisRow = (props: {
  axis: 'x' | 'y';
  value: number;
  target: 'rotation' | 'gimbal' | 'offset';
}) => {
  const { act } = useBackend<Data>();
  const { axis, value, target } = props;
  return (
    <LabeledList.Item label={`${axis.toUpperCase()}: ${value}`}>
      <Stack>
        {AXIS_STEPS.map((step) => (
          <Stack.Item key={step}>
            <Button
              icon={step > 0 ? 'plus' : 'minus'}
              onClick={() => act('adjust', { axis, delta: step, target })}
            >
              {step > 0 ? `+${step}` : step}
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </LabeledList.Item>
  );
};

export const TankPivotTuner = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    dir_name,
    weapons = [],
    selected_name,
    tuning_label,
    pivot_x,
    pivot_y,
    offset_x,
    offset_y,
    is_gimballed,
    gimbal_pivot_x,
    gimbal_pivot_y,
  } = data;

  return (
    <Window width={420} height={480}>
      <Window.Content scrollable>
        <Section title={`Tuning direction: ${dir_name}`}>
          <LabeledList>
            {weapons.map((weaponEntry) => (
              <LabeledList.Item key={weaponEntry.ref} label={weaponEntry.name}>
                <Button
                  selected={weaponEntry.selected}
                  onClick={() =>
                    act('select_weapon', { ref: weaponEntry.ref })
                  }
                >
                  ({weaponEntry.pivot_x}, {weaponEntry.pivot_y})
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
        {selected_name && (
          <Section title={`${selected_name} - offset`}>
            <LabeledList>
              <AxisRow axis="x" value={offset_x} target="offset" />
              <AxisRow axis="y" value={offset_y} target="offset" />
            </LabeledList>
          </Section>
        )}
        {selected_name && (
          <Section
            title={`${selected_name} - turret pivot (${tuning_label})`}
          >
            <LabeledList>
              <AxisRow axis="x" value={pivot_x} target="rotation" />
              <AxisRow axis="y" value={pivot_y} target="rotation" />
            </LabeledList>
          </Section>
        )}
        {selected_name && is_gimballed && (
          <Section title={`${selected_name} - own swivel pivot`}>
            <LabeledList>
              <AxisRow axis="x" value={gimbal_pivot_x} target="gimbal" />
              <AxisRow axis="y" value={gimbal_pivot_y} target="gimbal" />
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
