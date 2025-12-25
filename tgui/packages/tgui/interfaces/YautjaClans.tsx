import type { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Dropdown, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type YautjaData = {
  user_clan_rank: number;
  user_clan_id: number;

  user_is_council: BooleanLike;
  user_is_superadmin: BooleanLike;

  clans: Clan[];
  clan_names: string[];

  clan_leader_rank: number;
  clan_elder_rank: number;
};

type Clan = {
  label: string;
  desc: string;
  color: string;
  members: Yautja[];
  clan_id?: number;
};

type Yautja = {
  ckey: string;
  player_label: string;
  name: string;
  player_id: number;
  rank: string;
  ancillary: string;
  clan_id: number;
  active_whitelist: BooleanLike;
  is_legacy: BooleanLike;
};

export const YautjaClans = () => {
  return (
    <Window theme="ntos_spooky" width={780} height={725}>
      <Window.Content scrollable>
        <ViewClans />
      </Window.Content>
    </Window>
  );
};

const ViewClans = () => {
  const { data, act } = useBackend<YautjaData>();
  const { clans, clan_names, user_is_council, user_is_superadmin } = data;

  const [currentClan, setCurrentClan] = useState(clans[0]);

  return (
    <Section>
      {!!user_is_superadmin && (
        <Section>
          <Button.Confirm
            bold
            width="auto"
            disabled={!user_is_superadmin}
            onClick={() => act('create_new_clan')}
          >
            New Clan
          </Button.Confirm>
        </Section>
      )}
      <Dropdown
        width="100%"
        menuWidth="200px"
        selected={currentClan.label}
        options={clan_names}
        onSelected={(value) =>
          setCurrentClan(clans[clan_names.findIndex((val) => value === val)])
        }
      />

      <Section color={currentClan.color}>
        <h1>{currentClan.label}</h1>
        <Box mb=".75rem" italic>
          {currentClan.desc}
        </Box>
        {currentClan.clan_id && (
          <>
            <Button.Confirm
              bold
              mt="1rem"
              width="23vw"
              disabled={
                !isClanLeader(currentClan.clan_id) || !currentClan.clan_id
              }
              onClick={() =>
                act('clan_name', {
                  target_clan: currentClan.clan_id,
                })
              }
            >
              Rename Clan
            </Button.Confirm>
            <Button.Confirm
              bold
              mt="1rem"
              width="23vw"
              disabled={
                !isClanLeader(currentClan.clan_id) || !currentClan.clan_id
              }
              onClick={() =>
                act('clan_desc', {
                  target_clan: currentClan.clan_id,
                })
              }
            >
              Change Description
            </Button.Confirm>
            <Button.Confirm
              bold
              mt="1rem"
              width="23vw"
              disabled={
                !isClanLeader(currentClan.clan_id) || !currentClan.clan_id
              }
              onClick={() =>
                act('clan_color', {
                  target_clan: currentClan.clan_id,
                })
              }
            >
              Change Clan Color
            </Button.Confirm>
            {!!user_is_superadmin && (
              <Button.Confirm
                bold
                mt="1rem"
                width="23vw"
                disabled={!user_is_superadmin || !currentClan.clan_id}
                onClick={() =>
                  act('delete_clan', {
                    target_clan: currentClan.clan_id,
                  })
                }
              >
                Delete Clan
              </Button.Confirm>
            )}
          </>
        )}
      </Section>
      {currentClan.members.map((yautja, i) => (
        <Section
          key={i}
          title={yautja.player_label}
          color={yautja.active_whitelist ? 'white' : 'red'}
        >
          <LabeledList>
            <LabeledList.Item label="Name">{yautja.name}</LabeledList.Item>
            <LabeledList.Item label="Rank">{yautja.rank}</LabeledList.Item>
            <LabeledList.Item label="Ancillary">
              {yautja.ancillary}
            </LabeledList.Item>
          </LabeledList>
          <Button.Confirm
            bold
            mt="1rem"
            width="23vw"
            disabled={!isClanElder(currentClan.clan_id)}
            onClick={() =>
              act('assign_ancillary', { target_player: yautja.player_id })
            }
          >
            Assign Ancillary
          </Button.Confirm>
          <Button.Confirm
            bold
            mt="1rem"
            width="23vw"
            disabled={!isClanLeader(currentClan.clan_id)}
            onClick={() =>
              act('change_rank', { target_player: yautja.player_id })
            }
          >
            Change Rank
          </Button.Confirm>
          {!user_is_council && (
            <>
              <Button.Confirm
                bold
                mt="1rem"
                width="23vw"
                disabled={!isClanLeader(currentClan.clan_id)}
                onClick={() =>
                  act('kick_from_clan', { target_player: yautja.player_id })
                }
              >
                Remove From Clan
              </Button.Confirm>
              <Button.Confirm
                bold
                mt="1rem"
                width="23vw"
                disabled={!isClanLeader(currentClan.clan_id)}
                onClick={() =>
                  act('banish_from_clan', { target_player: yautja.player_id })
                }
              >
                Banish
              </Button.Confirm>
            </>
          )}
          {!!user_is_council && (
            <Button.Confirm
              bold
              mt="1rem"
              width="23vw"
              disabled={!user_is_council}
              onClick={() =>
                act('move_to_clan', { target_player: yautja.player_id })
              }
            >
              Change Clan
            </Button.Confirm>
          )}
          {!!user_is_superadmin && (
            <Button.Confirm
              bold
              mt="1rem"
              width="23vw"
              disabled={!user_is_superadmin || yautja.is_legacy}
              onClick={() =>
                act('delete_player_data', { target_player: yautja.player_id })
              }
            >
              Delete Player
            </Button.Confirm>
          )}
        </Section>
      ))}
    </Section>
  );
};

const isClanElder = (clan?: number) => {
  const { data } = useBackend<YautjaData>();

  const { user_clan_id, user_clan_rank, clan_elder_rank, user_is_superadmin } =
    data;

  if (user_is_superadmin) {
    return true;
  }

  if (user_clan_id !== clan) {
    return false;
  }

  if (user_clan_rank < clan_elder_rank) {
    return false;
  }

  return true;
};

const isClanLeader = (clan?: number) => {
  const { data } = useBackend<YautjaData>();

  const { user_clan_id, user_clan_rank, clan_leader_rank, user_is_superadmin } =
    data;

  if (user_is_superadmin) {
    return true;
  }

  if (user_clan_id !== clan) {
    return false;
  }

  if (user_clan_rank < clan_leader_rank) {
    return false;
  }

  return true;
};
