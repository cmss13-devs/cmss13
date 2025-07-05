import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Button, Flex, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  current_allies: Record<string, BooleanLike>;
  glob_factions: Record<string, string[]>;
};

export const HiveFaction = (props) => {
  const { act, data } = useBackend<Data>();
  const { glob_factions, current_allies } = data;

  const onFactionButtonClick = (faction) =>
    act('set_ally', {
      should_ally: !current_allies[faction],
      target_faction: faction,
    });

  return (
    <Window theme="xeno" width={400} height={550}>
      <Window.Content scrollable>
        <Flex>
          <Section title="Xenomorph" height="100%" width="100%" mr={1}>
            {glob_factions['Xenomorph'].map((faction) => (
              <Button.Checkbox
                key={faction}
                width="100%"
                checked={current_allies[faction]}
                onClick={() => onFactionButtonClick(faction)}
              >
                {faction}
              </Button.Checkbox>
            ))}
          </Section>
          <Section title="Human" height="100%" width="100%" ml={1}>
            {glob_factions['Human'].map((faction) => (
              <Button.Checkbox
                key={faction}
                width="100%"
                checked={current_allies[faction]}
                onClick={() => onFactionButtonClick(faction)}
              >
                {faction}
              </Button.Checkbox>
            ))}
          </Section>
        </Flex>
      </Window.Content>
    </Window>
  );
};
