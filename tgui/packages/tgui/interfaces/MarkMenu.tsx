import { classes } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, Stack, Tabs } from '../components';
import { Window } from '../layouts';

interface MarkProps {
  mark_meanings: Mark[];
  mark_list_infos: PlacedMark[];
  selected_mark?: string;
  is_leader: HivePosition;
  user_nicknumber: string;
  tracked_mark: null | string;
}

interface Mark {
  name: string;
  icon_state: string;
  desc: string;
  id: string;
  image: string;
}

interface PlacedMark extends Mark {
  owner: string;
  owner_name: string;
  area: string;
  time: string;
  watching: Array<string>;
}

// The position of the xeno in the hive (0 = normal xeno; 1 = queen; 2+ = hive leader)
type HivePosition = 0 | 1 | 2;

const MenuActions = (props: {
  readonly historicalSelected: string;
  readonly setHistoricalSelected: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { historicalSelected, setHistoricalSelected } = props;
  const { data, act } = useBackend<MarkProps>();
  return (
    <Flex fill={1} justify="space-between" className="ActionMenu">
      <Flex.Item>
        <Button
          color="xeno"
          disabled={historicalSelected === ''}
          onClick={() => act('watch', { type: historicalSelected })}
        >
          Watch
        </Button>
      </Flex.Item>
      <Flex.Item>
        <Button
          color="xeno"
          disabled={historicalSelected === ''}
          onClick={() => act('track', { type: historicalSelected })}
        >
          Track
        </Button>
      </Flex.Item>
      {data.is_leader !== 0 && (
        <Flex.Item>
          <Button
            color="red"
            disabled={historicalSelected === ''}
            onClick={() => {
              act('destroy', { type: historicalSelected });
              setHistoricalSelected('');
            }}
          >
            Destroy
          </Button>
        </Flex.Item>
      )}

      {data.is_leader === 1 && (
        <Flex.Item>
          <Button
            color="xeno"
            disabled={historicalSelected === ''}
            onClick={() => act('force', { type: historicalSelected })}
          >
            Force Tracking
          </Button>
        </Flex.Item>
      )}
    </Flex>
  );
};

const MarkSelection = (props) => {
  const { data } = useBackend<MarkProps>();
  const [selectionMenu, setSelectionMenu] = useState(false);
  const { selected_mark } = data;
  const mark_prototype =
    data.mark_meanings.find((x) => x.id === selected_mark) ??
    data.mark_meanings[0];
  return (
    <Box>
      <Stack className="MarkStack">
        <Stack.Item className="ChooseMark__BuildIcon">
          <Button
            className={classes([
              'MenuSelectionButton',
              selectionMenu && 'MenuSelectionButtonClicked',
            ])}
            color="xeno"
            onClick={() => setSelectionMenu(!selectionMenu)}
            compact
          >
            <MarkImage image={mark_prototype?.image} size="64x64" />
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              <span className="MarkName">
                New Mark - {mark_prototype.name}{' '}
              </span>
            </Stack.Item>
            <Stack.Item>
              <span>{mark_prototype.desc}</span>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      {selectionMenu && (
        <div className="ChooseMenu">
          <MarkMeaningList onClick={() => setSelectionMenu(false)} />
        </div>
      )}
    </Box>
  );
};

const MarkImage = (
  props: { readonly image: string; readonly size: string },
  _,
) => {
  return (
    <span
      className={classes([
        `choosemark${props.size}`,
        `${props.image}${props.size === '64x64' ? '_big' : ''}`,
        'ChooseMark__BuildIcon',
      ])}
    />
  );
};

const HistoricalMark = (props: {
  readonly mark: PlacedMark;
  readonly historicalSelected: string;
  readonly setHistoricalSelected: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { data } = useBackend<MarkProps>();
  const { mark, historicalSelected, setHistoricalSelected } = props;

  const isTracked =
    data.tracked_mark === null ? false : data.tracked_mark === mark.id;

  return (
    <Box
      className={classes([historicalSelected === mark.id && 'Selected'])}
      onClick={() =>
        setHistoricalSelected(
          historicalSelected === ''
            ? mark.id
            : historicalSelected === mark.id
              ? ''
              : mark.id,
        )
      }
    >
      <Flex
        className="MarkStack"
        direction="row"
        justify="space-between"
        fill={1}
      >
        <Flex.Item className="ChooseMark__BuildIcon">
          <MarkImage image={mark.image} size="64x64" />
        </Flex.Item>
        <Flex.Item className={classes(['MarkLabel'])}>
          <Flex align="flex-top" justify="flex-start" fill={1}>
            <Flex.Item>
              <Stack vertical className="HistoricalLabel">
                <Stack.Item>
                  <span className="MarkName">{mark.name}</span>
                </Stack.Item>
                <Stack.Item>
                  <span>{mark.area}</span>
                </Stack.Item>
                <Stack.Item>
                  <span>
                    Owner: {mark.owner_name} - {mark.time}
                  </span>
                </Stack.Item>
              </Stack>
            </Flex.Item>
            <Flex.Item grow={1}>
              <div className={classes(['MarkWatch'])}>
                {mark.watching.map((x) => (
                  <div key={x}>
                    <span>{x}</span>
                  </div>
                ))}
              </div>
            </Flex.Item>

            {isTracked && (
              <Flex.Item>
                <Icon name="eye" className="TrackIcon" size={2} />
              </Flex.Item>
            )}
          </Flex>
        </Flex.Item>
      </Flex>
    </Box>
  );
};

const MarkHistory = (props) => {
  const { data } = useBackend<MarkProps>();
  const [historicalSelected, setHistoricalSelected] = useState('');

  const { mark_list_infos } = data;
  return (
    <Flex direction="column" fill={1} className="History">
      <Flex.Item>
        <MarkSelection />
      </Flex.Item>

      <hr />

      <Flex.Item>
        <MenuActions
          historicalSelected={historicalSelected}
          setHistoricalSelected={setHistoricalSelected}
        />
      </Flex.Item>

      {mark_list_infos.map((x) => (
        <Flex.Item key={x.id}>
          <HistoricalMark
            mark={x}
            historicalSelected={historicalSelected}
            setHistoricalSelected={setHistoricalSelected}
          />
        </Flex.Item>
      ))}
    </Flex>
  );
};

export const MarkMenu = (props) => {
  return (
    <Window title={'Mark Menu'} theme="hive_status" width={560} height={680}>
      <Window.Content scrollable className="MarkMenu">
        <Stack vertical>
          <Stack.Item>
            <MarkHistory />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MarkMeaningList = (props: { readonly onClick?: () => void }) => {
  const { data, act } = useBackend<MarkProps>();
  const { mark_meanings, selected_mark } = data;

  return (
    <Tabs vertical fluid fill>
      {mark_meanings.map((val, index) => (
        <Tabs.Tab
          key={index}
          selected={val.id === selected_mark}
          onClick={() => {
            act('choose_mark', { type: val.id });
            if (props.onClick) {
              props.onClick();
            }
          }}
        >
          <Stack align="center">
            <Stack.Item>
              <MarkImage image={val.image} size="32x32" />
            </Stack.Item>
            <Stack.Item grow>
              <Box>{val.desc}</Box>
            </Stack.Item>
          </Stack>
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};
