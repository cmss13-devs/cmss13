import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
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
  3: {
    color: 'average',
    externalPowerText: 'Local Power',
    chargingText: 'Charging',
  },
  2: {
    color: 'good',
    externalPowerText: 'Внешнее питание',
    chargingText: 'Полная зарядка',
  },
  1: {
    color: 'average',
    externalPowerText: 'Low External Power',
    chargingText: 'Зарядка',
  },
  0: {
    color: 'bad',
    externalPowerText: 'No External Power',
    chargingText: 'Не заряжать',
  },
};

const ApcContent = (props) => {
  const { act, data } = useBackend<Data>();
  const locked = data.locked && !data.siliconUser;
  const externalPowerStatus =
    powerStatusMap[data.externalPower] || powerStatusMap[0];
  const chargingStatus =
    powerStatusMap[data.chargingStatus] || powerStatusMap[0];
  const channelArray = data.powerChannels || [];
  const adjustedCellChange = data.powerCellStatus
    ? data.powerCellStatus / 100
    : 0;
  return (
    <>
      <InterfaceLockNoticeBox />
      <Section title="Статус">
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
                {data.isOperating ? 'вкл.' : 'откл.'}
              </Button>
            }
          >
            [ {externalPowerStatus.externalPowerText} ]
          </LabeledList.Item>
          <LabeledList.Item label="Заряд">
            <ProgressBar color="good" value={adjustedCellChange} />
          </LabeledList.Item>
          <LabeledList.Item
            label="Снабжение"
            color={chargingStatus.color}
            buttons={
              <Button
                icon={data.chargeMode ? 'sync' : 'times'}
                disabled={locked}
                onClick={() => act('charge')}
              >
                {data.chargeMode ? 'авт.' : 'откл.'}
              </Button>
            }
          >
            [ {chargingStatus.chargingText} ]
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Питание">
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
          <LabeledList.Item label="Общее">
            <b>{data.totalLoad}</b>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Дополнительно"
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
                tooltip="Крышку ЛКП можно вскрыть с помощью лома."
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
