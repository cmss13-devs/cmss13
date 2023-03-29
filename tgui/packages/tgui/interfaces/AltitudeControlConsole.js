import { useBackend } from '../backend';
import { Button, ProgressBar, Box, Section } from '../components';
import { Window } from '../layouts';
import { createLogger } from '../logging';
export const AltitudeControlConsole = (_props, context) => {
  const { act, data } = useBackend(context);
  const logger = createLogger('Debug');
  logger.warn(data);
  return (
    <Window width={455} height={275}>
      <Window.Content scrollable>
        <Section title="Engine Temperature">
          <Box textAlign="center">
            <ProgressBar
              width="100%"
              minValue={0}
              maxValue={100}
              value={data.temp}
              ranges={{
                good: [-Infinity, 50],
                bad: [51, Infinity],
              }}>
              <Box textAlign="center">{data.temp}% to overheat</Box>
            </ProgressBar>
          </Box>
        </Section>
        <Section title="Altitude Control">
          {
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={data.alt === 0.5}
              content="Set to: Low Altitude"
              onClick={() => act('low_alt')}
            />
          }
          {
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={data.alt === 1}
              content="Set to: Medium Altitude"
              onClick={() => act('med_alt')}
            />
          }
          {
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={data.alt === 1.5}
              content="Set to: High Altitude"
              onClick={() => act('high_alt')}
            />
          }
        </Section>
      </Window.Content>
    </Window>
  );
};
