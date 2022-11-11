import { useBackend, useLocalState } from '../backend';
import {
  Stack,
  Section,
  NoticeBox,
  Flex,
  Dropdown,
  Dimmer,
  Icon,
} from '../components';
import { ButtonCheckbox, Button } from '../components/Button';
import { Window } from '../layouts';

const ARMOR_TYPES = ['Light Armor', 'Medium Armor', 'Heavy Armor'];
const HEAD_TYPES = ['Helmet', 'Beret', 'Tactical Cap'];

export const PmcTransfer = (props, context) => {
  const { act, data } = useBackend(context);
  const { verification, possible_verifications, human } = data;
  let primary;
  if (verification) {
    primary = <PMCArmorSelect />;
  } else if (!human) {
    primary = <PMCTransferWindow />;
  } else if (human) {
    primary = <PMCVerification />;
  }
  return (
    <Window width={400} height={300} theme="weyland">
      <Window.Content>{primary}</Window.Content>
    </Window>
  );
};

const PMCTransferWindow = (props, context) => {
  const { act, data } = useBackend(context);
  const { human, possible_verifications } = data;
  return (
    <Section fill>
      <Stack vertical>
        {!human && (
          <Stack.Item>
            <NoticeBox>Place a hand on the scanner to continue.</NoticeBox>
          </Stack.Item>
        )}
        {!!human && (
          <Stack.Item>
            <NoticeBox>Selected for PMC transfer: {human}</NoticeBox>
          </Stack.Item>
        )}
        <Stack.Item bold>
          Possible Transfers Left: {possible_verifications}
        </Stack.Item>
      </Stack>
      {possible_verifications <= 0 && <NoRecruitsDimmer />)}
    </Section>
  );
};

const PMCArmorSelect = (props, context) => {
  const { act, data } = useBackend(context);
  const [selected_armor, setArmor] = useLocalState(
    context,
    'selected_armor',
    Object.values(ARMOR_TYPES)[0]
  );
  const [selected_head, setHead] = useLocalState(
    context,
    'selected_head',
    Object.values(HEAD_TYPES)[0]
  );
  const { possible_verifications } = data;

  return (
    <Section textAlign="center" flexGrow="1" fill>
      <Flex height="100%">
        <Flex.Item grow="1" align="center">
          Please select an armor type and headwear for the recruit.
          <Dropdown
            width={12}
            selected={selected_armor}
            options={ARMOR_TYPES}
            onSelected={(value) => setArmor(value)}
          />
          <Dropdown
            width={12}
            selected={selected_head}
            options={HEAD_TYPES}
            onSelected={(value) => setHead(value)}
          />
          <Button
            icon="check"
            content="Confirm Armor"
            onClick={() =>
              act('selectArmor', {
                selected_armor: selected_armor,
                selected_head: selected_head,
              })
            }
          />
        </Flex.Item>
      </Flex>
      {possible_verifications <= 0 && <NoRecruitsDimmer />}
    </Section>
  );
};

const PMCNoRecruits = (props, context) => {
  return (
    <NoticeBox>
      You have reached the company-authorized limit of PMC recruits, please
      contact via fax should more be required.
    </NoticeBox>
  );
};

const PMCVerification = (props, context) => {
  const { act, data } = useBackend(context);
  const { verification, is_loading, possible_verifications } = data;
  return (
    <Section title="Squad Transfer" fill>
      By checking the box, you are confirming that you have followed company
      procedure for the vetting and recruitment of PMC units from USMC ranks,
      and that the appropriate paperwork has been filed, namely record form
      268-C and any paperwork the recruit&apos;s former employer may require.
      <ButtonCheckbox
        checked={verification}
        disabled={is_loading || !!(possible_verifications <= 0)}
        fluid
        color="default"
        onClick={() => act('startLoading')}>
        Confirm
      </ButtonCheckbox>
      {(is_loading && <LoadingScreenDimmer />)}
      {possible_verifications <= 0 && <NoRecruitsDimmer />)}
    </Section>
  );
};

const LoadingScreenDimmer = (props, context) => {
  return (
    <Stack fill>
      <Stack.Item>
        <Dimmer>
          <Stack align="baseline" vertical>
            <Stack.Item>
              <Stack ml={-2}>
                <Stack.Item>
                  <Icon color="red" name="address-card" size={10} />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item fontSize="18px">Uploading...</Stack.Item>
          </Stack>
        </Dimmer>
      </Stack.Item>
    </Stack>
  );
};

const NoRecruitsDimmer = (props, context) => {
  return (
    <Stack fill>
      <Stack.Item>
        <Dimmer>
          <Stack align="baseline" vertical>
            <Stack.Item>
              <Stack ml={-2}>
                <Stack.Item>
                  <Icon color="red" name="circle-xmark" size={10} />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item fontSize="18px">
              Company-authorized recruit limit reached.
            </Stack.Item>
          </Stack>
        </Dimmer>
      </Stack.Item>
    </Stack>
  );
};
