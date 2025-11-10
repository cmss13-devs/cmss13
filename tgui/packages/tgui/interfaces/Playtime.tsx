import { classes } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

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

const PlaytimeRow = (props: {
  readonly data: PlaytimeRecord;
  readonly maxPlaytime: number;
  readonly category: string;
}) => {
  const { data, maxPlaytime, category } = props;
  const percentage = maxPlaytime > 0 ? data.playtime / maxPlaytime : 0;
  const percentage_100 = percentage * 100;

  const getRankName = (playtime: number) => {
    switch (true) {
      case playtime < 5:
        return 'private1';
      case playtime < 10:
        return 'private2';
      case playtime < 15:
        return 'private3';
      case playtime < 20:
        return 'private4';
      case playtime < 25:
        return 'private5';
      case playtime < 30:
        return 'private6';
      case playtime < 35:
        return 'sergeant1';
      case playtime < 40:
        return 'sergeant2';
      case playtime < 45:
        return 'sergeant3';
      case playtime < 50:
        return 'sergeant4';
      case playtime < 55:
        return 'sergeant5';
      case playtime < 60:
        return 'sergeant6';
      case playtime < 65:
        return 'officer1';
      case playtime < 70:
        return 'officer2';
      case playtime < 75:
        return 'officer3';
      case playtime < 80:
        return 'officer4';
      case playtime < 85:
        return 'officer5';
      case playtime < 90:
        return 'officer6';
      case playtime < 100:
        return 'general1';
      case playtime < 110:
        return 'general2';
      case playtime < 120:
        return 'general3';
      case playtime < 130:
        return 'general4';
      case playtime < 140:
        return 'general5';
      case playtime < 150:
        return 'general6';
      case playtime < 160:
        return 'marshal1';
      case playtime < 170:
        return 'marshal2';
      case playtime < 180:
        return 'marshal3';
      case playtime < 190:
        return 'marshal4';
      case playtime < 200:
        return 'marshal5';
      default:
        return 'marshal6';
    }
  };

  const getProgressColor = (percent: number) => {
    if (percent < 25) {
      return 'linear-gradient(90deg, #ff5e5e 0%, #ff9a5e 100%)';
    }
    if (percent < 50) {
      return 'linear-gradient(90deg, #ff9a5e 0%, #ffcc5e 100%)';
    }
    if (percent < 75) {
      return 'linear-gradient(90deg, #ffcc5e 0%, #a2ff5e 100%)';
    }
    return 'linear-gradient(90deg, #a2ff5e 0%, #5eff86 100%)';
  };

  return (
    <Box className="PlaytimeRow" mb={1}>
      <Stack align="center">
        <Stack.Item width="32px" height="32px">
          <Box
            className={classes(['playtimerank', getRankName(data.playtime)])}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Box bold color={data.textcolor}>
            {data.job}
          </Box>
        </Stack.Item>
        <Stack.Item width="80px" textAlign="right" mr={1}>
          <Box bold>{data.playtime.toFixed(1)} ч.</Box>
          <Box fontSize="0.9em" opacity={0.8}>
            {percentage_100.toFixed(1)}%
          </Box>
        </Stack.Item>
      </Stack>
      <Box
        mt={0.5}
        style={{
          height: '4px',
          position: 'relative',
          backgroundColor: 'rgba(0, 0, 0, 0.2)',
          borderRadius: '2px',
          overflow: 'hidden',
        }}
      >
        <Box
          style={{
            position: 'absolute',
            left: '0',
            top: '0',
            height: '100%',
            width: `${percentage_100}%`,
            background: getProgressColor(percentage_100),
            borderRadius: '2px',
          }}
        />
      </Box>
    </Box>
  );
};

const PlaytimeList = (props: {
  readonly data: PlaytimeRecord[];
  readonly maxPlaytime: number;
  readonly category: string;
}) => {
  const { data, maxPlaytime, category } = props;

  return (
    <Box>
      {data
        .slice(data.length > 1 ? 1 : 0)
        .filter((x) => x.playtime !== 0)
        .sort((a, b) => b.playtime - a.playtime)
        .map((x) => (
          <PlaytimeRow
            key={x.job}
            data={x}
            maxPlaytime={maxPlaytime}
            category={category}
          />
        ))}
    </Box>
  );
};

const PlaytimeTab = (props: {
  readonly title: string;
  readonly hours: number;
  readonly color: string;
  readonly icon: string;
  readonly selected: boolean;
  readonly onClick: () => void;
}) => {
  return (
    <Box
      className={classes([
        'PlaytimeTab',
        props.selected && 'PlaytimeTab--selected',
      ])}
      onClick={props.onClick}
      style={{
        borderBottom: props.selected ? `3px solid ${props.color}` : 'none',
      }}
    >
      <Stack align="center">
        <Stack.Item>
          <Box className={classes(['PlaytimeTab', props.icon])} />
        </Stack.Item>
        <Stack.Item>
          <Box bold color={props.selected ? props.color : 'grey'}>
            {props.title}
          </Box>
          <Box fontSize="0.9em" opacity={0.8}>
            {props.hours.toFixed(1)} ч.
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const Playtime = (props) => {
  const { data } = useBackend<PlaytimeData>();
  const [selected, setSelected] = useState('human');

  const humanTime = data.stored_human_playtime[0]?.playtime || 0;
  const xenoTime = data.stored_xeno_playtime[0]?.playtime || 0;
  const otherTime = data.stored_other_playtime[0]?.playtime || 0;
  const totalTime = humanTime + xenoTime + otherTime;

  return (
    <Window width={450} height={600}>
      <Window.Content className="PlaytimeInterface" scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Box textAlign="center" bold fontSize="1.2em" p={1}>
              Общее игровое время: {totalTime.toFixed(1)} ч.
            </Box>
          </Stack.Item>

          <Stack.Item>
            <Stack justify="space-around" textAlign="center" fill>
              <Stack.Item grow>
                <PlaytimeTab
                  title="Человек"
                  hours={humanTime}
                  color="#4d7cff"
                  icon="uscm"
                  selected={selected === 'human'}
                  onClick={() => setSelected('human')}
                />
              </Stack.Item>
              <Stack.Item grow>
                <PlaytimeTab
                  title="Ксено"
                  hours={xenoTime}
                  color="#bd3d3d"
                  icon="xeno"
                  selected={selected === 'xeno'}
                  onClick={() => setSelected('xeno')}
                />
              </Stack.Item>
              <Stack.Item grow>
                <PlaytimeTab
                  title="Другое"
                  hours={otherTime}
                  color="#8a6e4d"
                  icon="weyland"
                  selected={selected === 'other'}
                  onClick={() => setSelected('other')}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item grow>
            <Box p={1}>
              {selected === 'human' && (
                <PlaytimeList
                  data={data.stored_human_playtime}
                  maxPlaytime={humanTime}
                  category={'human'}
                />
              )}
              {selected === 'xeno' && (
                <PlaytimeList
                  data={data.stored_xeno_playtime}
                  maxPlaytime={xenoTime}
                  category={'xeno'}
                />
              )}
              {selected === 'other' && (
                <PlaytimeList
                  data={data.stored_other_playtime}
                  maxPlaytime={otherTime}
                  category={'other'}
                />
              )}
            </Box>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
