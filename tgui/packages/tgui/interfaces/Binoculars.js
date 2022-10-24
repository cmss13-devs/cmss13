import { useBackend } from '../backend';
import { Section, Box } from '../components';
import { Window } from '../layouts';

export const Binoculars = (_props, context) => {
  const { data } = useBackend(context);

  const x_coord = data.xcoord;
  const y_coord = data.ycoord;

  return (
    <Window width={450} height={200}>
      <Window.Content scrollable>
        <Section
          title="SIMPLIFIED COORDINATES OF TARGET"
          textAlign="center"
          fontSize="15px">
          <Box fontSize="30px">
            LONGITUDE : {x_coord}, LATITUDE : {y_coord}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
