import { useBackend } from '../backend';
import { Section, Box, ProgressBar } from '../components';
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
    <Window width={450} height={600}>
      <Window.Content scrollable>
        <Section title="SHIP STATUS" textAlign="center" fontSize="15px">
          <ProgressBar value={hull} maxValue={100}>
            <Box textAlign="center">{hull}/100 Hull HP</Box>
          </ProgressBar>
          <ProgressBar value={systems} maxValue={100}>
            <Box textAlign="center">{systems}/100 Hull HP</Box>
          </ProgressBar>
        </Section>
        <Section title="WEAPONS HIT" textAlign="center" fontSize="15px">
          <Box fontSize="15px">TIMES HIT BY MISSILES : {missile}</Box>
          <Box fontSize="15px">TIMES HIT BY RAILGUNS : {railgun}</Box>
          <Box fontSize="15px">TIMES HIY BY O.D.C.s : {odc}</Box>
          <Box fontSize="15px">TIMES HIT BY AA BOILER SHOTS : {aaboiler}</Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
