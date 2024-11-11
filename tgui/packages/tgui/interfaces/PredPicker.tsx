import { BooleanLike } from 'common/react';
import { capitalizeFirst } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Button,
  ColorBox,
  DmIcon,
  LabeledList,
  Modal,
  NumberInput,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';
import { HairPickerElement } from './HairPicker';

type PredData = {
  name: string;
  gender: string;
  age: number;
  hair_style: string;
  skin_color: string;
  flavor_text: string;
  yautja_status: string;

  use_legacy: BooleanLike;
  translator_type: string;
  armor_type: number;
  greave_type: number;
  mask_type: number;
  mask_material: string;
  armor_material: string;
  greave_material: string;
  caster_material: string;

  cape_color: string;

  armor_icon: string;
  armor_types: number;

  mask_icon: string;
  mask_types: number;

  greave_icon: string;
  greave_types: number;

  mask_accessory_types: number;

  hair_icon: string;
  hair_styles: { name: string; icon: string }[];

  skin_colors: { [key: string]: string };

  materials: string[];
};

export const PredPicker = () => {
  const { data } = useBackend<PredData>();

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
    yautja_status,
  } = data;

  const selectedHair = hair_styles.filter(
    (hair) => hair.name === hair_style,
  )[0];

  const [modal, setModal] = useState<'hair' | 'skin' | false>(false);

  return (
    <Window height={950} width={700} theme="ntos_spooky">
      <Window.Content className="PredPicker">
        <Section title="Yautja Information">
          <Stack>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Name">
                  <Button.Input>{name}</Button.Input>
                </LabeledList.Item>
                <LabeledList.Item label="Gender">
                  <Button.Input>{capitalizeFirst(gender)}</Button.Input>
                </LabeledList.Item>
                <LabeledList.Item label="Age">
                  <NumberInput value={age} minValue={175} maxValue={3000} />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Flavor Text">
                  {flavor_text.length > 0 ? flavor_text : 'None'}
                </LabeledList.Item>
                <LabeledList.Item label="Skin Color">
                  <Button onClick={() => setModal('skin')}>
                    <ColorBox color={skin_colors[skin_color]} />
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Yautja Status">
                  {yautja_status}
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <Button tooltip="Select Quill" onClick={() => setModal('hair')}>
                <DmIcon
                  icon={hair_icon}
                  icon_state={selectedHair.icon}
                  width="64px"
                />
              </Button>
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="Equipment">
          <PredEquipment />
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

const PredEquipment = () => {
  const { data } = useBackend<PredData>();

  const {
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
  } = data;

  return (
    <Stack vertical>
      <Stack.Item>
        <PredItem
          icon={armor_icon}
          selected_type={armor_type}
          selected_material={armor_material}
          available_types={armor_types}
          prefix="halfarmor"
        />
      </Stack.Item>
      <Stack.Item>
        <PredItem
          icon={mask_icon}
          selected_type={mask_type}
          selected_material={mask_material}
          available_types={mask_types}
          prefix="pred_mask"
        />
      </Stack.Item>
      <Stack.Item>
        <PredItem
          icon={greave_icon}
          selected_type={greave_type}
          selected_material={greave_material}
          available_types={greave_types}
          prefix="y-boots"
        />
      </Stack.Item>
    </Stack>
  );
};

const PredItem = (props: {
  readonly icon: string;
  readonly selected_type: number;
  readonly selected_material: string;
  readonly available_types: number;
  readonly prefix: string;
}) => {
  const { data } = useBackend<PredData>();

  const { icon, selected_type, selected_material, available_types, prefix } =
    props;

  const { materials } = data;

  return (
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
            <Stack wrap width="600px">
              {Array.from({ length: available_types }).map((num, i) => (
                <Button tooltip={i + 1} key={i}>
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
                <Button key={material} tooltip={capitalizeFirst(material)}>
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
  );
};

const PredModal = (props: {
  readonly type: 'hair' | 'skin';
  readonly close: () => void;
}) => {
  const { type, close } = props;

  const { data } = useBackend<PredData>();

  const { hair_icon, hair_style, hair_styles } = data;

  switch (type) {
    case 'hair':
      return (
        <HairPickerElement
          name="Quill Style"
          icon={hair_icon}
          active={hair_style}
          hair={hair_styles}
          action={() => {}}
          close={() => close()}
        />
      );

    case 'skin':
      return <SkinColorPicker close={close} />;

    default:
      break;
  }
};

const SkinColorPicker = (props: { readonly close: () => void }) => {
  const { close } = props;

  const { data } = useBackend<PredData>();
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
            <Button p={1} tooltip={capitalizeFirst(color)}>
              <ColorBox p={2} color={skin_colors[color]} />
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
