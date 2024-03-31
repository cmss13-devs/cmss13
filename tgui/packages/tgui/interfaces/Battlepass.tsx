import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section, Dimmer, Stack } from '../components';
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
    <Window width={1850} height={570} theme="usmc" title="Battlepass">
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
  const [infoView, setInfoView] = useLocalState('info_view', false);
  return (
    <>
      {infoView === true ? (
        <Dimmer>
          <div
            style={{
              'width': '800px',
              'height': '460px',
              'display': 'flex',
              'background-color': '#0c0e1e',
              'font-family': 'Verdana, Geneva, sans-serif',
              'text-align': 'center',
              'justifyContent': 'center',
              'alignItems': 'center',
              'font-size': '18px',
              'padding': '10px',
            }}>
            <Section
              title="Battlepass"
              style={{
                'width': '100%',
                'height': '100%',
              }}>
              The battlepass system is a way of rewarding players with in-game
              rewards for playing well. <br />
              <br />
              On the left of the UI, you can find your objectives. These
              objectives are unique to you and reset every 24 hours. Completing
              them gives you XP. The other way to obtain XP is by playing a
              match to completion. Everyone gets XP regardless of winning or
              losing, but the winning side earns more. Whichever side you join
              first will be the side you gain XP for, even if you log out before
              the round ends.
              <br /> <br />
              Every 10 XP, your battlepass tier increases by 1, granting you new
              rewards to use in game. You can claim rewards with the "Claim
              Battlepass Reward" verb, and come back to this UI with the
              "Battlepass" verb. <br /> <br />
              The premium battlepass is coming soon, purchasable for an
              also-coming-soon 1000 ColonialCoins.
              <br /> <br />
              <Button
                fontSize="16px"
                icon="xmark"
                content="Exit"
                onClick={() => {
                  setInfoView(false);
                }}
              />
            </Section>
          </div>
        </Dimmer>
      ) : (
        <> </>
      )}
      <div
        style={{
          'display': 'flex',
          'overflow': 'auto',
        }}>
        <BattlepassInfoContainer />
        <div
          style={{
            'overflow-x': 'auto',
            'display': 'flex',
            'flex-wrap': 'wrap',
            'position': 'relative',
            'max-width': '1500px',
            'min-width': '1500px',
          }}>
          <div
            style={{
              'position': 'absolute',
              'top': '32%',
              'left': '35%',
              'font-size': '24px',
              'font-family': 'Verdana, Geneva, sans-serif',
              'z-index': `${infoView === true ? '0' : '10'}`,
            }}>
            Premium Battlepass coming soon!
          </div>
          <div
            style={{
              'position': 'absolute',
              'top': '84%',
              'left': '35%',
              'font-size': '24px',
              'font-family': 'Verdana, Geneva, sans-serif',
              'z-index': `${infoView === true ? '0' : '10'}`,
            }}>
            Premium Battlepass coming soon!
          </div>
          {rewards.map((reward, rewardIndex) => (
            <BattlepassRegularEntry
              key={reward.tier}
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
  const [infoView, setInfoView] = useLocalState('info_view', false);
  return (
    <div
      style={{
        'padding-right': '20px',
        'border-right': 'solid',
      }}>
      <Section title="Season 1">
        <Button
          fontSize="12px"
          icon="circle-info"
          content="Information"
          onClick={() => {
            setInfoView(true);
          }}
        />
        <br />
        <b
          style={{
            'font-size': '16px',
          }}>
          Tier: {data.tier} / {data.max_tier}
          <br />
          XP: {data.xp} / 10
        </b>
        {data.daily_challenges.map((challenge) => (
          <BattlepassChallenge challenge={challenge} key={challenge.name} />
        ))}
      </Section>
    </div>
  );
};

const BattlepassChallenge = (props) => {
  const challenge: BattlepassChallenge = props.challenge;
  return (
    <Section title={`${challenge.category} - ${challenge.name}`}>
      {challenge.desc}
      <div
        style={{
          'padding-bottom': '4px',
        }}
      />
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
