import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Tooltip,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type PowerChannel = {
  title: string;
  powerLoad: string;
  status: number;
  topicParams: {
    auto: { eqp?: number; lgt?: number; env?: number };
    on: { eqp?: number; lgt?: number; env?: number };
    off: { eqp?: number; lgt?: number; env?: number };
  };
};

type Data = {
  locked: BooleanLike;
  isOperating: BooleanLike;
  externalPower: number;
  powerCellStatus: number | null;
  chargeMode: BooleanLike;
  chargingStatus: number;
  totalLoad: string;
  totalLoadDemanded: string;
  totalGenerated: string;
  totalGeneratedSurplus: string;
  generatorCount: number;
  coverLocked: BooleanLike;
  siliconUser: BooleanLike;
  powerChannels: PowerChannel[];
  wires: { numbeR: number; cut: BooleanLike }[];
  proper_name: string;
};

export const Apc = (props) => {
  return (
    <Window width={450} height={445}>
      <Window.Content scrollable>
        <ApcContent />
      </Window.Content>
    </Window>
  );
};

const powerStatusMap = {
  4: {
    color: 'average',
    externalPowerText: 'Local Power',
  },
  3: {
    color: 'good',
    externalPowerText: 'External Power',
  },
  2: {
    color: 'average',
    externalPowerText: 'Low External Power',
  },
  1: {
    color: 'bad',
    externalPowerText: 'No External Power',
  },
  0: {
    color: 'bad',
    externalPowerText: 'Electrical Fault',
  },
};

const chargeStatusMap = {
  2: {
    color: 'good',
    chargingText: 'Fully Charged',
  },
  1: {
    color: 'average',
    chargingText: 'Charging',
  },
  0: {
    color: 'bad',
    chargingText: 'Not Charging',
  },
};

const ApcContent = (props) => {
  const { act, data } = useBackend<Data>();
  const locked = data.locked && !data.siliconUser;
  const externalPowerStatus =
    powerStatusMap[data.externalPower] || powerStatusMap[0];
  const chargingStatus =
    chargeStatusMap[data.chargingStatus] || chargeStatusMap[0];
  const channelArray = data.powerChannels || [];
  const adjustedCellChange = data.powerCellStatus
    ? data.powerCellStatus / 100
    : 0;
  return (
    <>
      <InterfaceLockNoticeBox />
      <Section title="Power Status">
        <LabeledList>
          <LabeledList.Item
            label="Main Breaker"
            color={externalPowerStatus.color}
            buttons={
              <Button
                icon={data.isOperating ? 'power-off' : 'times'}
                selected={data.isOperating && !locked}
                disabled={locked}
                onClick={() => act('breaker')}
              >
                {data.isOperating ? 'On' : 'Off'}
              </Button>
            }
          >
            [ {externalPowerStatus.externalPowerText} ]
          </LabeledList.Item>
          <LabeledList.Item label="Power Cell">
            <ProgressBar color="good" value={adjustedCellChange} />
          </LabeledList.Item>
          <LabeledList.Item
            label="Charge Mode"
            color={chargingStatus.color}
            buttons={
              <Button
                icon={data.chargeMode ? 'sync' : 'times'}
                disabled={locked}
                onClick={() => act('charge')}
              >
                {data.chargeMode ? 'Auto' : 'Off'}
              </Button>
            }
          >
            [ {chargingStatus.chargingText} ]
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Power Channels">
        <LabeledList>
          {channelArray.map((channel) => {
            const { topicParams } = channel;
            return (
              <LabeledList.Item
                key={channel.title}
                label={channel.title}
                buttons={
                  <>
                    <Box
                      inline
                      mx={2}
                      color={channel.status >= 2 ? 'good' : 'bad'}
                    >
                      {channel.status >= 2 ? 'On' : 'Off'}
                    </Box>
                    <Button
                      icon="sync"
                      selected={
                        !locked &&
                        (channel.status === 1 || channel.status === 3)
                      }
                      disabled={locked}
                      onClick={() => act('channel', topicParams.auto)}
                    >
                      Auto
                    </Button>
                    <Button
                      icon="power-off"
                      selected={!locked && channel.status === 2}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.on)}
                    >
                      On
                    </Button>
                    <Button
                      icon="times"
                      selected={!locked && channel.status === 0}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.off)}
                    >
                      Off
                    </Button>
                  </>
                }
              >
                {channel.powerLoad}
              </LabeledList.Item>
            );
          })}
          <Tooltip content="How much power is used (Demand includes idle usage that a breaker may be preventing)">
            <LabeledList.Item label="Total Load (Demand)">
              <b>
                {data.totalLoad} ({data.totalLoadDemanded})
              </b>
            </LabeledList.Item>
          </Tooltip>
          {data.generatorCount > 0 && (
            <Tooltip content="How much generators are producing (Surplus is how much is supplied to the grid)">
              <LabeledList.Item label="Generated (Surplus)">
                {data.totalGenerated} ({data.totalGeneratedSurplus})
              </LabeledList.Item>
            </Tooltip>
          )}
        </LabeledList>
      </Section>
      <Section
        title="Misc"
        buttons={
          !!data.siliconUser /* }&& (
            <>

              {!!data.malfStatus && (
                <Button
                  icon={malfStatus.icon}
                  color="bad"
                  onClick={() => act(malfStatus.action)}
                >
                  {malfStatus.content}
                </Button>
              )}
              <Button icon="lightbulb-o" onClick={() => act('overload')}>
                Overload
              </Button>
            </>
          )*/
        }
      >
        <LabeledList>
          <LabeledList.Item
            label="Cover Lock"
            buttons={
              <Button
                tooltip="APC cover can be pried open with a crowbar."
                icon={data.coverLocked ? 'lock' : 'unlock'}
                disabled={locked}
                onClick={() => act('cover')}
              >
                {data.coverLocked ? 'Engaged' : 'Disengaged'}
              </Button>
            }
          />
        </LabeledList>
      </Section>
    </>
  );
};
