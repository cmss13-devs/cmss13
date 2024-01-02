import { useBackend, useLocalState } from '../backend';
import { Flex, LabeledList, Box, Section, Tabs, Button } from '../components';
import { Window } from '../layouts';

const PAGES = {
  'main': () => MainMenu,
  'incident_report': () => NewReport,
  'new_charge': () => NewCharge,
};

export const Sentencing = (props, context) => {
  const { data } = useBackend(context);
  const { current_menu } = data;
  const PageComponent = PAGES[current_menu]();

  return (
    <Window theme="weyland" width={780} height={725}>
      <Window.Content scrollable>
        <PageComponent />
      </Window.Content>
    </Window>
  );
};

const MainMenu = (props, context) => {
  const { act } = useBackend(context);

  return (
    <Flex
      direction="column"
      justify="center"
      align="center"
      height="100%"
      color="darkgrey"
      fontSize="2rem"
      mt="-3rem"
      bold>
      <Box fontFamily="monospace">Jurisdictional Automated System</Box>
      <Box mb="2rem" fontFamily="monospace">
        WY-DOS Executive
      </Box>
      <Box fontFamily="monospace">Version 5.8.4</Box>
      <Box fontFamily="monospace">Copyright © 2182, Weyland Yutani Corp.</Box>

      <Button
        content="New Report"
        width="30vw"
        textAlign="center"
        fontSize="1.5rem"
        p="1rem"
        mt="5rem"
        onClick={() => act('new_report')}
      />
      <Box fontSize="2rem" mt="1rem">
        OR
      </Box>
      <Box fontSize="1.5rem" mt="1rem">
        scan an existing report
      </Box>
    </Flex>
  );
};

const NewReport = (props, context) => {
  const { data, act } = useBackend(context);
  const { suspect_name, summary, sentence, current_charges } = data;
  const canExport = suspect_name && current_charges.length;

  return (
    <>
      <Section>
        <Flex align="center">
          <Button.Confirm
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            tooltip="Delete report"
            onClick={() => act('scrap_report')}
          />

          <h1>Incident Report</h1>

          <Button
            content="Export"
            icon="print"
            ml="auto"
            px="2rem"
            bold
            tooltip={canExport ? '' : 'Missing suspect or charges'}
            disabled={!canExport}
            onClick={() => act('export')}
          />
        </Flex>
      </Section>
      <Section>
        <LabeledList>
          <LabeledList.Item label="Suspect">
            <Button
              content={suspect_name}
              icon="pen"
              bold
              tooltip="Hold an ID in your hand"
              onClick={() => act('set_suspect')}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Sentence">
            {sentence !== '0 minutes' ? sentence : '--'}
          </LabeledList.Item>
          <LabeledList.Item label="Summary">
            <Button icon="pen" onClick={() => act('edit_summary')} />
          </LabeledList.Item>
        </LabeledList>
        <Box mt=".5rem" italic>
          {summary}
        </Box>
      </Section>

      <Charges />

      <Evidence />
    </>
  );
};

const NewCharge = (props, context) => {
  const { data, act } = useBackend(context);
  const { laws } = data;
  const [chargeCategory, setChargeCategory] = useLocalState(
    context,
    'chargeCategory',
    0
  );

  return (
    <>
      <Section>
        <Flex align="center">
          <Button
            icon="arrow-left"
            px="2rem"
            textAlign="center"
            mr="1rem"
            onClick={() => act('set_menu', { new_menu: 'incident_report' })}
          />
          <h1>New Charge</h1>
        </Flex>
      </Section>
      <Section>
        <Tabs fluid textAlign="center">
          {laws.map((category, i) => (
            <Tabs.Tab
              key={i}
              selected={i === chargeCategory}
              onClick={() => setChargeCategory(i)}>
              {category.label}
            </Tabs.Tab>
          ))}
        </Tabs>

        <Section>
          {laws[chargeCategory].laws.map((law, i) => (
            <Section key={i} title={law.name}>
              <Box mb=".75rem" italic>
                {law.desc}
              </Box>
              <LabeledList>
                <LabeledList.Item label="Sentence">
                  {law.brig_time} minutes
                </LabeledList.Item>
                {law.special_punishment && (
                  <LabeledList.Item label="Extra">
                    {law.special_punishment}
                  </LabeledList.Item>
                )}
              </LabeledList>
              <Button
                content="Add Charge"
                bold
                mt="1rem"
                onClick={() => act('new_charge', { law: law.ref })}
              />
            </Section>
          ))}
        </Section>
      </Section>
    </>
  );
};

