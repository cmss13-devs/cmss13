import { useBackend } from '../backend';
import { Button, Collapsible, Box, Stack } from '../components';
import { Window } from '../layouts';

export const Who = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    admin,
    all_clients,
    total_players,
    additional_info,
    factions,
    xenomorphs,
  } = data;

  return (
    <Window resizable width={800} height={600}>
      <Window.Content scrollable>
        <Stack fill vertical>
          <Stack.Item mt={0.2} grow>
            {total_players !== undefined ? (
              <WhoCollapsible title={'Players - ' + all_clients} color="good">
                {total_players.map((x, index) => (
                  <GetPlayerInfo
                    key={x.index}
                    admin={admin}
                    ckey={x.ckey}
                    ckey_color={x.ckey_color}
                    color={x.color}
                    text={x.text}
                  />
                ))}
              </WhoCollapsible>
            ) : null}
            {admin !== 0 ? (
              <WhoCollapsible title="Information" color="olive">
                <Box direction="column">
                  {additional_info !== undefined
                    ? additional_info.map((x, index) => (
                      <GetAddInfo
                        key={x.index}
                        content={x.content}
                        color={x.color}
                        text={x.text}
                      />
                    ))
                    : null}
                  {factions !== undefined
                    ? factions.map((x, index) => (
                      <GetAddInfo
                        key={x.index}
                        content={x.content}
                        color={x.color}
                        text={x.text}
                      />
                    ))
                    : null}
                  {xenomorphs !== undefined
                    ? xenomorphs.map((x, index) => (
                      <GetAddInfo
                        key={x.index}
                        content={x.content}
                        color={x.color}
                        text={x.text}
                      />
                    ))
                    : null}
                </Box>
              </WhoCollapsible>
            ) : null}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const WhoCollapsible = (props, context) => {
  const { title, color, children } = props;
  return (
    <Collapsible title={title} color={color} open>
      {children}
    </Collapsible>
  );
};

const GetAddInfo = (props, context) => {
  const { act } = useBackend(context);
  const { content, color, text } = props;

  return (
    <Button
      color={'transparent'}
      style={{
        'border-color': color,
        'border-style': 'solid',
        'border-width': '1px',
        'color': color,
      }}
      tooltip={text}
      tooltipPosition="bottom-start">
      {content}
    </Button>
  );
};

const GetPlayerInfo = (props, context) => {
  const { act } = useBackend(context);
  const { admin, ckey, ckey_color, color, text } = props;
  return admin !== 0 ? (
    <Button
      color={ckey_color}
      style={{
        'border-color': color,
        'border-style': 'solid',
        'border-width': '1px',
        'color': color,
      }}
      onClick={() => act('get_player_panel', { ckey: ckey })}
      tooltip={text}
      tooltipPosition="bottom-start">
      <b style={{ 'color': ckey_color }}>{ckey}</b>
    </Button>
  ) : (
    <Button
      color={ckey_color}
      style={{
        'border-color': '#2185d0',
        'border-style': 'solid',
        'border-width': '1px',
        'color': ckey_color,
      }}>
      {ckey}
    </Button>
  );
};
