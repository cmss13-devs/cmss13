import { capitalize } from 'common/string';
import { Fragment } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Divider, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  languages: { name: string; desc: string; key: string; hearOnly: boolean }[];
};

export const LanguageMenu = (props) => {
  const { act, data } = useBackend<Data>();
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
  const { act, data } = useBackend<Data>();
  const { languages } = data;
  return languages.map((lang, index) => (
    <Fragment key={index}>
      <Button
        fluid
        tooltip={
          lang.hearOnly
            ? 'You can not speak this language'
            : index === 0
              ? 'Default language'
              : 'Make default'
        }
        color={index === 0 ? 'good' : null}
        disabled={lang.hearOnly}
        onClick={() =>
          act('set_default_language', {
            key: lang.key,
          })
        }
      >
        {capitalize(lang.name) + ' (!' + lang.key + ')'}
      </Button>
      <Box height="3px" />
      <Box>
        {lang.desc}
        {lang.hearOnly
          ? ' - You can not speak this language, only understand it being spoken.'
          : ''}
      </Box>
      <Divider />
    </Fragment>
  ));
};
