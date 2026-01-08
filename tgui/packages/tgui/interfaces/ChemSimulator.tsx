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
    conflictingSafety,
    setConflictingSafety,
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
                setConflictingSafety(!conflictingSafety);
              }}
              selected={!conflictingSafety}
              icon={'hard-drive'}
              tooltip={
                'Disable the protection for relating conflicting properties.'
              }
            >
              OVERRIDE
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
  readonly conflictingSafety: string | boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { target_data, reference_data, lock_control } = data;
  const {
    setSelectedTargetProperty,
    setSelectedReferenceProperty,
    selectedReferenceProperty,
    selectedTargetProperty,
    conflictingSafety,
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
                  disabled={
                    lock_control ||
                    (conflictingSafety ? property.is_locked : false)
                  }
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
                    disabled={
                      lock_control ||
                      (conflictingSafety ? property.is_locked : false)
                    }
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

export const ModeAdd = (props) => {
  const { act, data } = useBackend<Data>();
  const { target_data, reference_data, lock_control } = data;
  const {
    setSelectedTargetProperty,
    setSelectedReferenceProperty,
    selectedReferenceProperty,
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
              {data.target_data?.map((property, id) => (
                <Button bold m={0.6} width={8} textAlign={'center'} key={id}>
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
                {data.reference_data.map((property, id) => (
                  <Button
                    bold
                    key={id}
                    m={0.6}
                    width={8}
                    textAlign={'center'}
                    onClick={() => {
                      act('select_reference_property', {
                        property_code: property.code,
                      });
                      setSelectedReferenceProperty(property.code);
                      setSelectedTargetProperty(null);
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
          {data.reference_data.map(
            (property, id) =>
              property.code === selectedReferenceProperty && (
                <Stack vertical key={id}>
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

export const ChemSimulator = () => {
  const { data } = useBackend<Data>();
  const { is_picking_recipe } = data;
  const [selectedMode, setSelectedMode] = useSharedState('modes', 0);
  const [conflictingSafety, setConflictingSafety] = useSharedState(
    'conflicting_flip',
    true,
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
                conflictingSafety={conflictingSafety}
                setConflictingSafety={setConflictingSafety}
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
            conflictingSafety={conflictingSafety}
          />
        )}
        {selectedMode === 4 && (
          <ModeAdd
            setSelectedTargetProperty={setSelectedTargetProperty}
            setSelectedReferenceProperty={setSelectedReferenceProperty}
            selectedReferenceProperty={selectedReferenceProperty}
          />
        )}
      </Window.Content>
    </Window>
  );
};
