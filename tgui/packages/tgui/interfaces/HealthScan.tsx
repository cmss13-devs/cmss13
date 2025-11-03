import { round } from 'common/math';
import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type LimbData = {
  name: string;
  brute: number;
  burn: number;
  bandaged: BooleanLike;
  salved: BooleanLike;
  missing: BooleanLike;
  bleeding: BooleanLike;
  implant: BooleanLike;
  internal_bleeding: BooleanLike;
  limb_status?: string;
  limb_splint?: string;
  limb_type?: string;
  open_incision: BooleanLike | string;
  open_zone_incision: string;
};

type HumanData = {
  has_blood: BooleanLike;
  species?: string;
  permadead: BooleanLike;
  lung_ruptured: BooleanLike;
  heart_broken: BooleanLike;
  limb_data_lists?: Record<string, LimbData>;
  limbs_damaged: number;
  internal_bleeding: BooleanLike;
  body_temperature: string;
  pulse: string;
  implants: number;
  core_fracture: BooleanLike;
  damaged_organs: {
    name: string;
    damage: number;
    status: string;
    robotic: BooleanLike;
  }[];
  advice: { advice: string; icon: string; color: string }[] | null;
  diseases:
    | {
        name: string;
        form: string;
        type: string | null;
        stage: number;
        max_stage: number;
        cure: string | null;
      }[]
    | null;
  ssd: string | null;
};

type Data = {
  patient: string;
  dead: BooleanLike;
  health: number;
  total_brute: number;
  total_burn: number;
  toxin: number;
  oxy: number;
  clone: number;
  blood_type: string;
  blood_amount: number;
  holocard: string | null;
  hugged: string | null;
  ui_mode: number;
  detail_level: number;
  has_unknown_chemicals: BooleanLike;
  has_chemicals: number;
  chemicals_lists: {
    name: string;
    amount: number;
    od: BooleanLike;
    dangerous: BooleanLike;
    color: string;
  }[];
} & Partial<HumanData>;

export const HealthScan = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    patient,
    detail_level,
    species,
    has_chemicals,
    diseases,
    advice,
    limbs_damaged,
    damaged_organs,
    ui_mode,
  } = data;

  const bodyscanner = detail_level >= 1;
  const Synthetic = species === 'Synthetic';
  const theme = Synthetic ? 'hackerman' : bodyscanner ? 'ntos' : 'default';

  return (
    <Window
      width={ui_mode ? 300 : 500}
      height={bodyscanner ? 700 : 600}
      theme={theme}
      title={'Пациент: ' + patient}
    >
      <Window.Content scrollable>
        <Patient />
        {limbs_damaged ? <ScannerLimbs /> : null}
        {has_chemicals ? <ScannerChems /> : null}
        <Misc />
        {diseases ? <Diseases /> : null}
        {advice && !ui_mode ? <MedicalAdvice /> : null}
        {damaged_organs?.length && bodyscanner ? <ScannerOrgans /> : null}
      </Window.Content>
    </Window>
  );
};

