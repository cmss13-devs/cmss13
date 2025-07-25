import type { BooleanLike } from 'common/react';
import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type ChemData = {
  code: string;
  level: number;
  name: string;
  desc: string;
  cost: number;
  is_locked: BooleanLike;
  tooltip: string;
};

type Filter = Record<number, number>;

type Data = {
  mode_data: {
    name: string;
    desc: string;
    mode_id: string;
    icon_type: string;
  }[];
  credits: number;
  status: string;
  is_ready: BooleanLike;
  can_simulate: BooleanLike;
  can_eject_target: BooleanLike;
  can_eject_reference: BooleanLike;
  is_picking_recipe: BooleanLike;
  lock_control: BooleanLike;
  can_cancel_simulation: BooleanLike;
  estimated_cost: number;
  od_level: number;
  chemical_name: string;
  reference_name: string;
  reagent_option_data?: { id: string; name: String }[];
  target_data?: ChemData[];
  reference_data: ChemData[];
  template_filters: {
    MED: Filter;
    TOX: Filter;
    STI: Filter;
    REA: Filter;
    IRR: Filter;
    MET: Filter;
  };
  known_properties?:
    | {
        code: string;
        level: number;
        name: string;
        desc: string;
        is_enabled: BooleanLike;
        is_locked: BooleanLike;
        conflicting_tooltip: string;
      }[]
    | null;
  complexity_list: string[];
};

export const InfoPanel = () => {
  const { data } = useBackend<Data>();
  const {
    credits,
    status,
    od_level,
    chemical_name,
    estimated_cost,
    reference_name,
  } = data;
  return (
    <Section fill height={12} width={35} fontSize={0.5}>
      <Flex direction={'column'} wrap={'wrap'} color={'#cfcfcf'} maxHeight={40}>
        <Flex.Item>
          <ProgressBar
            value={credits}
            minValue={0}
            maxValue={100}
            ranges={{
              good: [60, Infinity],
              average: [15, 40],
              bad: [-Infinity, 15],
            }}
          >
            <h4>RESEARCH CREDITS: {credits}</h4>
          </ProgressBar>
        </Flex.Item>
        <Flex.Item fontSize={'13px'} bold mt={1}>
          STATUS: {status}
        </Flex.Item>
        <Flex.Item fontSize={'13px'} mt={0.5}>
          ESTIMATED SIMULATING COST: {estimated_cost}
        </Flex.Item>
        <Flex.Item fontSize={'13px'} mt={0.5}>
          TARGET NAME: {chemical_name}
        </Flex.Item>
        <Flex.Item fontSize={'13px'} mt={0.5}>
          REFERENCE NAME: {reference_name}
        </Flex.Item>
        <Flex.Item fontSize={'13px'} mt={0.5}>
          OVERDOSE LEVEL AFTER SIMULATION: {od_level}
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const Controls = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    selectedMode,
    setSelectedMode,
    complexityMenu,
    setComplexityMenu,
    setSelectedReferenceProperty,
    setSelectedTargetProperty,
  } = props;
  const {
    mode_data,
    can_simulate,
    can_eject_target,
    can_eject_reference,
    can_cancel_simulation,
    lock_control,
  } = data;
  return (
    <Flex>
      <Flex.Item mr={1} fontSize={1.2} height={12} width={13}>
        <Stack vertical>
          <Stack.Item>
            {can_cancel_simulation ? (
              <Button
                fluid
                onClick={() => {
                  act('simulate');
                }}
                disabled={!can_simulate}
                icon={'radiation'}
              >
                SIMULATE
              </Button>
            ) : (
              <Button
                fluid
                icon={'circle-xmark'}
                color={'red'}
                onClick={() => {
                  act('cancel_simulation');
                }}
              >
                CANCEL
              </Button>
            )}
          </Stack.Item>
          <Stack.Item>
            <Button
              fluid
              onClick={() => {
                act('eject_target');
                setSelectedTargetProperty(null);
              }}
              disabled={!can_eject_target || lock_control}
              icon={can_eject_target ? 'eject' : 'file-import'}
            >
              EJECT TARGET
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              fluid
              onClick={() => {
                act('eject_reference');
                setSelectedReferenceProperty(null);
              }}
              disabled={!can_eject_reference || lock_control}
              icon={can_eject_reference ? 'eject' : 'file-import'}
            >
              EJECT REFERENCE
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              fluid
              onClick={() => {
                act('keyboard_sound');
                setComplexityMenu(!complexityMenu);
              }}
              selected={complexityMenu}
              icon={'hard-drive'}
            >
              COMPLEXITY
            </Button>
          </Stack.Item>
        </Stack>
      </Flex.Item>
      <Flex.Item fontSize={1.2} height={12} width={13}>
        <Stack vertical>
          {mode_data.map((mode_data) => (
            <Stack.Item key={mode_data.mode_id}>
              <Button
                fluid
                onClick={() => {
                  act('change_mode', { mode_id: mode_data.mode_id });
                  setSelectedMode(mode_data.mode_id);
                }}
                tooltip={mode_data.desc}
                icon={mode_data.icon_type}
                disabled={mode_data.mode_id === selectedMode || lock_control}
                tooltipPosition="bottom"
              >
                {mode_data.name}
              </Button>
            </Stack.Item>
          ))}
        </Stack>
      </Flex.Item>
    </Flex>
  );
};

