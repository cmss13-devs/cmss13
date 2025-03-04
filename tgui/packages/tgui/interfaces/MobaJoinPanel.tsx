// @ts-nocheck

import { useState } from 'react';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Dropdown } from '../components';
import { Window } from '../layouts';
/*
			"name" = caste.name,
			"desc" = caste.desc,
			"icon_state" = caste.icon_state,
			"category" = caste.category,
			"ideal_roles" = caste.ideal_roles,
*/

type Caste = {
  name: string;
  desc: string;
  icon_state: string;
  category: string;
  ideal_roles: string[];
};

type BackendContext = {
  castes: { [caste_name: string]: string };
  castes_2: Caste[];
  categories: string[];
  in_queue: BooleanLike;
  can_enter_queue: BooleanLike;
  picked_castes: Caste[];
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

const MainTab2 = () => {
  const { data, act } = useBackend<BackendContext>();
  const [selectedPriority, setSelectedPriority] = useState<number>(1);
  const [casteSelectorOpen, setCasteSelectorOpen] = useState<Boolean>(false);

  return (
    <Box>
      <Box style={{ display: 'flex' }}>
        <MobaCastePicked
          priority={1}
          setCasteSelectorOpen={setCasteSelectorOpen}
        />
        <MobaCastePicked
          priority={2}
          setCasteSelectorOpen={setCasteSelectorOpen}
        />
        <MobaCastePicked
          priority={3}
          setCasteSelectorOpen={setCasteSelectorOpen}
        />
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

const MobaCastePicked = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const priority: number = props.priority;
  const setCasteSelectorOpen = props.setCasteSelectorOpen;
  return (
    <Button onClick={setCasteSelectorOpen(true)}>
      {data.picked_castes.length >= priority ? (
        <span
          className={classes([
            'tutorial60x60',
            `${data.picked_castes[priority].icon_state}`,
          ])}
        />
      ) : (
        <span className={classes(['tutorial60x60', 'empty'])} />
      )}
    </Button>
  );
};

const MobaCasteSelector = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const priority: number = props.priority;
  return (
    <>
      {data.categories.forEach((element) => {
        <MobaCasteSelectorCategory priority={priority} category={element} />;
      })}
    </>
  );
};

const MobaCasteSelectorCategory = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const priority: number = props.priority;
  const category: string = props.category;
  return (
    <>
      <h2>{category}</h2>
      <hr />
      {data.castes_2.forEach((element) => {
        if (element.category === category) {
          <MobaCasteSelectorButton priority={priority} caste={element} />;
        }
      })}
    </>
  );
};

const MobaCasteSelectorButton = (props) => {
  const priority: number = props.priority;
  const caste: Caste = props.caste;
  return (
    <Button
      onClick={act('select_caste', { caste: caste.name, priority: priority })}
    >
      <span className={classes(['tutorial60x60', `${caste.icon_state}`])} />
    </Button>
  );
};

export const MobaJoinPanel = () => {
  return (
    <Window width={810} height={600}>
      <Window.Content>
        <MainTab2 />
      </Window.Content>
    </Window>
  );
};
