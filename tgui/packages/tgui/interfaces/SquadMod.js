import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, Section, NoticeBox } from '../components';
import { Window } from '../layouts';
import { map } from 'common/collections';
import { COLORS } from '../constants';

export const SquadMod = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    squads = [],
    human,
    id_name,
    has_id,
  } = data;
  const COLORS_SPECTRUM = [
    'red',
    'yellow',
    'purple',
    'teal',
    'brown',
    'grey',
  ];
  return (
    <Window
      width={400}
      height={300}
      resizable>
      <Window.Content scrollable>
        <Box>
          <Button
            fluid
            icon="eject"
            content={id_name}
            onClick={() => act('PRG_eject')} />
          {(!has_id) && (
            <NoticeBox>
              Insert ID of person, that you want transfer.
            </NoticeBox>
          )}
          {(!human) && (
            <NoticeBox>
              Ask or force person, to place hand on my scanner.
            </NoticeBox>
          )}
          {(human) && (
            <NoticeBox>
              Selected for sqaud transfer: {human}
            </NoticeBox>
          )}
          {(human && has_id) && (
            <Section
              title="Squad Transfer">
              {squads.map(entry => (
                <Button
                  key={entry.name}
                  fluid
                  content={entry.name}
                  color={COLORS_SPECTRUM[entry.color]}
                  onClick={() => act('PRG_squad', {
                    name: entry.name,
                  })} />
              ))}
            </Section>
          )}
        </Box>
      </Window.Content>
    </Window>
  );
};