export const RecipeOptions = () => {
  const { act, data } = useBackend<Data>();
  const [selectedRecipe, setSelectedRecipe] = useSharedState('recipe', '');
  const { reagent_option_data = [] } = data;
  return (
    <Stack vertical>
      <Stack.Item>
        <Button
          verticalAlignContent={'middle'}
          bold
          textAlign={'center'}
          width={28}
          height={2.6}
          fluid
          disabled={selectedRecipe === null}
          mb={'5px'}
          onClick={() => {
            act('submit_recipe_pick', { reagent_picked: selectedRecipe });
            setSelectedRecipe('');
          }}
        >
          <h3>FINALIZE</h3>
        </Button>
        {reagent_option_data.map((recipe) => (
          <Button
            my={0.2}
            lineHeight={1.5}
            bold
            textAlign={'center'}
            key={recipe.id}
            width={28}
            height={3}
            fluid
            onClick={() => {
              setSelectedRecipe(recipe.id);
            }}
            selected={selectedRecipe === recipe.id}
          >
            <h3>{recipe.name}</h3>
          </Button>
        ))}
      </Stack.Item>
    </Stack>
  );
};

export const ModeChange = (props: {
  readonly selectedTargetProperty: string | boolean;
  readonly setSelectedTargetProperty: (
    value: React.SetStateAction<string | boolean>,
  ) => void;
}) => {
  const { act, data } = useBackend<Data>();
  const { target_data, lock_control } = data;
  const { selectedTargetProperty, setSelectedTargetProperty } = props;
  return (
    (target_data && (
      <Flex ml={5} fontSize={1.2} width={60} height={20} mt={5}>
        <Stack vertical>
          <Stack.Item
            bold
            backgroundColor={'#232429'}
            py={0.5}
            opacity={0.7}
            mx={1}
            textAlign="center"
          >
            Target Data
          </Stack.Item>
          <Stack.Item>
            <Flex.Item width={20} textAlign="center">
              {target_data.map((property) => (
                <Button
                  key={property.code}
                  bold
                  m={0.6}
                  width={8}
                  textAlign={'center'}
                  onClick={() => {
                    act('select_target_property', {
                      property_code: property.code,
                    });
                    setSelectedTargetProperty(property.code);
                  }}
                  selected={
                    selectedTargetProperty === property.code ? true : false
                  }
                  disabled={lock_control}
                >
                  {property.code} {property.level}
                </Button>
              ))}
            </Flex.Item>
          </Stack.Item>
        </Stack>

        <Flex.Item width={30} grow>
          {target_data.map(
            (property) =>
              property.code === selectedTargetProperty && (
                <Stack key={property.code} vertical>
                  <Stack.Item>
                    <Section title={property.name}>{property.desc}</Section>
                  </Stack.Item>
                  <Stack.Item bold backgroundColor={'#191b22'} p={1}>
                    Price of the operation : {property.cost}
                  </Stack.Item>
                </Stack>
              ),
          )}
        </Flex.Item>
      </Flex>
    )) || (
      <Box m={3}>
        <NoticeBox>No data inserted!</NoticeBox>
      </Box>
    )
  );
};

