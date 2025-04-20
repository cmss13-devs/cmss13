/* eslint-disable react/jsx-no-undef */
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

import type { ParticleUIData } from './data';
import {
  EntryCoord,
  EntryFloat,
  EntryGradient,
  EntryIcon,
  EntryIconState,
  EntryTransform,
} from './EntriesBasic';
import {
  EntryGeneratorNumbersList,
  FloatGenerator,
  FloatGeneratorColor,
} from './EntriesGenerators';
import { ShowDesc } from './Tutorial';

export const ParticleEdit = (props) => {
  const { act, data } = useBackend<ParticleUIData>();
  const [desc, setDesc] = useState('');

  const {
    width,
    height,
    count,
    spawning,
    bound1,
    bound2,
    gravity,
    gradient,
    transform,

    icon,
    icon_state,
    lifespan,
    fade,
    fadein,
    color,
    color_change,
    position,
    velocity,
    scale,
    grow,
    rotation,
    spin,
    friction,

    drift,
  } = data.particle_data;

  return (
    <Window title={data.target_name + "'s particles"} width={940} height={890}>
      {desc ? <ShowDesc desc={desc} setDesc={setDesc} /> : null}
      <Window.Content scrollable>
        <LabeledList>
          <Section
            title={'Affects entire set'}
            buttons={
              <>
                <Button
                  icon={'question'}
                  onClick={() => setDesc('generator')}
                  tooltip={'Generator information'}
                />
                <Button
                  icon={'sync'}
                  onClick={() => act('new_type')}
                  tooltip={'Change type'}
                />
                <Button
                  icon={'x'}
                  color={'red'}
                  onClick={() => act('delete_and_close')}
                  tooltip={'Delete and close UI'}
                />
              </>
            }
          >
            <EntryFloat
              setDesc={setDesc}
              name={'Width'}
              var_name={'width'}
              float={width}
            />
            <EntryFloat
              setDesc={setDesc}
              name={'Height'}
              var_name={'height'}
              float={height}
            />
            <EntryFloat
              setDesc={setDesc}
              name={'Count'}
              var_name={'count'}
              float={count}
            />
            <EntryFloat
              setDesc={setDesc}
              name={'Spawning'}
              var_name={'spawning'}
              float={spawning}
            />
            <EntryCoord
              setDesc={setDesc}
              name={'Bound corner 1'}
              var_name={'bound1'}
              coord={bound1}
            />
            <EntryCoord
              setDesc={setDesc}
              name={'Bound corner 2'}
              var_name={'bound2'}
              coord={bound2}
            />
            <EntryCoord
              setDesc={setDesc}
              name={'Gravity'}
              var_name={'gravity'}
              coord={gravity}
            />
            <EntryGradient
              setDesc={setDesc}
              name={'Gradient'}
              var_name={'gradient'}
              gradient={gradient}
            />
            <EntryTransform
              setDesc={setDesc}
              name={'Transform'}
              var_name={'transform'}
              transform={transform}
            />
          </Section>
          <Section title={'Evaluated on particle creation'}>
            <EntryIcon
              setDesc={setDesc}
              name={'Icon'}
              var_name={'icon'}
              icon_state={icon}
            />
            <EntryIconState
              setDesc={setDesc}
              name={'Icon State'}
              var_name={'icon_state'}
              icon_state={icon_state}
            />
            <FloatGenerator
              setDesc={setDesc}
              name={'Lifespan'}
              var_name={'lifespan'}
              float={lifespan}
            />
            <FloatGenerator
              setDesc={setDesc}
              name={'Fade out'}
              var_name={'fade'}
              float={fade}
            />
            <FloatGenerator
              setDesc={setDesc}
              name={'Fade in'}
              var_name={'fadein'}
              float={fadein}
            />
            <FloatGeneratorColor
              setDesc={setDesc}
              name={'Color'}
              var_name={'color'}
              float={color}
            />
            <FloatGenerator
              setDesc={setDesc}
              name={'Color change'}
              var_name={'color_change'}
              float={color_change}
            />
            <EntryGeneratorNumbersList
              setDesc={setDesc}
              name={'Position'}
              var_name={'position'}
              allow_z
              input={position}
            />
            <EntryGeneratorNumbersList
              setDesc={setDesc}
              name={'Velocity'}
              var_name={'velocity'}
              allow_z
              input={velocity}
            />
            <EntryGeneratorNumbersList
              setDesc={setDesc}
              name={'Scale'}
              var_name={'scale'}
              allow_z={false}
              input={scale}
            />
            <EntryGeneratorNumbersList
              setDesc={setDesc}
              name={'Grow'}
              var_name={'grow'}
              allow_z={false}
              input={grow}
            />
            <FloatGenerator
              setDesc={setDesc}
              name={'Rotation'}
              var_name={'rotation'}
              float={rotation}
            />
            <FloatGenerator
              setDesc={setDesc}
              name={'Spin'}
              var_name={'spin'}
              float={spin}
            />
            <FloatGenerator
              setDesc={setDesc}
              name={'Friction'}
              var_name={'friction'}
              float={friction}
            />
          </Section>
          <Section title={'Evaluated every tick'}>
            <EntryGeneratorNumbersList
              setDesc={setDesc}
              name={'Drift'}
              var_name={'drift'}
              allow_z
              input={drift}
            />
          </Section>
        </LabeledList>
      </Window.Content>
    </Window>
  );
};
