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
  type groupSorter,
  type Observable,
  type OrbitData,
  type splitter,
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
  const tdomeHive: Array<Observable> = [];
  const primeHive: Array<Observable> = [];
  const corruptedHive: Array<Observable> = [];
  const forsakenHive: Array<Observable> = [];
  const mutatedHive: Array<Observable> = [];
  const otherHives: Array<Observable> = [];
  const yautjaHive: Array<Observable> = [];

  members.forEach((x) => {
    if (x.area_name?.includes('Thunderdome')) {
      tdomeHive.push(x);
    } else if (x.hivenumber?.includes('normal')) {
      primeHive.push(x);
    } else if (x.hivenumber?.includes('corrupted')) {
      corruptedHive.push(x);
    } else if (x.hivenumber?.includes('forsaken')) {
      forsakenHive.push(x);
    } else if (x.hivenumber?.includes('mutated')) {
      mutatedHive.push(x);
    } else if (x.hivenumber?.includes('yautja')) {
      yautjaHive.push(x);
    } else {
      otherHives.push(x);
    }
  });
  const squads = [
    buildSquadObservable('Thunderdome', 'xeno', tdomeHive),
    buildSquadObservable('Prime', 'xeno', primeHive),
    buildSquadObservable('Corrupted', 'green', corruptedHive),
    buildSquadObservable('Forsaken', 'grey', forsakenHive),
    buildSquadObservable('Mutated', 'pink', mutatedHive),
    buildSquadObservable('Other', 'light-grey', otherHives),
    buildSquadObservable('Yautja', 'green', yautjaHive),
  ];
  return squads;
};

const infectedSplitter = (members: Array<Observable>) => {
  const tdomeHive: Array<Observable> = [];
  const primeHive: Array<Observable> = [];
  const corruptedHive: Array<Observable> = [];
  const forsakenHive: Array<Observable> = [];
  const mutatedHive: Array<Observable> = [];
  const otherHives: Array<Observable> = [];
  const yautjaHive: Array<Observable> = [];

  members.forEach((x) => {
    if (x.area_name?.includes('Thunderdome')) {
      tdomeHive.push(x);
    } else if (x.embryo_hivenumber?.includes('normal')) {
      primeHive.push(x);
    } else if (x.embryo_hivenumber?.includes('corrupted')) {
      corruptedHive.push(x);
    } else if (x.embryo_hivenumber?.includes('forsaken')) {
      forsakenHive.push(x);
    } else if (x.embryo_hivenumber?.includes('mutated')) {
      mutatedHive.push(x);
    } else if (x.embryo_hivenumber?.includes('yautja')) {
      yautjaHive.push(x);
    } else {
      otherHives.push(x);
    }
  });
  const squads = [
    buildSquadObservable('Thunderdome', 'xeno', tdomeHive),
    buildSquadObservable('Prime', 'xeno', primeHive),
    buildSquadObservable('Corrupted', 'green', corruptedHive),
    buildSquadObservable('Forsaken', 'grey', forsakenHive),
    buildSquadObservable('Mutated', 'pink', mutatedHive),
    buildSquadObservable('Other', 'light-grey', otherHives),
    buildSquadObservable('Yautja', 'green', yautjaHive),
  ];
  return squads;
};

