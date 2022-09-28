import { useBackend } from '../backend';
import { Section, ProgressBar, Box, LabeledList, NoticeBox, Stack, Icon, Divider } from '../components';
import { Window } from '../layouts';

export const HealthScan = (props, context) => {
  const { data } = useBackend(context);
  const {
    patient,
    dead,
    health,
    total_brute,
    total_burn,
    toxin,
    oxy,
    clone,

    has_chemicals,
    limbs_damaged,

    damaged_organs,
    ssd,

    diseases,

    blood_type,
    blood_amount,
    has_blood,
    body_temperature,
    pulse,
    internal_bleeding,
    implants,
    core_fracture,
    lung_ruptured,
    hugged,
    detail_level,
    permadead,
    advice,
    species,
  } = data;
  const healthanalyser = detail_level < 1;
  const bodyscanner = detail_level >= 1;
  const ghostscan = detail_level >= 2;

  const Synthetic = species === "Synthetic";

  const theme = Synthetic ? "hackerman" : (bodyscanner ? "ntos" : "default");

  return (
    <Window
      width={550}
      height={bodyscanner ? 700 : 500}
      theme={theme}>
      <Window.Content scrollable>
        <Section title={"Patient: " + patient}>
          {hugged && ghostscan ? (
            <NoticeBox danger>
              Patient has been implanted with an alien embryo!
            </NoticeBox>
          ) : null}
          {dead ? (
            <NoticeBox danger>
              Patient is deceased!
            </NoticeBox>
          ) : null}
          {ssd ? (
            <NoticeBox warning color="grey">
              {ssd}
            </NoticeBox>
          ) : null}
          <LabeledList>
            <LabeledList.Item
              label="Health">
              {health >= 0 ? (
                <ProgressBar
                  value={health/100}
                  ranges={{
                    good: [0.7, Infinity],
                    average: [0.2, 0.7],
                    bad: [-Infinity, 0.2],
                  }} >{health}% healthy
                </ProgressBar>
              ) : (
                <ProgressBar
                  value={1 + (health/100)}
                  ranges={{
                    bad: [-Infinity, Infinity],
                  }} >{health}% healthy
                </ProgressBar>)}
            </LabeledList.Item>
            {dead ? (
              <LabeledList.Item
                label="Condition">
                <Box
                  color={permadead ? "red" : "green"}
                  bold={1}
                >
                  {permadead ? "Permanently deceased" : (Synthetic ? "Central power system shutdown, reboot possible." : "Cardiac arrest, defibrillation possible")}
                </Box>
              </LabeledList.Item>
            ) : null}
            <LabeledList.Item
              label="Damage">
              <Box inline>
                <ProgressBar
                  value={total_brute}
                  maxvalue={total_brute}
                  ranges={{
                    red: [-Infinity, Infinity],
                  }}>Brute:{total_brute}
                </ProgressBar>
              </Box>
              <Box inline width={"5px"} />
              <Box inline>
                <ProgressBar
                  value={total_burn}
                  maxvalue={total_burn}
                  ranges={{
                    orange: [-Infinity, Infinity],
                  }}>Burns:{total_burn}
                </ProgressBar>
              </Box>
              <Box inline width={"5px"} />
              <Box inline>
                <ProgressBar
                  value={toxin}
                  maxvalue={toxin}
                  ranges={{
                    green: [-Infinity, Infinity],
                  }}>Toxin:{toxin}
                </ProgressBar>
              </Box>
              <Box inline width={"5px"} />
              <Box inline>
                <ProgressBar
                  value={oxy}
                  maxvalue={oxy}
                  ranges={{
                    blue: [-Infinity, Infinity],
                  }}>Oxygen:{oxy}
                </ProgressBar>
              </Box>
              <Box inline width={"5px"} />
              {!!clone && (
                <Box inline>
                  <ProgressBar
                    value={clone}
                    maxvalue={clone}
                    ranges={{
                      teal: [-Infinity, Infinity],
                    }}>Clone:{clone}
                  </ProgressBar>
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {has_chemicals ? (
          <ScannerChems />
        ) : null}
        {limbs_damaged ? (
          <ScannerLimbs />
        ) : null}
        {damaged_organs.length && bodyscanner ? (
          <ScannerOrgans />
        ) : null }
        {diseases ? (
          <Section title="Diseases">
            <LabeledList>
              {
                diseases.map(disease => (
                  <LabeledList.Item
                    key={disease.name}
                    label={disease.name[0].toUpperCase()
                    + disease.name.slice(1)}>
                    <Box inline
                      bold={1}>
                      Type : {disease.type}, possible cure : {disease.cure}
                    </Box>
                    <Box inline width={"5px"} />
                    <Box inline>
                      <ProgressBar
                        width="200px"
                        value={disease.stage/disease.max_stage}
                        ranges={{
                          good: [-Infinity, 20],
                          average: [20, 50],
                          bad: [50, Infinity],
                        }}>Stage:{disease.stage}/{disease.max_stage}
                      </ProgressBar>
                    </Box>
                  </LabeledList.Item>
                ))
              }
            </LabeledList>
          </Section>
        ) : null }
        <Section>
          <LabeledList>
            {has_blood ? (
              <LabeledList.Item
                label={"Blood Type: " + blood_type}>
                <ProgressBar
                  value={blood_amount/560}
                  ranges={{
                    good: [0.9, Infinity],
                    average: [0.7, 0.9],
                    bad: [-Infinity, 0.7],
                  }}>
                  <Box>
                    {Math.round(blood_amount/5.6)}%, {blood_amount}cl
                  </Box>
                </ProgressBar>
              </LabeledList.Item>
            ) : null}
            <LabeledList.Item
              label={"Body Temperature"}>
              {body_temperature}
            </LabeledList.Item>
            <LabeledList.Item
              label={"Pulse"}>
              {pulse}
            </LabeledList.Item>
          </LabeledList>
          {internal_bleeding || implants || hugged || core_fracture
          || (lung_ruptured && bodyscanner) ? (<Divider />
            ) : null}
          {internal_bleeding ?(
            <NoticeBox danger>
              Internal Bleeding Detected!
              {healthanalyser ? " Advanced scanner required for location." : ""}
            </NoticeBox>
          ) : null}
          {implants && detail_level !== 1 ? (
            <NoticeBox danger>
              {implants} embedded object{implants > 1 ? "s" : ""} detected!
              {healthanalyser ? " Advanced scanner required for location." : ""}
            </NoticeBox>
          ) : null}
          {(implants || hugged) && detail_level === 1 ? (
            <NoticeBox danger>
              {implants + (hugged ? 1 : 0)} unknown bod{(implants + (hugged ? 1 : 0)) > 1 ? "ies" : "y"} detected!
            </NoticeBox>
          ) : null}
          {lung_ruptured && bodyscanner ? (
            <NoticeBox danger>
              Ruptured lung detected!
            </NoticeBox>
          ) : null}
          {core_fracture && healthanalyser ? (
            <NoticeBox danger>
              Bone fractures detected! Advanced scanner required for location.
            </NoticeBox>
          ) : null}
        </Section>
        {advice ? (
          <Section title="Medication Advice">
            <Stack vertical>
              {
                advice.map(advice => (
                  <Stack.Item
                    key={advice.advice}>
                    <Box inline>
                      <Icon name={advice.icon} ml={0.2} color={advice.colour} />
                      <Box inline width={"5px"} />
                      {advice.advice}
                    </Box>
                  </Stack.Item>
                ))
              }
            </Stack>
          </Section>
        ) : null}
      </Window.Content>
    </Window>
  );
};

const ScannerChems = (props, context) => {
  const { data } = useBackend(context);
  const {
    has_unknown_chemicals,
    chemicals_lists,
  } = data;
  const chemicals = Object.values(chemicals_lists);

  return (
    <Section title="Chemical Contents">
      {has_unknown_chemicals ? (
        <NoticeBox warning color="grey">
          Unknown reagents detected.
        </NoticeBox>
      ) : null}
      <Stack>
        {
          chemicals.map(chemical => (
            <Stack.Item
              key={chemical.name}>
              <Box inline>
                <Icon name={"flask"} ml={0.2} color={chemical.colour} />
                <Box inline width={"5px"} />
                <Box inline
                  color={chemical.dangerous ? "red" : "white"}
                  bold={chemical.dangerous}>
                  {chemical.amount + "u " + chemical.name}
                </Box>
                <Box inline width={"5px"} />
                {chemical.od ? (
                  <Box inline
                    color={"red"}
                    bold={1}>
                    {"OD"}
                  </Box>
                ) : null}
              </Box>
            </Stack.Item>
          ))
        }
      </Stack>
    </Section>
  );
};

const ScannerLimbs = (props, context) => {
  const { data } = useBackend(context);
  const {
    limb_data_lists,
    detail_level,
  } = data;
  const limb_data = Object.values(limb_data_lists);
  const bodyscanner = detail_level >= 1;

  return (
    <Section title="Limbs Damaged">
      <LabeledList>
        {
          limb_data.map(limb => (
            <LabeledList.Item
              key={limb.name}
              label={limb.name[0].toUpperCase() + limb.name.slice(1)}>
              {limb.missing ? (
                <Box inline
                  color={"red"}
                  bold={1}>
                  MISSING
                </Box>
              ) : (
                <>
                  {limb.brute > 0 ? (
                    <>
                      <Box inline>
                        <ProgressBar
                          value={limb.brute}
                          maxvalue={limb.brute}
                          ranges={{
                            red: [-Infinity, Infinity],
                          }}>Brute:{limb.brute}
                        </ProgressBar>
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {limb.burn > 0 ? (
                    <>
                      <Box inline>
                        <ProgressBar
                          value={limb.burn}
                          maxvalue={limb.burn}
                          ranges={{
                            orange: [-Infinity, Infinity],
                          }}>Burn:{limb.burn}
                        </ProgressBar>
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {!limb.bandaged && limb.brute > 0 && !limb.limb_type ? (
                    <>
                      <Box inline color={"orange"}>
                        [Unbandaged]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {!limb.salved && limb.burn > 0 && !limb.limb_type ? (
                    <>
                      <Box inline color={"orange"}>
                        [Unsalved]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {limb.bleeding ? (
                    <>
                      <Box inline color={"red"} bold={1}>
                        [Bleeding]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {limb.internal_bleeding && bodyscanner ? (
                    <>
                      <Box inline color={"red"} bold={1}>
                        [Internal Bleeding]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {limb.limb_status ? (
                    <>
                      <Box inline color={(limb.limb_status === "Fracture" || "Possible Fracture") ? "white" : "red"} bold={1}>
                        [{limb.limb_status}]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {limb.limb_splint ? (
                    <>
                      <Box inline color={"green"} bold={1}>
                        [{limb.limb_splint}]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {limb.limb_type ? (
                    <>
                      <Box inline color={(limb.limb_type === "Nonfunctional Cybernetic") ? "red" : "green"} bold={1}>
                        [{limb.limb_type}]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {limb.open_incision ? (
                    <>
                      <Box inline color={"red"} bold={1}>
                        [Open Surgical Incision]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                  {limb.implant && bodyscanner ? (
                    <>
                      <Box inline color={"white"} bold={1}>
                        [Embedded Object]
                      </Box>
                      <Box inline width={"5px"} />
                    </>
                  ) : null}
                </>
              )}
            </LabeledList.Item>
          ))
        }
      </LabeledList>
    </Section>
  );
};

const ScannerOrgans = (props, context) => {
  const { data } = useBackend(context);
  const {
    damaged_organs,
  } = data;


  return (
    <Section title="Organ(s) Damaged">
      <LabeledList>
        {
          damaged_organs.map(organ => (
            <LabeledList.Item
              key={organ.name}
              label={organ.name[0].toUpperCase() + organ.name.slice(1)}>
              <Box inline
                color={organ.status === "Bruised" ? "orange" : "red"}
                bold={1}>
                {organ.status + " [" + organ.damage + " damage]"}
              </Box>
              <Box inline width={"5px"} />
              {organ.robotic ? (
                <Box inline bold={1} color="blue">
                  Robotic
                </Box>
              ) : null}
            </LabeledList.Item>
          ))
        }
      </LabeledList>
    </Section>
  );
};
