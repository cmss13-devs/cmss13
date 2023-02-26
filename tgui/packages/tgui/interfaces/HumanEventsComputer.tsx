import { useBackend, useLocalState } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

interface EventComputerData {
  shipmap_name: string;
  groundmap_name: string;
  traits: TraitItem[];
}

interface TraitItem {
  name: string;
  report: string;
}

export const HumanEventsComputer = (props, context) => {
  const { data } = useBackend<EventComputerData>(context);
  return (
    <Window theme="crtgreen" width={790} height={440}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <ShipInfo />
          </Stack.Item>
          <Stack.Item height="100%">
            <Notifications />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const ShipInfo = (props, context) => {
  const { data } = useBackend<EventComputerData>(context);
  const { shipmap_name, groundmap_name } = data;
  return (
    <Section title="Information">
      <Stack justify={'space-between'}>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <b>Ship:</b> {shipmap_name}
            </Stack.Item>
            <Stack.Item>
              <b>Orbiting:</b> {groundmap_name}
            </Stack.Item>
            <Stack.Item>
              <b>Time:</b> 12:07
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <b>User:</b> Daniel Jimenez
            </Stack.Item>
            <Stack.Item>
              <b>Assignment:</b> Executive Officer
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const Notifications = (props, context) => {
  const { data } = useBackend<EventComputerData>(context);
  const traits = Array.from(data.traits);

  const [currentNotification, setNotification] = useLocalState(
    context,
    'notificationText',
    traits[0] ? traits[0]?.name : ''
  );

  return (
    <Stack fill>
      <Stack.Item width="30%" height="100%">
        <Section scrollable title="Inbox" fill>
          {traits.map((val) => (
            <Button
              key={val.name}
              selected={val.name === currentNotification}
              onClick={() => {
                setNotification(val.name);
              }}
              fluid>
              {val.name}
            </Button>
          ))}
        </Section>
      </Stack.Item>
      <Stack.Item width="70%" height="100%" fill>
        <Section title="Message" fill>
          {
            traits.find((element) => element.name === currentNotification)
              ?.report
          }
        </Section>
      </Stack.Item>
    </Stack>
  );
};
