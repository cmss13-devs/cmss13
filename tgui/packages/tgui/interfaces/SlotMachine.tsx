import { useBackend } from '../backend';
import { Button, Icon, Section } from '../components';
import { Window } from '../layouts';

type IconInfo = {
  value: number;
  colour: string;
  icon_name: string;
};

type BackendData = {
  state: any[];
  balance: number;
  rolling: boolean;
  prize_money: number;
  cost: number;
  plays: number;
  jackpots: number;
  jackpot: number;
};

type SlotsTileProps = {
  readonly icon: string;
  readonly color?: string;
  readonly background?: string;
};

type SlotsReelProps = {
  readonly reel: IconInfo[];
};

const pluralS = (amount: number) => {
  return amount === 1 ? '' : 's';
};

const SlotsReel = (props: SlotsReelProps) => {
  const { reel } = props;
  return (
    <div
      style={{
        display: 'inline-flex',
        flexDirection: 'column',
      }}
    >
      {reel.map((slot, i) => (
        <SlotsTile key={i} icon={slot.icon_name} color={slot.colour} />
      ))}
    </div>
  );
};

const SlotsTile = (props: SlotsTileProps) => {
  return (
    <div
      style={{
        textAlign: 'center',
        padding: '1rem',
        margin: '0.5rem',
        display: 'inline-block',
        width: '5rem',
        background: props.background || 'rgba(62, 97, 137, 1)',
      }}
    >
      <Icon className={`color-${props.color}`} size={2.5} name={props.icon} />
    </div>
  );
};

export const SlotMachine = () => {
  const { act, data } = useBackend<BackendData>();
  const {
    plays,
    jackpots,
    prize_money,
    cost,
    state,
    balance,
    jackpot,
    rolling,
  } = data;

  return (
    <Window>
      <Section
        title="Slots!"
        style={{ justifyContent: 'center', textAlign: 'center' }}
      >
        <Section style={{ textAlign: 'left' }}>
          <p>
            Only <b>{cost}</b> credit{pluralS(cost)} for a chance to win big!
          </p>
          <p>
            Available prize money:{' '}
            <b>
              {prize_money} credit{pluralS(prize_money)}
            </b>{' '}
          </p>
          <p>
            Current jackpot:{' '}
            <b>
              {prize_money + jackpot} credit{pluralS(prize_money + jackpot)}!
            </b>
          </p>
          <p>
            So far people have spun{' '}
            <b>
              {plays} time{pluralS(plays)},
            </b>{' '}
            and won{' '}
            <b>
              {jackpots} jackpot{pluralS(jackpots)}!
            </b>
          </p>
        </Section>
        <hr />
        <Section
          style={{
            flexDirection: 'row',
            display: 'flex',
            justifyContent: 'center',
          }}
        >
          {state.map((reel, i) => {
            return <SlotsReel key={i} reel={reel} />;
          })}
        </Section>
        <hr />
        <Button
          onClick={() => act('spin')}
          disabled={rolling || balance < cost}
        >
          Spin!
        </Button>
        <Section>
          <b>Balance: {balance}</b>
          <br />
          <Button onClick={() => act('payout')} disabled={!(balance > 0)}>
            Refund balance
          </Button>
        </Section>
      </Section>
    </Window>
  );
};
