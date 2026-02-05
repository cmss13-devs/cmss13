import { useBackend } from 'tgui/backend';
import { Box, Button, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = { xcoord: number; ycoord: number; zcoord: number };

const copyToClipboard = (text) => {
  const textArea = document.createElement('textarea');
  textArea.value = text;
  document.body.appendChild(textArea);
  textArea.select();
  try {
    document.execCommand('copy');
  } catch (err) {
    console.error('Failed to copy text', err);
  }
  document.body.removeChild(textArea);
};

export const Binoculars = () => {
  const { data } = useBackend<Data>();

  const x_coord = data.xcoord;
  const y_coord = data.ycoord;
  const z_coord = data.zcoord;

  const coordinatesString = `LONGTITUDE: ${x_coord}, LATITUDE: ${y_coord}, HEIGHT: ${z_coord}`;

  return (
    <Window width={450} height={300}>
      {' '}
      <Window.Content scrollable>
        <Section
          title="SIMPLIFIED COORDINATES OF TARGET"
          textAlign="center"
          fontSize="15px"
        >
          <Box fontSize="30px" mb={2}>
            LONGITUDE : {x_coord}, LATITUDE : {y_coord}, HEIGHT : {z_coord}
          </Box>
          <Box textAlign="center">
            <Button
              icon="clipboard"
              content="Copy Coordinates"
              tooltip="Copies 'X,Y,Z' to clipboard"
              fontSize="18px"
              onClick={() => copyToClipboard(coordinatesString)}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
