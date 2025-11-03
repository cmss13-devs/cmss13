import { useBackend } from 'tgui/backend';
import { Button, Flex, NoticeBox, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  faction: string;
  cooldown_message: number;
  distresstimelock: number;
  alert_level: number;
  evac_status: number;
  endtime: number;
  distresstime: number;
  worldtime: number;
};

export const CommandTablet = () => {
  const { act, data } = useBackend<Data>();

  const evacstatus = data.evac_status;

  const AlertLevel = data.alert_level;

  const minimumTimeElapsed = data.worldtime > data.distresstimelock;

  const canAnnounce = data.endtime < data.worldtime;

  const distressCooldown = data.worldtime < data.distresstime;

  const canEvac = evacstatus === 0 && AlertLevel >= 2;

  const canDistress =
    AlertLevel === 2 && !distressCooldown && minimumTimeElapsed;

  let distress_reason;
  if (AlertLevel === 3) {
    distress_reason = 'Начат процесс самоуничтожения. Аварийный маяк отключён.';
  } else if (AlertLevel !== 2) {
    distress_reason = 'Уровень угрозы не соответствует аварийной ситуации.';
  } else if (distressCooldown) {
    distress_reason = 'Аварийный маяк перезаряжается.';
  } else if (!minimumTimeElapsed) {
    distress_reason = 'Ещё слишком рано запускать аварийный маяк.';
  }

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        <Section title="Меню">
          <Flex height="100%" direction="column">
            <Flex.Item>
              {!canAnnounce && (
                <Button color="bad" fluid icon="ban">
                  Защита от спама:{' '}
                  {Math.ceil((data.endtime - data.worldtime) / 10)} сек.
                </Button>
              )}
              {!!canAnnounce && (
                <Button
                  fluid
                  icon="bullhorn"
                  onClick={() => act('announce')}
                  disabled={!canAnnounce}
                >
                  Сделать оповещение
                </Button>
              )}
            </Flex.Item>
            <Flex.Item>
              <Button fluid icon="medal" onClick={() => act('award')}>
                Выдать медаль
              </Button>
            </Flex.Item>
            <Flex.Item>
              <Button fluid icon="globe-africa" onClick={() => act('mapview')}>
                Тактическая карта
              </Button>
            </Flex.Item>
            {data.faction === 'USCM' && (
              <Section title="Эвакуация">
                {AlertLevel < 2 && (
                  <NoticeBox color="bad" warning textAlign="center">
                    Перед оповещением об эвакуации должна быть объявлен
                    «Красный» уровень угрозы.
                  </NoticeBox>
                )}
                <Flex.Item>
                  {!canDistress && (
                    <Button
                      disabled={1}
                      tooltip={distress_reason}
                      fluid
                      icon="ban"
                    >
                      {'Аварийный маяк отключён'}
                    </Button>
                  )}
                  {canDistress && (
                    <Button.Confirm
                      fluid
                      color="orange"
                      icon="phone-volume"
                      confirmColor="bad"
                      confirmContent="Confirm?"
                      confirmIcon="question"
                      onClick={() => act('distress')}
                    >
                      {'Включить аварийный маяк'}
                    </Button.Confirm>
                  )}
                </Flex.Item>
                {evacstatus === 0 && (
                  <Flex.Item>
                    <Button.Confirm
                      fluid
                      color="orange"
                      icon="door-open"
                      confirmColor="bad"
                      confirmContent="Подтвердить"
                      confirmIcon="question"
                      onClick={() => act('evacuation_start')}
                      disabled={!canEvac}
                    >
                      {'Объявить эвакуацию'}
                    </Button.Confirm>
                  </Flex.Item>
                )}
                {evacstatus === 1 && (
                  <NoticeBox color="good" info textAlign="center">
                    Начат процесс эвакуации.
                  </NoticeBox>
                )}
                {evacstatus === 2 && (
                  <NoticeBox color="good" info textAlign="center">
                    Запуск спасательных капсул.
                  </NoticeBox>
                )}
                {evacstatus === 3 && (
                  <NoticeBox color="good" success textAlign="center">
                    Эвакуация завершена.
                  </NoticeBox>
                )}
              </Section>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
