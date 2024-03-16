import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section, Dimmer } from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';
import { classes, BooleanLike } from 'common/react';

interface BattlepassReward {
  name: string;
  icon_state: string;
  tier: number;
}

interface BattlepassChallenge {
  name: string;
  desc: string;
  completed: BooleanLike;
  category: string;
  completion_xp: number;
  completion_percent: number;
  completion_numerator: number;
  completion_denominator: number;
}

interface BattlepassData {
  xp: number;
  tier: number;
  max_tier: number;
  xp_tierup: number;
  rewards: BattlepassReward[];
  premium_rewards: BattlepassReward[];
  daily_challenges: BattlepassChallenge[];
}

export const Battlepass = (props) => {
  return (
    <Window width={900} height={325} theme="usmc" title="Battlepass">
      <Window.Content>
        <BattlepassContent />
      </Window.Content>
    </Window>
  );
};

const BattlepassContent = (props) => {
  const { act, data } = useBackend<BattlepassData>();
  const rewards = data.rewards;
  const premium_rewards = data.premium_rewards;
  return (
    <>
      <div
        style={{
          'display': 'flex',
          'overflow': 'auto',
        }}>
        <BattlepassInfoContainer />
        <div
          style={{
            'overflow-x': 'scroll',
            'display': 'flex',
            'flex-wrap': 'nowrap',
            'position': 'relative',
          }}>
          <div
            style={{
              'position': 'absolute',
              'top': '70%',
              'left': '10%',
              'font-size': '24px',
              'font-family': 'Verdana, Geneva, sans-serif',
              'z-index': '10',
            }}>
            Premium Battlepass coming soon!
          </div>
          {rewards.map((reward, rewardIndex) => (
            <BattlepassRegularEntry
              reward={reward}
              premiumReward={premium_rewards[rewardIndex]}
            />
          ))}
        </div>
      </div>
    </>
  );
};

const BattlepassInfoContainer = (props) => {
  const { act, data } = useBackend<BattlepassData>();
  return (
    <div
      style={{
        'padding-right': '20px',
        'border-right': 'solid',
      }}>
      <Section title="Season 1">
        <b
          style={{
            'font-size': '16px',
          }}>
          Tier: {data.tier} / {data.max_tier}
          <br />
          Xp: {data.xp} / 10
        </b>
        {data.daily_challenges.map((challenge) => (
          <BattlepassChallenge challenge={challenge} />
        ))}
      </Section>
    </div>
  );
};

const BattlepassChallenge = (props) => {
  const challenge: BattlepassChallenge = props.challenge;
  return (
    <Section title={challenge.name}>
      {challenge.desc}
      <ProgressBar
        minValue={0}
        maxValue={1}
        value={challenge.completion_percent}
        ranges={{
          bad: [0, 0.4],
          average: [0.4, 0.7],
          good: [0.7, 1],
        }}>
        Completion: {challenge.completion_numerator} /{' '}
        {challenge.completion_denominator}
      </ProgressBar>
      Reward: {challenge.completion_xp} XP
    </Section>
  );
};

const BattlepassRegularEntry = (props) => {
  const { act, data } = useBackend<BattlepassData>();
  const reward: BattlepassReward = props.reward;
  const premiumReward: BattlepassReward = props.premiumReward;
  return (
    <>
      <div
        style={{
          'border-style': 'none',
          'border-width': '2px',
          'border-color': 'black',
          'margin-right': '10px',
          'width': '135px',
        }}>
        {data.tier >= reward.tier ? (
          <div
            style={{
              'background-color': 'rgba(0, 255, 0, 0.4)',
              'width': '100%',
              'padding-top': '3px',
              'padding-bottom': '3px',
              'text-align': 'center',
            }}>
            {reward.name}
          </div>
        ) : (
          <div
            style={{
              'background-color': 'rgba(255, 0, 0, 0.4)',
              'width': '100%',
              'padding-top': '3px',
              'padding-bottom': '3px',
              'text-align': 'center',
            }}>
            {reward.name}
          </div>
        )}
        <div
          style={{
            'display': 'flex',
            'justifyContent': 'center',
            'alignItems': 'center',
            'background-image': 'linear-gradient(black, transparent)',
          }}>
          <span
            className={classes(['battlepass96x96', `${reward.icon_state}`])}
          />
        </div>
        {data.tier >= reward.tier ? (
          <div
            style={{
              'background-image':
                'linear-gradient(rgba(0, 255, 0, 0.4), rgba(212, 68, 23, 0.4))',
              'width': '100%',
              'padding-top': '3px',
              'padding-bottom': '3px',
              'text-align': 'center',
            }}>
            {reward.tier}
          </div>
        ) : (
          <div
            style={{
              'background-image':
                'linear-gradient(rgba(255, 0, 0, 0.4), rgba(212, 68, 23, 0.4))',
              'width': '100%',
              'padding-top': '3px',
              'padding-bottom': '3px',
              'text-align': 'center',
            }}>
            {reward.tier}
          </div>
        )}
        <div
          style={{
            'opacity': '0.5',
          }}>
          <div
            style={{
              'display': 'flex',
              'justifyContent': 'center',
              'alignItems': 'center',
              'background-image': 'linear-gradient(transparent, black)',
            }}>
            <span
              className={classes([
                'battlepass96x96',
                `${premiumReward.icon_state}`,
              ])}
            />
          </div>
          <div
            style={{
              'background-color': 'rgba(212, 68, 23, 0.4)',
              'width': '100%',
              'padding-top': '3px',
              'padding-bottom': '3px',
              'text-align': 'center',
            }}>
            {premiumReward.name}
          </div>
        </div>
      </div>
    </>
  );
};
