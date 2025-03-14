/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui/components';

export const meta = {
  title: 'ProgressBar',
  render: () => <Story />,
};

const Story = (props) => {
  const [progress, setProgress] = useState(0.5);
  const [color, setColor] = useState('');

  return (
    <Section>
      {color ? (
        <ProgressBar color={color} minValue={-1} maxValue={1} value={progress}>
          Value: {Number(progress).toFixed(1)}
        </ProgressBar>
      ) : (
        <ProgressBar
          ranges={{
            good: [0.5, Infinity],
            bad: [-Infinity, 0.1],
            average: [0, 0.5],
          }}
          minValue={-1}
          maxValue={1}
          value={progress}
        >
          Value: {Number(progress).toFixed(1)}
        </ProgressBar>
      )}
      <Box mt={1} mb="2em">
        <LabeledList>
          <LabeledList.Item label="Adjust value">
            <Button onClick={() => setProgress(progress - 0.1)}>-0.1</Button>
            <Button onClick={() => setProgress(progress + 0.1)}>+0.1</Button>
          </LabeledList.Item>
          <LabeledList.Item label="Override color">
            <Input value={color} onChange={(e, value) => setColor(value)} />
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Section>
  );
};
