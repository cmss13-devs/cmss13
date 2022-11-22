import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { resolveAsset } from '../assets';
import { Box, Button, Flex, Icon, Input, Section } from '../components';
import { Window } from '../layouts';

const PATTERN_NUMBER = / \(([0-9]+)\)$/;

const searchFor = (searchText: string) => {
  return createSearch(searchText, (thing: { name: string }) => thing.name);
};

const compareNumberedText = (a: { name: string }, b: { name: string }) => {
  const aName = a.name;
  const bName = b.name;

  // Check if aName and bName are the same except for a number at the end
  // e.g. Medibot (2) and Medibot (3)
  const aNumberMatch = aName.match(PATTERN_NUMBER);
  const bNumberMatch = bName.match(PATTERN_NUMBER);

  if (
    aNumberMatch &&
    bNumberMatch &&
    aName.replace(PATTERN_NUMBER, '') === bName.replace(PATTERN_NUMBER, '')
  ) {
    const aNumber = parseInt(aNumberMatch[1], 10);
    const bNumber = parseInt(bNumberMatch[1], 10);

    return aNumber - bNumber;
  }

  return aName.localeCompare(bName);
};

type OrbitList = {
  name: string;
  ref: string;
  orbiters: number;
};

type OrbitData = {
  humans: OrbitList[];
  marines: OrbitList[];
  survivors: OrbitList[];
  xenos: OrbitList[];
  ert_members: OrbitList[];
  synthetics: OrbitList[];
  predators: OrbitList[];
  dead: OrbitList[];
  ghosts: OrbitList[];
  misc: OrbitList[];
  npcs: OrbitList[];
  vehicles: OrbitList[];
};

type BasicSectionProps = {
  searchText: string;
  source: OrbitList[];
  title: string;
};

type OrbitedButtonProps = {
  color: string;
  thing: OrbitList;
};

const BasicSection = (props: BasicSectionProps, context: any) => {
  const { act } = useBackend(context);
  const { searchText, source, title } = props;
  const things = source.filter(searchFor(searchText));
  things.sort(compareNumberedText);
  if (source.length <= 0) {
    return null;
  }
  return (
    <Section title={`${title} - (${source.length})`}>
      {things.map((thing: OrbitList) => (
        <Button
          key={thing.name}
          content={thing.name}
          onClick={() =>
            act('orbit', {
              ref: thing.ref,
            })
          }
        />
      ))}
    </Section>
  );
};

const OrbitedButton = (props: OrbitedButtonProps, context: any) => {
  const { act } = useBackend(context);
  const { color, thing } = props;

  return (
    <Button
      color={color}
      onClick={() =>
        act('orbit', {
          ref: thing.ref,
        })
      }>
      {thing.name}
      {thing.orbiters && (
        <Box inline ml={1}>
          {'('}
          {thing.orbiters}{' '}
          <Box as="img" src={resolveAsset('ghost.png')} opacity={0.7} />
          {')'}
        </Box>
      )}
    </Button>
  );
};

export const Orbit = (props: any, context: any) => {
  const { act, data } = useBackend<OrbitData>(context);
  const {
    humans,
    marines,
    survivors,
    xenos,
    ert_members,
    synthetics,
    predators,
    dead,
    ghosts,
    misc,
    npcs,
    vehicles,
  } = data;

  const [searchText, setSearchText] = useLocalState(context, 'searchText', '');

  const orbitMostRelevant = (searchText: string) => {
    for (const source of [humans, marines, survivors, xenos]) {
      const member = source
        .filter(searchFor(searchText))
        .sort(compareNumberedText)[0];
      if (member !== undefined) {
        act('orbit', { ref: member.ref });
        break;
      }
    }
  };

  return (
    <Window title="Orbit" width={500} height={700}>
      <Window.Content scrollable>
        <Section>
          <Flex>
            <Flex.Item>
              <Icon name="search" mr={1} />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Input
                placeholder="Search..."
                autoFocus
                fluid
                value={searchText}
                onInput={(_: any, value: string) => setSearchText(value)}
                onEnter={(_: any, value: string) => orbitMostRelevant(value)}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                inline
                color="transparent"
                tooltip="Refresh"
                tooltipPosition="bottom-start"
                icon="sync-alt"
                onClick={() => act('refresh')}
              />
            </Flex.Item>
          </Flex>
        </Section>

        {!!marines.length && (
          <Section title={`Marines - (${marines.length})`}>
            {marines
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="good" thing={thing} />
              ))}
          </Section>
        )}

        {!!xenos.length && (
          <Section title={`Xenos - (${xenos.length})`}>
            {xenos
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="good" thing={thing} />
              ))}
          </Section>
        )}

        {!!survivors.length && (
          <Section title={`Survivors - (${survivors.length})`}>
            {survivors
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="good" thing={thing} />
              ))}
          </Section>
        )}

        {!!ert_members.length && (
          <Section title={`ERT Members - (${ert_members.length})`}>
            {ert_members
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="good" thing={thing} />
              ))}
          </Section>
        )}

        {!!synthetics.length && (
          <Section title={`Synthetics - (${synthetics.length})`}>
            {synthetics
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="good" thing={thing} />
              ))}
          </Section>
        )}

        {!!predators.length && (
          <Section title={`Predators - (${predators.length})`}>
            {predators
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="good" thing={thing} />
              ))}
          </Section>
        )}

        {!!humans.length && (
          <Section title={`Humans - (${humans.length})`}>
            {humans
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="good" thing={thing} />
              ))}
          </Section>
        )}

        {!!vehicles.length && (
          <Section title={`Vehicles - (${vehicles.length})`}>
            {vehicles
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="blue" thing={thing} />
              ))}
          </Section>
        )}

        {!!ghosts.length && (
          <Section title={`Ghosts - (${ghosts.length})`}>
            {ghosts
              .filter(searchFor(searchText))
              .sort(compareNumberedText)
              .map((thing) => (
                <OrbitedButton key={thing.name} color="grey" thing={thing} />
              ))}
          </Section>
        )}

        {!!npcs.length && (
          <BasicSection title="NPCs" source={npcs} searchText={searchText} />
        )}

        {!!dead.length && (
          <BasicSection title="Dead" source={dead} searchText={searchText} />
        )}

        {!!misc.length && (
          <BasicSection title="Misc" source={misc} searchText={searchText} />
        )}
      </Window.Content>
    </Window>
  );
};