const Patient = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    dead,
    health,
    total_brute,
    total_burn,
    toxin,
    oxy,
    clone,
    ui_mode,
    ssd,
    hugged,
    detail_level,
    permadead,
    heart_broken,
    species,
    holocard,
  } = data;

  const holocardMessages = {
    red: 'Необходима срочная помощь',
    orange: 'Необходима операция',
    purple: 'Заражён паразитом XX-121',
    black: 'Скончался',
    none: 'Нет данных',
  };
  const ghostscan = detail_level >= 2;
  const Synthetic = species === 'Synthetic';

  let holocard_message = holocardMessages[holocard || 'none'];
  return (
    <Section>
      {hugged && ghostscan ? (
        <NoticeBox danger>
          Patient has been implanted with an alien embryo!
        </NoticeBox>
      ) : null}
      {dead ? <NoticeBox danger>Пациент при смерти!</NoticeBox> : null}
      {ssd ? (
        <NoticeBox warning color="grey">
          {ssd}
        </NoticeBox>
      ) : null}

      {ui_mode ? (
        <Stack vertical>
          {dead ? (
            <Stack.Item>
              <Stack>
                <Stack.Item>Состояние:</Stack.Item>
                <Stack.Item>
                  <Box color={permadead ? 'red' : 'green'} bold>
                    {permadead
                      ? heart_broken
                        ? 'Требуется операция на сердце'
                        : 'Скончался'
                      : Synthetic
                        ? 'Требуется перезагрузка'
                        : 'Требуется дефибрилляция'}
                  </Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          ) : null}
          <Stack.Item>
            <Stack>
              <Stack.Item>Урон:</Stack.Item>
              <Stack.Item>
                <Box inline bold color={'red'} mr={1}>
                  {total_brute}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box inline bold color={'#ffb833'} mx={1}>
                  {total_burn}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box inline bold color={'green'} mx={1}>
                  {toxin}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box inline bold color={'blue'} mx={1}>
                  {oxy}
                </Box>
              </Stack.Item>
              {!!clone && (
                <Box inline bold color={'teal'} mx={1}>
                  {clone}
                </Box>
              )}
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item>Медголокарта:</Stack.Item>
              {holocard ? (
                <Stack.Item>
                  <ColorBox color={holocard} />
                </Stack.Item>
              ) : (
                <Stack.Item>
                  <Icon name="x" />
                </Stack.Item>
              )}
              <Stack.Item>
                <Box
                  inline
                  onClick={() => act('change_holo_card')}
                  backgroundColor="rgba(255, 255, 255, .05)"
                >
                  Изменить
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box
                  inline
                  onClick={() => act('change_ui_mode')}
                  backgroundColor="rgba(255, 255, 255, .05)"
                >
                  Увеличить UI
                </Box>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      ) : (
        <LabeledList>
          <LabeledList.Item label="Здоровье">
            {health >= 0 ? (
              <ProgressBar
                value={health / 100}
                ranges={{
                  good: [0.7, Infinity],
                  average: [0.2, 0.7],
                  bad: [-Infinity, 0.2],
                }}
              >
                {health}%
              </ProgressBar>
            ) : (
              <ProgressBar
                value={1 + health / 100}
                ranges={{
                  bad: [-Infinity, Infinity],
                }}
              >
                {health}%
              </ProgressBar>
            )}
          </LabeledList.Item>
          {dead ? (
            <LabeledList.Item label="Condition">
              <Box color={permadead ? 'red' : 'green'} bold>
                {permadead
                  ? heart_broken
                    ? 'Инфаркт миокарда, требуется операция'
                    : 'Дефибрилляция невозможна, пациент скончался'
                  : Synthetic
                    ? 'Сбой системы питания, требуется перезапуск'
                    : 'Остановка сердца, требуется дефибрилляция'}
              </Box>
            </LabeledList.Item>
          ) : null}
          <LabeledList.Item label="Урон">
            <Box inline>
              <ProgressBar value={0}>
                Физ.:{' '}
                <Box inline bold color={'red'}>
                  {total_brute}
                </Box>
              </ProgressBar>
            </Box>
            <Box inline width={'5px'} />
            <Box inline>
              <ProgressBar value={0}>
                Терм.:{' '}
                <Box inline bold color={'#ffb833'}>
                  {total_burn}
                </Box>
              </ProgressBar>
            </Box>
            <Box inline width={'5px'} />
            <Box inline>
              <ProgressBar value={0}>
                Токс.:{' '}
                <Box inline bold color={'green'}>
                  {toxin}
                </Box>
              </ProgressBar>
            </Box>
            <Box inline width={'5px'} />
            <Box inline>
              <ProgressBar value={0}>
                Гипокс.:{' '}
                <Box inline bold color={'blue'}>
                  {oxy}
                </Box>
              </ProgressBar>
            </Box>
            <Box inline width={'5px'} />
            {!!clone && (
              <Box inline>
                <ProgressBar value={0}>
                  Clone:{' '}
                  <Box inline bold color={'teal'}>
                    {clone}
                  </Box>
                </ProgressBar>
              </Box>
            )}
          </LabeledList.Item>
          <LabeledList.Item label="Медголокарта">
            <NoticeBox color={holocard} inline>
              {holocard_message}
            </NoticeBox>

            <Button
              inline
              style={{ marginLeft: '2%' }}
              onClick={() => act('change_holo_card')}
            >
              Изменить
            </Button>

            <Button inline onClick={() => act('change_ui_mode')}>
              Уменьшить UI
            </Button>
          </LabeledList.Item>
        </LabeledList>
      )}
    </Section>
  );
};

