import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

interface BattlepassReward {
  name: string;
  icon_state: string;
  tier: number;
}

interface BattlepassData {
  xp: number;
  tier: number;
  xp_tierup: number;
  rewards: BattlepassReward[];
}

export const Battlepass = (props) => {
  return (
    <Window width={450} height={445} theme="usmc">
      <Window.Content scrollable>
        <BattlepassContent />
      </Window.Content>
    </Window>
  );
};

const BattlepassContent = (props) => {
  const { act, data } = useBackend<BattlepassData>();
  const rewards = data.rewards;
  return <div>{rewards.map((reward) => reward.name)}</div>;
};
