import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { capitalizeFirst } from 'common/string';
import { useBackend, useLocalState } from 'tgui/backend';
import { Box, Button, Collapsible, ColorBox, Icon, Input, LabeledList, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { getDisplayName, isJobOrNameMatch, getHealthColor } from './helpers';
import type { Observable, OrbitData } from './types';

export const Orbit = (props, context) => {
  return (
    <Window title="Orbit" width={500} height={700}>
      <Window.Content scrollable>
        <Stack fill vertical>
          <Stack.Item>
            <ObservableSearch />
          </Stack.Item>
          <Stack.Item mt={0.2} grow>
            <Section fill>
              <ObservableContent />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Controls filtering out the list of observables via search */
const ObservableSearch = (props, context) => {
  const { act, data } = useBackend<OrbitData>(context);
  const {
    auto_observe,
    humans = [],
    marines = [],
    survivors = [],
    xenos = [],
  } = data;
  const [searchQuery, setSearchQuery] = useLocalState<string>(
    context,
    'searchQuery',
    ''
  );
  /** Gets a list of Observables, then filters the most relevant to orbit */
  const orbitMostRelevant = (searchQuery: string) => {
    /** Returns the most orbited observable that matches the search. */
    const mostRelevant: Observable = flow([
      // Filters out anything that doesn't match search
      filter<Observable>((observable) =>
        isJobOrNameMatch(observable, searchQuery)
      ),
      // Sorts descending by orbiters
      sortBy<Observable>((observable) => -(observable.orbiters || 0)),
      // Makes a single Observables list for an easy search
    ])([humans, marines, survivors, xenos].flat())[0];
    if (mostRelevant !== undefined) {
      act('orbit', {
        ref: mostRelevant.ref,
      });
    }
  };

  return (
    <Section>
      <Stack>
        <Stack.Item>
          <Icon name="search" />
        </Stack.Item>
        <Stack.Item grow>
          <Input
            autoFocus
            fluid
            onEnter={(e, value) => orbitMostRelevant(value)}
            onInput={(e) => setSearchQuery(e.target.value)}
            placeholder="Search..."
            value={searchQuery}
          />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <Button
            color="transparent"
            icon="sync-alt"
            onClick={() => act('refresh')}
            tooltip="Refresh"
            tooltipPosition="bottom-start"
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

/**
 * The primary content display for points of interest.
 * Renders a scrollable section replete with subsections for each
 * observable group.
 */
const ObservableContent = (props, context) => {
  const { data } = useBackend<OrbitData>(context);
  const {
    humans = [],
    marines = [],
    survivors = [],
    xenos = [],
    ert_members = [],
    synthetics = [],
    predators = [],
    animals = [],
    dead = [],
    ghosts = [],
    misc = [],
    npcs = [],
    vehicles = [],
    escaped = [],
  } = data;

  return (
    <Stack vertical>
      <ObservableSection color="blue" section={marines} title="Marines" />
      <ObservableSection color="teal" section={humans} title="Humans" />
      <ObservableSection color="xeno" section={xenos} title="Xenomorphs" />
      <ObservableSection color="good" section={survivors} title="Survivors" />
      <ObservableSection
        color="average"
        section={ert_members}
        title="ERT Members"
      />
      <ObservableSection
        color="light-grey"
        section={synthetics}
        title="Synthetics"
      />
      <ObservableSection color="green" section={predators} title="Predators" />
      <ObservableSection color="olive" section={escaped} title="Escaped" />
      <ObservableSection section={vehicles} title="Vehicles" />
      <ObservableSection section={animals} title="Animals" />
      <ObservableSection section={dead} title="Dead" />
      <ObservableSection section={ghosts} title="Ghosts" />
      <ObservableSection section={misc} title="Misc" />
      <ObservableSection section={npcs} title="NPCs" />
    </Stack>
  );
};

/**
 * Displays a collapsible with a map of observable items.
 * Filters the results if there is a provided search query.
 */
const ObservableSection = (
  props: {
    color?: string;
    section: Array<Observable>;
    title: string;
  },
  context
) => {
  const { color, section = [], title } = props;
  if (!section.length) {
    return null;
  }
  const [searchQuery] = useLocalState<string>(context, 'searchQuery', '');
  const filteredSection: Array<Observable> = flow([
    filter<Observable>((observable) =>
      isJobOrNameMatch(observable, searchQuery)
    ),
    sortBy<Observable>((observable) =>
      getDisplayName(observable.full_name, observable.nickname)
        .replace(/^"/, '')
        .toLowerCase()
    ),
  ])(section);
  if (!filteredSection.length) {
    return null;
  }

  return (
    <Stack.Item>
      <Collapsible
        bold
        color={color ?? 'grey'}
        open={!!color}
        title={title + ` - (${filteredSection.length})`}>
        {filteredSection.map((poi, index) => {
          return <ObservableItem color={color} item={poi} key={index} />;
        })}
      </Collapsible>
    </Stack.Item>
  );
};

/** Renders an observable button that has tooltip info for living Observables*/
const ObservableItem = (
  props: { color?: string; item: Observable },
  context
) => {
  const { act } = useBackend<OrbitData>(context);
  const { color, item } = props;
  const { health, icon, full_name, nickname, orbiters, ref, background_color } =
    item;

  return (
    <Button
      color={'transparent'}
      style={{
        'border-color': color ? '#2185d0' : 'grey',
        'border-style': 'solid',
        'border-width': '1px',
        'color': color ? 'white' : 'grey',
      }}
      onClick={() => act('orbit', { ref: ref })}
      tooltip={!!health && <ObservableTooltip item={item} />}
      tooltipPosition="bottom-start">
      {!!health && (
        <ColorBox
          color={getHealthColor(health)}
          style={{ 'margin-right': '0.5em' }}
        />
      )}
      {capitalizeFirst(getDisplayName(full_name, nickname))}
      {!!orbiters && (
        <>
          {' '}
          <Icon mr={0} name={'ghost'} />
          {orbiters}
        </>
      )}
    </Button>
  );
};

/** Displays some info on the mob as a tooltip. */
const ObservableTooltip = (props: { item: Observable }) => {
  const {
    item: { caste, health, job, full_name, icon, background_color },
  } = props;
  const displayHealth = !!health && health >= 0 ? `${health}%` : 'Critical';

  return (
    <LabeledList>
      {!!full_name && (
        <LabeledList.Item label="Full Name">{full_name}</LabeledList.Item>
      )}
      {!!caste && (
        <LabeledList.Item label="Caste">
          {!!icon && (
            <ObservableIcon icon={icon} background_color={background_color} />
          )}
          {caste}
        </LabeledList.Item>
      )}
      {!!job && (
        <LabeledList.Item label="Job">
          {!!icon && (
            <ObservableIcon icon={icon} background_color={background_color} />
          )}
          {job}
        </LabeledList.Item>
      )}
      {!!health && (
        <LabeledList.Item label="Health">{displayHealth}</LabeledList.Item>
      )}
    </LabeledList>
  );
};

/** Generates a small icon for buttons based on ICONMAP */
const ObservableIcon = (
  props: {
    icon: Observable['icon'];
    background_color: Observable['background_color'];
  },
  context
) => {
  const { data } = useBackend<OrbitData>(context);
  const { icons = [] } = data;
  const { icon, background_color } = props;
  if (!icon || !icons[icon]) {
    return null;
  }

  return (
    <Box
      as="img"
      mr={1.3}
      src={`data:image/jpeg;base64,${icons[icon]}`}
      style={{
        transform: 'scale(2) translatey(-1px)',
        '-ms-interpolation-mode': 'nearest-neighbor',
        'background-color': background_color ? background_color : null,
        'vertical-align': 'middle',
      }}
    />
  );
};
