import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { capitalizeFirst, multiline } from 'common/string';
import { useBackend, useLocalState } from 'tgui/backend';
import { Box, Button, Collapsible, ColorBox, Icon, Input, LabeledList, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { getDisplayName, isJobOrNameMatch, getHealthColor } from './helpers';
import type { Observable, OrbitData } from './types';

export const Orbit = (props) => {
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
const ObservableSearch = (props) => {
  const { act, data } = useBackend<OrbitData>();
  const { humans = [], marines = [], survivors = [], xenos = [] } = data;

  let auto_observe = data.auto_observe;

  const [autoObserve, setAutoObserve] = useLocalState<boolean>(
    'autoObserve',
    auto_observe ? true : false
  );
  const [searchQuery, setSearchQuery] = useLocalState<string>(
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
        auto_observe: autoObserve,
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
            color={autoObserve ? 'good' : 'transparent'}
            icon={autoObserve ? 'toggle-on' : 'toggle-off'}
            onClick={() => act('toggle_auto_observe')}
            tooltip={multiline`Toggle Auto-Observe. When active, you'll
            see the UI / full inventory of whoever you're orbiting. Neat!`}
            tooltipPosition="bottom-start"
          />
        </Stack.Item>
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
const ObservableContent = (props) => {
  const { data } = useBackend<OrbitData>();
  const {
    humans = [],
    marines = [],
    survivors = [],
    xenos = [],
    ert_members = [],
    upp = [],
    clf = [],
    wy = [],
    twe = [],
    freelancer = [],
    mercenary = [],
    contractor = [],
    dutch = [],
    marshal = [],
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
      <ObservableSection
        color="green"
        section={upp}
        title="Union of Progressive Peoples"
      />
      <ObservableSection
        color="teal"
        section={clf}
        title="Colonial Liberation Front"
      />
      <ObservableSection color="white" section={wy} title="Weyland Yutani" />
      <ObservableSection
        color="red"
        section={twe}
        title="Royal Marines Commando"
      />
      <ObservableSection
        color="orange"
        section={freelancer}
        title="Freelancers"
      />
      <ObservableSection
        color="label"
        section={mercenary}
        title="Mercenaries"
      />
      <ObservableSection
        color="light-grey"
        section={contractor}
        title="Military Contractors"
      />
      <ObservableSection color="good" section={dutch} title="Dutchs Dozen" />
      <ObservableSection
        color="dark-blue"
        section={marshal}
        title="Colonial Marshal Bureau"
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
const ObservableSection = (props: {
  readonly color?: string;
  readonly section: Array<Observable>;
  readonly title: string;
}) => {
  const { color, section = [], title } = props;
  if (!section.length) {
    return null;
  }
  const [searchQuery] = useLocalState<string>('searchQuery', '');
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
const ObservableItem = (props: {
  readonly color?: string;
  readonly item: Observable;
}) => {
  const { act } = useBackend<OrbitData>();
  const { color, item } = props;
  const { health, icon, full_name, nickname, orbiters, ref, background_color } =
    item;

  const [autoObserve] = useLocalState<boolean>('autoObserve', false);

  const displayHealth = typeof health === 'number';

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
      tooltip={displayHealth && <ObservableTooltip item={item} />}
      tooltipPosition="bottom-start">
      {displayHealth && (
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
const ObservableTooltip = (props: { readonly item: Observable }) => {
  const {
    item: { caste, health, job, full_name, icon, background_color },
  } = props;

  const displayHealth = typeof health === 'number';
  const healthText = !!health && health >= 0 ? `${health}%` : 'Critical';

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
      {displayHealth && (
        <LabeledList.Item label="Health">{healthText}</LabeledList.Item>
      )}
    </LabeledList>
  );
};

/** Generates a small icon for buttons based on ICONMAP */
const ObservableIcon = (props: {
  readonly icon: Observable['icon'];
  readonly background_color: Observable['background_color'];
}) => {
  const { data } = useBackend<OrbitData>();
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
        'backgroundColor': background_color ? background_color : null,
        'verticalAlign': 'middle',
      }}
    />
  );
};
