import { useBackend } from '../backend';
import { Box, DmIcon, Section, Stack, Tooltip } from '../components';
import { Window } from '../layouts';

type HairPickerData = {
  hair_icon: string;
  facial_hair_icon: string;
  hair_styles: { name: string; icon: string }[];
  hair_style: string;
  facial_hair_styles: { name: string; icon: string }[];
  facial_hair: string;
};

export const HairPicker = () => {
  const { act, data } = useBackend<HairPickerData>();

  const {
    hair_icon,
    hair_style,
    hair_styles,
    facial_hair_icon,
    facial_hair,
    facial_hair_styles,
  } = data;

  const height = facial_hair_styles.length > 0 ? 550 : 290;

  return (
    <Window width={400} height={height} theme={'crtblue'}>
      <Window.Content className="HairPicker">
        <PickerElement
          name="Hair"
          icon={hair_icon}
          hair={hair_styles}
          active={hair_style}
        />
        <PickerElement
          name="Facial Hair"
          icon={facial_hair_icon}
          hair={facial_hair_styles}
          active={facial_hair}
        />
      </Window.Content>
    </Window>
  );
};

const PickerElement = (props: {
  readonly name: string;
  readonly icon: string;
  readonly active: string;
  readonly hair: { icon: string; name: string }[];
}) => {
  const { name, icon, hair, active } = props;

  return (
    <Section title={name} height="250px" scrollable>
      <Stack wrap="wrap" height="200px" width="400px">
        {hair.map((facial_hair) => (
          <Stack.Item
            key={facial_hair.name}
            className={`Picker${active === facial_hair.icon ? ' Active' : ''}`}
          >
            <Tooltip content={facial_hair.name}>
              <Box position="relative">
                <DmIcon
                  icon={icon}
                  icon_state={`${facial_hair.icon}_s`}
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
