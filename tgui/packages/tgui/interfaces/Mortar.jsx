import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const Mortar = (props) => {
  const { act, data } = useBackend();
  const {
    data_target_x,
    data_target_y,
    data_target_z,
    data_dial_x,
    data_dial_y,
  } = data;

  const [target_x, setTargetX] = useState(data_target_x);
  const [target_y, setTargetY] = useState(data_target_y);
  const [target_z, setTargetZ] = useState(data_target_z);
  const [dial_x, setDialX] = useState(data_dial_x);
  const [dial_y, setDialY] = useState(data_dial_y);

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
                onChange={(value) => setTargetX(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Y">
              <NumberInput
                width="4em"
                step={1}
                minValue={-1000}
                maxValue={1000}
                value={target_y}
                onChange={(value) => setTargetY(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Target Z">
              <NumberInput
                width="4em"
                step={1}
                minValue={-1000}
                maxValue={1000}
                value={target_z}
                onChange={(value) => setTargetZ(value)}
              />
            </LabeledList.Item>
          </LabeledList>
          <Button
            icon="crosshairs"
            style={{
              marginTop: '5px',
              marginLeft: '10px',
            }}
            onClick={() =>
              act('set_target', {
                target_x: target_x,
                target_y: target_y,
                target_z: target_z,
              })
            }
          >
            Set Target
          </Button>
          <Button
            style={{
              display: 'flex',
              position: 'absolute',
              top: '10px',
              right: '15px',
              height: '65px',
              width: '80px',
              whiteSpace: 'normal',
              textAlign: 'center',
              alignItems: 'center',
            }}
            onClick={() =>
              act('operate_cam', {
                camera: 1,
              })
            }
          >
            View Camera
          </Button>
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
                onChange={(value) => setDialX(value)}
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
                onChange={(value) => setDialY(value)}
              />
            </LabeledList.Item>
          </LabeledList>
          <Button
            icon="wrench"
            style={{
              marginTop: '5px',
              marginLeft: '10px',
            }}
            onClick={() =>
              act('set_offset', {
                dial_x: dial_x,
                dial_y: dial_y,
              })
            }
          >
            Dial Offset
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
