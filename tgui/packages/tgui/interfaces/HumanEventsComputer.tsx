import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

interface EventComputerData {
  shipmap_name: String;
  groundmap_name: String;
  traits: TraitItem[];
}

interface TraitItem {
  name: String;
  report: String;
}

export const HumanEventsComputer = (props, context) => {
  const { data } = useBackend<EventComputerData>(context);
  return (
    <Window theme="crtgreen" width={790} height={440}>
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <ShipInfo />
          </Stack.Item>
          <Stack.Item>
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
      <Stack>
        <Stack.Item>
          <p>Ship: {shipmap_name}</p>
          <p>Orbiting:{groundmap_name}</p>
        </Stack.Item>
        <Stack.Item>
          <p>Time: 12:07</p>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const Notifications = (props, context) => {
  const { data } = useBackend<EventComputerData>(context);
  const traits = Array.from(data.traits);

  return (
    <Stack fill>
      <Stack.Item width="30%">
        <Section scrollable title="Inbox">
          {traits.map((val, index) => (
            <Button key={index} fluid>
              {val.name}
            </Button>
          ))}
        </Section>
      </Stack.Item>
      <Stack.Item width="70%">
        <Section title="Message">woooh woaah!!</Section>
      </Stack.Item>
    </Stack>
  );
};