export const ModeRelate = (props: {
  readonly setSelectedTargetProperty: (
    value: React.SetStateAction<string | boolean>,
  ) => void;
  readonly setSelectedReferenceProperty: (
    value: React.SetStateAction<string | boolean>,
  ) => void;
  readonly selectedReferenceProperty: string | boolean;
  readonly selectedTargetProperty: string | boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { target_data, reference_data, lock_control } = data;
  const {
    setSelectedTargetProperty,
    setSelectedReferenceProperty,
    selectedReferenceProperty,
    selectedTargetProperty,
  } = props;
  return (
    (target_data && reference_data && (
      <Flex ml={3} fontSize={1.2} maxWidth={70} height={20} mt={5}>
        <Stack vertical>
          <Stack.Item
            bold
            backgroundColor={'#232429'}
            py={1}
            opacity={0.7}
            mx={1}
            textAlign="center"
          >
            Target Data
          </Stack.Item>
          <Stack.Item>
            <Flex.Item
              maxWidth={18}
              minWidth={18}
              textAlign="center"
              height={10}
            >
              {target_data.map((property) => (
                <Button
                  key={property.code}
                  bold
                  m={0.6}
                  width={8}
                  textAlign={'center'}
                  onClick={() => {
                    act('select_target_property', {
                      property_code: property.code,
                    });
                    setSelectedTargetProperty(property.code);
                  }}
                  selected={
                    selectedTargetProperty === property.code ? true : false
                  }
                  disabled={lock_control || property.is_locked}
                  tooltip={property.tooltip}
                >
                  {property.code} {property.level}
                </Button>
              ))}
            </Flex.Item>
          </Stack.Item>
        </Stack>
        <Flex.Item
          maxWidth={18}
          minWidth={18}
          textAlign="center"
          height={10}
          mr={1}
        >
          <Stack vertical>
            <Stack.Item
              bold
              backgroundColor={'#232429'}
              py={1}
              opacity={0.8}
              textAlign="center"
            >
              Reference Data
            </Stack.Item>
            <Stack.Item>
              <Flex.Item
                maxWidth={18}
                minWidth={18}
                textAlign="center"
                height={10}
              >
                {reference_data.map((property) => (
                  <Button
                    key={property.code}
                    bold
                    m={0.6}
                    width={8}
                    textAlign={'center'}
                    onClick={() => {
                      act('select_reference_property', {
                        property_code: property.code,
                      });
                      setSelectedReferenceProperty(property.code);
                    }}
                    selected={
                      selectedReferenceProperty === property.code ? true : false
                    }
                    disabled={lock_control || property.is_locked}
                    tooltip={property.tooltip}
                  >
                    {property.code} {property.level}
                  </Button>
                ))}
              </Flex.Item>
            </Stack.Item>
          </Stack>
        </Flex.Item>
        <Flex.Item maxWidth={25} grow>
          {target_data.map(
            (property) =>
              property.code === selectedTargetProperty && (
                <Stack key={property.code} vertical>
                  <Stack.Item>
                    <Section title={property.name}>{property.desc}</Section>
                  </Stack.Item>
                  <Stack.Item bold backgroundColor={'#191b22'} p={1}>
                    Price of the operation : {property.cost}
                  </Stack.Item>
                </Stack>
              ),
          )}
        </Flex.Item>
      </Flex>
    )) || (
      <Box m={3} height={10}>
        <NoticeBox bold>No data inserted!</NoticeBox>
      </Box>
    )
  );
};

export const ModeCreate = (props: { readonly complexityMenu: boolean }) => {
  const { act, data } = useBackend<Data>();
  const { complexityMenu } = props;
  const { known_properties } = data;
  const [selectedProperty, setSelectedProperty] = useSharedState(
    'selected_propery',
    '',
  );
  return (
    <Flex direction={'column'}>
      <Flex.Item>
        <CreateControl complexityMenu={complexityMenu} />
      </Flex.Item>
      <Flex.Item>
        <Stack
          ml={1}
          mt={1}
          mr={1}
          width={65}
          height={7}
          wrap="wrap"
          align="start"
        >
          {known_properties &&
            known_properties.map((property) => (
              <Stack.Item
                key={property.name}
                m={0.5}
                bold
                grow
                fontSize={'12px'}
                minWidth={4}
                maxHeight={2}
              >
                <Button
                  textAlign={'center'}
                  fluid
                  px={'1px'}
                  onClick={() => {
                    act('select_create_property', {
                      property_code: property.code,
                    });
                    setSelectedProperty(property.code);
                  }}
                  selected={
                    property.is_enabled || selectedProperty === property.code
                  }
                  disabled={property.is_locked}
                  tooltip={property.conflicting_tooltip}
                  tooltipPosition="bottom"
                >
                  <Box
                    italic={!!property.is_locked}
                    bold={!!property.is_locked}
                  >
                    {property.code} {property.level}
                  </Box>
                </Button>
              </Stack.Item>
            ))}
        </Stack>
      </Flex.Item>
      <Flex.Item mt={'18px'} width={65.5}>
        {known_properties &&
          known_properties.map(
            (property) =>
              property.code === selectedProperty && (
                <Section
                  key={property.name}
                  title={property.name}
                  textAlign={'center'}
                >
                  <h4>{property.desc}</h4>
                </Section>
              ),
          )}
      </Flex.Item>
    </Flex>
  );
};

export const CreateControl = (props: { readonly complexityMenu: boolean }) => {
  const { act, data } = useBackend<Data>();
  const { template_filters, lock_control, complexity_list } = data;
  const { complexityMenu } = props;
  return !complexityMenu ? (
    <Flex width={64.5} height={2} ml={1}>
      <Flex.Item ml={2}>
        <Button
          width={10}
          fontSize={'14px'}
          bold
          onClick={() => act('select_overdose')}
          disabled={lock_control}
        >
          Set OD
        </Button>
      </Flex.Item>
      <Flex.Item ml={2}>
        <Button
          width={10}
          fontSize={'14px'}
          bold
          disabled={lock_control}
          onClick={() => {
            act('change_name');
          }}
        >
          Set Name
        </Button>
      </Flex.Item>
      <Flex.Item ml={2} bold>
        <Button
          fontSize={'14px'}
          disabled={lock_control}
          onClick={() => {
            act('change_create_target_level');
          }}
        >
          Set LEVEL
        </Button>
      </Flex.Item>
      {Object.entries(template_filters).map(([name, flag]) => (
        <Flex.Item ml={1} key={flag[1]} width={5} textAlign="center">
          <Button
            fluid
            onClick={() => {
              act('toggle_flag', {
                flag_id: flag[1],
              });
            }}
            fontSize={'14px'}
            selected={flag[0]}
            bold
          >
            <Box italic={!!flag[0]}>{name}</Box>
          </Button>
        </Flex.Item>
      ))}
    </Flex>
  ) : (
    <Flex width={64.5} height={2} ml={1}>
      {complexity_list.map((rarity, id) => (
        <Flex.Item key={id} ml={1} width={15}>
          <Button
            fluid
            onClick={() => {
              act('change_complexity', {
                complexity_slot: id + 1,
              });
            }}
            fontSize={'14px'}
            bold
          >
            {rarity}
          </Button>
        </Flex.Item>
      ))}
    </Flex>
  );
};

export const ChemSimulator = () => {
  const { data } = useBackend<Data>();
  const { is_picking_recipe } = data;
  const [selectedMode, setSelectedMode] = useSharedState('modes', 0);
  const [complexityMenu, setComplexityMenu] = useSharedState(
    'complexity_flip',
    false,
  );
  const [selectedTargetProperty, setSelectedTargetProperty] = useSharedState(
    'target',
    false,
  );
  const [selectedReferenceProperty, setSelectedReferenceProperty] =
    useSharedState('reference_relate', false);
  return (
    <Window width={800} height={450} theme={'weyland'}>
      <Window.Content>
        <Flex m={1}>
          <Flex.Item>
            <InfoPanel />
          </Flex.Item>
          <Flex.Item mx={2}>
            {(!is_picking_recipe && (
              <Controls
                selectedMode={selectedMode}
                setSelectedMode={setSelectedMode}
                complexityMenu={complexityMenu}
                setComplexityMenu={setComplexityMenu}
                setSelectedTargetProperty={setSelectedTargetProperty}
                setSelectedReferenceProperty={setSelectedReferenceProperty}
              />
            )) || <RecipeOptions />}
          </Flex.Item>
        </Flex>
        <Divider />
        {selectedMode === 1 && (
          <ModeChange
            setSelectedTargetProperty={setSelectedTargetProperty}
            selectedTargetProperty={selectedTargetProperty}
          />
        )}
        {selectedMode === 2 && (
          <ModeChange
            setSelectedTargetProperty={setSelectedTargetProperty}
            selectedTargetProperty={selectedTargetProperty}
          />
        )}
        {selectedMode === 3 && (
          <ModeRelate
            setSelectedTargetProperty={setSelectedTargetProperty}
            selectedTargetProperty={selectedTargetProperty}
            setSelectedReferenceProperty={setSelectedReferenceProperty}
            selectedReferenceProperty={selectedReferenceProperty}
          />
        )}
        {selectedMode === 4 && <ModeCreate complexityMenu={complexityMenu} />}
      </Window.Content>
    </Window>
  );
};
