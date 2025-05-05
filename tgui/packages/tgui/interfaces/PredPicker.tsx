import { hexToHsva, type HsvaColor, hsvaToHex } from 'common/color';
import type { BooleanLike } from 'common/react';
import { capitalizeFirst } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  DmIcon,
  Dropdown,
  Icon,
  LabeledList,
  Modal,
  NumberInput,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import { ColorSelector } from './ColorPickerModal';
import { HairPickerElement } from './HairPicker';

type PredData = {
  name: string;
  gender: string;
  age: number;
  hair_style: string;
  skin_color: string;
  flavor_text: string;
  yautja_status: string;
  available_statuses: string[];

  can_use_legacy: BooleanLike;
  use_legacy: string;
  translator_type: string;
  invisibility_sound: string;

  cape_color: string;

  armor_icon: string;
  armor_type: number;
  armor_types: number;
  armor_material: string;

  mask_icon: string;
  mask_type: number;
  mask_types: number;
  mask_material: string;

  greave_icon: string;
  greave_type: number;
  greave_types: number;
  greave_material: string;

  caster_icon: string;
  caster_prefix: string;
  caster_material: string;

  mask_accessory_icon: string;
  mask_accessory_type: number;
  mask_accessory_types: number;

  hair_icon: string;
  hair_styles: { name: string; icon: string }[];

  skin_colors: { [key: string]: string };

  materials: string[];
  translators: string[];
  invisibility_sounds: string[];
  legacies: string[];
};

type ModalOptions =
  | 'hair'
  | 'skin'
  | 'armor'
  | 'greaves'
  | 'mask'
  | 'mask_accessory'
  | 'caster'
  | 'cape_color';

