import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Dropdown } from '../components';
import { Window } from '../layouts';

type BackendContext = {
  castes: { [caste_name: string]: string };
  in_queue: BooleanLike;
  can_enter_queue: BooleanLike;
  picked_castes: string[];
  picked_lanes: string[];
  amount_in_queue: number;
  is_moba_participant: BooleanLike;
};

const MainTab = () => {
  const { data, act } = useBackend<BackendContext>();

  return (
    <Box>
      <Box style={{ display: 'flex' }}>
        <RoleCastePick priority={1} />
        <RoleCastePick priority={2} />
        <RoleCastePick priority={3} />
      </Box>
      <br />
      <br />
      <Box style={{ display: 'flex' }}>
        <Box style={{ margin: 'auto' }}>
          Currently {data.amount_in_queue} players in queue.
          <br />
          {data.in_queue ? (
            <Button
              color="bad"
              onClick={() => act('exit_queue')}
              disabled={!!data.is_moba_participant}
            >
              Exit Queue
            </Button>
          ) : (
            <Button
              onClick={() => act('enter_queue')}
              disabled={!data.can_enter_queue || !!data.is_moba_participant}
            >
              Join Queue
            </Button>
          )}
        </Box>
      </Box>
    </Box>
  );
};

const RoleCastePick = (props) => {
  const priority: number = props.priority;
  const { data, act } = useBackend<BackendContext>();
  return (
    <Box style={{ margin: 'auto' }}>
      Priority Slot #{priority}
      <Dropdown
        options={['Top Lane', 'Jungle', 'Support', 'Bottom Lane', 'None']}
        selected={data.picked_lanes[priority - 1]}
        placeholder={'Select lane...'}
        disabled={!!data.in_queue || !!data.is_moba_participant}
        onSelected={(value) =>
          act('select_lane', { lane: value, priority: priority })
        }
      />
      <Dropdown // Swap this out for something better eventually
        options={Object.keys(data.castes)}
        selected={data.picked_castes[priority - 1]}
        placeholder={'Select caste...'}
        disabled={!!data.in_queue || !!data.is_moba_participant}
        onSelected={(value) =>
          act('select_caste', { caste: value, priority: priority })
        }
      />
    </Box>
  );
};

export const MobaJoinPanel = () => {
  return (
    <Window width={810} height={600}>
      <Window.Content>
        <MainTab />
      </Window.Content>
    </Window>
  );
};
