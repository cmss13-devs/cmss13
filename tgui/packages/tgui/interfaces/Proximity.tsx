import { useBackend } from 'tgui/backend';
import { Button, Knob, LabeledList, Section, Slider } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  min_time: number;
  max_time: number;
  min_range: number;
  max_range: number;
  min_delay: number;
  max_delay: number;
  current_arm_time: number;
  is_arming: number;
  current_delay: number;
  current_range: number;
  armed: number;
};

export const Proximity = (props) => {
  const { act, data } = useBackend<Data>();
  const { max_time, min_time, max_range, min_range, max_delay, min_delay } =
    data;

  const window_width = 360;
  return (
    <Window width={window_width} height={215}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Arming Configuration">
              <Button
                color={data.is_arming ? 'green' : 'red'}
                icon="clock"
                onClick={() =>
                  act('set_arming', { should_start_arming: !data.is_arming })
                }
              >
                {data.is_arming ? 'Arming' : 'Not Arming'}
              </Button>
              <Slider
                maxValue={max_time}
                minValue={min_time}
                value={data.current_arm_time}
                onChange={(e, value) =>
                  act('set_arm_time', { arm_time: value })
                }
                unit="Seconds"
                stepPixelSize={window_width / max_time} // width / max_time
              />
            </LabeledList.Item>
            <LabeledList.Item label="Range">
              <Knob
                inline
                animated={false}
                maxValue={max_range}
                minValue={min_range}
                value={data.current_range}
                onChange={(e, value) => act('set_range', { value: value })}
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
                onChange={(e, value) => act('set_delay', { value: value })}
                stepPixelSize={20}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <Button
            fluid
            color={data.armed ? 'red' : 'green'}
            icon={data.armed ? 'exclamation-triangle' : 'bomb'}
            onClick={() => act('set_armed', { armed: !data.armed })}
            tooltip="Begins scanning for potential hostiles. Very dangerous if attached to any volatile materials."
            tooltipPosition="top"
          >
            {data.armed ? 'Armed' : 'Unarmed'}
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
