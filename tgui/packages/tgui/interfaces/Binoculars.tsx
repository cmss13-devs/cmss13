import { useBackend } from 'tgui/backend';
import { Box, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = { xcoord: number; ycoord: number; zcoord: number };

export const Binoculars = () => {
  const { data } = useBackend<Data>();

  const x_coord = data.xcoord;
  const y_coord = data.ycoord;
  const z_coord = data.zcoord;

  return (
    <Window width={450} height={200}>
      <Window.Content scrollable>
        <Section
          title="SIMPLIFIED COORDINATES OF TARGET"
          textAlign="center"
          fontSize="15px"
        >
          <Box fontSize="30px">
            LONGITUDE : {x_coord}, LATITUDE : {y_coord}, HEIGHT : {z_coord}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
