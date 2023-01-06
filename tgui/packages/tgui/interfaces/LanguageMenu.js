import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Section, Box, Button, Divider } from '../components';
import { Window } from '../layouts';
import { capitalize } from 'common/string';

export const LanguageMenu = (props, context) => {
  const { act, data } = useBackend(context);
  const { languages } = data;

  const height = 20 + languages.length * 95;

  return (
    <Window width={300} height={height}>
      <Window.Content>
        <Section>
          <LanguagesView />
        </Section>
      </Window.Content>
    </Window>
  );
};

const LanguagesView = (props, context) => {
  const { act, data } = useBackend(context);
  const { languages } = data;
  return languages.map((lang, index) => (
    <Fragment key={index}>
      <Button
        fluid
        content={capitalize(lang.name) + ' (:' + lang.key + ')'}
        tooltip={index === 0 ? 'Default language' : 'Make default'}
        color={index === 0 ? 'good' : null}
        onClick={() =>
          act('set_default_language', {
            key: lang.key,
          })
        }
      />
      <Box height="3px" />
      <Box>{lang.desc}</Box>
      <Divider />
    </Fragment>
  ));
};
