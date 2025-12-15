import { type BooleanLike, classes } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

interface MedalProps {
  medals: Medal[];
}

interface Medal {
  round_id: string;
  medal_type?: string;
  medal_icon?: string;
  xeno_medal?: BooleanLike;
  recipient_name?: string;
  recipient_role?: string;
  giver_name?: string;
  citation?: string;
}

export const MedalsViewer = (props) => {
  const { data, act } = useBackend<MedalProps>();
  const { medals } = data;

  return (
    <Window width={700} height={350}>
      <Window.Content scrollable className={'MedalsViewer'}>
        {medals.map((medal) => {
          const medalType = medal.medal_type
            ? medal.medal_type
            : 'Unknown Medal';
          const sectionTitle = `Round ${medal.round_id} - ${medalType}`;
          const sectionType = medal.xeno_medal ? 'xeno-medal' : 'human-medal';
          return (
            <Section
              key={medal.citation}
              title={sectionTitle}
              className={sectionType}
            >
              Issued to{' '}
              <b>
                {medal.recipient_name}{' '}
                {!medal.xeno_medal && `(${medal.recipient_role})`}
              </b>{' '}
              by <b>{medal.giver_name}</b> for: <br />
              {!medal.xeno_medal && (
                <span
                  className={classes([
                    'medal32x32',
                    medal.medal_icon,
                    'medal-icon',
                  ])}
                />
              )}
              {medal.citation}
            </Section>
          );
        })}
      </Window.Content>
    </Window>
  );
};
