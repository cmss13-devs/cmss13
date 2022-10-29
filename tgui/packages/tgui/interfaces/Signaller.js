import { useBackend } from '../backend';
import { Button, Section, LabeledList, Slider } from '../components';
import { Window } from '../layouts';

export const Signaller = (props, context) => {
  const { act, data } = useBackend(context);
  const { max_freq, min_freq, max_signal, min_signal } = data;

  return (
    <Window width={300} height={170}>
      <Window.Content>
        <Section>
          <Button
            fluid
            textAlign="center"
            icon="satellite-dish"
            content="Trigger"
            onClick={() => act('send_signal')}
          />
        </Section>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Frequency">
              <Slider
                inline
                maxValue={max_freq}
                minValue={min_freq}
                value={data.current_freq}
                onChange={(e, value) => act('set_freq', { value: value })}
                mt={1}
                stepPixelSize={2}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Signal">
              <Slider
                inline
                maxValue={max_signal}
                minValue={min_signal}
                value={data.current_signal}
                onChange={(e, value) => act('set_signal', { value: value })}
                mt={1}
                stepPixelSize={8}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
