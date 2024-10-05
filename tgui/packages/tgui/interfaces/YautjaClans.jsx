import { useBackend } from '../backend';
import { Box, Button, Dropdown, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const YautjaClans = (props) => {
  return (
    <Window theme="ntos_spooky" width={780} height={725}>
      <Window.Content scrollable>
        <ViewClans />
      </Window.Content>
    </Window>
  );
};

const ViewClans = (props) => {
  const { data, act } = useBackend();
  const {
    clans,
    clan_names,
    current_clan_index,
    user_is_clan_leader,
    user_is_council,
    user_is_superadmin,
  } = data;

  return (
    <Section>
      <Dropdown
        width="100%"
        menuWidth="200px"
        selected={clans[current_clan_index].label}
        options={clan_names}
        onSelected={(value) => act('change_clan_list', { new_clan: value })}
      />

      <Section color={clans[current_clan_index].color}>
        <h1>{clans[current_clan_index].label}</h1>
        <Box mb=".75rem" italic>
          {clans[current_clan_index].desc}
        </Box>
      </Section>
      {clans[current_clan_index].members.map((yautja, i) => (
        <Section key={i} title={yautja.player_label}>
          <LabeledList>
            <LabeledList.Item label="Name">{yautja.name}</LabeledList.Item>
            <LabeledList.Item label="Rank">{yautja.rank}</LabeledList.Item>
            <LabeledList.Item label="Ancillary">None</LabeledList.Item>
          </LabeledList>
          <Button
            bold
            mt="1rem"
            width="23vw"
            disabled={!user_is_clan_leader}
            onClick={() => act('change_rank')}
          >
            Change Rank
          </Button>
          <Button
            bold
            mt="1rem"
            width="23vw"
            disabled={!user_is_clan_leader}
            onClick={() => act('assign_ancillary')}
          >
            Assign Ancillary
          </Button>
          {!user_is_council && (
            <>
              <Button
                bold
                mt="1rem"
                width="23vw"
                disabled={!user_is_clan_leader}
                onClick={() => act('kick_from_clan')}
              >
                Remove From Clan
              </Button>
              <Button
                bold
                mt="1rem"
                width="23vw"
                disabled={!user_is_clan_leader}
                onClick={() => act('banish_from_clan')}
              >
                Banish
              </Button>
            </>
          )}
          {user_is_council && (
            <Button
              bold
              mt="1rem"
              width="23vw"
              disabled={!user_is_council}
              onClick={() => act('move_to_clan')}
            >
              Change Clan
            </Button>
          )}
          {user_is_superadmin && (
            <Button
              bold
              mt="1rem"
              width="23vw"
              disabled={!user_is_superadmin}
              onClick={() => act('delete_player_data')}
            >
              Delete Player
            </Button>
          )}
        </Section>
      ))}
    </Section>
  );
};
