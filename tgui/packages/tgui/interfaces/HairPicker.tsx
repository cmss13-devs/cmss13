import { hexToHsva, HsvaColor, hsvaToHex } from 'common/color';
import { BooleanLike, classes } from 'common/react';
import { createRef, useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  ColorBox,
  DmIcon,
  Dropdown,
  Input,
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

  gradient_available: BooleanLike;
  gradient_styles: string[];
  gradient_style: string;
  gradient_color: string;
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
    gradient_available,
    gradient_style,
    gradient_styles,
    gradient_color,
  } = data;

  const [colorPicker, setColorPicker] = useState<
    'hair' | 'facial_hair' | 'gradient' | false
  >(false);

  let height = 340;
  if (facial_hair_styles.length > 1) {
    height = height + 310;
  }

  if (gradient_available) {
    height = height + 85;
  }

  let defaultColor = '#000000';
  switch (colorPicker) {
    case 'hair':
      defaultColor = hair_color;
      break;
    case 'facial_hair':
      defaultColor = facial_hair_color;
      break;
    case 'gradient':
      defaultColor = gradient_color;
      break;

    default:
      break;
  }

  return (
    <Window width={400} height={height} theme={'crtblue'}>
      <Window.Content
        className={classes(['HairPicker', colorPicker && 'ModalOpen'])}
      >
        <HairPickerElement
          name="Hair"
          icon={hair_icon}
          hair={hair_styles}
          active={hair_style}
          color={hair_color}
          setColor={() => setColorPicker('hair')}
          action={(obj) => act('hair', obj)}
          height="240px"
        />
        {!!(facial_hair_styles.length > 1) && (
          <HairPickerElement
            name="Facial Hair"
            icon={facial_hair_icon}
            hair={facial_hair_styles}
            active={facial_hair_style}
            color={facial_hair_color}
            setColor={() => setColorPicker('facial_hair')}
            action={(obj) => act('facial_hair', obj)}
            height="240px"
          />
        )}
        {!!gradient_available && (
          <Section
            title="Gradient"
            buttons={
              <Button onClick={() => setColorPicker('gradient')}>
                <ColorBox color={gradient_color} mr={1} />
                Color
              </Button>
            }
          >
            <Dropdown
              options={gradient_styles}
              selected={gradient_style}
              onSelected={(selected) => act('gradient', { name: selected })}
              over
            />
          </Section>
        )}
        {!!colorPicker && (
          <ColorPicker
            type={colorPicker}
            close={() => setColorPicker(false)}
            default_color={defaultColor}
          />
        )}
      </Window.Content>
    </Window>
  );
};

const ColorPicker = (props: {
  readonly type: 'hair' | 'facial_hair' | 'gradient';
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

export const HairPickerElement = (props: {
  readonly name: string;
  readonly icon: string;
  readonly active: string;
  readonly hair: { icon: string; name: string }[];
  readonly color?: string;
  readonly height?: number | string;

  readonly action: (_: object) => void;
  readonly setColor?: (_) => void;
  readonly close?: () => void;
}) => {
  const { name, icon, hair, active, action, setColor, close, color, height } =
    props;

  const scrollRef = createRef<HTMLDivElement>();

  const [search, setSearch] = useState('');

  return (
    <Section
      title={name}
      scrollable
      buttons={
        <>
          <Input
            placeholder="Search..."
            onInput={(_, val) => setSearch(val.toLowerCase())}
          />
          {color && (
            <Button onClick={() => (setColor ? setColor(action) : null)}>
              <ColorBox color={color} mr={1} />
              Color
            </Button>
          )}
          {close && <Button icon="x" onClick={() => close()} />}
        </>
      }
      ref={scrollRef}
      onMouseOver={() => {
        scrollRef.current?.focus();
      }}
    >
      <Stack wrap="wrap" height={height}>
        {hair
          .filter(
            (val) =>
              search.length === 0 || val.name.toLowerCase().includes(search),
          )
          .sort((a, b) => (a.name > b.name ? 1 : -1))
          .map((hair) => (
            <Stack.Item
              key={hair.name}
              className={`Picker${active === hair.icon ? ' Active' : ''}`}
            >
              <Tooltip content={hair.name}>
                <Box
                  position="relative"
                  onClick={() => action({ name: hair.name })}
                >
                  <DmIcon
                    icon={icon}
                    icon_state={`${hair.icon}_s`}
                    height="64px"
                    width="64px"
                    style={{ filter: `drop-shadow(0px 1000px 0 ${color})` }}
                  />
                </Box>
              </Tooltip>
            </Stack.Item>
          ))}
      </Stack>
    </Section>
  );
};
