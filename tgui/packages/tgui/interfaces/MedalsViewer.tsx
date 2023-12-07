import { useBackend } from '../backend';
import { Flex } from '../components';
import { Window } from '../layouts';

interface MedalProps {
  medals: Medal[];
}

interface Medal {
  round_id: string;
  medal_type?: string;
  recipient_name?: string;
  recipient_role?: string;
  giver_name?: string;
  citation?: string;
}

export const MedalsViewer = (props, context) => {
  const { data, act } = useBackend<MedalProps>(context);
  const { medals } = data;

  return (
    <Window width={350} height={350}>
      <Window.Content scrollable>
        <Flex direction="column">
          {medals.map((medal) => {
            return (
              <Flex.Item key={medal.citation}>
                {medal.round_id}: {medal.medal_type} issued to{' '}
                {medal.recipient_name} ({medal.recipient_role}) by{' '}
                {medal.giver_name} for: <br />
                {medal.citation}
              </Flex.Item>
            );
          })}
        </Flex>
      </Window.Content>
    </Window>
  );
};
