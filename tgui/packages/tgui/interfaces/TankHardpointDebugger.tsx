import type { BooleanLike } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  NumberInput,
  Section,
  Table,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type WoundRow = {
  family_type: string;
  family_label: string;
  current_tier: number;
  max_tier: number;
  tier_names: string[];
};

type SlotCandidate = {
  type: string;
  name: string;
};

type InstalledInfo = {
  ref: string;
  name: string;
  health_pct: number;
  selected: BooleanLike;
};

type SlotRow = {
  slot: string;
  location: string;
  installed: InstalledInfo | null;
  candidates: SlotCandidate[];
};

type HullData = {
  health: number;
  max_health: number;
  wounds: WoundRow[];
};

type SelectedData = {
  ref: string;
  name: string;
  slot: string;
  health: number;
  max_health: number;
  wounds: WoundRow[];
};

type Data = {
  slots: SlotRow[];
  hull: HullData;
  selected?: SelectedData;
};

export const TankHardpointDebugger = () => {
  const { data } = useBackend<Data>();
  const { slots, hull, selected } = data;

  return (
    <Window width={700} height={700}>
      <Window.Content scrollable>
        <Section title="Hull">
          <HealthEditor
            health={hull.health}
            maxHealth={hull.max_health}
            setAction="set_hull_health"
          />
          <WoundFamiliesEditor
            wounds={hull.wounds}
            setAction="set_hull_wound_tier"
          />
        </Section>
        <Section title="Hardpoint Slots">
          <SlotsTable slots={slots} />
        </Section>
        {selected && (
          <Section title={`Selected: ${selected.name} (${selected.slot})`}>
            <HealthEditor
              health={selected.health}
              maxHealth={selected.max_health}
              setAction="set_health"
            />
            <WoundFamiliesEditor
              wounds={selected.wounds}
              setAction="set_wound_tier"
            />
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

const HealthEditor = (props: {
  readonly health: number;
  readonly maxHealth: number;
  readonly setAction: string;
}) => {
  const { act } = useBackend<Data>();
  const { health, maxHealth, setAction } = props;

  return (
    <Box mb={1}>
      Health:{' '}
      <NumberInput
        animated
        value={health}
        minValue={0}
        maxValue={maxHealth}
        step={5}
        stepPixelSize={5}
        width="80px"
        unit={`/ ${maxHealth}`}
        onDrag={(value) => act(setAction, { value })}
      />
    </Box>
  );
};

const WoundFamiliesEditor = (props: {
  readonly wounds: WoundRow[];
  readonly setAction: string;
}) => {
  const { act } = useBackend<Data>();
  const { wounds, setAction } = props;

  if (!wounds.length) {
    return <Box color="label">No wound families for this slot.</Box>;
  }

  return (
    <Table>
      {wounds.map((wound) => {
        const options = ['Undamaged', ...wound.tier_names];
        const selectedOption = options[wound.current_tier];
        return (
          <Table.Row key={wound.family_type}>
            <Table.Cell>{wound.family_label}</Table.Cell>
            <Table.Cell>
              <Dropdown
                displayText={selectedOption}
                width="180px"
                options={options}
                selected={selectedOption}
                onSelected={(value) => {
                  const tier = options.indexOf(value);
                  act(setAction, {
                    family_type: wound.family_type,
                    tier,
                  });
                }}
              />
            </Table.Cell>
          </Table.Row>
        );
      })}
    </Table>
  );
};

const SlotsTable = (props: { readonly slots: SlotRow[] }) => {
  const { act } = useBackend<Data>();
  const { slots } = props;
  const [chosenType, setChosenType] = useState<Record<string, string>>({});

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Slot</Table.Cell>
        <Table.Cell>Location</Table.Cell>
        <Table.Cell>Installed</Table.Cell>
        <Table.Cell>Install</Table.Cell>
        <Table.Cell />
      </Table.Row>
      {slots.map((row) => {
        const options = row.candidates.map((candidate) => candidate.name);
        const selectedType = chosenType[row.slot] || row.candidates[0]?.type;
        const selectedName = row.candidates.find(
          (candidate) => candidate.type === selectedType,
        )?.name;

        return (
          <Table.Row key={row.slot}>
            <Table.Cell>{row.slot}</Table.Cell>
            <Table.Cell>{row.location}</Table.Cell>
            <Table.Cell>
              {row.installed ? (
                <>
                  {row.installed.name} ({row.installed.health_pct}%)
                  <Button
                    ml={1}
                    icon="crosshairs"
                    selected={!!row.installed.selected}
                    onClick={() =>
                      act('select_hardpoint', { ref: row.installed!.ref })
                    }
                  >
                    Select
                  </Button>
                  <Button.Confirm
                    ml={1}
                    icon="trash"
                    color="bad"
                    onClick={() =>
                      act('remove', { ref: row.installed!.ref })
                    }
                  >
                    Remove
                  </Button.Confirm>
                </>
              ) : (
                <Box color="label">Empty</Box>
              )}
            </Table.Cell>
            <Table.Cell>
              {!!options.length && (
                <Dropdown
                  displayText={selectedName}
                  width="180px"
                  options={options}
                  selected={selectedName}
                  onSelected={(value) => {
                    const candidate = row.candidates.find(
                      (c) => c.name === value,
                    );
                    if (candidate) {
                      setChosenType({
                        ...chosenType,
                        [row.slot]: candidate.type,
                      });
                    }
                  }}
                />
              )}
            </Table.Cell>
            <Table.Cell>
              {!!options.length && (
                <Button
                  icon="wrench"
                  onClick={() => {
                    const candidate = row.candidates.find(
                      (c) => c.name === selectedName,
                    );
                    if (!candidate) {
                      return;
                    }
                    act('install', {
                      type: candidate.type,
                      slot: row.slot,
                      location: row.location,
                    });
                  }}
                >
                  Install
                </Button>
              )}
            </Table.Cell>
          </Table.Row>
        );
      })}
    </Table>
  );
};
