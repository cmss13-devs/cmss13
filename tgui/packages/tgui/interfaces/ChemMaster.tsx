import { useState } from 'react';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Input,
  Modal,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type PillBottleType = {
  size: number;
  max_size: number;
  label?: string;
  icon_state: string;
  isNeedsToBeFilled: boolean;
};

type ChemMasterData = {
  is_connected: boolean;
  pill_bottles: PillBottleType[];
  color_pill: {
    icon: string;
    colors: { [key: string]: string };
    base: string;
  };
  beaker?: {
    reagents_volume: number;
    reagents: Reagent[];
  };
  buffer?: Reagent[];
  mode: boolean;
  pill_or_bottle_icon: string;
  pill_icon_choices: number;
  bottle_icon_choices: number;
  bottlesprite: number;
  pillsprite: number;
  is_pillmaker: boolean;
  is_condiment: boolean;
  is_vialmaker: boolean;
  internal_reagent_name: string;
};

type Reagent = {
  name: string;
  volume: number;
  id: number;
};

export const ChemMaster = () => {
  const { act, data } = useBackend<ChemMasterData>();

  const { is_connected, beaker, buffer, mode } = data;

  const [glasswarePicker, setGlasswarePicker] = useState<
    'pill' | 'bottle' | false
  >(false);

  const [pillPicker, setPillPicker] = useState(false);

  return (
    <Window width={550} height={550}>
      <Window.Content className="ChemMaster">
        <Section title="Status">
          <Stack vertical>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Box>Beaker:</Box>
                </Stack.Item>
                <Stack.Item grow>
                  {beaker ? (
                    beaker.reagents_volume + 'u'
                  ) : (
                    <NoticeBox info>No beaker inserted.</NoticeBox>
                  )}
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <PillBottle setPicker={setPillPicker} />
            </Stack.Item>
            <Stack.Item>
              {beaker && !is_connected && (
                <Button fluid onClick={() => act('connect')}>
                  Connect Smartfridge
                </Button>
              )}
            </Stack.Item>
          </Stack>
        </Section>
        {beaker && (
          <Section
            title="Beaker"
            buttons={
              <Button
                icon={'eject'}
                tooltip={'Remove beaker, and clear buffer.'}
                onClick={() => act('eject')}
              >
                Eject
              </Button>
            }
          >
            {beaker.reagents ? (
              <Reagents reagents={beaker.reagents} type={'beaker'} />
            ) : (
              <NoticeBox info>Beaker is empty.</NoticeBox>
            )}
          </Section>
        )}
        <Section
          title="Buffer"
          buttons={
            <Button
              icon={mode ? 'toggle-on' : 'toggle-off'}
              onClick={() => act('toggle')}
            >
              {mode ? 'To Beaker' : 'To Disposal'}
            </Button>
          }
        >
          {buffer?.length ? (
            <Reagents reagents={buffer} type="buffer" />
          ) : (
            <NoticeBox info>Buffer is empty.</NoticeBox>
          )}
        </Section>
        <Glassware setPicker={setGlasswarePicker} />
        {glasswarePicker && (
          <GlasswarePicker
            setPicker={setGlasswarePicker}
            type={glasswarePicker}
          />
        )}
        {pillPicker && <PillPicker setPicker={setPillPicker} />}
      </Window.Content>
    </Window>
  );
};

