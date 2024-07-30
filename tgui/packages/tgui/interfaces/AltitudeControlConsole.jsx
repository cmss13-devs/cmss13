import { useBackend } from '../backend';
import {
  Box,
  Button,
  Icon,
  ProgressBar,
  Section,
  Tooltip,
} from '../components';
import { Window } from '../layouts';
export const AltitudeControlConsole = () => {
  const { act, data } = useBackend();
  let altIcon = 'plane';
  let altTip = 'Currently: Normal Altitude';
  if (data.alt === 0.5) {
    altIcon = 'plane-arrival';
    altTip = 'Currently: Low Altitude';
  } else if (data.alt === 1.5) {
    altIcon = 'plane-departure';
    altTip = 'Currently: High Altitude';
  }
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
              }}
            >
              <Box textAlign="center">{data.temp}% to overheat</Box>
            </ProgressBar>
          </Box>
        </Section>
        <Section
          title="Altitude Control"
          buttons={
            <Tooltip content={altTip} position="left">
              <Icon name={altIcon} size={1.5} />
            </Tooltip>
          }
        >
          {
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={data.alt === 0.5}
              onClick={() => act('low_alt')}
            >
              Set to: Lowest orbitable altitude
            </Button>
          }
          {
            <Button
              fontSize="20px"
              textAlign="center"
              fluid
              disabled={data.alt === 1}
              onClick={() => act('med_alt')}
            >
              Set to: Most optimal orbitable altitude
            </Button>
          }
        </Section>
        <Section title="System Operational Warning">
          <Box textAlign="center" fontSize="20px">
            The Ship will always be set according to the disabled option, if
            none of the two options available to you are disabled, that means
            the ship is on high altitude
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
