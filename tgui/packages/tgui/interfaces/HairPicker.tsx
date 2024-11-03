import { useBackend } from '../backend';
import { DmIcon, Stack } from '../components';
import { Window } from '../layouts';

type HairPickerData = {
  icon: string;
  hair_styles: { name: string; icon_state: string }[];
  hair_style: string;
};

export const HairPicker = () => {
  const { act, data } = useBackend<HairPickerData>();

  const { icon, hair_styles } = data;

  return (
    <Window width={400} height={200} theme={'crtblue'}>
      <Window.Content scrollable>
        <Stack wrap="wrap" width="400px">
          {hair_styles.map((hair) => (
            <Stack.Item key={hair.name}>
              <DmIcon icon={icon} icon_state={hair.icon_state} />
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};
