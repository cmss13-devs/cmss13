import { useBackend } from '../backend';
import { Section, Box } from '../components';
import { Window } from '../layouts';

export const shiphealthpanelUI = (_props, context) => {
  const { data } = useBackend(context);

  const missile = data.missile;
  const railgun = data.railgun;
  const odc = data.odc;
  const aaboiler = data.aaboiler;
  const hull = data.hull;
  const systems = data.systems;

  return (
    <Window width={450} height={200}>
      <Window.Content scrollable>
        <Section
          title="CURRENT STATUS OF THE MARINE SHIP"
          textAlign="center"
          fontSize="15px">
          <Box fontSize="30px">
            TIMES HIT BY MISSILES : {missile}, TIMES HIT BY RAILGUNS : {railgun}
            , TIMES HIY BY O.D.C.s : {odc}, TIMES HIT BY AA BOILER SHOTS :{' '}
            {aaboiler}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
