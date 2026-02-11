import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  ProgressBar,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  patient: string;
  status: number;
  health: number;
  total_brute: number;
  total_burn: number;
  total_toxin: number;
  total_oxy: number;
  revival_timer: number;
};

export const DummyTablet = () => {
  const { act, data } = useBackend<Data>();

  return (
    <Window width={350} height={417} theme="crtgreen">
      <Window.Content scrollable>
        <Section>
          <Flex height="100%" direction="column">
            <Flex.Item ml="2px" mr="5px" bold fontFamily="monospace">
              {data.patient}
            </Flex.Item>
            <Divider />
            <Flex.Item width="99.5%" mb="2px">
              <ProgressBar
                value={data.health / 100}
                textAlign="left"
                fontFamily="monospace"
                bold
                textColor={data.health >= 95 ? 'black' : 'hsl(140, 100%, 46%)'}
              >
                {data.health}% Healthy
              </ProgressBar>
            </Flex.Item>
            <Flex.Item width="100%" align="center" fontSize="11px">
              <Flex direction="row">
                <Button compact width="75%">
                  Status: [ {data.status === 3 ? 'DECEASED' : 'ALIVE'} ]
                </Button>
                <Button
                  width="25%"
                  icon="skull"
                  backgroundColor="transparent"
                  color="hsl(140, 100%, 46%)"
                >
                  Kill
                </Button>
              </Flex>
            </Flex.Item>
            <Flex.Item width="100%">
              <Flex direction="row">
                <Button
                  width="80%"
                  backgroundColor="transparent"
                  color="hsl(140, 100%, 46%)"
                  compact
                  fontSize="11px"
                  verticalAlignContent="middle"
                >
                  Revival timer: {data.revival_timer} seconds
                </Button>
                <Button
                  width="20%"
                  fontSize="10px"
                  compact
                  textAlign="center"
                  verticalAlignContent="middle"
                  onClick={() => act('set_revival_time')}
                >
                  Set
                </Button>
              </Flex>
            </Flex.Item>
          </Flex>
          <Divider />
          <Flex
            direction="row"
            width="100%"
            justify="space-around"
            fontFamily="monospace"
            nowrap
            align="center"
            fontSize="10px"
            bold
          >
            <Flex.Item color="red">[ Brute: {data.total_brute} ]</Flex.Item>
            <Flex.Item color="orange">[ Burn: {data.total_burn} ]</Flex.Item>
            <Flex.Item>[ Toxin: {data.total_toxin} ]</Flex.Item>
            <Flex.Item color="blue">[ Oxygen: {data.total_oxy} ]</Flex.Item>
          </Flex>
          <Divider />
          <Flex direction="row">
            <Flex.Item width="50%">
              <Flex direction="column" fontSize="10px">
                <Box fontSize="11px" bold mb="5px">
                  General Damage Types
                </Box>
                <Button compact onClick={() => act('brute_damage_limb')}>
                  - Set Brute Damage
                </Button>
                <Button compact onClick={() => act('burn_damage')}>
                  - Set Burn Damage
                </Button>
                <Button compact onClick={() => act('toxin')}>
                  - Set Toxin Damage
                </Button>
                <Button compact>- Set Oxygen Damage</Button>
                <Button compact onClick={() => act('blood_loss')}>
                  - Set Blood Levels
                </Button>
              </Flex>
            </Flex.Item>
            <Flex.Item width="50%">
              <Flex direction="column" fontSize="10px">
                <Box fontSize="11px" bold mb="5px">
                  Limb Damage Types
                </Box>
                <Button compact onClick={() => act('bones')}>
                  - Break Bones
                </Button>
                <Button compact onClick={() => act('eshar')}>
                  - Inflict Eschar
                </Button>
                <Button compact onClick={() => act('shrapnel')}>
                  - Shrapnel
                </Button>
                <Button compact onClick={() => act('delimb')}>
                  - Delimb
                </Button>
                <Button compact onClick={() => act('bleeding')}>
                  - Internal Bleeding
                </Button>
              </Flex>
            </Flex.Item>
          </Flex>
          <Flex direction="column" fontSize="10px" mt="3px">
            <Box fontSize="11px" bold mb="5px">
              Internal Damage
            </Box>
            <Button compact onClick={() => act('brute_damage_organ')}>
              - Set Organ Damage
            </Button>
            <Button compact onClick={() => act('simulate_parasite')}>
              - Simulate embryo
            </Button>
          </Flex>
          <Divider />
          <Button
            mt="3px"
            width="100%"
            textAlign="center"
            bold
            onClick={() => act('randomize_condition')}
          >
            - Randomize Condition -
          </Button>
          <Button
            mt="0px"
            width="100%"
            textAlign="center"
            bold
            backgroundColor="transparent"
            color="hsl(140, 100%, 46%)"
            compact
            onClick={() => act('reset')}
          >
            RESET
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
