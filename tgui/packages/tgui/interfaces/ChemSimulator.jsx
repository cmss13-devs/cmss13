import { map } from 'common/collections';

import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Divider,
  Flex,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const InfoPanel = () => {
  const { data } = useBackend();
  const { clearance, credits, status } = data;
  return (
    <Box height={12} width={35} fontSize={0.5}>
      <Section fill>
        <Flex direction={'column'} wrap={'wrap'} color={'#cfcfcf'}>
          <Flex.Item>
            <ProgressBar
              value={credits}
              minValue={1}
              maxValue={60}
              ranges={{
                good: [40, Infinity],
                average: [15, 40],
                bad: [-Infinity, 15],
              }}
            >
              <h4>RESEARCH CREDITS: {credits}</h4>
            </ProgressBar>
          </Flex.Item>
          <Flex.Item>
            <h3>STATUS: {status}</h3>
          </Flex.Item>
          <Flex.Item>
            <h3>RESEARCH CLEARANCE: {clearance}</h3>
          </Flex.Item>
          <Flex.Item>
            <h3>RESEARCH CLEARANCE: {clearance}</h3>
          </Flex.Item>
        </Flex>
      </Section>
    </Box>
  );
};

export const Controls = (props) => {
  const { act, data } = useBackend();
  const { selectedMode, setSelectedMode } = props;
  const {
    mode_data,
    can_simulate,
    can_eject_target,
    can_eject_reference,
    can_cancel_simulation,
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
              >
                SIMULATE
              </Button>
            ) : (
              <Button
                fluid
                icon={'fill-circle-xmark'}
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
              }}
              disabled={!can_eject_target}
            >
              EJECT TARGET
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button
              fluid
              onClick={() => {
                act('eject_reference');
              }}
              disabled={!can_eject_reference}
            >
              EJECT REFERENCE
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button fluid>COMPLEXITY</Button>
          </Stack.Item>
        </Stack>
      </Flex.Item>
      <Flex.Item fontSize={1.2} height={12} width={13}>
        <Stack vertical>
          {mode_data.map((mode_data, id) => (
            <Stack.Item key={id}>
              <Button
                fluid
                onClick={() => {
                  act('change_mode', { mode_id: mode_data.mode_id });
                  setSelectedMode(mode_data.mode_id);
                }}
                tooltip={mode_data.desc}
                icon={mode_data.icon}
                disabled={mode_data.mode_id === selectedMode}
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

export const RecipeOptions = (props) => {
  const { act, data } = useBackend();
  const [selectedRecipe, setSelectedRecipe] = useSharedState(false);
  const { reagent_option_data } = data;
  return (
    <Stack vertical>
      <Stack.Item>
        <Button
          verticalAlignContent={'middle'}
          bold
          textAlign={'center'}
          width={28}
          height={3}
          fluid
          onClick={() => {
            act('submit_recipe_pick', { reagent_picked: selectedRecipe });
          }}
        >
          <h3>FINALIZE</h3>
        </Button>
        {map(reagent_option_data, (recipe, id) => (
          <Button
            my={0.1}
            lineHeight={1.5}
            bold
            textAlign={'center'}
            key={id}
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

export const ModeChange = () => {
  const { act, data } = useBackend();
  const { target_data, lock_target_control } = data;
  const [selectedProperty, setSelectedProperty] = useSharedState(false);
  return (
    (target_data && (
      <Flex ml={5} fontSize={1.2} width={60} height={20} mt={5}>
        <Flex.Item width={20}>
          {map(target_data, (property, key) => (
            <Button
              bold
              m={0.6}
              width={8}
              textAlign={'center'}
              onClick={() => {
                act('select_target_property', {
                  property_code: property.code,
                });
                setSelectedProperty(property.code);
              }}
              selected={selectedProperty === property.code ? true : false}
              disabled={lock_target_control}
            >
              {property.code} {property.level}
            </Button>
          ))}
        </Flex.Item>
        <Flex.Item width={30}>
          {map(
            target_data,
            (property, key) =>
              property.code === selectedProperty && (
                <Stack vertical>
                  <Stack.Item>
                    <Section title={property.name}>{property.desc}</Section>
                  </Stack.Item>
                  <Stack.Item>
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

export const ModeRelate = () => {
  const { act, data } = useBackend();
  const { target_data, reference_data, lock_target_control } = data;
  const [selectedTargetProperty, setSelectedTargetProperty] = useSharedState(
    'target',
    false,
  );
  const [selectedReferenceProperty, setSelectedReferenceProperty] =
    useSharedState('reference', false);
  const [InfoPanel, setInfoPanel] = useSharedState('panel', false);
  return (
    (target_data && reference_data && (
      <Flex ml={3} fontSize={1.2} width={70} height={20} mt={5}>
        <Flex.Item width={20}>
          {map(target_data, (property) => (
            <Button
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
              selected={selectedTargetProperty === property.code ? true : false}
              disabled={lock_target_control || property.is_locked}
              tooltip={property.tooltip}
            >
              {property.code} {property.level} {selectedTargetProperty}
            </Button>
          ))}
        </Flex.Item>
        <Flex.Item width={20}>
          {map(reference_data, (property) => (
            <Button
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
              disabled={lock_target_control || property.is_locked}
              tooltip={property.tooltip}
            >
              {property.code} {property.level} {selectedReferenceProperty}
            </Button>
          ))}
        </Flex.Item>
        <Flex.Item ml={40}>
          {map(
            target_data,
            (property, key) =>
              property.code === selectedTargetProperty && (
                <Stack vertical>
                  <Stack.Item>
                    <Section title={property.name}>{property.desc}</Section>
                  </Stack.Item>
                  <Stack.Item>
                    Price of the operation : {property.cost}
                  </Stack.Item>
                </Stack>
              ),
          )}
        </Flex.Item>
      </Flex>
    )) || (
      <Box m={3}>
        <NoticeBox>No data insertsed!</NoticeBox>
      </Box>
    )
  );
};

export const ModeCreate = (props) => {
  const { act, data } = useBackend();
  const { complexityMenu } = props;
  const { known_properties } = data;
  return (
    <Flex direction={'column'}>
      <Flex.Item>
        <CreateControl />
      </Flex.Item>
      <Flex.Item>
        <Flex ml={1} mt={2} mr={1}>
          {map(known_properties, (property, key) => (
            <Flex.Item ml={1} grow mr={1} bold fontSize={'14px'}>
              <Button fluid textAlign={'center'}>
                {property.code}
              </Button>
            </Flex.Item>
          ))}
        </Flex>
      </Flex.Item>
    </Flex>
  );
};

export const CreateControl = () => {
  const { act, data } = useBackend();
  const { template_filters } = data;
  return (
    <Flex width={64.5} height={2} ml={1}>
      <Flex.Item ml={2}>
        <Button width={10} fontSize={'14px'} bold>
          Set OD
        </Button>
      </Flex.Item>
      <Flex.Item ml={2}>
        <Button width={10} fontSize={'14px'} bold>
          Set Name
        </Button>
      </Flex.Item>
      <Flex.Item ml={2} bold>
        <Button fontSize={'14px'}>Set LEVEL</Button>
      </Flex.Item>
      {map(template_filters, (flag, name) => (
        <Flex.Item ml={1} width={5}>
          <Button
            fluid
            onClick={() => {
              act('toogle_flag', {
                flag_id: flag[1],
              });
            }}
            fontSize={'14px'}
            selected={flag[0]}
            bold
          >
            {name}
          </Button>
        </Flex.Item>
      ))}
    </Flex>
  );
};

export const ChemSimulator = () => {
  const { act, data } = useBackend();
  const { clearance, credits, status, is_picking_recipe, is_ready } = data;
  const [selectedMode, setSelectedMode] = useSharedState(1);
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
              />
            )) || <RecipeOptions />}
          </Flex.Item>
        </Flex>
        <Divider />
        {selectedMode === 1 && <ModeChange />}
        {selectedMode === 2 && <ModeChange />}
        {selectedMode === 3 && <ModeRelate />}
        {selectedMode === 4 && <ModeCreate />}
      </Window.Content>
    </Window>
  );
};
