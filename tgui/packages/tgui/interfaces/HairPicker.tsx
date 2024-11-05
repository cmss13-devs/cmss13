import { hexToHsva, HsvaColor, hsvaToHex } from 'common/color';
import { createRef, useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  ColorBox,
  DmIcon,
  Modal,
  Section,
  Stack,
  Tooltip,
} from '../components';
import { Window } from '../layouts';
import { ColorSelector } from './ColorPickerModal';

type HairPickerData = {
  hair_icon: string;
  hair_styles: { name: string; icon: string }[];
  hair_style: string;
  hair_color: string;
  facial_hair_icon: string;
  facial_hair_styles: { name: string; icon: string }[];
  facial_hair_style: string;
  facial_hair_color: string;
};

export const HairPicker = () => {
  const { act, data } = useBackend<HairPickerData>();

  const {
    hair_icon,
    hair_style,
    hair_styles,
    hair_color,
    facial_hair_icon,
    facial_hair_style,
    facial_hair_styles,
    facial_hair_color,
  } = data;

  const height = facial_hair_styles.length > 0 ? 550 : 290;

  const [colorPicker, setColorPicker] = useState<
    'hair' | 'facial_hair' | false
  >(false);

  return (
    <Window width={400} height={height} theme={'crtblue'}>
      <Window.Content className="HairPicker">
        <PickerElement
          name="Hair"
          icon={hair_icon}
          hair={hair_styles}
          active={hair_style}
          color={hair_color}
          setColor={setColorPicker}
          action="hair"
        />
        <PickerElement
          name="Facial Hair"
          icon={facial_hair_icon}
          hair={facial_hair_styles}
          active={facial_hair_style}
          color={facial_hair_color}
          setColor={setColorPicker}
          action="facial_hair"
        />
        {colorPicker && (
          <ColorPicker
            type={colorPicker}
            close={() => setColorPicker(false)}
            default_color={
              colorPicker === 'hair' ? hair_color : facial_hair_color
            }
          />
        )}
      </Window.Content>
    </Window>
  );
};

const ColorPicker = (props: {
  readonly type: 'hair' | 'facial_hair';
  readonly close: () => void;
  readonly default_color: string;
}) => {
  const { act } = useBackend();

  const { type, close, default_color } = props;

  const [currentColor, setCurrentColor] = useState<HsvaColor>(
    hexToHsva(default_color || '#000000'),
  );

  return (
    <Modal width="100%">
      <Box width="350px">
        <Stack vertical>
          <Stack.Item>
            <ColorSelector
              color={currentColor}
              setColor={setCurrentColor}
              defaultColor={default_color}
              onConfirm={() => {
                close();
                act(`${type}_color`, { color: hsvaToHex(currentColor) });
              }}
            />
          </Stack.Item>
        </Stack>
      </Box>
    </Modal>
  );
};

const PickerElement = (props: {
  readonly name: string;
  readonly icon: string;
  readonly active: string;
  readonly hair: { icon: string; name: string }[];
  readonly action: 'hair' | 'facial_hair';
  readonly setColor: (_) => void;
  readonly color: string;
}) => {
  const { name, icon, hair, active, action, setColor, color } = props;

  const { act } = useBackend();

  const scrollRef = createRef<HTMLDivElement>();

  return (
    <Section
      title={name}
      height="250px"
      scrollable
      buttons={
        <Button onClick={() => setColor(action)}>
          <ColorBox color={color} mr={1} />
          Color
        </Button>
      }
      ref={scrollRef}
      onMouseOver={() => {
        scrollRef.current?.focus();
      }}
    >
      <Stack wrap="wrap" height="200px" width="400px">
        {hair.map((hair) => (
          <Stack.Item
            key={hair.name}
            className={`Picker${active === hair.icon ? ' Active' : ''}`}
          >
            <Tooltip content={hair.name}>
              <Box
                position="relative"
                onClick={() => act(action, { name: hair.name })}
              >
                <DmIcon
                  icon={icon}
                  icon_state={`${hair.icon}_s`}
                  height="64px"
                  width="64px"
                />
              </Box>
            </Tooltip>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
