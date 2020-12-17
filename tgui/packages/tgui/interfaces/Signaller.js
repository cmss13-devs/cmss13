import { useBackend } from '../backend';
import { Button, Section, Knob, NoticeBox, LabeledList } from '../components';
import { Window } from '../layouts';

export const Signaller = (props, context) => {
  const { act, data } = useBackend(context);
  const { max_freq, min_freq, max_signal, min_signal } = data;

  return (
    <Window
      width={160}
      height={170}
    >
      <Window.Content>
        <Section>
          <Button
            fluid
            icon="satellite-dish"
            content="Trigger"
            onClick={() => act("send_signal")}
          />
        </Section>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Frequency">
              <Knob 
                inline
                maxValue={max_freq}
                minValue={min_freq}
                value={data.current_freq}
                onChange={(e, value) => act("set_freq", { value: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Signal">
              <Knob
                inline
                maxValue={max_signal}
                minValue={min_signal}
                value={data.current_signal}
                onChange={(e, value) => act("set_signal", { value: value })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
  