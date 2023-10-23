import { Box } from '../../components';
import { MfdProps, MfdPanel, usePanelState } from './MultifunctionDisplay';
const EquipmentPanel = (props, context) => {
  return (
    <Box className="NavigationMenu">
      <svg height="500" width="500">
        <defs>
          <pattern
            id="smallGrid"
            width="20"
            height="20"
            patternUnits="userSpaceOnUse">
            <path
              d="M 20 0 L 0 0 0 20"
              fill="none"
              stroke="gray"
              stroke-width="0.5"
            />
          </pattern>
          <pattern
            id="grid"
            width="100"
            height="100"
            patternUnits="userSpaceOnUse">
            <rect width="100" height="100" fill="url(#smallGrid)" />
            <path
              d="M 100 0 L 0 0 0 100"
              fill="none"
              stroke="gray"
              stroke-width="1"
            />
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#grid)" />
        {/* cockpit */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 200 120 L 200 40 L 300 40 L 300 120 "
        />
        <path fill-opacity="0" stroke="#00e94e" d="M 220 120 L 280 120" />
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 220 120 L 220 60 L 280 60 L 280 120"
        />
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 240 140 L 260 140 L 260 120 L 240 120 L 240 140"
        />

        {/* left body */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 200 120 L 160 120 L 160 280 L 180 280 L 180 400 L 220 400 L 220 380 L 200 380 L 200 260 L 180 260 L 180 140 L 240 140 L 240 120"
        />
        {/* left airlock */}

        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 160 180 L 180 180 L 180 220 L 160 220 L 160 180 "
        />

        {/* left weapon */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 160 140 L 140 140 L 140 180 L 160 180"
        />
        {/* left engine */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 180 380 L 140 380 L 140 300 L 180 300"
        />

        <text x="40" y="300" stroke="#00e94e">
          <tspan x="40" dy="1.2em">
            Left Engine
          </tspan>
          <tspan x="40" dy="1.2em">
            Fuel Enhancer
          </tspan>
        </text>

        {/* left tail */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 200 400 L 200 440 L 160 440 L 160 460 L 220 460 L 220 400"
        />

        {/* right body */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 300 120 L 340 120 L 340 280 L 320 280 L 320 400 L 280 400 L 280 380 L 300 380 L 300 260 L 320 260 L 320 140 L 260 140 L 260 120"
        />
        {/* right weapon */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 340 140 L 360 140 L 360 180 L 340 180"
        />
        {/* right airlock */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 340 180 L 320 180 L 320 220 L 340 220 L 340 180 "
        />

        {/* right engine */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 320 380 L 360 380 L 360 300 L 320 300"
        />

        <text x="400" y="300" stroke="#00e94e">
          <tspan x="400" dy="1.2em">
            Right Engine
          </tspan>
          <tspan x="400" dy="1.2em">
            Fuel Enhancer
          </tspan>
        </text>

        {/* right tail */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 300 400 L 300 440 L 340 440 L 340 460 L 280 460 L 280 400"
        />
        {/* rear ramp */}
        <path
          fill-opacity="0"
          stroke="#00e94e"
          d="M 220 400 L 280 400 L 280 380 L 220 380 L 220 400"
        />

        <text x="230" y="280" stroke="#00e94e">
          Empty
        </text>

        <text x="230" y="320" stroke="#00e94e">
          Empty
        </text>

        <text x="230" y="360" stroke="#00e94e">
          Empty
        </text>

        <ShipOutline />
      </svg>
    </Box>
  );
};

/*

<?xml version="1.0" encoding="utf-8"?>
<svg viewBox="140.8544 159.358 172.8826 307.335" width="172.8826" height="307.335" xmlns="http://www.w3.org/2000/svg">
  <path style="fill: rgb(216, 216, 216); stroke: rgb(0, 0, 0);" d="M 196.158 206.636 L 195.576 159.488 L 248.545 159.358 L 247.963 207.67 L 313.737 206.506 L 313.155 358.427 L 271.246 356.681 L 269.499 466.693 C 269.499 466.693 177.532 464.364 178.114 463.782 C 178.696 463.2 178.696 355.517 178.696 355.517 C 178.696 355.517 140.279 357.263 140.861 356.099 C 141.443 354.935 140.861 204.76 142.026 204.76 C 143.191 204.76 195.576 206.506 196.158 206.636 Z" transform="matrix(1, 0, 0, 1, 7.105427357601002e-15, 0)"/>
</svg>

 */

const ShipOutline = () => {
  return <line x1={140} y1={140} x2={280} y2={280} />;
};

export const EquipmentMfdPanel = (props: MfdProps, context) => {
  const [panelState, setPanelState] = usePanelState(
    props.panelStateId,
    context
  );
  return (
    <MfdPanel
      bottomButtons={[
        {
          children: 'BACK',
          onClick: () => setPanelState(''),
        },
      ]}>
      <EquipmentPanel />
    </MfdPanel>
  );
};
