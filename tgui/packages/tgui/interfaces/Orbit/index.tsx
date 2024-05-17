import { filter, sortBy } from 'common/collections';
import { capitalizeFirst } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
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
import type { Observable, OrbitData } from './types';

export const Orbit = (props) => {
  const [searchQuery, setSearchQuery] = useState<string>('');

  return (
    <Window title="Orbit" width={500} height={700}>
      <Window.Content scrollable>
        <Stack fill vertical>
          <Stack.Item>
            <ObservableSearch
              searchQuery={searchQuery}
              setSearchQuery={setSearchQuery}
            />
          </Stack.Item>
          <Stack.Item mt={0.2} grow>
            <Section fill>
              <ObservableContent searchQuery={searchQuery} />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Controls filtering out the list of observables via search */
const ObservableSearch = (props: {
  readonly searchQuery: string;
  readonly setSearchQuery: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { act, data } = useBackend<OrbitData>();
  const { searchQuery, setSearchQuery } = props;
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
            onInput={(event, value) => setSearchQuery(value)}
            placeholder="Search..."
            value={searchQuery}
          />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <Button
            color={auto_observe ? 'good' : 'transparent'}
            icon={auto_observe ? 'toggle-on' : 'toggle-off'}
            onClick={() => act('toggle_auto_observe')}
            tooltip={`Toggle Full Observe. When active, you'll see the UI / full inventory of whoever you're orbiting. Neat!`}
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
const ObservableContent = (props: { readonly searchQuery: string }) => {
  const { data } = useBackend<OrbitData>();
  const { searchQuery } = props;
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
      <ObservableSection
        searchQuery={searchQuery}
        color="blue"
        section={marines}
        title="Marines"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="teal"
        section={humans}
        title="Humans"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="xeno"
        section={xenos}
        title="Xenomorphs"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="good"
        section={survivors}
        title="Survivors"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="average"
        section={ert_members}
        title="ERT Members"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="light-grey"
        section={synthetics}
        title="Synthetics"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="green"
        section={upp}
        title="Union of Progressive Peoples"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="teal"
        section={clf}
        title="Colonial Liberation Front"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="white"
        section={wy}
        title="Weyland Yutani"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="red"
        section={twe}
        title="Royal Marines Commando"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="orange"
        section={freelancer}
        title="Freelancers"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="label"
        section={mercenary}
        title="Mercenaries"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="light-grey"
        section={contractor}
        title="Military Contractors"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="good"
        section={dutch}
        title="Dutchs Dozen"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="dark-blue"
        section={marshal}
        title="Colonial Marshal Bureau"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="green"
        section={predators}
        title="Predators"
      />
      <ObservableSection
        searchQuery={searchQuery}
        color="olive"
        section={escaped}
        title="Escaped"
      />
      <ObservableSection
        searchQuery={searchQuery}
        section={vehicles}
        title="Vehicles"
      />
      <ObservableSection
        searchQuery={searchQuery}
        section={animals}
        title="Animals"
      />
      <ObservableSection
        searchQuery={searchQuery}
        section={dead}
        title="Dead"
      />
      <ObservableSection
        searchQuery={searchQuery}
        section={ghosts}
        title="Ghosts"
      />
      <ObservableSection
        searchQuery={searchQuery}
        section={misc}
        title="Misc"
      />
      <ObservableSection
        searchQuery={searchQuery}
        section={npcs}
        title="NPCs"
      />
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
  readonly searchQuery: string;
}) => {
  const { color, section = [], title, searchQuery } = props;

  if (!section.length) {
    return null;
  }

  const filteredSection = sortBy(
    filter(section, (observable) => isJobOrNameMatch(observable, searchQuery)),
    (observable) =>
      getDisplayName(observable.full_name, observable.nickname)
        .replace(/^"/, '')
        .toLowerCase(),
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
