import { classes } from 'common/react';
import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

interface MedalProps {
  medals: Medal[];
}

interface Medal {
  round_id: string;
  medal_type?: string;
  medal_icon?: string;
  recipient_name?: string;
  recipient_role?: string;
  giver_name?: string;
  citation?: string;
}

export const MedalsViewer = (props, context) => {
  const { data, act } = useBackend<MedalProps>(context);
  const { medals } = data;

  return (
    <Window width={700} height={350}>
      <Window.Content scrollable>
        {medals.map((medal) => {
          const medalType = medal.medal_type
            ? medal.medal_type
            : 'Unknown Medal';
          const sectionTitle = `Round ${medal.round_id} - ${medalType}`;
          return (
            <Section key={medal.citation} title={sectionTitle}>
              Issued to{' '}
              <b>
                {medal.recipient_name} ({medal.recipient_role})
              </b>{' '}
              by <b>{medal.giver_name}</b> for: <br />
              <span
                className={classes([
                  'medal32x32',
                  medal.medal_icon,
                  'medal-icon',
                ])}
              />
              {medal.citation}
            </Section>
          );
        })}
      </Window.Content>
    </Window>
  );
};
