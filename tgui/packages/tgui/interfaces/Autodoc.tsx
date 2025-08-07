import { round } from 'common/math';
import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Flex,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

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

const damageRange: Record<string, [number, number]> = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

type HumanData = {
  pulse: number;
  bloodLevel: number;
  bloodMax: number;
  bloodPercent: number;
};

type OccupantData = {
  name: string;
  stat: number;
  health: number;
  maxHealth: number;
  minHealth: number;
  bruteLoss: number;
  oxyLoss: number;
  toxLoss: number;
  fireLoss: number;
  hasBlood: BooleanLike;
  totalReagents: number;
} & Partial<HumanData>;

type Data = {
  connected: string | null;
  connected_operable: BooleanLike;
  hasOccupant: BooleanLike;
  occupant: OccupantData;
  surgery: BooleanLike;
  surgeries: BooleanLike[];
  filtering: BooleanLike;
  blood_transfer: BooleanLike;
  heal_brute: BooleanLike;
  heal_burn: BooleanLike;
  heal_toxin: BooleanLike;
};

export const Autodoc = (props) => {
  const { data } = useBackend<Data>();
  const { hasOccupant } = data;
  const body = hasOccupant ? <AutodocMain /> : <AutodocEmpty />;
  const windowHeight = hasOccupant ? 700 : 150;
  return (
    <Window width={500} height={windowHeight}>
      <Window.Content className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};

const AutodocMain = (props) => {
  const { data } = useBackend<Data>();
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
  const { data } = useBackend<Data>();
  const { occupant } = data;
  return (
    <Section title="Occupant">
      <LabeledList>
        <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
        <LabeledList.Item label="Health">
          <ProgressBar
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
                value={occupant.bloodLevel! / occupant.bloodMax!}
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
        <LabeledList.Item label="Reagents">
          <ProgressBar
            value={occupant.totalReagents / 60}
            ranges={{
              bad: [1, Infinity],
              average: [0.11, 0.99],
            }}
          >
            {round(occupant.totalReagents, 1)}
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const AutodocDamage = (props) => {
  const { data } = useBackend<Data>();
  const { occupant } = data;
  return (
    <Section title="Occupant Damage">
      <LabeledList>
        {damages.map((d, i) => (
          <LabeledList.Item key={i} label={d[0]}>
            <ProgressBar
              key={i}
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
  const { act, data } = useBackend<Data>();
  const { surgery } = data;
  return (
    <Section>
      <Flex justify="space-between">
        <Flex.Item>
          <Button
            onClick={() => act('surgery')}
            disabled={surgery}
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
            disabled={surgery}
            icon="trash-can"
            iconPosition="right"
          >
            Clear selected
          </Button>
        </Flex.Item>
        <Flex.Item>
          <Button
            onClick={() => act('ejectify')}
            icon={surgery ? 'triangle-exclamation' : 'user-slash'}
            iconPosition="right"
            backgroundColor={!!surgery && 'red'}
          >
            Eject patient
          </Button>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const AutodocSurgeries = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    surgery,
    surgeries,
    filtering,
    blood_transfer,
    heal_brute,
    heal_burn,
    heal_toxin,
  } = data;
  const brute_active = !!surgeries['brute'] || !!heal_brute;
  const burn_active = !!surgeries['burn'] || !!heal_burn;
  const toxin_active = !!surgeries['toxin'] || !!heal_toxin;
  const blood_active = !!surgeries['blood'] || !!blood_transfer;
  const dialysis_active = !!surgeries['dialysis'] || !!filtering;
  return (
    <>
      <Section title="Trauma Surgeries">
        <Flex>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={brute_active}
              disabled={surgery}
              onClick={() => !brute_active && act('brute')}
            >
              Brute Damage Treatment
              {brute_active && (
                <Icon
                  name={surgery ? 'arrows-rotate' : 'plus'}
                  position="absolute"
                  right="0px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={burn_active}
              disabled={surgery}
              onClick={() => !burn_active && act('burn')}
            >
              Burn Damage Treatment
              {burn_active && (
                <Icon
                  name={surgery ? 'arrows-rotate' : 'plus'}
                  position="absolute"
                  right="0px"
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
              selected={surgeries['open']}
              disabled={surgery}
              onClick={() => !surgeries['open'] && act('open')}
            >
              Close Open Incisions
              {!!surgeries['open'] && (
                <Icon
                  name={surgery ? 'hourglass' : 'plus'}
                  position="absolute"
                  right="0px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={surgeries['shrapnel']}
              disabled={surgery}
              onClick={() => !surgeries['shrapnel'] && act('shrapnel')}
            >
              Shrapnel Removal Surgery
              {!!surgeries['shrapnel'] && (
                <Icon
                  name={surgery ? 'hourglass' : 'plus'}
                  position="absolute"
                  right="0px"
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
              selected={blood_active}
              disabled={surgery}
              onClick={() => !blood_active && act('blood')}
            >
              Blood Transfusion
              {blood_active && (
                <Icon
                  name={surgery ? 'arrows-rotate' : 'plus'}
                  position="absolute"
                  right="0px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
          <Flex.Item grow="1">
            <Button
              fluid
              mx="3px"
              selected={dialysis_active}
              disabled={surgery}
              onClick={() => !dialysis_active && act('dialysis')}
            >
              Dialysis
              {dialysis_active && (
                <Icon
                  name={surgery ? 'arrows-rotate' : 'plus'}
                  position="absolute"
                  right="0px"
                  top="4px"
                />
              )}
            </Button>
          </Flex.Item>
          <Flex.Item grow="3">
            <Button
              fluid
              mx="3px"
              selected={toxin_active}
              disabled={surgery}
              onClick={() => !toxin_active && act('toxin')}
            >
              Bloodstream Toxin Removal
              {toxin_active && (
                <Icon
                  name={surgery ? 'arrows-rotate' : 'plus'}
                  position="absolute"
                  right="0px"
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
  const { act, data } = useBackend<Data>();
  const { surgery, surgeries } = data;
  return (
    <Section title="Orthopedic Surgeries">
      <Flex>
        {surgeries['internal'] !== undefined && (
          <Flex.Item basis="50%">
            <Button
              fluid
              mx="3px"
              selected={surgeries['internal']}
              disabled={surgery}
              onClick={() => !surgeries['internal'] && act('internal')}
            >
              Internal Bleeding Surgery
              {!!surgeries['internal'] && (
                <Icon
                  name={surgery ? 'hourglass' : 'plus'}
                  position="absolute"
                  right="0px"
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
              selected={surgeries['broken']}
              disabled={surgery}
              onClick={() => !surgeries['broken'] && act('broken')}
            >
              Broken Bone Surgery
              {!!surgeries['broken'] && (
                <Icon
                  name={surgery ? 'hourglass' : 'plus'}
                  position="absolute"
                  right="0px"
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
              selected={surgeries['organdamage']}
              disabled={surgery}
              onClick={() => !surgeries['organdamage'] && act('organdamage')}
            >
              Organ Damage Treatment
              {!!surgeries['organdamage'] && (
                <Icon
                  name={surgery ? 'hourglass' : 'plus'}
                  position="absolute"
                  right="0px"
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
              selected={surgeries['larva']}
              disabled={surgery}
              onClick={() => !surgeries['larva'] && act('larva')}
            >
              Parasite Extraction
              {!!surgeries['larva'] && (
                <Icon
                  name={surgery ? 'hourglass' : 'plus'}
                  position="absolute"
                  right="0px"
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
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No occupant detected.
        </Flex.Item>
      </Flex>
    </Section>
  );
};