const Misc = (props) => {
  const { data } = useBackend<Data>();
  const {
    blood_type,
    blood_amount,
    has_blood,
    body_temperature,
    pulse,
    implants = 0,
    core_fracture,
    lung_ruptured,
    hugged,
    detail_level,
    ui_mode,
  } = data;
  const bloodpct = blood_amount / 560;
  const healthanalyser = detail_level < 1;
  const bodyscanner = detail_level >= 1;
  return (
    <Section>
      <LabeledList>
        {has_blood ? (
          <LabeledList.Item label={'Группа крови (' + blood_type + ')'}>
            <Box
              color={
                bloodpct > 0.9 ? 'green' : bloodpct > 0.7 ? 'orange' : 'red'
              }
            >
              {Math.round(blood_amount / 5.6)}%, {round(blood_amount * 10, 2)}{' '}
              мл
            </Box>
          </LabeledList.Item>
        ) : null}
        <LabeledList.Item label={'Температура'}>
          {body_temperature}
        </LabeledList.Item>
        <LabeledList.Item label={'Пульс'}>{pulse}</LabeledList.Item>
      </LabeledList>
      {implants || hugged || core_fracture || (lung_ruptured && bodyscanner) ? (
        <Divider />
      ) : null}
      {implants && detail_level !== 1 ? (
        <NoticeBox danger>
          {implants} embedded object{implants > 1 ? 's' : ''} detected!
          {healthanalyser && !ui_mode
            ? ' Advanced scanner required for location.'
            : null}
        </NoticeBox>
      ) : null}
      {(implants || hugged) && detail_level === 1 ? (
        <NoticeBox danger>
          {implants + (hugged ? 1 : 0)} unknown bod
          {implants + (hugged ? 1 : 0) > 1 ? 'ies' : 'y'} detected!
        </NoticeBox>
      ) : null}
      {lung_ruptured && bodyscanner ? (
        <NoticeBox danger>Выявлен разрыв лёгких!</NoticeBox>
      ) : null}
      {core_fracture && healthanalyser ? (
        <NoticeBox danger>
          Bone fractures detected!
          {!ui_mode ? ' Advanced scanner required for location.' : null}
        </NoticeBox>
      ) : null}
    </Section>
  );
};