const Charges = (props, context) => {
  const { data, act } = useBackend(context);
  const { current_charges } = data;

  return (
    <Section title="Charges">
      <Flex direction="column">
        {!!current_charges.length && (
          <Flex
            className="candystripe"
            p=".75rem"
            align="center"
            fontSize="1.25rem">
            <Flex.Item bold width="9rem" shrink="0" mr="1rem">
              Charge
            </Flex.Item>
            <Flex.Item grow bold>
              Description
            </Flex.Item>
            <Flex.Item
              width="10rem"
              shrink="0"
              textAlign="right"
              pr="3rem"
              bold>
              Extra
            </Flex.Item>
          </Flex>
        )}
        {current_charges.map((charge, i) => {
          return (
            <Flex key={i} className="candystripe" p=".75rem" align="center">
              <Flex.Item bold width="9rem" shrink="0" mr="1rem">
                {charge.name}
              </Flex.Item>
              <Flex.Item grow italic>
                {charge.desc}
              </Flex.Item>
              <Flex.Item width="9rem" ml="1rem" shrink="0" textAlign="right">
                {charge.special_punishment}
              </Flex.Item>
              <Flex.Item ml="1rem">
                <Button
                  icon="trash"
                  onClick={() => act('remove_charge', { charge: charge.ref })}
                />
              </Flex.Item>
            </Flex>
          );
        })}
        <Flex justify="center" mt=".75rem">
          <Button
            content="New Charge"
            px="2rem"
            py=".25rem"
            mb=".5rem"
            bold
            onClick={() => act('set_menu', { new_menu: 'new_charge' })}
          />
        </Flex>
      </Flex>
    </Section>
  );
};

const Evidence = (props, context) => {
  const { data, act } = useBackend(context);
  const { witnesses, evidence } = data;

  return (
    <Section title="Evidence">
      <Flex>
        {/* Witnesses */}
        <Flex direction="column" width="50%">
          {witnesses.map((witness, i) => (
            <Flex
              key={i}
              className="candystripe"
              p=".75rem"
              mb=".75rem"
              align="center">
              <Flex direction="column" align="middle" width="100%">
                <Flex.Item bold mb=".5rem">
                  {witness.name}
                </Flex.Item>

                <Flex.Item italic>{witness.notes}</Flex.Item>
              </Flex>

              <Flex
                direction="column"
                width="2.5rem"
                textAlign="center"
                ml="1rem">
                <Button
                  icon="pen"
                  width="100%"
                  onClick={() =>
                    act('edit_witness_notes', { witness: witness.ref })
                  }
                />
                <Button
                  icon="trash"
                  width="100%"
                  onClick={() =>
                    act('remove_witness', { witness: witness.ref })
                  }
                />
              </Flex>
            </Flex>
          ))}
          <Button
            content="Add Witness"
            textAlign="center"
            bold
            width="50%"
            mx="auto"
            py=".25rem"
            tooltip="Hold an ID in your hand"
            onClick={() => act('add_witness')}
          />
        </Flex>

        {/* Objects */}
        <Flex direction="column" width="50%">
          {evidence.map((evidence, i) => (
            <Flex
              key={i}
              className="candystripe"
              p=".75rem"
              mb=".75rem"
              align="center">
              <Flex direction="column" align="middle" width="100%">
                <Flex.Item bold mb=".5rem">
                  {evidence.name}
                </Flex.Item>

                <Flex.Item italic>{evidence.notes}</Flex.Item>
              </Flex>

              <Flex
                direction="column"
                width="2.5rem"
                textAlign="center"
                ml="1rem">
                <Button
                  icon="pen"
                  width="100%"
                  onClick={() =>
                    act('edit_evidence_notes', { evidence: evidence.ref })
                  }
                />
                <Button
                  icon="trash"
                  width="100%"
                  onClick={() =>
                    act('remove_evidence', { evidence: evidence.ref })
                  }
                />
              </Flex>
            </Flex>
          ))}
          <Button
            content="Add Evidence"
            textAlign="center"
            bold
            width="50%"
            mx="auto"
            py=".25rem"
            tooltip="Hold an object in your hand"
            onClick={() => act('add_evidence')}
          />
        </Flex>
      </Flex>
    </Section>
  );
};
