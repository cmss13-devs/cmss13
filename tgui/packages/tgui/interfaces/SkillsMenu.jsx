import { capitalizeAll } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Section, Box, ProgressBar, Slider, NoticeBox, Button } from '../components';
import { Window } from '../layouts';

export const SkillsMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const { skillset_name, skills, owner, admin } = data;

  return (
    <Window width={300} height={550}>
      <Window.Content>
        <Section
          title={'Skillset name: ' + skillset_name}
          buttons={
            <Button
              color="transparent"
              tooltip="Refresh"
              tooltipPosition="left"
              icon="sync-alt"
              onClick={() => act('refresh')}
            />
          }>
          {skills ? (
            admin ? (
              <SkillsEdit />
            ) : (
              <SkillsView />
            )
          ) : (
            <NoticeBox danger>Warning! Mob has null skills!</NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const SkillsView = (props, context) => {
  const { act, data } = useBackend(context);
  const { skillset_name, skills, owner, admin } = data;
  return skills.map((skill, index) => (
    <Fragment key={index}>
      <ProgressBar value={skill.level / skill.maxlevel}>
        {capitalizeAll(skill.name)}: {skill.level}/{skill.maxlevel}
      </ProgressBar>
      <Box height="3px" />
    </Fragment>
  ));
};

const SkillsEdit = (props, context) => {
  const { act, data } = useBackend(context);
  const { skillset_name, skills, owner, admin } = data;
  return skills.map((skill, index) => (
    <Fragment key={index}>
      <Slider
        value={skill.level}
        stepPixelSize={150 / skill.maxlevel}
        minValue={0}
        maxValue={skill.maxlevel}
        onChange={(e, value) =>
          act('set_skill', {
            skill: skill.realname,
            level: value,
            oldlevel: skill.level,
          })
        }>
        {capitalizeAll(skill.name)}: {skill.level}/{skill.maxlevel}
      </Slider>
      <Box height="3px" />
    </Fragment>
  ));
};
