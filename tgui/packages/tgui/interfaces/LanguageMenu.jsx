import { capitalize } from 'common/string';
import { Fragment } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Divider, Section } from '../components';
import { Window } from '../layouts';

export const LanguageMenu = (props) => {
  const { act, data } = useBackend();
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

const LanguagesView = (props) => {
  const { act, data } = useBackend();
  const { languages } = data;
  return languages.map((lang, index) => (
    <Fragment key={index}>
      <Button
        fluid
        tooltip={index === 0 ? 'Default language' : 'Make default'}
        color={index === 0 ? 'good' : null}
        onClick={() =>
          act('set_default_language', {
            key: lang.key,
          })
        }
      >
        {capitalize(lang.name) + ' (:' + lang.key + ')'}
      </Button>
      <Box height="3px" />
      <Box>{lang.desc}</Box>
      <Divider />
    </Fragment>
  ));
};
