import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from "inferno";
import { useBackend, useLocalState } from '../backend';
import { Input, Button, Flex, Divider, Collapsible, Icon, NumberInput, Table } from '../components';
import { Window } from '../layouts';

const redFont = {
  color: "red",
};

/**
 * Filters the list of xenos and returns a set of rows that will be used in the
 * xeno list table
 */
const filterXenos = data => {
  const {
    searchKey, searchFilters,
    maxHealth, xeno_keys,
    xeno_vitals, xeno_info,
  } = data;
  const xeno_entries = [];

  xeno_keys.map((key, i) => {
    const nicknumber = key.nicknumber.toString();
    let entry = {
      nicknumber: nicknumber,
      name: xeno_info[nicknumber].name,
      strain: xeno_info[nicknumber].strain,
      location: xeno_vitals[nicknumber].area,
      health: xeno_vitals[nicknumber].health,
      ref: xeno_info[nicknumber].ref,
      is_ssd: xeno_vitals[nicknumber].is_ssd,
      is_leader: key.is_leader,
      is_queen: key.is_queen,
    };
    xeno_entries.push(entry);
  });

  const filter_params = {
    searchKey: searchKey,
    searchFilters: searchFilters,
    maxHealth: maxHealth,
  };
  const filtered = xeno_entries.filter(getFilter(filter_params));

  return filtered;
};

/**
 * Creates a filter function based on the search key (passed to the search bar),
 * the categories selected to be searched through, and the max health filter
 */
const getFilter = data => {
  const {
    searchKey, searchFilters, maxHealth,
  } = data;
  const textSearch = createSearch(searchKey);

  return entry => {
    if (entry.health > maxHealth) {
      return false;
    }

    let hasFilter = false;
    for (let filter in searchFilters) {
      if (searchFilters[filter]) {
        hasFilter = true;
        if (textSearch(entry[filter])) {
          return true;
        }
      }
    }

    return hasFilter ? false : true;
  };
};

export const HiveStatus = (props, context) => {
  const { data } = useBackend(context);
  const { hive_name } = data;

  return (
    <Window
      title={hive_name + " Status"}
      theme="hive_status"
      resizable
      width={600}
      height={680}
    >
      <Window.Content scrollable>
        <XenoCollapsible
          title="General Hive Information"
        >
          <GeneralInformation />
        </XenoCollapsible>
        <Divider />
        <XenoCollapsible
          title="Hive Counts"
        >
          <XenoCounts />
        </XenoCollapsible>
        <Divider />
        <XenoCollapsible
          title="Hive Xenomorph List"
        >
          <XenoList />
        </XenoCollapsible>
      </Window.Content>
    </Window>
  );
};

const GeneralInformation = (props, context) => {
  const { data } = useBackend(context);
  const {
    queen_location, hive_location,
    total_xenos, pooled_larva,
    evilution_level,
  } = data;

  return (
    <Flex
      direction="column"
      align="center"
    >
      <Flex.Item
        textAlign="center"
      >
        <h3 className="whiteTitle">The Queen is in:</h3>
        <h1 className="whiteTitle">{queen_location}</h1>
      </Flex.Item>
      {!!hive_location && (
        <Flex.Item
          textAlign="center"
          mt={2}
        >
          <h3 className="whiteTitle">The Hive location is:</h3>
          <h1 className="whiteTitle">{hive_location}</h1>
        </Flex.Item>
      )}
      <Flex.Item
        mt={1}
      >
        <i>Total sisters: {total_xenos}</i>
      </Flex.Item>
      <Flex.Item>
        <i>Pooled larvae: {pooled_larva}</i>
      </Flex.Item>
      <Flex.Item>
        <i>Evilution: {evilution_level}</i>
      </Flex.Item>
    </Flex>
  );
};

const XenoCounts = (props, context) => {
  const { data } = useBackend(context);
  const { xeno_counts, tier_slots, hive_color } = data;

  return (
    <Flex
      direction="column-reverse"
    >
      {xeno_counts.map((counts, tier) => (
        <Flex.Item
          key={tier}
          mb={tier !== 0 ? 2 : 0}
        >
          <Flex
            direction="column"
          >
            <Flex.Item>
              <center>
                <h1 className="whiteTitle">Tier {tier}</h1>
                {tier >= 2
                  && <span><i>{tier_slots[tier-2]} remaining slot{tier_slots[tier-2] !== 1 && "s"}</i></span>}
              </center>
            </Flex.Item>
            <Flex.Item>
              <center>
                <Table className="xenoCountTable" collapsing>
                  <Table.Row header>
                    {Object.keys(counts).map((caste, i) => (
                      <Table.Cell
                        key={i}
                        className="underlineCell"
                        width={7}
                      >
                        {caste === 'Bloody Larva' ? 'Larva' : caste}
                      </Table.Cell>
                    ))}
                  </Table.Row>
                  <Table.Row className="xenoCountRow">
                    {Object.keys(counts).map((caste, i) => (
                      <Table.Cell key={i}
                        className="xenoCountCell"
                        backgroundColor={!!hive_color && hive_color}
                        textAlign="center"
                        width={7}
                      >
                        {counts[caste]}
                      </Table.Cell>
                    ))}
                  </Table.Row>
                </Table>
              </center>
            </Flex.Item>
          </Flex>
        </Flex.Item>
      ))}
    </Flex>
  );
};

