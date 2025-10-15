import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui/components';

import {
  useDirectFireXOffsetValue,
  useDirectFireYOffsetValue,
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
  const { act, data } = useBackend();
  const { selectedTarget } = useLazeTarget();

  const { fmXOffsetValue, setFmXOffsetValue } = useFiremissionXOffsetValue();
  const { fmYOffsetValue, setFmYOffsetValue } = useFiremissionYOffsetValue();
  const { directXOffsetValue, setDirectXOffsetValue } =
    useDirectFireXOffsetValue();
  const { directYOffsetValue, setDirectYOffsetValue } =
    useDirectFireYOffsetValue();

  const min_value = -12;
  const max_value = 12;

  const canModifyDirectOffset =
    typeof data === 'object' &&
    data !== null &&
    'can_modify_direct_offset' in data
      ? (data as any).can_modify_direct_offset
      : false;

  const updateOffset = (e, newFmx, newDirectX, newFmy, newDirectY) => {
    const safeDirectX = canModifyDirectOffset ? newDirectX : directXOffsetValue;
    const safeDirectY = canModifyDirectOffset ? newDirectY : directYOffsetValue;

    if (
      newFmx < min_value ||
      newFmx > max_value ||
      safeDirectX < min_value ||
      safeDirectX > max_value ||
      newFmy < min_value ||
      newFmy > max_value ||
      safeDirectY < min_value ||
      safeDirectY > max_value
    ) {
      return;
    }
    setFmXOffsetValue(newFmx);
    setFmYOffsetValue(newFmy);
    setDirectXOffsetValue(safeDirectX);
    setDirectYOffsetValue(safeDirectY);
    act('firemission-dual-offset-camera', {
      target_id: selectedTarget,
      x_offset_value: newFmx,
      y_offset_value: newFmy,
      direct_x_offset_value: safeDirectX,
      direct_y_offset_value: safeDirectY,
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
                  updateOffset(
                    e,
                    fmXOffsetValue - 1,
                    canModifyDirectOffset
                      ? directXOffsetValue - 1
                      : directXOffsetValue,
                    fmYOffsetValue,
                    directYOffsetValue,
                  )
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
                  updateOffset(
                    e,
                    fmXOffsetValue,
                    directXOffsetValue,
                    fmYOffsetValue + 1,
                    canModifyDirectOffset
                      ? directYOffsetValue + 1
                      : directYOffsetValue,
                  )
                }
              />
            </Stack.Item>
            <Stack.Item className="container">
              <Button onClick={() => updateOffset(undefined, 0, 0, 0, 0)} />
            </Stack.Item>
            <Stack.Item className="container">
              <SvgButton
                transform="rotate(-90 12.5 12.5)"
                onClick={(e) =>
                  updateOffset(
                    e,
                    fmXOffsetValue,
                    directXOffsetValue,
                    fmYOffsetValue - 1,
                    canModifyDirectOffset
                      ? directYOffsetValue - 1
                      : directYOffsetValue,
                  )
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
                  updateOffset(
                    e,
                    fmXOffsetValue + 1,
                    canModifyDirectOffset
                      ? directXOffsetValue + 1
                      : directXOffsetValue,
                    fmYOffsetValue,
                    directYOffsetValue,
                  )
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