const Diseases = (props) => {
  const { data } = useBackend<Data>();
  const { diseases } = data;
  return (
    <Section title="Diseases">
      <LabeledList>
        {diseases?.map((disease) => (
          <LabeledList.Item
            key={disease.name}
            label={disease.name[0].toUpperCase() + disease.name.slice(1)}
          >
            <Box inline bold>
              Type : {disease.type}, possible cure : {disease.cure}
            </Box>
            <Box inline width={'5px'} />
            <Box inline>
              <ProgressBar
                width="200px"
                value={disease.stage / disease.max_stage}
                ranges={{
                  good: [-Infinity, 20],
                  average: [20, 50],
                  bad: [50, Infinity],
                }}
              >
                Stage:{disease.stage}/{disease.max_stage}
              </ProgressBar>
            </Box>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const MedicalAdvice = (props) => {
  const { data } = useBackend<Data>();
  const { advice } = data;
  return (
    <Section title="Рекомендации">
      <Stack vertical>
        {advice?.map((advice) => (
          <Stack.Item key={advice.advice}>
            <Box inline>
              <Icon name={advice.icon} ml={0.2} color={advice.color} />
              <Box inline width={'5px'} />
              {advice.advice}
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const ScannerChems = (props) => {
  const { data } = useBackend<Data>();
  const { has_unknown_chemicals, chemicals_lists, ui_mode } = data;
  const chemicals = Object.values(chemicals_lists);

  return (
    <Section title={ui_mode ? null : 'Вещества в организме'}>
      {has_unknown_chemicals ? (
        <NoticeBox warning color="grey">
          Регистрируются неизвестные вещества.
        </NoticeBox>
      ) : null}
      <Stack vertical>
        {chemicals.map((chemical) => (
          <Stack.Item key={chemical.name}>
            <Box inline>
              <Icon name={'flask'} ml={0.2} color={chemical.color} />
              <Box inline width={'5px'} />
              <Box
                inline
                color={chemical.dangerous ? 'red' : 'white'}
                bold={!!chemical.dangerous}
              >
                {chemical.amount + ' ед. ' + chemical.name}
              </Box>
              <Box inline width={'5px'} />
              {chemical.od ? (
                <Box inline color={'red'} bold>
                  {'[ПЕРЕДОЗИРОВКА]'}
                </Box>
              ) : null}
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const ScannerLimbs = (props) => {
  const { data } = useBackend<Data>();
  const { limb_data_lists = {}, detail_level, ui_mode } = data;
  const limb_data = Object.values(limb_data_lists) as (LimbData & {
    unbandaged: boolean;
    unsalved: boolean;
  })[];
  const bodyscanner = detail_level >= 1;

  let index = 0;
  const row_bg_color = 'rgba(255, 255, 255, .05)';

  limb_data.forEach((limb) => {
    limb.unbandaged = !limb.bandaged && limb.brute > 0 && !limb.limb_type;
    limb.unsalved = !limb.salved && limb.burn > 0 && !limb.limb_type;
  });

  return (
    <Section title={ui_mode ? null : 'Повреждённые части тела'}>
      <Stack vertical fill>
        {ui_mode ? null : (
          <Flex width="100%" height="20px">
            <Flex.Item basis="120px" />
            <Flex.Item basis="55px" bold color="red">
              Физ.
            </Flex.Item>
            <Flex.Item basis="55px" bold color="#ffb833">
              Терм.
            </Flex.Item>
            <Flex.Item grow="1" shrink="1" textAlign="right" nowrap>
              {'{#} - не обработано'}
            </Flex.Item>
          </Flex>
        )}
        {limb_data.map((limb) => (
          <Flex
            key={limb.name}
            width="100%"
            minHeight="15px"
            py="3px"
            backgroundColor={index++ % 2 === 0 ? row_bg_color : ''}
          >
            <Flex.Item basis="120px" shrink="0" bold pl="3px">
              {limb.name[0].toUpperCase() + limb.name.slice(1)}
            </Flex.Item>
            {limb.missing ? (
              <Flex.Item color={'red'} bold={1}>
                ОТСУТСТВУЕТ
              </Flex.Item>
            ) : (
              <>
                <Flex.Item basis="fit-content" shrink="0">
                  <Box
                    inline
                    width="50px"
                    color={limb.brute > 0 ? 'red' : 'white'}
                  >
                    {limb.unbandaged ? `{${limb.brute}}` : `${limb.brute}`}
                  </Box>
                  <Box
                    inline
                    width="40px"
                    color={limb.burn > 0 ? '#ffb833' : 'white'}
                  >
                    {limb.unsalved ? `{${limb.burn}}` : `${limb.burn}`}
                  </Box>
                </Flex.Item>
                <Flex.Item shrink="1">
                  {limb.bleeding ? (
                    <Box inline color={'red'} bold>
                      {ui_mode ? `[К]` : `[Кровотечение]`}
                    </Box>
                  ) : null}
                  {limb.internal_bleeding ? (
                    <Box inline color={'red'} bold>
                      {ui_mode ? `[ВК]` : `[Внутреннее кровотечение]`}
                    </Box>
                  ) : null}
                  {limb.limb_status ? (
                    <Box inline color="white" bold>
                      {ui_mode ? '[П]' : `[Перелом]`}
                    </Box>
                  ) : null}
                  {limb.limb_splint ? (
                    <Box inline color={'lime'} bold>
                      {ui_mode ? '[Ш]' : `[Наложена шина]`}
                    </Box>
                  ) : null}
                  {limb.limb_type ? (
                    <Box
                      inline
                      color={
                        limb.limb_type === 'Nonfunctional Cybernetic'
                          ? 'red'
                          : 'green'
                      }
                      bold
                    >
                      {ui_mode ? '[КИБ]' : `[Кибернетическая]`}
                    </Box>
                  ) : null}
                  {limb.open_incision ? (
                    <Box inline color={'red'} bold>
                      {ui_mode ? `[ХР}]` : `[Хирургический разрез]`}
                    </Box>
                  ) : null}
                  {limb.implant && bodyscanner ? (
                    <Box inline color={'white'} bold>
                      {ui_mode ? `[ИТ]` : `[Инородное тело]`}
                    </Box>
                  ) : null}
                  {limb.open_zone_incision ? (
                    <Box inline color={'red'} bold>
                      [Open Surgical Incision In {limb.open_zone_incision}]
                      {ui_mode
                        ? `[ХР:${limb.open_zone_incision}]`
                        : `[Хирургический разрез ${limb.open_zone_incision}]`}
                    </Box>
                  ) : null}
                </Flex.Item>
              </>
            )}
          </Flex>
        ))}
      </Stack>
    </Section>
  );
};

const ScannerOrgans = (props) => {
  const { data } = useBackend<Data>();
  const { damaged_organs = [], ui_mode } = data;

  return (
    <Section title={ui_mode ? null : 'Повреждения органов'}>
      <LabeledList>
        {damaged_organs.map((organ) => (
          <LabeledList.Item
            key={organ.name}
            label={organ.name[0].toUpperCase() + organ.name.slice(1)}
          >
            <Box
              inline
              color={organ.status === 'Лёгкое' ? 'orange' : 'red'}
              bold
            >
              {organ.status + ' [' + organ.damage + ' урона]'}
            </Box>
            <Box inline width={'5px'} />
            {organ.robotic ? (
              <Box inline bold color="blue">
                Robotic
              </Box>
            ) : null}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
