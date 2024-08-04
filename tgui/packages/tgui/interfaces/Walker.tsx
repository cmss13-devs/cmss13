import { useBackend } from '../backend';
import { Window } from '../layouts';

type OurData = {
  text: string;
};

export const Walker = (props) => {
  const { act, data } = useBackend<OurData>();
  const { text } = data;
  return (
    <Window theme="uscm" height={400} width={200}>
      <Window.Content>{text}</Window.Content>
    </Window>
  );
};
