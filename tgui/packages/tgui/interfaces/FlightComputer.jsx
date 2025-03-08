import { useBackend } from '../backend';
import { Button, ProgressBar } from '../components';
import { Window } from '../layouts';

export const FlightComputer = (props) => {
  const { act, data } = useBackend();

  const vtol_detected = data.vtol_detected;
  const fuel = data.fuel;
  const max_fuel = data.max_fuel;
  const battery = data.battery;
  const max_battery = data.max_battery;
  const fueling = data.fueling;

  const message = vtol_detected
    ? 'Aircraft detected - AD-19D chimera'
    : 'No aircraft detected.';

  const fuel_button = () => {
    if (!vtol_detected) {
      return null;
    }

    if (fueling) {
      return <Button onClick={() => act('stop_fueling')}>Stop Fueling & Charging</Button>;
    } else {
      return (
        <Button onClick={() => act('start_fueling')}>Start Fueling & Charing</Button>
      );
    }
  };

  return (
    <Window width={450} height={445}>
      <Window.Content scrollable>
        {message + '\n'}

        {vtol_detected ? (
          <ProgressBar
            value={fuel / max_fuel}
            ranges={{
              good: [0.7, Infinity],
              average: [0.2, 0.7],
              bad: [-Infinity, 0.2],
            }}
          />
        ) : null}
        {'\n'}

        {vtol_detected ? (
          <ProgressBar
            value={battery / max_battery}
            ranges={{
              good: [0.7, Infinity],
              average: [0.2, 0.7],
              bad: [-Infinity, 0.2],
            }}
          />
        ) : null}
        {'\n'}

        {fuel_button()}
      </Window.Content>
    </Window>
  );
};
