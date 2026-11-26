import { useBackend } from 'tgui/backend';
import { Box, Button, Stack } from 'tgui/components';

import { useLazeTarget } from '../MfdPanels/stateManagers';
import type { TargetContext } from '../MfdPanels/types';

const SvgButton = (props: {
  readonly transform?: string;
  readonly onClick?: (e: any) => void;
}) => {
  return (
    <svg height="100" width="100" overflow="visible">
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

export const Dpad = () => {
  const { act, data } = useBackend<TargetContext>();
  const { selectedTarget } = useLazeTarget();

  const minimumOffset = -data.firemission_max_offset;
  const maximumOffset = data.firemission_max_offset;
  const updateOffset = (xValue, yValue) => {
    if (xValue < minimumOffset || yValue < minimumOffset) {
      return;
    }
    if (xValue > maximumOffset || yValue > maximumOffset) {
      return;
    }
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
                onClick={() =>
                  updateOffset(
                    data.firemission_x_offset - 1,
                    data.firemission_y_offset,
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
                onClick={() =>
                  updateOffset(
                    data.firemission_x_offset,
                    data.firemission_y_offset + 1,
                  )
                }
              />
            </Stack.Item>
            <Stack.Item className="container">
              <Button onClick={() => updateOffset(0, 0)} />
            </Stack.Item>
            <Stack.Item className="container">
              <SvgButton
                transform="rotate(-90 12.5 12.5)"
                onClick={() =>
                  updateOffset(
                    data.firemission_x_offset,
                    data.firemission_y_offset - 1,
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
                onClick={() =>
                  updateOffset(
                    data.firemission_x_offset + 1,
                    data.firemission_y_offset,
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