const PillPicker = (props: { readonly setPicker: (_) => void }) => {
  const { setPicker } = props;

  const { act, data } = useBackend<ChemMasterData>();

  const { color_pill } = data;

  return (
    <Modal m="1 rem">
      <Stack width="17rem" wrap>
        {Object.keys(color_pill.colors).map((color) => (
          <Stack.Item key={color} mr={1} mb={1} className="picker">
            <Box
              className="icon"
              onClick={() => {
                act('color_pill', { color: color });
                setPicker(false);
              }}
            >
              <DmIcon
                icon={color_pill.icon}
                icon_state={`${color_pill.base}${color_pill.colors[color]}`}
                height="32px"
                width="32px"
              />
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Modal>
  );
};

const GlasswarePicker = (props: {
  readonly setPicker: (_) => void;
  readonly type: 'pill' | 'bottle';
}) => {
  const { act, data } = useBackend<ChemMasterData>();

  const { pill_icon_choices, bottle_icon_choices, pill_or_bottle_icon } = data;

  const { setPicker, type } = props;

  return (
    <Modal m="1rem">
      <Stack width="17rem" wrap>
        {Array.from(
          {
            length: type === 'pill' ? pill_icon_choices : bottle_icon_choices,
          },
          (_, index) => (
            <Stack.Item key={index} mr={1} mb={1} className="picker">
              <Box
                className="icon"
                onClick={() => {
                  act(type === 'pill' ? 'change_pill' : 'change_bottle', {
                    picked: index + 1,
                  });
                  setPicker(false);
                }}
              >
                <DmIcon
                  icon={pill_or_bottle_icon}
                  icon_state={
                    type === 'pill' ? `pill${index + 1}` : `bottle-${index + 1}`
                  }
                  height="32px"
                  width="32px"
                />
              </Box>
            </Stack.Item>
          ),
        )}
      </Stack>
    </Modal>
  );
};

const PillBottle = (props: { readonly setPicker: (_) => void }) => {
  const { data, act } = useBackend<ChemMasterData>();

  const { setPicker } = props;

  const { pill_bottles, is_connected, color_pill } = data;

  const [tag, setTag] = useState('');

  return (
    <Stack>
      <Stack.Item>
        <Box>Pill Bottle{pill_bottles.length > 1 ? 's' : ''}:</Box>
      </Stack.Item>
      <Stack.Item grow>
        {pill_bottles.length ? (
          pill_bottles.map((pill_bottle, index) => (
            <Stack key={index} justify="space-between">
              <Stack.Item>
                <Stack>
                  {pill_bottles.length > 1 && (
                    <Stack.Item>
                      <Button.Checkbox
                        width="100%"
                        checked={pill_bottle.isNeedsToBeFilled}
                        onClick={() =>
                          act('check_pill_bottle', {
                            bottleIndex: index,
                            value: !pill_bottle.isNeedsToBeFilled,
                          })
                        }
                      >
                        Fill bottle
                      </Button.Checkbox>
                    </Stack.Item>
                  )}
                  <Stack.Item>
                    <Box>
                      {pill_bottle.size} / {pill_bottle.max_size}
                    </Box>
                  </Stack.Item>
                  <Stack.Item>
                    {pill_bottle.label && <Box>({pill_bottle.label})</Box>}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              {index === 0 ? (
                <Stack>
                  <Stack.Item>
                    <Button.Input
                      onCommit={(_, value) => {
                        act('label_pill', { text: value, bottleIndex: index });
                      }}
                    >
                      <Icon name={'tag'} /> Label
                    </Button.Input>
                  </Stack.Item>
                  <Stack.Item>
                    <Button onClick={() => setPicker(true)} height="1.75rem">
                      <DmIcon
                        mt={-1.5}
                        icon={color_pill.icon}
                        icon_state={pill_bottle.icon_state}
                      />
                    </Button>
                  </Stack.Item>
                </Stack>
              ) : (
                <Stack>
                  <Stack.Item>
                    <DmIcon
                      mt={-1.5}
                      icon={color_pill.icon}
                      icon_state={pill_bottle.icon_state}
                    />
                  </Stack.Item>
                </Stack>
              )}
              <Stack>
                {!!is_connected && (
                  <Stack.Item>
                    <Button
                      icon={'arrow-up'}
                      onClick={() =>
                        act('transfer_pill', { bottleIndex: index })
                      }
                    >
                      Transfer
                    </Button>
                  </Stack.Item>
                )}
                <Stack.Item>
                  <Button
                    icon={'eject'}
                    onClick={() => act('eject_pill', { bottleIndex: index })}
                  >
                    Eject
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack>
          ))
        ) : (
          <NoticeBox info>No pill bottles inserted.</NoticeBox>
        )}
      </Stack.Item>
    </Stack>
  );
};

const Glassware = (props: { readonly setPicker: (type) => void }) => {
  const { data, act } = useBackend<ChemMasterData>();

  const { setPicker } = props;

  const {
    pill_or_bottle_icon,
    pillsprite,
    is_pillmaker,
    is_condiment,
    is_connected,
    is_vialmaker,
    bottlesprite,
    internal_reagent_name,
    buffer,
    pill_bottles,
  } = data;

  const [numPills, setNumPills] = useSharedState('pillNum', 16);

  return (
    <Section title="Glassware">
      {!is_condiment ? (
        <Stack>
          <Stack.Item>
            {!!is_pillmaker && (
              <Stack>
                <Button
                  lineHeight={'35px'}
                  disabled={
                    !buffer ||
                    !pill_bottles.some((bottle) => bottle.isNeedsToBeFilled)
                  }
                  onClick={() => act('create_pill', { number: numPills })}
                >
                  Create Pill{numPills > 1 ? 's' : ''}
                </Button>
                <Box className="icon" onClick={() => setPicker('pill')}>
                  <DmIcon
                    icon={pill_or_bottle_icon}
                    icon_state={`pill${pillsprite}`}
                    height="32px"
                    width="32px"
                  />
                </Box>
                <NumberInput
                  value={numPills}
                  maxValue={20}
                  minValue={1}
                  step={1}
                  stepPixelSize={3}
                  width="30px"
                  onChange={(value) => setNumPills(value)}
                />
              </Stack>
            )}
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack>
                <Stack vertical>
                  <Button.Input
                    disabled={!buffer}
                    height={'100%'}
                    lineHeight={is_connected ? '' : '35px'}
                    currentValue={internal_reagent_name}
                    onCommit={(_, value) =>
                      act('create_glass', {
                        type: 'glass',
                        label: value,
                      })
                    }
                  >
                    Create Bottle (60u)
                  </Button.Input>
                  {!!is_connected && (
                    <Button.Input
                      disabled={!buffer}
                      currentValue={internal_reagent_name}
                      onCommit={(_, value) =>
                        act('create_glass', {
                          type: 'glass',
                          label: value,
                          store: true,
                        })
                      }
                    >
                      Create and Transfer
                    </Button.Input>
                  )}
                </Stack>
                <Box className="icon" onClick={() => setPicker('bottle')}>
                  <DmIcon
                    icon={pill_or_bottle_icon}
                    icon_state={`bottle-${bottlesprite}`}
                    height="32px"
                    width="32px"
                  />
                </Box>
              </Stack>
            </Stack>
          </Stack.Item>
          {!!is_vialmaker && (
            <Stack.Item>
              <Stack>
                <Stack>
                  <Stack vertical>
                    <Button.Input
                      disabled={!buffer}
                      height={'100%'}
                      lineHeight={is_connected ? '' : '35px'}
                      currentValue={internal_reagent_name}
                      onCommit={(_, value) =>
                        act('create_glass', { type: 'vial', label: value })
                      }
                    >
                      Create Vial (30u)
                    </Button.Input>
                    {!!is_connected && (
                      <Button.Input
                        disabled={!buffer}
                        currentValue={internal_reagent_name}
                        onCommit={(_, value) =>
                          act('create_glass', {
                            type: 'vial',
                            label: value,
                            store: true,
                          })
                        }
                      >
                        Create and Transfer
                      </Button.Input>
                    )}
                  </Stack>
                </Stack>
              </Stack>
            </Stack.Item>
          )}
        </Stack>
      ) : (
        <Stack>
          <Stack.Item>
            <Stack>
              <Button onClick={() => act('create_glass')} disabled={!buffer}>
                Create Bottle (50u)
              </Button>
            </Stack>
          </Stack.Item>
        </Stack>
      )}
    </Section>
  );
};

const Reagents = (props: {
  readonly reagents: Reagent[];
  readonly type: 'beaker' | 'buffer';
}) => {
  const { reagents, type } = props;

  const { act } = useBackend();

  return (
    <Stack vertical>
      {reagents.map((reagent) => (
        <Stack.Item key={reagent.id}>
          <Stack justify="space-between">
            <Stack.Item>
              {reagent.name}, {reagent.volume} units
            </Stack.Item>
            <Stack>
              <ReagentButton amount={1} reagent={reagent} type={type} />
              <ReagentButton amount={5} reagent={reagent} type={type} />
              <ReagentButton amount={10} reagent={reagent} type={type} />
              <ReagentButton amount={30} reagent={reagent} type={type} />
              <ReagentButton amount={60} reagent={reagent} type={type} />
              <ReagentButton amount={'All'} reagent={reagent} type={type} />
              <Stack.Item>
                <Input
                  placeholder="Custom"
                  onEnter={(_, value) => {
                    act(type === 'beaker' ? 'add' : 'remove', {
                      amount: parseInt(value, 10),
                      id: reagent.id,
                    });
                  }}
                />
              </Stack.Item>
            </Stack>
          </Stack>
        </Stack.Item>
      ))}
      <Stack.Item>
        <Button
          fluid
          onClick={() => act(type === 'beaker' ? 'add_all' : 'remove_all')}
        >
          All Reagents
        </Button>
      </Stack.Item>
    </Stack>
  );
};

const ReagentButton = (props: {
  readonly amount: number | 'All';
  readonly reagent: Reagent;
  readonly type: 'buffer' | 'beaker';
}) => {
  const { act } = useBackend();

  const { amount, reagent, type } = props;

  return (
    <Stack.Item>
      <Button
        onClick={() => {
          act(type === 'beaker' ? 'add' : 'remove', {
            amount: amount === 'All' ? reagent.volume : amount,
            id: reagent.id,
          });
        }}
      >
        {amount}
      </Button>
    </Stack.Item>
  );
};
