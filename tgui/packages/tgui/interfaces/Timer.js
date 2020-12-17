import { useBackend } from '../backend';
import { Button, Section, Slider } from '../components';
import { Window } from '../layouts';

export const Timer = (props, context) => {
  const { act, data } = useBackend(context);
  const { max_time, min_time } = data;

  const window_width = 360;
  return (
    <Window
      width={window_width}
      height={120}
    >
      <Window.Content>
        <Section>
          <Button
            fluid
            color={data.is_timing? "green" : "red"}
            icon="clock"
            content={data.is_timing? "Enabled" : "Disabled"}
            onClick={() => act("set_timing", { should_time: !data.is_timing })}
          />
        </Section>
        <Section>
          <Slider 
            maxValue={max_time}
            minValue={min_time}
            value={data.current_time}
            onChange={(e, value) => act("set_time", { time: value })}
            unit="Seconds"
            stepPixelSize={window_width/max_time} // width / max_time
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
  