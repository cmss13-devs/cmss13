import { useBackend } from 'tgui/backend';
import { Box } from 'tgui/components';

type FlightTimeData = {
  shuttle_state?: string;
  flight_time?: number;
  max_flight_duration?: number;
  max_refuel_duration?: number;
};

export const FlightTimeBar = (props: {
  readonly themeColor?: string;
  readonly themeColorRgb?: string;
}) => {
  const { data } = useBackend<FlightTimeData>();
  const color = props.themeColor ?? '#00e94e';
  const colorRgb = props.themeColorRgb ?? '0, 233, 78';
  const shuttleState = data.shuttle_state ?? 'idle';
  const flightTime = data.flight_time ?? 0;
  const isRecharging = shuttleState === 'recharging';

  if (shuttleState === 'idle') {
    return (
      <Box textAlign="center" fontSize="10px" color={color}>
        IDLE
      </Box>
    );
  }

  const duration = isRecharging
    ? data.max_refuel_duration
    : data.max_flight_duration;
  const progress = Math.min(
    100,
    Math.max(0, (flightTime / Math.max(duration ?? 1, 1)) * 100),
  );
  const label = isRecharging ? `REFUEL T-${flightTime}s` : `T-${flightTime}s`;

  return (
    <Box
      style={{
        position: 'relative',
        height: '16px',
        backgroundColor: 'rgba(0, 0, 0, 0.6)',
        border: `1px solid ${color}`,
      }}
    >
      <Box
        style={{
          position: 'absolute',
          top: '0',
          left: '0',
          height: '100%',
          width: `${progress}%`,
          backgroundColor: isRecharging
            ? 'rgba(255, 165, 0, 0.4)'
            : `rgba(${colorRgb}, 0.27)`,
          transition: 'width 1s linear',
        }}
      />
      <Box
        fontSize="10px"
        textAlign="center"
        color={isRecharging ? 'orange' : color}
        style={{ position: 'relative' }}
      >
        {label}
      </Box>
    </Box>
  );
};
