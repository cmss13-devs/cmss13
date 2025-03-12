// @ts-nocheck

import { classes } from 'common/react';

import { useBackend } from '../backend';
import { Box, Tooltip } from '../components';
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
  lane: string;
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
      <Box
        style={{ justifyContent: 'center', display: 'flex', fontSize: '20px' }}
      >
        <Tooltip content={'Left Side Kills'}>
          <Box style={{ color: '#af0c00', marginRight: '20px' }}>
            {data.team1_total_kills}
          </Box>
        </Tooltip>
        <Tooltip content={'Right Side Kills'}>
          <Box style={{ color: '#4949ba' }}>{data.team2_total_kills}</Box>
        </Tooltip>
      </Box>
      <Box style={{ border: '2px solid rgb(61, 55, 61)' }} />
      {data.team1_players.map((player, index) => (
        <>
          <PlayerRow
            player1={player}
            player2={data.team2_players[index]}
            key={player}
          />
          <Box style={{ border: '1px solid rgb(61, 55, 61)' }} />
          <PlayerRow
            player1={player}
            player2={data.team2_players[index]}
            key={player}
          />
          <Box style={{ border: '1px solid rgb(61, 55, 61)' }} />
          <PlayerRow
            player1={player}
            player2={data.team2_players[index]}
            key={player}
          />
          <Box style={{ border: '1px solid rgb(61, 55, 61)' }} />
          <PlayerRow
            player1={player}
            player2={data.team2_players[index]}
            key={player}
          />
        </>
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
      <PlayerEntry player={player1} right />
      <Box style={{ border: '2px solid rgb(61, 55, 61)' }} />
      <PlayerEntry player={player2} />
    </Box>
  );
};

const PlayerEntry = (props) => {
  const player: Player = props.player;
  if (!player) {
    return <Box style={{ flex: '1' }} />;
  }
  // <span style={{ border: 'dotted', height: '100px' }}>Hello!</span>;
  return (
    <Box
      style={{
        flex: '1',
        display: 'flex',
        alignItems: 'center',
        flexWrap: 'wrap',
      }}
    >
      <Box
        style={{
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          paddingLeft: '4%',
        }}
      >
        Lv {player.level}
        <Tooltip content={player.caste}>
          <span className={classes(['mobacastes60x60', player.caste_icon])} />
        </Tooltip>
      </Box>
      <Box style={{ marginLeft: '5%' }}>{player.name}</Box>
      <Box style={{ marginLeft: '5%' }}>
        {player.kills}/{player.deaths}
      </Box>
      <Box style={{ marginLeft: '5%', width: '100%' }}>
        {player.items.map((item) => (
          <ItemEntry item={item} key={item} />
        ))}
      </Box>
    </Box>
  );
};

const ItemEntry = (props) => {
  const item: Item = props.item;
  return (
    <Tooltip innerhtml={`<h2>${item.name}</h2>${item.desc}`}>
      <span className={classes(['mobaitems45x45', `${item.icon_state}`])} />
    </Tooltip>
  );
};

export const MobaScoreboard = () => {
  return (
    <Window width={810} height={600} title={'Scoreboard'} theme={'xeno'}>
      <Window.Content>
        <MainTab />
      </Window.Content>
    </Window>
  );
};
