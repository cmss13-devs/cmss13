import { useBackend } from '../backend';
import { Box, Button, Flex, Stack } from '../components';
import { Window } from '../layouts';
import { logger } from '../logging';

interface Destination {
  id: string;
  name: string;
}

interface ElevatorContext {
  destinations: Array<Destination>;
  docked_at: Destination;
  destination: string;
  mode: string;
  eta: number;
  max_flight_duration: number;
  max_pre_arrival_duration: number;
  max_refuel_duration: number;
  max_engine_start_duration: number;
  is_call_button: 0 | 1;
}

const InfoBox = (
  props: { title?: string; text: string | number },
  contenxt
) => {
  return (
    <Box className="InfoBox">
      {props.title && (
        <>
          <div className="Title">{props.title}</div>
          <div className="InfoText">{props.text}</div>
        </>
      )}
      {props.title === undefined && (
        <div className="InfoNoTitle">{props.text}</div>
      )}
    </Box>
  );
};

const ElevatorPanel = (props, context) => {
  const { data } = useBackend<ElevatorContext>(context);
  const is_stationary =
    data.mode === 'idle' ||
    data.mode === 'igniting' ||
    data.mode === 'recharging';
  const docked_label = data.docked_at.name;
  return (
    <Stack vertical className="InfoPanel">
      {is_stationary && (
        <Stack.Item>
          <InfoBox title="Located at" text={docked_label} />
        </Stack.Item>
      )}

      {data.mode === 'idle' && (
        <Stack.Item>
          <InfoBox title="Status" text="Ready to depart" />
        </Stack.Item>
      )}

      {data.mode === 'recharging' && (
        <Stack.Item>
          <InfoBox title="Curtesy Time" text={data.eta} />
        </Stack.Item>
      )}
      {data.mode === 'igniting' && (
        <Stack.Item>
          <InfoBox title="Alighting In" text={data.eta} />
        </Stack.Item>
      )}
      {data.mode === 'called' && (
        <>
          <Stack.Item>
            <InfoBox title="Travelling to" text={data.destination} />
          </Stack.Item>
          <Stack.Item>
            <InfoBox title="In transit" text={data.eta} />
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};

interface ElevatorButtonProps {
  id: string;
  name: string;
  onClick: () => void;
}

const ElevatorButton = (props: ElevatorButtonProps, context) => {
  const { data } = useBackend<ElevatorContext>(context);
  return (
    <Flex align="center" className="ButtonContainer">
      <Flex.Item>
        <Button
          circular
          color="yellow"
          className="pushButtonOuter"
          disabled={data.mode !== 'idle' || props.id === data.docked_at.id}
          onClick={props.onClick}>
          <span className="pushButton" />
        </Button>
      </Flex.Item>
      <Flex.Item className="buttonLabel">
        {data.is_call_button === 0 ? props.name : 'Call'}
      </Flex.Item>
    </Flex>
  );
};

export const ElevatorControl = (props, context) => {
  const { data, act } = useBackend<ElevatorContext>(context);
  return (
    <Window width={600} height={170}>
      <Window.Content className="ElevatorPanel">
        <Stack>
          <Stack.Item>
            <ElevatorPanel />
          </Stack.Item>
          <Stack.Item>
            <Flex className="ButtonPanel">
              {data.destinations.map((x) => (
                <Flex.Item key={x.id}>
                  <ElevatorButton
                    id={x.id}
                    name={x.name}
                    onClick={() => {
                      logger.info(x.id);
                      act('button-push');
                      act('move', { 'target': x.id });
                    }}
                  />
                </Flex.Item>
              ))}
            </Flex>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
