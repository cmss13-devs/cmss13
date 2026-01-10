import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  DmIcon,
  Modal,
  Stack,
  Tooltip,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type PickerData = {
  icon: string;
  body_types: { name: string; icon: string }[];
  skin_colors: { name: string; icon: string; color: string }[];
  body_sizes: { name: string; icon: string }[];

  body_type: string;
  skin_color: string;
  body_size: string;

  body_presentation: string;
};

export const BodyPicker = () => {
  const { act, data } = useBackend<PickerData>();

  const {
    icon,
    body_size,
    body_type,
    skin_color,
    body_types,
    body_sizes,
    body_presentation,
  } = data;

  const [picker, setPicker] = useState<'type' | 'size' | undefined>();

  const unselectedBodyType = body_types.filter(
    (val) => val.icon !== body_type,
  )[0];

  const unselectedBodySize = body_sizes.filter(
    (val) => val.icon !== body_size,
  )[0];

  return (
    <Window width={415} height={180} theme={'crtblue'}>
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
                  icon_state={`${skin_color}_torso_${body_size}_${body_type}_${body_presentation}`}
                  width={'128px'}
                  mt={-5}
                />
              </Stack.Item>
              <Stack width="100%" fill mt={-4} justify="space-around">
                <Stack.Item>
                  <Button width={'4em'} height={'4em'}>
                    <Tooltip
                      content={'Change Body Type'}
                      position="bottom-start"
                    >
                      <Box
                        position="relative"
                        onClick={() => setPicker('type')}
                      >
                        <DmIcon
                          position="relative"
                          icon={icon}
                          icon_state={`${skin_color}_torso_${body_size}_${unselectedBodyType.icon}_${body_presentation}`}
                          width={'80px'}
                          right={'22px'}
                          bottom={'18px'}
                        />
                      </Box>
                    </Tooltip>
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button width={'4em'} height={'4em'}>
                    <Tooltip
                      content={'Change Body Size'}
                      position="bottom-start"
                    >
                      <Box
                        position="relative"
                        onClick={() => setPicker('size')}
                      >
                        <DmIcon
                          position="relative"
                          icon={icon}
                          icon_state={`${skin_color}_torso_${unselectedBodySize.icon}_${body_type}_${body_presentation}`}
                          width={'80px'}
                          right={'22px'}
                          bottom={'18px'}
                        />
                      </Box>
                    </Tooltip>
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack vertical fill>
              <Stack.Item>
                <Button
                  onClick={() => act('body_presentation', { picked: 'm' })}
                  height="5em"
                  lineHeight="5em"
                  icon="mars"
                  selected={body_presentation === 'm'}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  height="5em"
                  lineHeight="5em"
                  onClick={() => act('body_presentation', { picked: 'f' })}
                  icon="venus"
                  selected={body_presentation === 'f'}
                />
              </Stack.Item>
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

  const {
    body_type,
    body_types,
    skin_color,
    body_size,
    body_sizes,
    icon,
    body_presentation,
  } = data;

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
                    ? `${skin_color}_torso_${body_size}_${type.icon}_${body_presentation}`
                    : `${skin_color}_torso_${type.icon}_${body_type}_${body_presentation}`
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
