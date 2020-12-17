import { useBackend } from '../backend';
import { Button, Knob, LabeledList, Section, Slider, Tooltip } from '../components';
import { Window } from '../layouts';

export const Proximity = (props, context) => {
  const { act, data } = useBackend(context);
  const { 
    max_time, min_time,
    max_range, min_range,
    max_delay, min_delay,
  } = data;

  const window_width = 360;
  return (
    <Window
      width={window_width}
      height={215}
    >
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Arming Configuration">
              <Button
                color={data.is_arming? "green" : "red"}
                icon="clock"
                content={data.is_arming? "Arming" : "Not Arming"}
                onClick={() => act("set_arming", { should_start_arming: !data.is_arming })}
              />
              <Slider 
                maxValue={max_time}
                minValue={min_time}
                value={data.current_arm_time}
                onChange={(e, value) => act("set_arm_time", { arm_time: value })}
                unit="Seconds"
                stepPixelSize={window_width/max_time} // width / max_time
              />
            </LabeledList.Item>
            <LabeledList.Item label="Range">
              <Knob
                inline
                animated={false}
                maxValue={max_range}
                minValue={min_range}
                value={data.current_range}
                onChange={(e, value) => act("set_range", { value: value })}
                stepPixelSize={20}
              /> 
            </LabeledList.Item>
            <LabeledList.Item label="Delay">
              <Knob
                inline
                animated={false}
                maxValue={max_delay}
                minValue={min_delay}
                value={data.current_delay}
                onChange={(e, value) => act("set_delay", { value: value })}
                stepPixelSize={20}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <Button
            fluid
            color={data.armed? "red" : "green"}
            icon={data.armed? "exclamation-triangle" : "bomb"}
            content={data.armed? "Armed" : "Unarmed"}
            onClick={() => act("set_armed", { armed: !data.armed })}
          >
            <Tooltip position="top" content="Begins scanning for potential hostiles. Very dangerous if attached to any volatile materials." />
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
  