const XenoList = (props, context) => {
  const { act, data } = useBackend(context);
  const [searchKey, setSearchKey] = useLocalState(context, 'searchKey', '');
  const [searchFilters, setSearchFilters] = useLocalState(context, 'searchFilters', { name: true, strain: true, location: true });
  const [maxHealth, setMaxHealth] = useLocalState(context, 'maxHealth', 100);
  const {
    xeno_keys, xeno_vitals,
    xeno_info, user_ref,
    is_in_ovi, hive_color,
  } = data;
  const xeno_entries = filterXenos({
    searchKey: searchKey,
    searchFilters: searchFilters,
    maxHealth: maxHealth,
    xeno_keys: xeno_keys,
    xeno_vitals: xeno_vitals,
    xeno_info: xeno_info,
  });

  return (
    <Flex
      direction="column"
    >
      <Flex.Item mb={1}>
        <Flex
          align="baseline"
        >
          <Flex.Item width="100px">
            Search Filters:
          </Flex.Item>
          <Flex.Item>
            <Button.Checkbox
              inline
              content="Name"
              checked={searchFilters.name}
              backgroundColor={searchFilters.name && hive_color}
              onClick={() => setSearchFilters({
                ...searchFilters,
                name: !searchFilters.name,
              })}
            />
            <Button.Checkbox
              inline
              content="Strain"
              checked={searchFilters.strain}
              backgroundColor={searchFilters.strain && hive_color}
              onClick={() => setSearchFilters({
                ...searchFilters,
                strain: !searchFilters.strain,
              })}
            />
            <Button.Checkbox
              inline
              content="Location"
              checked={searchFilters.location}
              backgroundColor={searchFilters.location && hive_color}
              onClick={() => setSearchFilters({
                ...searchFilters,
                location: !searchFilters.location,
              })}
            />
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item mb={1}>
        <Flex
          align="baseline"
        >
          <Flex.Item width="100px">
            Max Health:
          </Flex.Item>
          <Flex.Item>
            <NumberInput
              animated
              width="40px"
              step={1}
              stepPixelSize={5}
              value={maxHealth}
              minValue={0}
              maxValue={100}
              onChange={(_, value) => setMaxHealth(value)}
            />
          </Flex.Item>
        </Flex>
      </Flex.Item>
      <Flex.Item mb={2}>
        <Input
          fluid={1}
          placeholder="Search..."
          onInput={(_, value) => setSearchKey(value)}
        />
      </Flex.Item>

      <Table className="xeno_list">
        <Table.Row header className="xenoListRow">
          <Table.Cell width="5%" className="noPadCell" />
          <Table.Cell>Name</Table.Cell>
          <Table.Cell width="15%">Strain</Table.Cell>
          <Table.Cell>Location</Table.Cell>
          <Table.Cell width="75px">Health</Table.Cell>
          <Table.Cell width="100px" />
        </Table.Row>

        {xeno_entries.map((entry, i) => (
          <Table.Row
            key={i}
            className={classes([
              entry.is_ssd ? "ssdRow" : "",
              "xenoListRow",
            ])}
          >
            {/*
              Leader/SSD icon
              You might think using an image for rounded corners is stupid,
              but I shit you not, BYOND's version of IE doesn't support
              border-radius
            */}
            <Table.Cell className="noPadCell">
              <StatusIcon entry={entry} />
            </Table.Cell>
            <Table.Cell>{entry.name}</Table.Cell>
            <Table.Cell>{entry.strain}</Table.Cell>
            <Table.Cell>{entry.location}</Table.Cell>
            <Table.Cell>
              {entry.health < 30
                ? <b style={redFont}>{entry.health}%</b>
                : <Fragment>{entry.health}%</Fragment>}
            </Table.Cell>
            <Table.Cell className="noPadCell" textAlign="center">
              {entry.ref !== user_ref && (
                <Flex
                  unselectable="on"
                  wrap="wrap"
                  className="actionButton"
                  align="center"
                  justify="space-around"
                  inline
                >
                  <Flex.Item>
                    <Button
                      content="Watch"
                      color="xeno"
                      onClick={
                        () => act("overwatch", {
                          target_ref: entry.ref,
                        })
                      }
                    />
                  </Flex.Item>
                  {!!is_in_ovi && (
                    <QueenOviButtons target_ref={entry.ref} />
                  )}
                </Flex>
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Flex>
  );
};

const StatusIcon = (props, context) => {
  const { entry } = props;
  const { is_ssd, is_leader, is_queen } = entry;

  if (is_ssd) {
    return <div unselectable="on" className="ssdIcon" />;
  } else if (is_leader || is_queen) {
    return (
      <div unselectable="on" className="leaderIcon">
        <Icon name="star" ml={0.2} />
      </div>
    );
  }
};

const XenoCollapsible = (props, context) => {
  const { data } = useBackend(context);
  const { title, children } = props;
  const { hive_color } = data;

  return (
    <Collapsible
      title={title}
      backgroundColor={!!hive_color && hive_color}
      color={!hive_color && "xeno"}
      open
    >
      {children}
    </Collapsible>
  );
};

const QueenOviButtons = (props, context) => {
  const { act, data } = useBackend(context);
  const { target_ref } = props;

  return (
    <Fragment>
      <Flex.Item>
        <Button
          content="Heal"
          color="green"
          onClick={
            () => act("heal", {
              target_ref: target_ref,
            })
          }
        />
      </Flex.Item>
      <Flex.Item>
        <Button
          content="Give Plasma"
          color="blue"
          onClick={
            () => act("give_plasma", {
              target_ref: target_ref,
            })
          }
        />
      </Flex.Item>
    </Fragment>
  );
};
