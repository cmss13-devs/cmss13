import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = { xcoord: number; ycoord: number; zcoord: number };

export const Binoculars = () => {
  const { data } = useBackend<Data>();

  const x_coord = data.xcoord;
  const y_coord = data.ycoord;
  const z_coord = data.zcoord;

  const coordinatesString = `LONGTITUDE: ${x_coord}, LATITUDE: ${y_coord}, HEIGHT: ${z_coord}`;

  return (
    <Window width={450} height={300}>
      <Window.Content scrollable>
        <Section
          fill
          title="SIMPLIFIED COORDINATES OF TARGET"
          textAlign="center"
          fontSize="15px"
        >
          <Box fontSize="30px" mb={2}>
            LONGITUDE : {x_coord}, LATITUDE : {y_coord}, HEIGHT : {z_coord}
          </Box>
          <Button
            align="center"
            minWidth="70%"
            icon="clipboard"
            tooltip="Copies recorded coordinates to clipboard"
            fontSize="20px"
            onClick={() => navigator.clipboard.writeText(coordinatesString)}
          >
            Copy Coordinates
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
