import { Stack } from '../components';
import { Window } from '../layouts';
import { Color } from 'common/color';
import { Ping } from 'common/ping';

const COLORS = [
  new Color(220, 40, 40), // red
  new Color(220, 200, 40), // yellow
  new Color(60, 220, 40), // green
];

const getPingColor = function (ping) {
  if (ping < 100) {
    return COLORS[2];
  }
  if (ping < 400) {
    return COLORS[1];
  }
  return COLORS[0];
};

export class PingResult {
  constructor(desc = 'Loading...', url = '', ping = 0, color = COLORS[0]) {
    this.desc = desc;
    this.url = url;
    this.ping = ping;
    this.color = color;
  }

  update(desc, url, ping) {
    this.desc = desc;
    this.url = url;
    this.ping = ping;
    this.color = getPingColor(ping);
  }
}

let p = new Ping();
let currentIndex = 0;
let results = Array(8).fill(new PingResult());

const startTest = function (desc, pingURL, connectURL) {
  p.ping(`http://${pingURL}`, (err, data) => {
    results[++currentIndex].update(desc, `byond://${connectURL}`, data);
  });
};

startTest('Direct', 'play.cm-ss13.com:8998', 'play.cm-ss13.com:1400');
startTest(
  'United Kingdom, London',
  'uk.cm-ss13.com:8998',
  'uk.cm-ss13.com:1400'
);
startTest(
  'France, Gravelines',
  'eu-w.cm-ss13.com:8998',
  'eu-w.cm-ss13.com:1400'
);
startTest('Poland, Warsaw', 'eu-e.cm-ss13.com:8998', 'eu-e.cm-ss13.com:1400');
startTest(
  'Oregon, Hillsboro',
  'us-w.cm-ss13.com:8998',
  'us-w.cm-ss13.com:1400'
);
startTest(
  'Virginia, Vint Hill',
  'us-e.cm-ss13.com:8998',
  'us-e.cm-ss13.com:1400'
);
startTest('Singapore', 'asia-se.cm-ss13.com:8998', 'asia-se.cm-ss13.com:1400');
startTest('Australia, Sydney', 'aus.cm-ss13.com:8998', 'aus.cm-ss13.com:1400');

export const PingRelaysPanel = () => {
  return (
    <Window width={300} height={400} theme={'ntos'}>
      <Window.Content>
        <Stack direction="column" fill>
          {results.map((result, i) => (
            <Stack.Item key={i} basis="content" grow={0} pb={1}>
              {result.desc}: <a href={result.url}>{result.url}</a>{' '}
              <span color={result.color}>({result.ping})</span>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
};
