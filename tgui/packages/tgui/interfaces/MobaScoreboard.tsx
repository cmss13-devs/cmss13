// @ts-nocheck

import { classes } from 'common/react';

import { useBackend } from '../backend';
import { Box } from '../components';
import { Window } from '../layouts';

type Item = {
  name: string;
  desc: string;
  icon_state: string;
};

type Player = {
  name: string;
  caste: string;
  caste_icon: string;
  kills: number;
  deaths: number;
  level: number;
  items: Item[];
};

type BackendContext = {
  team1_players: Player[];
  team2_players: Player[];
  team1_total_kills: number;
  team2_total_kills: number;
};

const MainTab = () => {
  const { data, act } = useBackend<BackendContext>();

  return (
    <Box style={{ display: 'flex', height: '100%', flexDirection: 'column' }}>
      {data.team1_players.map((player, index) => (
        <PlayerRow
          player1={player}
          player2={data.team2_players[index]}
          key={player}
        />
      ))}
    </Box>
  );
};

const PlayerRow = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const player1: Player = props.player1;
  const player2: Player = props.player2;
  // <span style={{ border: 'dotted', height: '100px' }}>Hello!</span>;
  return (
    <Box style={{ height: '25%', display: 'flex' }}>
      <PlayerEntry player={player1} />
      <PlayerEntry player={player2} />
    </Box>
  );
};

const PlayerEntry = (props) => {
  const player: Player = props.player;
  if (!player) {
    return <Box style={{ border: 'dotted', flex: '1' }} />;
  }
  // <span style={{ border: 'dotted', height: '100px' }}>Hello!</span>;
  return (
    <Box
      style={{
        border: 'dotted',
        flex: '1',
        display: 'flex',
        alignItems: 'center',
        flexWrap: 'wrap',
      }}
    >
      <span className={classes(['mobacastes60x60', player.caste_icon])} />
      <Box style={{ marginLeft: '5%' }}>Lv {player.level}</Box>
      <Box style={{ marginLeft: '5%' }}>{player.name}</Box>
      <Box style={{ marginLeft: '5%' }}>
        {player.kills}/{player.deaths}
      </Box>
      <Box style={{ marginLeft: '5%', width: '100%' }}>
        <span className={classes(['mobaitems60x60', `empty`])} />
        {player.items.map((item) => (
          <ItemEntry item={item} key={item} />
        ))}
      </Box>
    </Box>
  );
};

const ItemEntry = (props) => {
  const item: Item = props.item;
  return <span className={classes(['mobaitems60x60', `${item.icon_state}`])} />;
};

export const MobaScoreboard = () => {
  return (
    <Window width={810} height={600} title={'Scoreboard'}>
      <Window.Content>
        <MainTab />
      </Window.Content>
    </Window>
  );
};
