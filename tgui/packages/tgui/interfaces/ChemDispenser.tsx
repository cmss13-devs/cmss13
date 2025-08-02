import { toFixed } from 'common/math';
import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

import type { BeakerProps } from './common/BeakerContents';

type Data = {
  beakerTransferAmounts: number[];
  amount: number;
  energy: number;
  maxEnergy: number;
  isBeakerLoaded: BooleanLike;
  beakerContents: BeakerProps;
  beakerCurrentVolume: number | null;
  beakerMaxVolume: number | null;
  chemicals: { title: string; id: string }[];
};

export const ChemDispenser = (props) => {
  const { act, data } = useBackend<Data>();
  const beakerTransferAmounts = data.beakerTransferAmounts || [];
  const beakerContents = data.beakerContents || [];
  return (
    <Window width={435} height={620}>
      <Window.Content scrollable>
        <Section title="Статус">
          <LabeledList>
            <LabeledList.Item label="Заряд">
              <ProgressBar value={data.energy / data.maxEnergy}>
                {toFixed(data.energy) + ' энергии'}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Реагенты"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="plus"
              selected={amount === data.amount}
              onClick={() =>
                act('amount', {
                  target: amount,
                })
              }
            >
              {amount}
            </Button>
          ))}
        >
          <Box mr={-1}>
            {data.chemicals.map((chemical) => (
              <Button
                key={chemical.id}
                icon="arrow-alt-circle-down"
                width="129.5px"
                lineHeight={1.75}
                onClick={() =>
                  act('dispense', {
                    reagent: chemical.id,
                  })
                }
              >
                {chemical.title}
              </Button>
            ))}
          </Box>
        </Section>
        <Section
          title="Ёмкость"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="minus"
              onClick={() => act('remove', { amount })}
            >
              {amount}
            </Button>
          ))}
        >
          <LabeledList>
            <LabeledList.Item
              label="Заполнено"
              buttons={
                !!data.isBeakerLoaded && (
                  <Button
                    icon="eject"
                    disabled={!data.isBeakerLoaded}
                    onClick={() => act('eject')}
                  >
                    Извлечь
                  </Button>
                )
              }
            >
              {(data.isBeakerLoaded && (
                <>
                  <AnimatedNumber
                    initial={0}
                    value={data.beakerCurrentVolume || 0}
                  />
                  /{data.beakerMaxVolume} единиц
                </>
              )) || <NoticeBox info>Ёмкость не обнаружена!</NoticeBox>}
            </LabeledList.Item>
            <LabeledList.Item label="Состав">
              <Box color="label">
                {(!data.isBeakerLoaded && 'Н/Д') ||
                  (beakerContents.length === 0 && 'Nothing')}
              </Box>
              {beakerContents.map((chemical) => (
                <Box key={chemical.name} color="label">
                  <AnimatedNumber initial={0} value={chemical.volume} />
                  &nbsp;единиц {chemical.name}
                </Box>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
