import { useBackend } from 'tgui/backend';
import { Box, Button, Dropdown, Flex, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

import type { DataCoreData } from './common/commonTypes';

type Data = DataCoreData & {
  local_current_menu: string;
  local_last_page: string;
  local_logged_in: string;
  local_access_text: string;
  local_access_level: number;
  local_notify_sounds: boolean;
};

const PAGES = {
  login: () => Login,
  main: () => MainMenu,
  apollo: () => ApolloLog,
  login_records: () => LoginRecords,
  maint_reports: () => MaintReports,
  maint_claim: () => MaintManagement,
  access_requests: () => AccessRequests,
  access_tickets: () => AccessTickets,
  // id_access: () => AccessID,
  core_security_gas: () => CoreSecGas,
};
export const WorkingJoe = (props) => {
  const { data } = useBackend<Data>();
  const { local_current_menu } = data;
  const PageComponent = PAGES[local_current_menu]();

  let themecolor = 'crtblue';
  if (local_current_menu === 'core_security_gas') {
    themecolor = 'crtred';
  }

  return (
    <Window theme={themecolor} width={950} height={725}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const Login = (props) => {
  const { act } = useBackend();

  return (
    <Flex
      direction="column"
      justify="center"
      align="center"
      height="100%"
      color="darkgrey"
      fontSize="2rem"
      mt="-3rem"
      bold
    >
      <Box fontFamily="monospace">Терминал обслуживания «АПОЛЛО»</Box>
      <Box mb="2rem" fontFamily="monospace">
        ВейЮ-DOS
      </Box>
      <Box fontFamily="monospace">Версия 12.8.3</Box>
      <Box fontFamily="monospace">
        Все права защищены © 2182, Вейланд-Ютани Корп.
      </Box>

      <Button
        icon="id-card"
        width="30vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        mt="5rem"
        onClick={() => act('login')}
      >
        Авторизация
      </Button>
    </Flex>
  );
};

const MainMenu = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    local_access_level,
    local_notify_sounds,
    faction_options,
    sentry_setting,
  } = data;
  let can_request_access = true;
  if (local_access_level > 2) {
    can_request_access = false;
  }
  let soundicon = 'volume-high';
  if (!local_notify_sounds) {
    soundicon = 'volume-xmark';
  }

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Назад"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              tooltip="Главное меню"
              onClick={() => act('home')}
              disabled={local_current_menu === 'main'}
            />
            <Button
              icon={soundicon}
              ml="auto"
              mr="1rem"
              tooltip={
                soundicon === 'volume-high'
                  ? 'Включить звук уведомлений'
                  : 'Выключить звук уведомлений'
              }
              onClick={() => act('toggle_sound')}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Выход
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 style={{ textAlign: 'center' }}>Главное меню</h1>
        <Stack>
          <Stack.Item grow>
            <h3>Запросы</h3>
          </Stack.Item>
          {can_request_access && (
            <Stack.Item>
              <Button
                tooltip="Запрос доступа к системе АРЕС."
                icon="bullhorn"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_request')}
              >
                Запрос доступов
              </Button>
            </Stack.Item>
          )}
          {local_access_level === 3 && (
            <Stack.Item>
              <Button.Confirm
                tooltip="Это действие анулирует ваш временный доступ."
                icon="eye"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('return_access')}
              >
                Сдать временный доступ
              </Button.Confirm>
            </Stack.Item>
          )}
          <Stack.Item>
            <Button
              tooltip="Управление заявками на обслуживание."
              icon="comments"
              ml="auto"
              px="2rem"
              width="33vw"
              bold
              onClick={() => act('page_report')}
            >
              Сервис-заявки
            </Button>
          </Stack.Item>
        </Stack>

        {local_access_level >= 4 && (
          <Stack>
            <Stack.Item grow>
              <h3>Журналы</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Просмотр журнала подключений к АПОЛЛО."
                icon="clipboard"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_apollo')}
              >
                Журнал АПОЛЛО
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Просмотр журнала входов в систему."
                icon="users"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_logins')}
              >
                Входы в систему
              </Button>
            </Stack.Item>
          </Stack>
        )}
        {local_access_level >= 5 && (
          <Stack>
            <Stack.Item grow>
              <h3>Главное управление</h3>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Управление временным доступом к системе."
                icon="user-shield"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_tickets')}
              >
                Доступ к системе
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                tooltip="Управление Maintenance Tickets."
                icon="cart-shopping"
                ml="auto"
                px="2rem"
                width="33vw"
                bold
                onClick={() => act('page_maintenance')}
              >
                Сервис-запросы
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Section>
      {local_access_level >= 5 && (
        <Section>
          <h1 style={{ textAlign: 'center' }}>Протоколы безопасности</h1>
          <Stack>
            <Stack.Item grow>
              <Button
                align="center"
                tooltip="Выпуск накопленного нервно-паралитического газа CN20-X из вентиляции."
                icon="wind"
                color="red"
                ml="auto"
                px="2rem"
                width="100%"
                bold
                onClick={() => act('page_core_gas')}
              >
                Управление газовой системой
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <Button.Confirm
                align="center"
                tooltip="Активировать/деактивировать блокировку ядра ИИ."
                icon="lock"
                color="red"
                ml="auto"
                px="2rem"
                width="100%"
                bold
                onClick={() => act('security_lockdown')}
              >
                Блокировка ядра ИИ
              </Button.Confirm>
            </Stack.Item>
            <Stack.Item ml="0" mr="0">
              <Dropdown
                options={faction_options}
                selected={sentry_setting}
                color="red"
                onSelected={(value) =>
                  act('update_sentries', { chosen_iff: value })
                }
                width="90px"
                disabled={local_access_level < 6}
              />
            </Stack.Item>
          </Stack>
        </Section>
      )}
    </>
  );
};

const ApolloLog = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    apollo_log,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Назад"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Главное меню"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Выход
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 style={{ textAlign: 'center' }}>Журнал АПОЛЛО</h1>

        {apollo_log.map((apollo_message, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{apollo_message}</Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const LoginRecords = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    apollo_access_log,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Назад"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Главное меню"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Выход
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 style={{ textAlign: 'center' }}>Журнал входа в систему</h1>

        {apollo_access_log.map((login, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold>{login}</Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const MaintReports = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    maintenance_tickets,
  } = data;
  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Назад"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Главное меню"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Выход
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 style={{ textAlign: 'center' }}>Заявки на обслуживание</h1>
        <Flex
          direction="column"
          justify="center"
          align="center"
          height="100%"
          color="darkgrey"
          fontSize="2rem"
          mt="-3rem"
          bold
        >
          <Button
            icon="exclamation-circle"
            width="30vw"
            textAlign="center"
            fontSize="1.5rem"
            mt="5rem"
            onClick={() => act('new_report')}
          >
            New Report
          </Button>
        </Flex>

        {!!maintenance_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0" mr="1.5rem">
              №
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Время
            </Flex.Item>
            <Flex.Item width="12rem" bold>
              Категория
            </Flex.Item>
            <Flex.Item width="40rem" bold>
              Описание
            </Flex.Item>
          </Flex>
        )}
        {maintenance_tickets.map((ticket, i) => {
          let view_status = 'Заявка на стадии рассмотрения.';
          let view_icon = 'circle-question';
          if (ticket.status === 'assigned') {
            view_status = 'Заявка принята.';
            view_icon = 'circle-plus';
          } else if (ticket.status === 'rejected') {
            view_status = 'Заявка отклонена.';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = 'Заявка отменена.';
            view_icon = 'circle-stop';
          } else if (ticket.status === 'completed') {
            view_status = 'Заявка решена.';
            view_icon = 'circle-check';
          }
          let can_cancel = true;
          if (
            ticket.submitter !== local_logged_in ||
            ticket.lock_status === 'CLOSED'
          ) {
            can_cancel = false;
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="12rem" mr="1rem">
                {ticket.category}
              </Flex.Item>
              <Flex.Item width="40rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="12rem" ml="1rem">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="file-circle-xmark"
                  tooltip="Отменить заявку"
                  disabled={!can_cancel}
                  onClick={() => act('cancel_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};
const MaintManagement = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    maintenance_tickets,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Назад"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Главное меню"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Выход
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 style={{ textAlign: 'center' }}>
          Управление заявками на обслуживание
        </h1>

        {!!maintenance_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0">
              №
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" ml="1rem">
              Время
            </Flex.Item>
            <Flex.Item width="12rem" bold>
              Категория
            </Flex.Item>
            <Flex.Item width="20rem" bold>
              Описание
            </Flex.Item>
            <Flex.Item width="10rem" bold>
              Принят
            </Flex.Item>
            <Flex.Item width="10rem" bold ml="0.5rem">
              Ответственный
            </Flex.Item>
          </Flex>
        )}
        {maintenance_tickets.map((ticket, i) => {
          let view_status = 'Заявка на стадии рассмотрения.';
          let view_icon = 'circle-question';
          if (ticket.status === 'assigned') {
            view_status = 'Заявка принята.';
            view_icon = 'circle-plus';
          } else if (ticket.status === 'rejected') {
            view_status = 'Заявка отклонена.';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = 'Заявка отменена.';
            view_icon = 'circle-stop';
          } else if (ticket.status === 'completed') {
            view_status = 'Заявка решена.';
            view_icon = 'circle-check';
          }
          let can_claim = true;
          let can_mark = true;
          if (ticket.lock_status === 'CLOSED') {
            can_claim = false;
            can_mark = false;
          }
          if (ticket.assignee !== null && ticket.assignee !== local_logged_in) {
            can_mark = false;
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" ml="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="12rem">{ticket.category}</Flex.Item>
              <Flex.Item width="20rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="10rem" shrink="0" textAlign="left">
                {ticket.submitter}
              </Flex.Item>
              <Flex.Item width="10rem" shrink="0" textAlign="left" ml="0.5rem">
                {ticket.assignee}
              </Flex.Item>
              <Flex.Item width="8rem" ml="1rem" direction="column">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="user-lock"
                  tooltip="Принять тикет"
                  disabled={!can_claim}
                  onClick={() => act('claim_ticket', { ticket: ticket.ref })}
                />
                <Button.Confirm
                  icon="user-gear"
                  tooltip="Отметить заявку"
                  disabled={can_mark}
                  onClick={() => act('mark_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};
const AccessRequests = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_access_level,
    local_last_page,
    local_current_menu,
    access_tickets,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Назад"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Главное меню"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Выход
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 style={{ textAlign: 'center' }}>Заявки на доступ</h1>
        <Flex
          direction="column"
          justify="center"
          align="center"
          height="100%"
          color="darkgrey"
          fontSize="2rem"
          mt="-3rem"
          bold
        >
          <Button
            icon="exclamation-circle"
            width="30vw"
            textAlign="center"
            fontSize="1.5rem"
            mt="5rem"
            onClick={() => act('new_access')}
            disabled={local_access_level > 2}
          >
            Создать
          </Button>
        </Flex>

        {!!access_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0" mr="1.5rem">
              №
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Время
            </Flex.Item>
            <Flex.Item width="8rem" mr="1rem" bold>
              Пользователь
            </Flex.Item>
            <Flex.Item width="40rem" bold>
              Описание
            </Flex.Item>
          </Flex>
        )}
        {access_tickets.map((ticket, i) => {
          let view_status = 'Заявка на стадии рассмотрения.';
          let view_icon = 'circle-question';
          if (ticket.status === 'assigned') {
            view_status = 'Заявка принята.';
            view_icon = 'circle-plus';
          } else if (ticket.status === 'rejected') {
            view_status = 'Заявка отклонена.';
            view_icon = 'circle-xmark';
          } else if (ticket.status === 'cancelled') {
            view_status = 'Заявка отменена.';
            view_icon = 'circle-stop';
          } else if (ticket.status === 'granted') {
            view_status = 'Доступ предоставлен.';
            view_icon = 'circle-check';
          } else if (ticket.status === 'revoked') {
            view_status = 'Доступ отменён.';
            view_icon = 'circle-minus';
          } else if (ticket.status === 'returned') {
            view_status = 'Доступ возвращён.';
            view_icon = 'circle-minus';
          }
          let can_cancel = true;
          if (
            ticket.submitter !== local_logged_in ||
            ticket.lock_status === 'CLOSED'
          ) {
            can_cancel = false;
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              {!!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold color="red">
                  {ticket.id}
                </Flex.Item>
              )}
              {!ticket.priority_status && (
                <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                  {ticket.id}
                </Flex.Item>
              )}
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.title}
              </Flex.Item>
              <Flex.Item width="40rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item width="12rem" ml="1rem">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="file-circle-xmark"
                  tooltip="Отменить заявку"
                  disabled={!can_cancel}
                  onClick={() => act('cancel_ticket', { ticket: ticket.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const AccessTickets = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_last_page,
    local_current_menu,
    access_tickets,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Назад"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Главное меню"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Выход
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 style={{ textAlign: 'center' }}>Управление заявками на доступ</h1>
        {!!access_tickets.length && (
          <Flex
            mt="2rem"
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem"
          >
            <Flex.Item bold width="5rem" shrink="0" mr="1.5rem">
              №
            </Flex.Item>
            <Flex.Item bold width="6rem" shrink="0" mr="1rem">
              Время
            </Flex.Item>
            <Flex.Item width="8rem" mr="1rem" bold>
              Автор
            </Flex.Item>
            <Flex.Item width="8rem" mr="1rem" bold>
              Пользователь
            </Flex.Item>
            <Flex.Item width="30rem" bold>
              Описание
            </Flex.Item>
          </Flex>
        )}
        {access_tickets.map((ticket, i) => {
          let can_update = true;
          if (ticket.lock_status === 'CLOSED') {
            can_update = false;
          }
          let view_status = 'Заявка на стадии рассмотрения.';
          let view_icon = 'circle-question';
          let update_tooltip = 'Grant Access';
          if (ticket.status === 'rejected') {
            view_status = 'Заявка отклонена.';
            view_icon = 'circle-xmark';
            update_tooltip =
              'Заявка была отклонена. Это окончательное решение.';
          } else if (ticket.status === 'cancelled') {
            view_status = 'Заявка отменена.';
            view_icon = 'circle-stop';
            update_tooltip = 'Заявка была отменена. Это окончательное решение.';
          } else if (ticket.status === 'granted') {
            view_status = 'Доступ предоставлен.';
            view_icon = 'circle-check';
            update_tooltip = 'Отозвать доступ';
          } else if (ticket.status === 'revoked') {
            view_status = 'Доступ отозван.';
            view_icon = 'circle-minus';
            update_tooltip = 'Доступ был отозван. Это окончательное решение.';
          } else if (ticket.status === 'returned') {
            view_status = 'Доступ возвращён.';
            view_icon = 'circle-minus';
            update_tooltip = 'Доступ возвращён. Это окончательное решение.';
          }
          let can_reject = true;
          if (!can_update) {
            can_reject = false;
          }
          if (ticket.status !== 'pending') {
            can_reject = false;
          }

          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item width="5rem" shrink="0" mr="1.5rem" bold>
                {ticket.id}
              </Flex.Item>
              <Flex.Item italic width="6rem" shrink="0" mr="1rem">
                {ticket.time}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.submitter}
              </Flex.Item>
              <Flex.Item width="8rem" mr="1rem">
                {ticket.title}
              </Flex.Item>
              <Flex.Item width="30rem" shrink="0" textAlign="left">
                {ticket.details}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button icon={view_icon} tooltip={view_status} />
                <Button.Confirm
                  icon="user-gear"
                  tooltip={update_tooltip}
                  disabled={!can_update}
                  onClick={() => act('auth_access', { ticket: ticket.ref })}
                />
                {can_reject && (
                  <Button.Confirm
                    icon="user-minus"
                    tooltip="Отклонить заявку"
                    disabled={!can_reject}
                    onClick={() => act('reject_access', { ticket: ticket.ref })}
                  />
                )}
              </Flex.Item>
            </Flex>
          );
        })}
      </Section>
    </>
  );
};

const CoreSecGas = (props) => {
  const { data, act } = useBackend<Data>();
  const {
    local_logged_in,
    local_access_text,
    local_access_level,
    local_last_page,
    local_current_menu,
    security_vents,
  } = data;

  return (
    <>
      <Section>
        <Flex align="center">
          <Box>
            <Button
              icon="arrow-left"
              px="2rem"
              textAlign="center"
              tooltip="Назад"
              onClick={() => act('go_back')}
              disabled={local_last_page === local_current_menu}
            />
            <Button
              icon="house"
              ml="auto"
              mr="1rem"
              tooltip="Главное меню"
              onClick={() => act('home')}
            />
          </Box>

          <h3>
            {local_logged_in}, {local_access_text}
          </h3>

          <Button.Confirm
            icon="circle-user"
            ml="auto"
            px="2rem"
            bold
            onClick={() => act('logout')}
          >
            Выход
          </Button.Confirm>
        </Flex>
      </Section>

      <Section>
        <h1 style={{ textAlign: 'center' }}>
          Выброс нервно-паралитического газа
        </h1>
        {security_vents.map((vent, i) => {
          return (
            <Button.Confirm
              key={i}
              align="center"
              icon="wind"
              tooltip="Выпустить газ"
              width="100%"
              disabled={local_access_level < 5 || !vent.available}
              onClick={() => act('trigger_vent', { vent: vent.ref })}
            >
              {vent.vent_tag}
            </Button.Confirm>
          );
        })}
      </Section>
    </>
  );
};
