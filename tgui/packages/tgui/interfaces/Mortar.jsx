import { useBackend, useLocalState } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const Mortar = (props, context) => {
  const { act, data } = useBackend(context);
  const { data_target_x, data_target_y, data_dial_x, data_dial_y } = data;

  const [target_x, setTargetX] = useLocalState(
    context,
    'target_x',
    data_target_x
  );

  const [target_y, setTargetY] = useLocalState(
    context,
    'target_y',
    data_target_y
  );

  const [dial_x, setDialX] = useLocalState(context, 'dial_x', data_dial_x);

  const [dial_y, setDialY] = useLocalState(context, 'dial_y', data_dial_y);

  return (
    <Window width={245} height={220}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Target X">
              <NumberInput
                width="4em"
                step={1}
                minValue={-1000}
                maxValue={1000}
                value={target_x}
                onChange={(_, value) => setTargetX(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Y">
              <NumberInput
                width="4em"
                step={1}
                minValue={-1000}
                maxValue={1000}
                value={target_y}
                onChange={(_, value) => setTargetY(value)}
              />
            </LabeledList.Item>
          </LabeledList>
          <Button
            content="Set Target"
            icon="crosshairs"
            style={{
              'margin-top': '5px',
              'margin-left': '10px',
            }}
            onClick={() =>
              act('set_target', {
                target_x: target_x,
                target_y: target_y,
              })
            }
          />
          <Button
            content="View Camera"
            style={{
              'display': 'flex',
              'position': 'absolute',
              'top': '10px',
              'right': '15px',
              'height': '65px',
              'width': '80px',
              'white-space': 'normal',
              'text-align': 'center',
              'align-items': 'center',
            }}
            onClick={() =>
              act('operate_cam', {
                camera: 1,
              })
            }
          />
        </Section>
        <Section>
          <LabeledList>
            <LabeledList.Item label="X Offset">
              <NumberInput
                width="4em"
                step={1}
                stepPixelSize={10}
                minValue={-10}
                maxValue={10}
                value={dial_x}
                onChange={(_, value) => setDialX(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Y Offset">
              <NumberInput
                width="4em"
                step={1}
                stepPixelSize={10}
                minValue={-10}
                maxValue={10}
                value={dial_y}
                onChange={(_, value) => setDialY(value)}
              />
            </LabeledList.Item>
          </LabeledList>
          <Button
            content="Dial Offset"
            icon="wrench"
            style={{
              'margin-top': '5px',
              'margin-left': '10px',
            }}
            onClick={() =>
              act('set_offset', {
                dial_x: dial_x,
                dial_y: dial_y,
              })
            }
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
