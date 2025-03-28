/* eslint-disable react/no-unescaped-entities */
// @ts-nocheck

import { classes } from 'common/react';
import { useState } from 'react';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Collapsible, Dropdown, Tooltip } from '../components';
import { Window } from '../layouts';
import { logger } from '../logging';

type Caste = {
  name: string;
  desc: string;
  icon_state: string;
  category: string;
  ideal_roles: string[];
};

type BackendContext = {
  castes: Caste[];
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
  const [selectedPriority, setSelectedPriority] = useState<number>(1);
  const [casteSelectorOpen, setCasteSelectorOpen] = useState<boolean>(false);
  const [casteSelectorPriority, setCasteSelectorPriority] = useState<number>(1);
  const [helpMenuOpen, setHelpMenuOpen] = useState<boolean>(false);

  return casteSelectorOpen ? (
    <MobaCasteSelector
      setCasteSelectorOpen={setCasteSelectorOpen}
      priority={casteSelectorPriority}
    />
  ) : (
    <div>
      {helpMenuOpen ? (
        <Box>
          <Button icon="x" onClick={() => setHelpMenuOpen(false)} color="bad">
            Close
          </Button>
          <br />
          <br />
          <Collapsible title="General">
            <Box style={{ paddingLeft: '20px' }}>
              <Collapsible title="What is a MOBA?">
                Multiplayer online battle arenas (MOBA) are a subgenre of
                strategy video games in which two teams of players compete on a
                structured battlefield, each controlling a single character with
                distinctive abilities that grow stronger as the match
                progresses. The objective is to destroy the enemy team's main
                structure while defending one's own.
              </Collapsible>
              <Collapsible title="How do I start?">
                You can play by selecting the three castes and lanes (more on
                this later) you'd prefer to play, and then entering the queue.
                Once eight people are in the queue, a game will be made.
              </Collapsible>
              <Collapsible title="How do I play?">
                Your goal is to destroy the enemy team's hive core while
                protecting your own. On the way, you will be able to improve
                your stats and abilities while spending accumulated money earned
                from kills and objectives on mutations that give you various
                benefits.
              </Collapsible>
              <Collapsible title="What roles are there?">
                There are four primary roles on each team: top lane, bottom
                lane, jungle, and support. Top laners are usually tankier,
                melee-focused castes that can hold their own. Bottom laners are
                typically ranged castes that deal high damage but suffer from
                little survivability. Supports share the bottom lane, and serve
                to empower their teammates. Junglers primarily play in the area
                between the two lanes, and serve to secure secondary objectives
                while applying pressure to lanes.
              </Collapsible>
              <Collapsible title="How is the map laid out?">
                The map is laid out symmetrically, with the top lane being to
                the north and the bottom lane to the south. In-between them lies
                the jungle, a large area with plenty of ambush spots and AI mobs
                to kill.
              </Collapsible>
              <Collapsible title="How do I get stronger?">
                You can become more powerful through the collection of gold and
                experience. Experience lets you level up, boosting your stats
                and letting you improve your abilities. Gold lets you purchase
                items from your team's shop that give you stat bonuses and
                unique effects.
              </Collapsible>
              <Collapsible title="How do I get XP?">
                You can get gold from killing minions, players, and jungle
                simplemobs. Any source of XP is generally shared between all
                nearby allies.
              </Collapsible>
              <Collapsible title="How do I get gold?">
                You can get gold from killing minions, players, jungle
                simplemobs, and destroying enemy turrets. Unlike XP, not all
                sources of gold share between allies. Minions are especially
                important, where the killer only gets the full gold amount if
                they land the killing blow on the minion ("last hitting").
              </Collapsible>
            </Box>
          </Collapsible>
          <Collapsible title="Role-Specific">
            <Box style={{ paddingLeft: '20px' }}>
              <Collapsible title="What is top lane?">
                As a top laner, you are usually a melee-focused frontliner who
                can hold your own in solo fights.
              </Collapsible>
              <Collapsible title="What is bottom lane?">
                As a bottom laner, you're typically playing a more ranged caste
                that may need support, hence sharing a lane with your support.
                Expect a weaker earlygame and a strong lategame.
              </Collapsible>
              <Collapsible title="What is support?">
                As a support, your primary goal is to empower the rest of your
                team (especially your bottom laner) while disrupting the enemy
                team. Considering that you uniquely get passive gold, you should
                focus less on killing minions and instead let your bottom laner
                do that instead.
              </Collapsible>
              <Collapsible title="What is a jungler?">
                As a jungler, you have the most complex role in the game.
                Instead of a lane, you mostly reside in the jungle between the
                two lanes. Your job is to apply pressure on lanes ("ganking")
                and secure secondary objectives that spawn in fixed locations
                throughout the round.
              </Collapsible>
            </Box>
          </Collapsible>
          <Collapsible title="Miscellaneous">
            <Box style={{ paddingLeft: '20px' }}>
              <Collapsible title="Does this save my spot in the larva queue?">
                Currently, joining a game gives up your spot in the larva queue.
                This is planned to change in the future.
              </Collapsible>
              <Collapsible title="What should I do if someone is griefing my game?">
                Please adminhelp people who are intentionally sabotaging their
                own team.
              </Collapsible>
            </Box>
          </Collapsible>
        </Box>
      ) : (
        <Box>
          <Button icon="question" onClick={() => setHelpMenuOpen(true)}>
            Help
          </Button>
          <Box style={{ display: 'flex' }}>
            <MobaCastePicked
              priority={1}
              setCasteSelectorOpen={setCasteSelectorOpen}
              setCasteSelectorPriority={setCasteSelectorPriority}
            />
            <MobaCastePicked
              priority={2}
              setCasteSelectorOpen={setCasteSelectorOpen}
              setCasteSelectorPriority={setCasteSelectorPriority}
            />
            <MobaCastePicked
              priority={3}
              setCasteSelectorOpen={setCasteSelectorOpen}
              setCasteSelectorPriority={setCasteSelectorPriority}
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
      )}
    </div>
  );
};

const MobaCastePicked = (props) => {
  const { data, act } = useBackend<BackendContext>();
  const priority: number = props.priority;
  const setCasteSelectorOpen = props.setCasteSelectorOpen;
  const setCasteSelectorPriority = props.setCasteSelectorPriority;
  const pickedCaste: Caste = data.picked_castes[priority - 1];
  let optionKeys: string[] = [
    'Top Lane',
    'Jungle',
    'Support',
    'Bottom Lane',
    'None',
  ];
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
        onClick={() => {
          setCasteSelectorPriority(priority);
          setCasteSelectorOpen(true);
        }}
      >
        {data.picked_castes.length >= priority ? (
          <span
            className={classes([
              'mobacastes60x60',
              `${pickedCaste.icon_state}`,
            ])}
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
          act('select_lane', {
            lane: optionKeys[options.indexOf(value)],
            priority: priority,
          })
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
      {data.castes
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
    <Tooltip innerhtml={caste.desc}>
      <Button
        onClick={() => {
          logger.log(priority);
          act('select_caste', { caste: caste.name, priority: priority });
          setCasteSelectorOpen(false);
        }}
      >
        <span className={classes(['mobacastes60x60', `${caste.icon_state}`])} />
      </Button>
    </Tooltip>
  );
};

export const MobaJoinPanel = () => {
  return (
    <Window width={810} height={600} title={'Moba Queue Panel'}>
      <Window.Content>
        <MainTab />
      </Window.Content>
    </Window>
  );
};
