import { useBackend } from '../backend';
import { Stack, Section, NoticeBox, Flex, Icon, Dropdown } from '../components';
import { ButtonCheckbox, Button } from '../components/Button';
import { Window } from '../layouts';

const ARMOR_TYPES = ['light', 'medium', 'heavy'];

export const PmcTransfer = (props, context) => {
  const { act, data } = useBackend(context);
  const { inserted_id, id_has_access, verification } = data;
  var primary;
  if (verification == true) {
    primary = <PMCArmorSelect />;
  } else if (inserted_id == false) {
    primary = <PMCNoID />;
  } else if (id_has_access == false) {
    primary = <PMCNoAccess />;
  } else {
    primary = <PMCTransferWindow />;
  }
  return (
    <Window width={400} height={300} theme="weyland">
      <Window.Content>{primary}</Window.Content>
    </Window>
  );
};

const PMCNoID = (props, context) => {
  return (
    <Section textAlign="center" flexGrow="1" fill>
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="red">
          <Icon name="times-circle" mb="0.5rem" size="5" color="red" />
          <br />
          No ID card detected.
          <br />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const PMCNoAccess = (props, context) => {
  return (
    <Section textAlign="center" flexGrow="1" fill>
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="red">
          <Icon name="times-circle" mb="0.5rem" size="5" color="red" />
          <br />
          Insufficient access.
          <br />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const PMCTransferWindow = (props, context) => {
  const { act, data } = useBackend(context);
  const { human, verification, possible_verifications, id_name } = data;
  {
    !!possible_verifications && (
      <Section>
        <Stack vertical>
          <Stack.Item>
            <Button
              fluid
              icon="eject"
              content={id_name}
              onClick={() => act('ejectID')}
            />
          </Stack.Item>
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
      </Section>
    );
  }
  {
    !!(human && possible_verifications) && (
      <Section title="Squad Transfer">
        By checking the box, you are confirming that you have followed company
        procedure for the vetting and recruitment of PMC units from USMC ranks,
        and that the appropriate paperwork has been filed.
        <ButtonCheckbox
          checked={verification}
          fluid
          onClick={() => act('clickVerification')}>
          Confirm
        </ButtonCheckbox>
      </Section>
    );
  }
  {
    !possible_verifications && (
      <NoticeBox>
        You have reached the company-authorized limit of PMC recruits, please
        contact via fax should more be required.
      </NoticeBox>
    );
  }
};

const PMCArmorSelect = (props, context) => {
  const [selected_armor, setArmor] = useLocalState(
    context,
    'selected_armor',
    Object.keys(ARMOR_TYPES)[0]
  );

  return (
    <Section textAlign="center" flexGrow="1" fill>
      <Flex height="100%">
        <Flex.Item grow="1" align="center">
          <Dropdown
            width={12}
            selected={selected_armor}
            options={ARMOR_TYPES}
            onSelected={(value) => setArmor(value)}
          />
          <Button
            icon="check"
            content="Confirm Armor"
            onClick={() => act('selectArmor', selected_armor)}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};
