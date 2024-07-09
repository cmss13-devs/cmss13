import { useBackend } from '../../backend';
import { Box, Button, Stack } from '../../components';
import {
  useFiremissionXOffsetValue,
  useFiremissionYOffsetValue,
  useLazeTarget,
} from '../MfdPanels/stateManagers';

const SvgButton = (props: {
  readonly transform?: string;
  readonly onClick?: (e: any) => void;
}) => {
  return (
    <svg height="100" width="100">
      <g transform={props.transform} onClick={props.onClick}>
        <path
          stroke="#808080"
          strokeWidth="1"
          fillOpacity="1"
          fill="#606060"
          d="M 0 15 l 0 -20 l 10 -10 l 20 15 l 0 25 l -20 15 l -10 -10 l 0 -20"
        />
        <path
          stroke="#FFFFFF"
          strokeWidth="2"
          fillOpacity="0"
          d="M 25 12 l -20 0 l 10 -10 l -10 10 l 10 10"
        />
      </g>
    </svg>
  );
};

export const Dpad = (props) => {
  const { act } = useBackend();
  const { selectedTarget } = useLazeTarget();

  const { fmXOffsetValue, setFmXOffsetValue } = useFiremissionXOffsetValue();
  const { fmYOffsetValue, setFmYOffsetValue } = useFiremissionYOffsetValue();

  const min_value = -12;
  const max_value = 12;
  const updateOffset = (e, xValue, yValue) => {
    if (xValue < min_value || yValue < min_value) {
      return;
    }
    if (xValue > max_value || yValue > max_value) {
      return;
    }
    setFmXOffsetValue(xValue);
    setFmYOffsetValue(yValue);
    act('firemission-dual-offset-camera', {
      target_id: selectedTarget,
      x_offset_value: xValue,
      y_offset_value: yValue,
    });
  };

  return (
    <Box className="Dpad">
      <Stack className="Dpadwrapper">
        <Stack.Item>
          <Stack vertical>
            <Stack.Item className="container" />
            <Stack.Item className="container">
              <SvgButton
                onClick={(e) =>
                  updateOffset(e, fmXOffsetValue - 1, fmYOffsetValue)
                }
              />
            </Stack.Item>
            <Stack.Item className="container" />
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item className="container">
              <SvgButton
                transform="rotate(90 12.5 12.5)"
                onClick={(e) =>
                  updateOffset(e, fmXOffsetValue, fmYOffsetValue + 1)
                }
              />
            </Stack.Item>
            <Stack.Item className="container">
              <Button onClick={() => updateOffset(undefined, 0, 0)} />
            </Stack.Item>
            <Stack.Item className="container">
              <SvgButton
                transform="rotate(-90 12.5 12.5)"
                onClick={(e) =>
                  updateOffset(e, fmXOffsetValue, fmYOffsetValue - 1)
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item className="container" />
            <Stack.Item className="container">
              <SvgButton
                transform="rotate(-180 12.5 12.5)"
                onClick={(e) =>
                  updateOffset(e, fmXOffsetValue + 1, fmYOffsetValue)
                }
              />
            </Stack.Item>
            <Stack.Item className="container" />
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};
