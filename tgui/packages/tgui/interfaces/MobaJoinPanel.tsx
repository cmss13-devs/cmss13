// @ts-nocheck

import { classes } from 'common/react';
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

const MainTab2 = () => {
  const { data, act } = useBackend<BackendContext>();
  const [selectedPriority, setSelectedPriority] = useState<number>(1);
  const [casteSelectorOpen, setCasteSelectorOpen] = useState<boolean>(false);

  return casteSelectorOpen ? (
    <MobaCasteSelector setCasteSelectorOpen={setCasteSelectorOpen} />
  ) : (
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
  const pickedCaste: Caste = data.picked_castes[priority - 1];
  let options: string[] = [
    'Top Lane',
    'Jungle',
    'Support',
    'Bottom Lane',
    'None',
  ];
  for (let i = 0; i < options.length; i++) {
    if (pickedCaste.ideal_roles.indexOf(options[i]) !== -1) {
      options[i] = `(Recommended) ${options[i]}`;
    }
  }

  return (
    <Box style={{ margin: 'auto' }}>
      <center>#{priority}</center>
      <Button
        disabled={data.in_queue || data.is_moba_participant}
        onClick={() => setCasteSelectorOpen(true)}
      >
        {data.picked_castes.length >= priority ? (
          <span
            className={classes(['mobacastes60x60', `${pickedCaste.icon_state}`])}
          />
        ) : (
          <span className={classes(['mobacastes60x60', 'empty'])} />
        )}
      </Button>
      <Dropdown
        options={options}
        selected={data.picked_lanes[priority - 1]}
        placeholder={'Select lane...'}
        disabled={!!data.in_queue || !!data.is_moba_participant}
        onSelected={(value) =>
          act('select_lane', { lane: value, priority: priority })
        }
        width={'100%'}
      />
    </Box>
  );
};

const MobaCasteSelector = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const priority: number = props.priority;
  const setCasteSelectorOpen = props.setCasteSelectorOpen;

  return (
    <>
      {data.categories.map((element) => (
        <MobaCasteSelectorCategory
          priority={priority}
          setCasteSelectorOpen={setCasteSelectorOpen}
          category={element}
          key={element}
        />
      ))}
    </>
  );
};

const MobaCasteSelectorCategory = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const priority: number = props.priority;
  const category: string = props.category;
  const setCasteSelectorOpen = props.setCasteSelectorOpen;

  return (
    <>
      <h2>{category}</h2>
      <hr />
      {data.castes_2
        .filter((element) => element.category === category)
        .map((element) => (
          <MobaCasteSelectorButton
            priority={priority}
            setCasteSelectorOpen={setCasteSelectorOpen}
            caste={element}
            key={element}
          />
        ))}
    </>
  );
};

const MobaCasteSelectorButton = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const priority: number = props.priority;
  const caste: Caste = props.caste;
  const setCasteSelectorOpen = props.setCasteSelectorOpen;

  return (
    <Button
      tooltip={caste.desc}
      onClick={() => {
        act('select_caste', { caste: caste.name, priority: priority });
        setCasteSelectorOpen(false);
      }}
    >
      <span className={classes(['mobacastes60x60', `${caste.icon_state}`])} />
    </Button>
  );
};

export const MobaJoinPanel = () => {
  return (
    <Window width={810} height={600} title={'Moba Queue Panel'}>
      <Window.Content>
        <MainTab2 />
      </Window.Content>
    </Window>
  );
};
