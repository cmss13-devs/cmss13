import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, ColorBox, DmIcon, Modal, Stack, Tooltip } from '../components';
import { Window } from '../layouts';

type PickerData = {
  icon: string;
  body_types: { name: string; icon: string }[];
  skin_colors: { name: string; icon: string; color: string }[];
  body_sizes: { name: string; icon: string }[];

  body_type: string;
  skin_color: string;
  body_size: string;
};

export const BodyPicker = () => {
  const { data } = useBackend<PickerData>();

  const { icon, body_size, body_type, skin_color, body_types, body_sizes } =
    data;

  const [picker, setPicker] = useState<'type' | 'size' | undefined>();

  const unselectedBodyType = body_types.filter(
    (val) => val.icon !== body_type,
  )[0];

  const unselectedBodySize = body_sizes.filter(
    (val) => val.icon !== body_size,
  )[0];

  return (
    <Window width={390} height={180}>
      <Window.Content className="BodyPicker">
        {picker && (
          <Modal m={1}>
            <TypePicker picker={setPicker} toUse={picker} />
          </Modal>
        )}
        <Stack>
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                <DmIcon
                  icon={icon}
                  icon_state={`${skin_color}_torso_${body_size}_${body_type}`}
                  width={'128px'}
                  mt={-5}
                />
              </Stack.Item>
              <Stack>
                <Tooltip content={'Change Body Type'} position="bottom-start">
                  <Box position="relative" onClick={() => setPicker('type')}>
                    <DmIcon
                      icon={icon}
                      icon_state={`${skin_color}_torso_${body_size}_${unselectedBodyType.icon}`}
                      width={'80px'}
                      mt={-5}
                    />
                  </Box>
                </Tooltip>
                <Tooltip content={'Change Body Size'} position="bottom-start">
                  <Box position="relative" onClick={() => setPicker('size')}>
                    <DmIcon
                      icon={icon}
                      icon_state={`${skin_color}_torso_${unselectedBodySize.icon}_${body_type}`}
                      width={'80px'}
                      mt={-5}
                      ml={-5}
                      position="relative"
                    />
                  </Box>
                </Tooltip>
              </Stack>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <ColorOptions />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const TypePicker = (props: {
  readonly picker: (_) => void;
  readonly toUse: 'type' | 'size';
}) => {
  const { data, act } = useBackend<PickerData>();

  const { picker, toUse } = props;

  const { body_type, body_types, skin_color, body_size, body_sizes, icon } =
    data;

  const toIterate = toUse === 'type' ? body_types : body_sizes;

  const active = toUse === 'type' ? body_type : body_size;

  return (
    <Stack>
      {toIterate.map((type) => (
        <Stack.Item key={type.name}>
          <Tooltip content={type.name}>
            <Box
              onClick={() => {
                picker(undefined);
                act(toUse, { name: type.name });
              }}
              position="relative"
              className={`typePicker ${active === type.icon ? 'active' : ''}`}
            >
              <DmIcon
                icon={icon}
                icon_state={
                  toUse === 'type'
                    ? `${skin_color}_torso_${body_size}_${type.icon}`
                    : `${skin_color}_torso_${type.icon}_${body_type}`
                }
                width={'80px'}
              />
            </Box>
          </Tooltip>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const ColorOptions = () => {
  const { data, act } = useBackend<PickerData>();

  const { skin_color, skin_colors } = data;

  return (
    <Stack wrap={'wrap'} width={'250px'}>
      {skin_colors.map((color) => (
        <Stack.Item key={color.name} className="colorPickerContainer">
          <ColorBox
            color={color.color}
            p={3.5}
            mt={0.5}
            onClick={() => act('color', { name: color.name })}
            className={`colorPicker ${skin_color === color.icon ? 'active' : ''}`}
          />
        </Stack.Item>
      ))}
    </Stack>
  );
};
