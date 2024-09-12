import { capitalizeFirst } from 'common/string';
import { createContext, useContext, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  ColorBox,
  Icon,
  Image,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import {
  getDisplayName,
  getHealthColor,
  getMostRelevant,
  isJobOrNameMatch,
} from './helpers';
import {
  buildSquadObservable,
  groupSorter,
  type Observable,
  type OrbitData,
  splitter,
} from './types';

type search = {
  value: string;
  setValue: (value: string) => void;
};

const SearchContext = createContext<search>({ value: '', setValue: () => {} });

export const Orbit = () => {
  const [searchQuery, setSearchQuery] = useState<string>('');

  return (
    <Window title="Orbit" width={500} height={700}>
      <Window.Content scrollable>
        <SearchContext.Provider
          value={{ value: searchQuery, setValue: setSearchQuery }}
        >
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
        </SearchContext.Provider>
      </Window.Content>
    </Window>
  );
};

/** Controls filtering out the list of observables via search */
const ObservableSearch = () => {
  const { act, data } = useBackend<OrbitData>();
  const { humans = [], marines = [], survivors = [], xenos = [] } = data;

  let auto_observe = data.auto_observe;

  /** Gets a list of Observables, then filters the most relevant to orbit */
  const orbitMostRelevant = (searchQuery: string) => {
    const mostRelevant = getMostRelevant(searchQuery, [
      humans,
      marines,
      survivors,
      xenos,
    ]);

    if (mostRelevant !== undefined) {
      act('orbit', {
        ref: mostRelevant.ref,
      });
    }
  };

  const { value, setValue } = useContext(SearchContext);

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
            onEnter={(event, value) => orbitMostRelevant(value)}
            onInput={(event, value) => setValue(value)}
            placeholder="Search..."
            value={value}
          />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <Button
            color={auto_observe ? 'good' : 'transparent'}
            icon={auto_observe ? 'toggle-on' : 'toggle-off'}
            onClick={() => act('toggle_auto_observe')}
            tooltip={`Toggle Full Observe. When active, you'll see the UI / full inventory of whoever you're orbiting.`}
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

const xenoSplitter = (members: Array<Observable>) => {
  const primeHive: Array<Observable> = [];
  const corruptedHive: Array<Observable> = [];
  const forsakenHive: Array<Observable> = [];
  const otherHives: Array<Observable> = [];

  members.forEach((x) => {
    if (x.hivenumber?.includes('normal')) {
      primeHive.push(x);
    } else if (x.hivenumber?.includes('corrupted')) {
      corruptedHive.push(x);
    } else if (x.hivenumber?.includes('forsaken')) {
      forsakenHive.push(x);
    } else {
      otherHives.push(x);
    }
  });
  const squads = [
    buildSquadObservable('Prime', 'xeno', primeHive),
    buildSquadObservable('Corrupted', 'green', corruptedHive),
    buildSquadObservable('Forsaken', 'grey', forsakenHive),
    buildSquadObservable('Other', 'light-grey', otherHives),
  ];
  return squads;
};

const marineSplitter = (members: Array<Observable>) => {
  const alphaSquad: Array<Observable> = [];
  const bravoSquad: Array<Observable> = [];
  const charlieSquad: Array<Observable> = [];
  const deltaSquad: Array<Observable> = [];
  const foxtrotSquad: Array<Observable> = [];
  const echoSquad: Array<Observable> = [];
  const CBRNSquad: Array<Observable> = [];
  const FORECONSquad: Array<Observable> = [];
  const SOFSquad: Array<Observable> = [];
  const other: Array<Observable> = [];

  members.forEach((x) => {
    if (x.job?.includes('Alpha')) {
      alphaSquad.push(x);
    } else if (x.job?.includes('Bravo')) {
      bravoSquad.push(x);
    } else if (x.job?.includes('Charlie')) {
      charlieSquad.push(x);
    } else if (x.job?.includes('Delta')) {
      deltaSquad.push(x);
    } else if (x.job?.includes('Foxtrot')) {
      foxtrotSquad.push(x);
    } else if (x.job?.includes('Echo')) {
      echoSquad.push(x);
    } else if (x.job?.includes('CBRN')) {
      CBRNSquad.push(x);
    } else if (x.job?.includes('FORECON')) {
      FORECONSquad.push(x);
    } else if (x.job?.includes('SOF')) {
      SOFSquad.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable('Alpha', 'red', alphaSquad),
    buildSquadObservable('Bravo', 'yellow', bravoSquad),
    buildSquadObservable('Charlie', 'purple', charlieSquad),
    buildSquadObservable('Delta', 'blue', deltaSquad),
    buildSquadObservable('Foxtrot', 'brown', foxtrotSquad),
    buildSquadObservable('Echo', 'teal', echoSquad),
    buildSquadObservable('CBRN', 'dark-blue', CBRNSquad),
    buildSquadObservable('FORECON', 'green', FORECONSquad),
    buildSquadObservable('SOF', 'red', SOFSquad),
    buildSquadObservable('Other', 'grey', other),
  ];
  return squads;
};

const rankList = [
  'Rifleman',
  'Spotter',
  'Hospital Corpsman',
  'Combat Technician',
  'Smartgunner',
  'Weapons Specialist',
  'Fireteam Leader',
  'Squad Leader',
];
const marineSort = (a: Observable, b: Observable) => {
  const a_index = rankList.findIndex((str) => a.job?.includes(str)) ?? 0;
  const b_index = rankList.findIndex((str) => b.job?.includes(str)) ?? 0;
  if (a_index === b_index) {
    return a.full_name.localeCompare(b.full_name);
  }
  return a_index > b_index ? -1 : 1;
};

const GroupedObservable = (props: {
  readonly color?: string;
  readonly section: Array<Observable>;
  readonly title: string;
  readonly splitter: splitter;
  readonly sorter?: groupSorter;
}) => {
  const { color, section = [], title } = props;

  const { value: searchQuery } = useContext(SearchContext);

  if (!section.length) {
    return null;
  }

  const filteredSection = section
    .filter((observable) => isJobOrNameMatch(observable, searchQuery))
    .sort((a, b) =>
      a.full_name
        .toLocaleLowerCase()
        .localeCompare(b.full_name.toLocaleLowerCase()),
    );

  if (!filteredSection.length) {
    return null;
  }

  const squads = props.splitter(filteredSection);

  return (
    <Stack.Item>
      <Collapsible
        bold
        color={color ?? 'grey'}
        open={!!color}
        title={title + ` - (${filteredSection.length})`}
      >
        <Box style={{ paddingLeft: '12px' }}>
          {squads.map((x) => (
            <ObservableSection
              color={x.color}
              title={x.title}
              section={props.sorter ? x.members.sort(props.sorter) : x.members}
              key={x.title}
            />
          ))}
        </Box>
      </Collapsible>
    </Stack.Item>
  );
};

/**
 * The primary content display for points of interest.
 * Renders a scrollable section replete with subsections for each
 * observable group.
 */
const ObservableContent = () => {
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
      <GroupedObservable
        color="blue"
        section={marines}
        title="Marines"
        splitter={marineSplitter}
        sorter={marineSort}
      />
      <ObservableSection color="teal" section={humans} title="Humans" />
      <GroupedObservable
        color="xeno"
        section={xenos}
        title="Xenomorphs"
        splitter={xenoSplitter}
      />
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

  const { value: searchQuery } = useContext(SearchContext);

  if (!section.length) {
    return null;
  }

  const filteredSection = section
    .filter((observable) => isJobOrNameMatch(observable, searchQuery))
    .sort((a, b) =>
      a.full_name
        .toLocaleLowerCase()
        .localeCompare(b.full_name.toLocaleLowerCase()),
    );

  if (!filteredSection.length) {
    return null;
  }

  return (
    <Stack.Item>
      <Collapsible
        bold
        color={color ?? 'grey'}
        open={!!color}
        title={title + ` - (${filteredSection.length})`}
      >
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

  const displayHealth = typeof health === 'number';

  return (
    <Button
      color={'transparent'}
      style={{
        borderColor: color ? '#2185d0' : 'grey',
        borderStyle: 'solid',
        borderWidth: '1px',
        color: color ? 'white' : 'grey',
      }}
      onClick={() => act('orbit', { ref: ref })}
      tooltip={displayHealth && <ObservableTooltip item={item} />}
      tooltipPosition="bottom-start"
    >
      {displayHealth && <ColorBox color={getHealthColor(health)} mr="0.5em" />}
      {!!icon && (
        <ObservableIcon icon={icon} background_color={background_color} />
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
    <Image
      mr={1.3}
      src={`data:image/jpeg;base64,${icons[icon]}`}
      fixBlur
      verticalAlign="middle"
      backgroundColor={background_color ? background_color : undefined}
      style={{
        transform: 'scale(2) translatey(-1px)',
      }}
    />
  );
};
