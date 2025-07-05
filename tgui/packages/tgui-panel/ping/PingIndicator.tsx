/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { Color } from 'common/color';
import { toFixed } from 'common/math';
import { useBackend, useSelector } from 'tgui/backend';
import { Box, Tooltip } from 'tgui/components';

import { selectPing } from './selectors';

export const PingIndicator = (props) => {
  const { act } = useBackend();
  const ping = useSelector(selectPing);
  const color = Color.lookup(ping.networkQuality, [
    new Color(220, 40, 40),
    new Color(220, 200, 40),
    new Color(60, 220, 40),
  ]).toString();
  const roundtrip = ping.roundtrip ? toFixed(ping.roundtrip) : '--';
  return (
    <Tooltip content="Ping relays" position="bottom-start">
      <div
        tabIndex={0}
        role="button"
        className="Ping"
        onClick={() => act('ping_relays')}
      >
        <Box className="Ping__indicator" backgroundColor={color} />
        {roundtrip}
      </div>
    </Tooltip>
  );
};
