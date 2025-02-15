import { round } from 'common/math';

import { useBackend } from '../backend';
import {
  Button,
  Flex,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

const stats = [
  ['good', 'Alive'],
  ['average', 'Critical'],
  ['bad', 'DEAD'],
];

const damages = [
  ['Brute', 'bruteLoss'],
  ['Burn', 'fireLoss'],
  ['Toxin', 'toxLoss'],
  ['Oxygen', 'oxyLoss'],
];

const damageRange = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

export const Autodoc = (props) => {
  const { act, data } = useBackend();
  const { hasOccupant } = data;
  const body = hasOccupant ? <AutodocMain /> : <AutodocEmpty />;
  const windowHeight = hasOccupant ? 675 : 150;
  return (
    <Window resizable width={500} height={windowHeight}>
      <Window.Content className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};

const AutodocMain = (props) => {
  const { act, data } = useBackend();
  const { surgeries } = data;
  const research =
    surgeries['broken'] !== undefined ||
    surgeries['internal'] !== undefined ||
    surgeries['organdamage'] !== undefined ||
    surgeries['larva'] !== undefined;
  return (
    <>
      <AutodocOccupant />
      <AutodocDamage />
      <AutodocControls />
      <AutodocSurgeries />
      {research && <AutodocSurgeriesEx />}
    </>
  );
};

const AutodocOccupant = (props) => {
  const { act, data } = useBackend();
  const { occupant, auto_eject_dead } = data;
  return (
    <Section
      title="Occupant"
      buttons={
        <Button icon="user-slash" onClick={() => act('ejectify')}>
          Eject
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
        <LabeledList.Item label="Health">
          <ProgressBar
            min="0"
            max={occupant.maxHealth}
            value={occupant.health / occupant.maxHealth}
            ranges={{
              good: [0.5, Infinity],
              average: [0, 0.5],
              bad: [-Infinity, 0],
            }}
          >
            {round(occupant.health, 0)}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Status" color={stats[occupant.stat][0]}>
          {stats[occupant.stat][1]}
        </LabeledList.Item>
        {!!occupant.hasBlood && (
          <>
            <LabeledList.Item label="Blood Level">
              <ProgressBar
                min="0"
                max={occupant.bloodMax}
                value={occupant.bloodLevel / occupant.bloodMax}
                ranges={{
                  bad: [-Infinity, 0.6],
                  average: [0.6, 0.9],
                  good: [0.6, Infinity],
                }}
              >
                {occupant.bloodPercent}%, {occupant.bloodLevel}cl
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Pulse" verticalAlign="middle">
              {occupant.pulse} BPM
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};

const AutodocDamage = (props) => {
  const { data } = useBackend();
  const { occupant } = data;
  return (
    <Section title="Occupant Damage">
      <LabeledList>
        {damages.map((d, i) => (
          <LabeledList.Item key={i} label={d[0]}>
            <ProgressBar
              key={i}
              min="0"
              max="100"
              value={occupant[d[1]] / 100}
              ranges={damageRange}
            >
              {round(occupant[d[1]], 0)}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const AutodocControls = (props) => {
  const { act, data } = useBackend();
  const { surgery, surgeries } = data;
  return (
    <Section>
      <Flex>
        <Flex.Item>
          <Button
            onClick={() => act('surgery')}
            disabled={!!surgery}
            px="15px"
            py="12px"
            backgroundColor="#10b310"
          >
            Begin Surgery
          </Button>
        </Flex.Item>
        <Flex.Item>
          <Button
            onClick={() => act('clear')}
            disabled={!!surgery}
            icon="trash-can"
            iconPosition="right"
          >
            Clear selected
          </Button>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const AutodocSurgeries = (props) => {
  const { act, data } = useBackend();
  const {
    surgery,
    surgeries,
    filtering,
    blood_transfer,
    heal_brute,
    heal_burn,
    heal_toxin,
  } = data;
  const research =
    surgeries['broken'] !== undefined ||
    surgeries['internal'] !== undefined ||
    surgeries['organdamage'] !== undefined ||
    surgeries['larva'] !== undefined;
  return (
    <>
      <Section title="Trauma Surgeries">
        <Flex>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={surgeries['brute'] === 1 || !!heal_brute}
              disabled={!!surgery}
              onClick={() => act('brute')}
            >
              Brute Damage Treatment
              {(surgeries['brute'] === 1 || !!heal_brute) && (
                <Icon
                  name={
                    heal_brute && surgery
                      ? 'arrows-rotate'
                      : surgeries['brute'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={surgeries['burn'] === 1 || !!heal_burn}
              disabled={!!surgery}
              onClick={() => act('burn')}
            >
              Burn Damage Treatment
              {(surgeries['burn'] === 1 || !!heal_burn) && (
                <Icon
                  name={
                    heal_burn && surgery
                      ? 'arrows-rotate'
                      : surgeries['burn'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
        </Flex>
        <Flex>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={surgeries['open'] === 1}
              disabled={!!surgery}
              onClick={() => act('open')}
            >
              Close Open Incisions
              {surgeries['open'] === 1 && (
                <Icon
                  name={
                    surgery && surgeries['open'] === 1
                      ? 'hourglass'
                      : surgeries['open'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={surgeries['shrapnel'] === 1}
              disabled={!!surgery}
              onClick={() => act('shrapnel')}
            >
              Shrapnel Removal Surgery
              {surgeries['shrapnel'] === 1 && (
                <Icon
                  name={
                    surgery && surgeries['shrapnel'] === 1
                      ? 'hourglass'
                      : surgeries['shrapnel'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
        </Flex>
      </Section>
      <Section title="Hematology Treatments">
        <Flex>
          <Flex.Item grow="2">
            <Button
              fluid
              mx="3px"
              selected={surgeries['blood'] === 1 || !!blood_transfer}
              disabled={!!surgery}
              onClick={() => act('blood')}
            >
              Blood Transfusion
              {(surgeries['blood'] === 1 || !!blood_transfer) && (
                <Icon
                  name={
                    blood_transfer && surgery
                      ? 'arrows-rotate'
                      : surgeries['blood'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={surgeries['dialysis'] === 1 || !!filtering}
              disabled={!!surgery}
              onClick={() => act('dialysis')}
            >
              Dialysis
              {(surgeries['dialysis'] === 1 || !!filtering) && (
                <Icon
                  name={
                    filtering && surgery
                      ? 'arrows-rotate'
                      : surgeries['dialysis'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
          <Flex.Item grow="3">
            <Button
              fluid
              mx="3px"
              selected={surgeries['toxin'] === 1 || !!heal_toxin}
              disabled={!!surgery}
              onClick={() => act('toxin')}
            >
              Bloodstream Toxin Removal
              {(surgeries['toxin'] === 1 || !!heal_toxin) && (
                <Icon
                  name={
                    heal_toxin && surgery
                      ? 'arrows-rotate'
                      : surgeries['toxin'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
        </Flex>
      </Section>
    </>
  );
};

const AutodocSurgeriesEx = (props) => {
  const { act, data } = useBackend();
  const { surgery, surgeries } = data;
  return (
    <Section title="Orthopedic Surgeries">
      <Flex>
        {surgeries['internal'] !== undefined && (
          <Flex.Item basis="50%">
            <Button
              fluid
              mx="3px"
              selected={surgeries['internal'] === 1}
              disabled={!!surgery}
              onClick={() => act('internal')}
            >
              Internal Bleeding Surgery
              {surgeries['internal'] === 1 && (
                <Icon
                  name={
                    surgery && surgeries['internal'] === 1
                      ? 'hourglass'
                      : surgeries['internal'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
        )}
        {surgeries['broken'] !== undefined && (
          <Flex.Item basis="50%">
            <Button
              fluid
              mx="3px"
              selected={surgeries['broken'] === 1}
              disabled={!!surgery}
              onClick={() => act('broken')}
            >
              Broken Bone Surgery
              {surgeries['broken'] === 1 && (
                <Icon
                  name={
                    surgery && surgeries['broken'] === 1
                      ? 'hourglass'
                      : surgeries['broken'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
        )}
      </Flex>
      <Flex>
        {surgeries['organdamage'] !== undefined && (
          <Flex.Item basis="50%">
            <Button
              fluid
              mx="3px"
              selected={surgeries['organdamage'] === 1}
              disabled={!!surgery}
              onClick={() => act('organdamage')}
            >
              Organ Damage Treatment
              {surgeries['organdamage'] === 1 && (
                <Icon
                  name={
                    surgery && surgeries['organdamage'] === 1
                      ? 'hourglass'
                      : surgeries['organdamage'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
        )}
        {surgeries['larva'] !== undefined && (
          <Flex.Item basis="50%">
            <Button
              fluid
              mx="3px"
              selected={surgeries['larva'] === 1}
              disabled={!!surgery}
              onClick={() => act('larva')}
            >
              Parasite Extraction
              {surgeries['larva'] === 1 && (
                <Icon
                  name={
                    surgery && surgeries['larva'] === 1
                      ? 'hourglass'
                      : surgeries['larva'] === 1 && 'plus'
                  }
                  position="absolute"
                  right="1px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
        )}
      </Flex>
    </Section>
  );
};

const AutodocEmpty = (props) => {
  return (
    <Section textAlign="center">
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size="5" />
          <br />
          No occupant detected.
        </Flex.Item>
      </Flex>
    </Section>
  );
};