const marineSplitter = (members: Array<Observable>) => {
  const mutineers: Array<Observable> = [];
  const loyalists: Array<Observable> = [];
  const nonCombatants: Array<Observable> = [];
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
  const provost: Array<Observable> = [];

  members.forEach((x) => {
    if (x.mutiny_status?.includes('Mutineer')) {
      mutineers.push(x);
    } else if (x.mutiny_status?.includes('Loyalist')) {
      loyalists.push(x);
    } else if (x.mutiny_status?.includes('Non-Combatant')) {
      nonCombatants.push(x);
    }

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
    } else if (x.job?.includes('Provost')) {
      provost.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable('MUTINY', 'red', mutineers),
    buildSquadObservable('LOYALIST', 'blue', loyalists),
    buildSquadObservable('NON-COMBAT', 'green', nonCombatants),
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
    buildSquadObservable('Provost', 'red', provost),
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

const uppSplitter = (members: Array<Observable>) => {
  const akulaSquad: Array<Observable> = [];
  const bizonSquad: Array<Observable> = [];
  const chaykaSquad: Array<Observable> = [];
  const delfinSquad: Array<Observable> = [];
  const UPPKdoSquad: Array<Observable> = [];
  const other: Array<Observable> = [];

  members.forEach((x) => {
    if (x.job?.includes('Akula')) {
      akulaSquad.push(x);
    } else if (x.job?.includes('Bizon')) {
      bizonSquad.push(x);
    } else if (x.job?.includes('Chayka')) {
      chaykaSquad.push(x);
    } else if (x.job?.includes('Delfin')) {
      delfinSquad.push(x);
    } else if (x.job?.includes('UPPKdo')) {
      UPPKdoSquad.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable('Akula', 'red', akulaSquad),
    buildSquadObservable('Bizon', 'yellow', bizonSquad),
    buildSquadObservable('Chayka', 'purple', chaykaSquad),
    buildSquadObservable('Delfin', 'blue', delfinSquad),
    buildSquadObservable('UPPKdo', 'red', UPPKdoSquad),
    buildSquadObservable('Other', 'grey', other),
  ];
  return squads;
};

const upprankList = [
  'UPP Ryadovoy',
  'UPP MSzht Engineer',
  'UPP MSzht Medic',
  'UPP Serzhant',
  'UPP Starshiy Serzhant',
];
const uppSort = (a: Observable, b: Observable) => {
  const a_index = upprankList.findIndex((str) => a.job?.includes(str)) ?? 0;
  const b_index = upprankList.findIndex((str) => b.job?.includes(str)) ?? 0;
  if (a_index === b_index) {
    return a.full_name.localeCompare(b.full_name);
  }
  return a_index > b_index ? -1 : 1;
};

const weyyuSplitter = (members: Array<Observable>) => {
  const whiteout: Array<Observable> = [];
  const wycommando: Array<Observable> = [];
  const pmc: Array<Observable> = [];
  const goons: Array<Observable> = [];
  const other: Array<Observable> = [];

  members.forEach((x) => {
    if (x.job?.includes('Whiteout')) {
      whiteout.push(x);
    } else if (x.job?.includes('Death Squad')) {
      whiteout.push(x);
    } else if (x.job?.includes('W-Y Commando')) {
      wycommando.push(x);
    } else if (x.job?.includes('PMC')) {
      pmc.push(x);
    } else if (x.job?.includes('Corporate Security')) {
      goons.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable('PMCs', 'white', pmc),
    buildSquadObservable('Goons', 'orange', goons),
    buildSquadObservable('Corporate', 'white', other),
    buildSquadObservable('W-Y Commando', 'white', wycommando),
    buildSquadObservable('Whiteout', 'red', whiteout),
  ];
  return squads;
};

const tweSplitter = (members: Array<Observable>) => {
  const iasf: Array<Observable> = [];
  const commando: Array<Observable> = [];
  const other: Array<Observable> = [];

  members.forEach((x) => {
    if (x.job?.includes('IASF')) {
      iasf.push(x);
    } else if (x.job?.includes('RMC')) {
      commando.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable('Imperial Armed Space Force', 'Orange', iasf),
    buildSquadObservable('Royal Marines Commando', 'red', commando),
    buildSquadObservable('Other', 'grey', other),
  ];
  return squads;
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
    responders = [],
    marines = [],
    survivors = [],
    xenos = [],
    infected = [],
    ert_members = [],
    upp = [],
    clf = [],
    wy = [],
    hyperdyne = [],
    twe = [],
    freelancer = [],
    mercenary = [],
    contractor = [],
    dutch = [],
    marshal = [],
    synthetics = [],
    predators = [],
    hunted = [],
    animals = [],
    dead = [],
    ghosts = [],
    misc = [],
    npcs = [],
    vehicles = [],
    escaped = [],
    in_thunderdome = [],
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
      <GroupedObservable
        color="red"
        section={infected}
        title="Infected"
        splitter={infectedSplitter}
      />
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
      <GroupedObservable
        color="green"
        section={upp}
        title="Union of Progressive Peoples"
        splitter={uppSplitter}
        sorter={uppSort}
      />
      <ObservableSection
        color="teal"
        section={clf}
        title="Colonial Liberation Front"
      />
      <GroupedObservable
        color="white"
        section={wy}
        title="Weyland Yutani"
        splitter={weyyuSplitter}
      />
      <ObservableSection
        color="orange"
        section={hyperdyne}
        title="Hyperdyne Corporation"
      />
      <GroupedObservable
        color="red"
        section={twe}
        title="Three World Empire"
        splitter={tweSplitter}
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
      <ObservableSection
        color="red"
        section={hunted}
        title="Hunted Personnel"
      />
      <ObservableSection color="good" section={dutch} title="Dutchs Dozen" />
      <ObservableSection
        color="dark-blue"
        section={marshal}
        title="Colonial Marshal Bureau"
      />
      <ObservableSection
        color="pink"
        section={responders}
        title="Fax Responders"
      />
      <ObservableSection color="green" section={predators} title="Predators" />
      <ObservableSection color="olive" section={escaped} title="Escaped" />
      <ObservableSection
        color="orange"
        section={in_thunderdome}
        title="Thunderdome"
      />
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
  const {
    health,
    icon,
    full_name,
    nickname,
    orbiters,
    ref,
    background_color,
    background_icon,
  } = item;

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
        <ObservableIcon
          icon={icon}
          background_color={background_color}
          background_icon={background_icon}
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
    item: {
      caste,
      health,
      job,
      full_name,
      icon,
      background_color,
      background_icon,
    },
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
            <ObservableIcon
              icon={icon}
              background_color={background_color}
              background_icon={background_icon}
            />
          )}
          {caste}
        </LabeledList.Item>
      )}
      {!!job && (
        <LabeledList.Item label="Job">
          {!!icon && (
            <ObservableIcon
              icon={icon}
              background_color={background_color}
              background_icon={background_icon}
            />
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
  readonly background_icon: Observable['background_icon'];
}) => {
  const { data } = useBackend<OrbitData>();
  const { icons = [] } = data;
  const { icon, background_color, background_icon } = props;
  if (!icon || !icons[icon] || !background_icon || !icons[background_icon]) {
    return null;
  }

  return (
    <>
      <Image
        mr={1}
        src={`data:image/jpeg;base64,${icons[background_icon]}`}
        fixBlur
        color={background_color ? background_color : undefined}
        verticalAlign="middle"
        style={{
          transform: 'scale(2) translatey(-1px)',
          position: 'relative',
        }}
      />
      <Image
        mr={1}
        src={`data:image/jpeg;base64,${icons[icon]}`}
        fixBlur
        verticalAlign="middle"
        style={{
          transform: 'scale(2) translatey(-1px)',
          position: 'relative',
          right: '13px',
          marginRight: '-5px',
        }}
      />
    </>
  );
};