export const PredPicker = () => {
  const { data, act } = useBackend<PredData>();

  const {
    name,
    gender,
    age,
    hair_icon,
    hair_style,
    hair_styles,
    flavor_text,
    skin_colors,
    skin_color,
    available_statuses,
    yautja_status,
  } = data;

  const selectedHair = hair_styles.filter(
    (hair) => hair.name === hair_style,
  )[0];

  const [modal, setModal] = useState<ModalOptions | false>(false);

  return (
    <Window height={600} width={700} theme="ntos_spooky">
      <Window.Content className="PredPicker">
        <Section title="Yautja Information">
          <Stack>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Name">
                  <Button.Input
                    onCommit={(_, value) => act('name', { name: value })}
                  >
                    {name}
                  </Button.Input>
                </LabeledList.Item>
                <LabeledList.Item label="Gender">
                  <Button onClick={() => act('gender')}>
                    {capitalizeFirst(gender)}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Age">
                  <NumberInput
                    step={1}
                    value={age}
                    minValue={175}
                    maxValue={3000}
                    onChange={(val) => act('age', { age: val })}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Flavor Text">
                  <Button onClick={() => act('flavor_text')}>
                    {flavor_text.length > 0
                      ? flavor_text.substring(0, 10) + '...'
                      : 'None'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Skin Color">
                  <Button onClick={() => setModal('skin')}>
                    <ColorBox color={skin_colors[skin_color]} />
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Yautja Status">
                  <Dropdown
                    selected={yautja_status}
                    options={available_statuses}
                    onSelected={(selected) =>
                      act('yautja_status', { selected: selected })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <Button tooltip="Select Quill" onClick={() => setModal('hair')}>
                <DmIcon
                  icon={hair_icon}
                  icon_state={`${selectedHair.icon}_s`}
                  width="64px"
                />
              </Button>
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="Equipment">
          <PredEquipment pick={setModal} />
        </Section>
        {modal && (
          <Modal>
            <PredModal type={modal} close={() => setModal(false)} />
          </Modal>
        )}
      </Window.Content>
    </Window>
  );
};

const PredEquipment = (props: { readonly pick: (_: ModalOptions) => void }) => {
  const { pick } = props;

  const { act, data } = useBackend<PredData>();

  const {
    armor_icon,
    armor_type,
    armor_material,

    mask_icon,
    mask_type,
    mask_material,

    greave_icon,
    greave_type,
    greave_material,

    caster_icon,
    caster_material,
    caster_prefix,

    mask_accessory_icon,
    mask_accessory_type,
    mask_accessory_types,

    can_use_legacy,

    translators,
    translator_type,
    invisibility_sounds,
    invisibility_sound,

    legacies,
    use_legacy,
  } = data;

  return (
    <Stack vertical>
      <Stack.Item>
        <Stack fill>
          <Stack.Item grow>
            <Button
              fluid
              tooltip="Customize Armor"
              onClick={() => pick('armor')}
            >
              <Stack justify="center">
                <Stack.Item>
                  <DmIcon
                    icon={armor_icon}
                    icon_state={`halfarmor${armor_type}_${armor_material}`}
                    height="128px"
                  />
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button fluid tooltip="Customize Mask" onClick={() => pick('mask')}>
              <Stack justify="center">
                <Stack.Item>
                  <DmIcon
                    icon={mask_icon}
                    icon_state={`pred_mask${mask_type}_${mask_material}`}
                    height="128px"
                  />
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              tooltip="Customize Greaves"
              onClick={() => pick('greaves')}
            >
              <Stack justify="center">
                <Stack.Item>
                  <DmIcon
                    icon={greave_icon}
                    icon_state={`y-boots${greave_type}_${greave_material}`}
                    height="128px"
                  />
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item>
        <Stack fill>
          <Stack.Item grow>
            <Button
              fluid
              tooltip="Select Plasma Caster"
              onClick={() => pick('caster')}
            >
              <Stack justify="center">
                <Stack.Item>
                  <DmIcon
                    icon={caster_icon}
                    icon_state={`${caster_prefix}_${caster_material}`}
                    height="128px"
                  />
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              height={11}
              tooltip="Select Mask Accessory"
              onClick={() => pick('mask_accessory')}
            >
              <Stack justify="center">
                <Stack.Item>
                  {mask_accessory_type > 0 ? (
                    <DmIcon
                      icon={mask_accessory_icon}
                      icon_state={`pred_accessory${mask_accessory_types}_${mask_material}`}
                      height="128px"
                    />
                  ) : (
                    <Icon name="x" size={5} mt={5} />
                  )}
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item>
        <Box width="150px">
          <LabeledList>
            <LabeledList.Item label="Translator Type">
              <Dropdown
                options={translators}
                selected={translator_type}
                onSelected={(val) => act('translator_type', { selected: val })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Invisibility Sound">
              <Dropdown
                options={invisibility_sounds}
                selected={invisibility_sound}
                onSelected={(val) =>
                  act('invisibility_sound', { selected: val })
                }
              />
            </LabeledList.Item>
            {!!can_use_legacy && (
              <LabeledList.Item labelWrap label="Legacy">
                <Dropdown
                  options={legacies}
                  selected={use_legacy}
                  onSelected={(val) => act('legacy', { selected: val })}
                />
              </LabeledList.Item>
            )}
            <LabeledList.Item label="Cape Color">
              <Button onClick={() => pick('cape_color')}>
                <ColorBox color={data.cape_color} />
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Box>
      </Stack.Item>
    </Stack>
  );
};

const PredItem = (props: {
  readonly title: string;
  readonly icon: string;
  readonly selected_type: number;
  readonly selected_material: string;
  readonly available_types: number;
  readonly prefix: string;
  readonly close: () => void;
  readonly action: string;
}) => {
  const { act, data } = useBackend<PredData>();

  const {
    icon,
    selected_type,
    selected_material,
    available_types,
    prefix,
    title,
    close,
    action,
  } = props;

  const { materials } = data;

  return (
    <Section
      title={title}
      buttons={<Button icon="x" onClick={() => close()} />}
    >
      <Stack>
        <Stack.Item style={{ backgroundColor: '#66031C' }}>
          <DmIcon
            icon={icon}
            icon_state={`${prefix}${selected_type}_${selected_material}`}
            height="128px"
          />
        </Stack.Item>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              <Stack wrap width="500px">
                {Array.from({ length: available_types }).map((num, i) => (
                  <Button
                    tooltip={i + 1}
                    selected={selected_type === i + 1}
                    key={i}
                    onClick={() => act(`${action}_type`, { type: i + 1 })}
                  >
                    <DmIcon
                      icon={icon}
                      icon_state={`${prefix}${i + 1}_${selected_material}`}
                      height="64px"
                    />
                  </Button>
                ))}
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                {materials.map((material) => (
                  <Button
                    key={material}
                    tooltip={capitalizeFirst(material)}
                    selected={selected_material === material}
                    onClick={() =>
                      act(`${action}_material`, { material: material })
                    }
                  >
                    <DmIcon
                      icon={icon}
                      icon_state={`${prefix}${selected_type}_${material}`}
                      height="64px"
                    />
                  </Button>
                ))}
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const PredModal = (props: {
  readonly type: ModalOptions;
  readonly close: () => void;
}) => {
  const { type, close } = props;

  const { data, act } = useBackend<PredData>();

  const {
    hair_icon,
    hair_style,
    hair_styles,

    armor_icon,
    armor_type,
    armor_material,
    armor_types,

    mask_icon,
    mask_type,
    mask_material,
    mask_types,

    greave_icon,
    greave_type,
    greave_material,
    greave_types,

    mask_accessory_icon,
    mask_accessory_type,
    mask_accessory_types,

    caster_material,

    materials,
  } = data;

  switch (type) {
    case 'hair':
      return (
        <HairPickerElement
          name="Quill Style"
          icon={hair_icon}
          active={
            hair_styles.filter((hair) => hair.name === hair_style)[0].icon
          }
          hair={hair_styles}
          action={(style) => act('hair_style', style)}
          close={() => close()}
        />
      );

    case 'skin':
      return <SkinColorPicker close={close} />;

    case 'armor':
      return (
        <PredItem
          title="Armor"
          icon={armor_icon}
          selected_type={armor_type}
          selected_material={armor_material}
          available_types={armor_types}
          prefix="halfarmor"
          close={close}
          action="armor"
        />
      );
    case 'greaves':
      return (
        <PredItem
          title="Greaves"
          icon={greave_icon}
          selected_type={greave_type}
          selected_material={greave_material}
          available_types={greave_types}
          prefix="y-boots"
          close={close}
          action="greaves"
        />
      );
    case 'mask':
      return (
        <PredItem
          title="Mask"
          icon={mask_icon}
          selected_type={mask_type}
          selected_material={mask_material}
          available_types={mask_types}
          prefix="pred_mask"
          close={close}
          action="mask"
        />
      );

    case 'caster':
      return (
        <Section
          title="Caster"
          p={2}
          buttons={<Button icon="x" onClick={() => close()} />}
        >
          <Stack>
            {materials.map((material) => (
              <Stack.Item key={material}>
                <Button
                  selected={material === caster_material}
                  onClick={() => act('caster_material', { material: material })}
                  tooltip={capitalizeFirst(material)}
                >
                  <DmIcon
                    icon={data.caster_icon}
                    icon_state={`${data.caster_prefix}_${material}`}
                    height="96px"
                  />
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      );

    case 'mask_accessory':
      return (
        <Section
          title="Mask Accessory"
          width={40}
          buttons={<Button icon="x" onClick={() => close()} />}
        >
          <Stack>
            {Array.from({ length: mask_accessory_types + 1 }).map(
              (_, index) => (
                <Stack.Item key={index}>
                  <Button
                    tooltip={index === 0 ? 'Unequipped' : index}
                    selected={mask_accessory_type === index}
                    onClick={() => act('mask_accessory', { type: index })}
                  >
                    <Stack align="center">
                      <Stack.Item width="96px" height="96px">
                        {index === 0 ? (
                          <Icon name="x" size={5} p={3} pl={6.5} />
                        ) : (
                          <DmIcon
                            icon={mask_accessory_icon}
                            icon_state={`pred_accessory${index}_${mask_material}`}
                            width="96px"
                          />
                        )}
                      </Stack.Item>
                    </Stack>
                  </Button>
                </Stack.Item>
              ),
            )}
          </Stack>
        </Section>
      );

    case 'cape_color':
      return <CapeColorPicker close={close} />;

    default:
      break;
  }
};

const CapeColorPicker = (props: { readonly close: () => void }) => {
  const { close } = props;

  const { act, data } = useBackend<PredData>();
  const { cape_color } = data;

  const [currentColor, setCurrentColor] = useState<HsvaColor>(
    hexToHsva(cape_color || '#000000'),
  );

  return (
    <Box width="500px">
      <ColorSelector
        color={currentColor}
        setColor={setCurrentColor}
        defaultColor={cape_color}
        onConfirm={() => {
          close();
          act(`cape_color`, { color: hsvaToHex(currentColor) });
        }}
      />
    </Box>
  );
};

const SkinColorPicker = (props: { readonly close: () => void }) => {
  const { close } = props;

  const { act, data } = useBackend<PredData>();
  const { skin_colors, skin_color } = data;

  return (
    <Section
      title="Skin Color"
      buttons={<Button icon="x" onClick={() => close()} />}
      p={2}
    >
      <Stack>
        {Object.keys(skin_colors).map((color) => (
          <Stack.Item key={color}>
            <Button
              p={1}
              tooltip={capitalizeFirst(color)}
              onClick={() => act('skin_color', { color: color })}
            >
              <ColorBox p={2} color={skin_colors[color]} />
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
