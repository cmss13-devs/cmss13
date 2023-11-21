import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Tabs } from '../components';
import { Table, TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

interface PlaytimeRecord {
  job: string;
  playtime: number;
  bgcolor: string;
  textcolor: string;
  icondisplay: string | undefined;
}

interface PlaytimeData {
  stored_human_playtime: PlaytimeRecord[];
  stored_xeno_playtime: PlaytimeRecord[];
  stored_other_playtime: PlaytimeRecord[];
}

const PlaytimeRow = (props: { data: PlaytimeRecord }, context) => {
  return (
    <>
      <TableCell className="AwardCell">
        {props.data.icondisplay && (
          <span
            className={classes([
              'AwardIcon',
              'playtimerank32x32',
              props.data.icondisplay,
            ])}
          />
        )}
      </TableCell>
      <TableCell>
        <span className="LabelSpan">{props.data.job}</span>
      </TableCell>
      <TableCell>
        <span className="TimeSpan">{props.data.playtime.toFixed(1)} hr</span>
      </TableCell>
    </>
  );
};

const PlaytimeTable = (props: { data: PlaytimeRecord[] }, context) => {
  return (
    <Table>
      {props.data
        .slice(props.data.length > 1 ? 1 : 0)
        .filter((x) => x.playtime !== 0)
        .map((x) => (
          <TableRow key={x.job} className="PlaytimeRow">
            <PlaytimeRow data={x} />
          </TableRow>
        ))}
    </Table>
  );
};

export const Playtime = (props, context) => {
  const { data } = useBackend<PlaytimeData>(context);
  const [selected, setSelected] = useLocalState(context, 'selected', 'human');
  const humanTime =
    data.stored_human_playtime.length > 0
      ? data.stored_human_playtime[0].playtime
      : 0;
  const xenoTime =
    data.stored_xeno_playtime.length > 0
      ? data.stored_xeno_playtime[0].playtime
      : 0;
  const otherTime =
    data.stored_other_playtime.length > 0
      ? data.stored_other_playtime[0].playtime
      : 0;
  return (
    <Window theme={selected !== 'xeno' ? 'usmc' : 'hive_status'}>
      <Window.Content className="PlaytimeInterface" scrollable>
        <Tabs fluid={1}>
          <Tabs.Tab
            selected={selected === 'human'}
            onClick={() => setSelected('human')}>
            Human ({humanTime} hr)
          </Tabs.Tab>
          <Tabs.Tab
            selected={selected === 'xeno'}
            onClick={() => setSelected('xeno')}>
            Xeno ({xenoTime} hr)
          </Tabs.Tab>
          <Tabs.Tab
            selected={selected === 'other'}
            onClick={() => setSelected('other')}>
            Other ({otherTime} hr)
          </Tabs.Tab>
        </Tabs>
        {selected === 'human' && (
          <PlaytimeTable data={data.stored_human_playtime} />
        )}
        {selected === 'xeno' && (
          <PlaytimeTable data={data.stored_xeno_playtime} />
        )}
        {selected === 'other' && (
          <PlaytimeTable data={data.stored_other_playtime} />
        )}
      </Window.Content>
    </Window>
  );
};
