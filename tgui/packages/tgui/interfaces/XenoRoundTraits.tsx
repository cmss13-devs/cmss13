import { useBackend } from '../backend';
import { Stack } from '../components';
import { Window } from '../layouts';
import { XenoCollapsible } from './HiveStatus';

interface EventComputerData {
  shipmap_name: string;
  groundmap_name: string;
  traits: TraitItem[];
}

interface TraitItem {
  name: string;
  report: string;
}

export const XenoRoundTraits = (props, context) => {
  const { data } = useBackend<EventComputerData>(context);
  return (
    <Window theme="hive_status" width={790} height={440}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item textAlign="center">
            <h1 className="whiteTitle">Proclamations from the Queen Mother</h1>
            <h3 className="whiteTitle">
              There {data.traits.length > 1 ? 'are' : 'is'} {data.traits.length}{' '}
              Proclamation
              {data.traits.length > 1 ? 's' : ''}
            </h3>
          </Stack.Item>
          <Stack.Item height="100%">
            {data.traits.map((trait) => (
              <XenoCollapsible title={trait.name} key={trait.name} closed>
                {trait.report}
              </XenoCollapsible>
            ))}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
