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

import { JobsRu } from '../BandaMarines/MarineJobs';
import { CastesRu } from '../BandaMarines/XenoCastes';
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
    buildSquadObservable(CastesRu('Thunderdome'), 'xeno', tdomeHive),
    buildSquadObservable(CastesRu('Prime'), 'xeno', primeHive),
    buildSquadObservable(CastesRu('Corrupted'), 'green', corruptedHive),
    buildSquadObservable(CastesRu('Forsaken'), 'grey', forsakenHive),
    buildSquadObservable(CastesRu('Mutated'), 'pink', mutatedHive),
    buildSquadObservable(CastesRu('Other'), 'light-grey', otherHives),
    buildSquadObservable(CastesRu('Yautja'), 'green', yautjaHive),
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
  const provost: Array<Observable> = [];

  // SS220 EDIT - TRANSLATE code/__DEFINES/bandamarines/ru_jobs.dm
  members.forEach((x) => {
    if (x.job?.includes(JobsRu('Alpha'))) {
      alphaSquad.push(x);
    } else if (x.job?.includes(JobsRu('Bravo'))) {
      bravoSquad.push(x);
    } else if (x.job?.includes(JobsRu('Charlie'))) {
      charlieSquad.push(x);
    } else if (x.job?.includes(JobsRu('Delta'))) {
      deltaSquad.push(x);
    } else if (x.job?.includes(JobsRu('Foxtrot'))) {
      foxtrotSquad.push(x);
    } else if (x.job?.includes(JobsRu('Echo'))) {
      echoSquad.push(x);
    } else if (x.job?.includes(JobsRu('CBRN'))) {
      CBRNSquad.push(x);
    } else if (x.job?.includes(JobsRu('FORECON'))) {
      FORECONSquad.push(x);
    } else if (x.job?.includes(JobsRu('SOF'))) {
      SOFSquad.push(x);
    } else if (x.job?.includes(JobsRu('Provost'))) {
      provost.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable(JobsRu('Alpha'), 'red', alphaSquad),
    buildSquadObservable(JobsRu('Bravo'), 'yellow', bravoSquad),
    buildSquadObservable(JobsRu('Charlie'), 'purple', charlieSquad),
    buildSquadObservable(JobsRu('Delta'), 'blue', deltaSquad),
    buildSquadObservable(JobsRu('Foxtrot'), 'brown', foxtrotSquad),
    buildSquadObservable(JobsRu('Echo'), 'teal', echoSquad),
    buildSquadObservable(JobsRu('CBRN'), 'dark-blue', CBRNSquad),
    buildSquadObservable(JobsRu('FORECON'), 'green', FORECONSquad),
    buildSquadObservable(JobsRu('SOF'), 'red', SOFSquad),
    buildSquadObservable(JobsRu('Other'), 'grey', other),
    buildSquadObservable(JobsRu('Provost'), 'red', provost),
  ];
  return squads;
};

const rankList = [
  JobsRu('Rifleman'),
  JobsRu('Spotter'),
  JobsRu('Hospital Corpsman'),
  JobsRu('Combat Technician'),
  JobsRu('Smartgunner'),
  JobsRu('Weapons Specialist'),
  JobsRu('Fireteam Leader'),
  JobsRu('Squad Leader'),
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

  // SS220 EDIT - TRANSLATE code/__DEFINES/bandamarines/ru_jobs.dm
  members.forEach((x) => {
    if (x.job?.includes('Акула')) {
      akulaSquad.push(x);
    } else if (x.job?.includes('Бизон')) {
      bizonSquad.push(x);
    } else if (x.job?.includes('Чайка')) {
      chaykaSquad.push(x);
    } else if (x.job?.includes('Дельфин')) {
      delfinSquad.push(x);
    } else if (x.job?.includes('СПНКом')) {
      UPPKdoSquad.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable(JobsRu('Akula'), 'red', akulaSquad),
    buildSquadObservable(JobsRu('Bizon'), 'yellow', bizonSquad),
    buildSquadObservable(JobsRu('Chayka'), 'purple', chaykaSquad),
    buildSquadObservable(JobsRu('Delfin'), 'blue', delfinSquad),
    buildSquadObservable(JobsRu('UPPKdo'), 'red', UPPKdoSquad),
    buildSquadObservable(JobsRu('Other'), 'grey', other),
  ];
  return squads;
};

const upprankList = [
  JobsRu('UPP Ryadovoy'),
  JobsRu('UPP MSzht Engineer'),
  JobsRu('UPP MSzht Medic'),
  JobsRu('UPP Serzhant'),
  JobsRu('UPP Starshiy Serzhant'),
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
  const pmc: Array<Observable> = [];
  const goons: Array<Observable> = [];
  const other: Array<Observable> = [];

  members.forEach((x) => {
    if (x.job?.includes(JobsRu('Whiteout'))) {
      whiteout.push(x);
    } else if (x.job?.includes(JobsRu('Death Squad'))) {
      whiteout.push(x);
    } else if (x.job?.includes(JobsRu('PMC'))) {
      pmc.push(x);
    } else if (x.job?.includes(JobsRu('Corporate Security'))) {
      goons.push(x);
    } else {
      other.push(x);
    }
  });

  const squads = [
    buildSquadObservable(JobsRu('PMCs'), 'white', pmc),
    buildSquadObservable(JobsRu('Goons'), 'orange', goons),
    buildSquadObservable(JobsRu('Corporate'), 'white', other),
    buildSquadObservable(JobsRu('Whiteout'), 'red', whiteout),
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
        title={JobsRu('Marines')}
        splitter={marineSplitter}
        sorter={marineSort}
      />
      <ObservableSection
        color="teal"
        section={humans}
        title={JobsRu('Humans')}
      />
      <GroupedObservable
        color="xeno"
        section={xenos}
        title={JobsRu('Xenomorphs')}
        splitter={xenoSplitter}
      />
      <ObservableSection
        color="good"
        section={survivors}
        title={JobsRu('Survivors')}
      />
      <ObservableSection
        color="average"
        section={ert_members}
        title={JobsRu('ERT Members')}
      />
      <ObservableSection
        color="light-grey"
        section={synthetics}
        title={JobsRu('Synthetics')}
      />
      <GroupedObservable
        color="green"
        section={upp}
        title={JobsRu('Union of Progressive Peoples')}
        splitter={uppSplitter}
        sorter={uppSort}
      />
      <ObservableSection
        color="teal"
        section={clf}
        title={JobsRu('Colonial Liberation Front')}
      />
      <GroupedObservable
        color="white"
        section={wy}
        title={JobsRu('Weyland Yutani')}
        splitter={weyyuSplitter}
      />
      <ObservableSection
        color="red"
        section={twe}
        title={JobsRu('Royal Marines Commando')}
      />
      <ObservableSection
        color="orange"
        section={freelancer}
        title={JobsRu('Freelancers')}
      />
      <ObservableSection
        color="label"
        section={mercenary}
        title={JobsRu('Mercenaries')}
      />
      <ObservableSection
        color="light-grey"
        section={contractor}
        title={JobsRu('Military Contractors')}
      />
      <ObservableSection
        color="red"
        section={hunted}
        title={JobsRu('Hunted Personnel')}
      />
      <ObservableSection
        color="good"
        section={dutch}
        title={JobsRu('Dutchs Dozen')}
      />
      <ObservableSection
        color="dark-blue"
        section={marshal}
        title={JobsRu('Colonial Marshal Bureau')}
      />
      <ObservableSection
        color="pink"
        section={responders}
        title={JobsRu('Fax Responders')}
      />
      <ObservableSection
        color="green"
        section={predators}
        title={JobsRu('Predators')}
      />
      <ObservableSection
        color="olive"
        section={escaped}
        title={JobsRu('Escaped')}
      />
      <ObservableSection
        color="orange"
        section={in_thunderdome}
        title={JobsRu('Thunderdome')}
      />
      <ObservableSection section={vehicles} title={JobsRu('Vehicles')} />
      <ObservableSection section={animals} title={JobsRu('Animals')} />
      <ObservableSection section={dead} title={JobsRu('Dead')} />
      <ObservableSection section={ghosts} title={JobsRu('Ghosts')} />
      <ObservableSection section={misc} title={JobsRu('Misc')} />
      <ObservableSection section={npcs} title={JobsRu('NPCs')} />
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
  const healthText = !!health && health >= 0 ? `${health}%` : 'Критическое';

  return (
    <LabeledList>
      {!!full_name && (
        <LabeledList.Item label="Полное имя">{full_name}</LabeledList.Item>
      )}
      {!!caste && (
        <LabeledList.Item label="Каста">
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
        <LabeledList.Item label="Должность">
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
        <LabeledList.Item label="Здоровье">{healthText}</LabeledList.Item>
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
