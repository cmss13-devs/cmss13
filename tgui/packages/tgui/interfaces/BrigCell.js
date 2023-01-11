import { useBackend } from '../backend';
import { addZeros } from 'common/math';
import { Window } from '../layouts';
import { Box, ColorBox, NoticeBox, Flex, ProgressBar, Button, LabeledList, Divider } from '../components';

export const BrigCell = (props, context) => {
  const { data, act } = useBackend(context);
  const { viewing_incident, incidents, bit_active } = data;

  return (
    <Window theme="weyland" width={450} height={450}>
      <Window.Content scrollable>
        <Flex justify="center" mt="2rem" mb=".5rem">
          <Button
            content="Toggle Shutters"
            height="100%"
            mr="1rem"
            px="2rem"
            py=".25rem"
            onClick={() => act('toggle_doors')}
          />
          <Button
            content="Activate Flash"
            height="100%"
            px="2rem"
            py=".25rem"
            onClick={() => act('flash')}
          />
        </Flex>

        <Divider />

        <Flex direction="column" justify="center" align="center" width="auto">
          {!viewing_incident && (
            <>
              <h1>Sentences:</h1>
              <Flex align="center">
                <ColorBox color="green" />
                <Box inline px="1rem">
                  Active
                </Box>
              </Flex>

              {incidents.map((incident, i) => {
                const isActive = incident.status & bit_active;

                return (
                  <Button
                    key={i}
                    textAlign="center"
                    minWidth="15rem"
                    p=".5rem"
                    my=".5rem"
                    color={isActive ? 'green' : ''}
                    onClick={() =>
                      act('set_viewed_incident', { incident: incident.ref })
                    }>
                    {incident.suspect}
                  </Button>
                );
              })}
            </>
          )}
        </Flex>

        {!!viewing_incident && <IncidentDetails />}
      </Window.Content>
    </Window>
  );
};

// Returns the time left, in seconds.
const getTimeLeft = function (data) {
  const {
    time_to_release,
    time,
    status,
    bit_active,
    brig_sentence,
    time_served,
  } = data;

  const isActive = status & bit_active;
  let timeLeft = (time_to_release - time) / 10;

  if (!isActive) {
    timeLeft = (brig_sentence * 600 - time_served) / 10;
  }

  return Math.max(0, timeLeft);
};

const IncidentDetails = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    suspect,
    can_pardon,
    brig_sentence,
    time_served,
    bit_active,
    bit_perma,
    bit_pardoned,
    bit_served,
    status,
  } = data;

  // Time left, in seconds.
  const time_left = getTimeLeft(data);

  // 0 to 1, for the progress bar.
  const progress = 1 - time_left / 60 / brig_sentence;

  // The time in 5:05 format.
  const time_left_pretty =
    Math.floor((time_left / 60) % 60) +
    ':' +
    addZeros(Math.floor(time_left % 60), 2);

  const isActive = status & bit_active;
  const isPerma = status & bit_perma;
  const isPardoned = status & bit_pardoned;
  const isServed = status & bit_served;
  const isStarted = time_served || isActive;

  let statusText, statusClass;
  if (isPardoned) {
    statusText = 'PARDONED';
    statusClass = 'info';
  } else if (isPerma) {
    statusText = 'PERMABRIG';
    statusClass = 'danger';
  } else if (isServed) {
    statusText = 'SERVED';
    statusClass = 'success';
  }

  return (
    <>
      <Flex mb=".5rem" justify="space-between" align="center">
        <Button
          icon="arrow-left"
          px="2rem"
          py=".25rem"
          mr="1rem"
          onClick={() => act('set_viewed_incident')}
        />

        <Flex.Item>
          {!(isPerma && !isPardoned) && (
            <Button.Confirm
              icon="rotate-left"
              px=".75rem"
              py=".25rem"
              mr="1rem"
              tooltip="Reset sentence"
              onClick={() => act('reset_timer')}
            />
          )}

          <Button.Confirm
            icon="eject"
            px=".75rem"
            py=".25rem"
            tooltip="Eject report"
            onClick={() => act('remove_report')}
          />
        </Flex.Item>
      </Flex>

      {!statusClass && (
        <ProgressBar
          my="0rem"
          value={progress}
          p="1.25rem"
          color="average"
          style={{ border: 'none', margin: 0 }}>
          <Flex justify="center" fontSize="2rem" bold>
            {time_left_pretty}
          </Flex>
        </ProgressBar>
      )}

      {statusClass && (
        <NoticeBox
          className={'NoticeBox--type--' + statusClass}
          width="100%"
          textAlign="center"
          p="1rem"
          fontSize="2rem">
          {statusText}
        </NoticeBox>
      )}

      <Flex mt="1rem">
        <LabeledList>
          <LabeledList.Item label="Suspect">{suspect}</LabeledList.Item>
          <LabeledList.Item label="Sentence">
            {isPerma ? 'Permabrig' : brig_sentence + ' Minutes'}
          </LabeledList.Item>
        </LabeledList>
      </Flex>

      {!!(!statusClass || isPerma) && (
        <Flex>
          {!isActive && (
            <Button
              tooltip={isStarted ? 'Resume Timer' : 'Start Timer'}
              icon="play"
              px="2rem"
              py=".25rem"
              mt="1rem"
              mr="1rem"
              onClick={() => act('start_timer')}
            />
          )}

          {!!isActive && (
            <>
              {!isPerma && (
                <Button
                  tooltip="Pause Timer"
                  icon="pause"
                  px="2rem"
                  py=".25rem"
                  mt="1rem"
                  mr="1rem"
                  height="100%"
                  onClick={() => act('pause_timer')}
                />
              )}

              <Button.Confirm
                tooltip="End Timer"
                icon="stop"
                px="2rem"
                py=".25rem"
                mt="1rem"
                mr="1rem"
                height="100%"
                onClick={() => act('end_timer')}
              />
            </>
          )}

          {!!can_pardon && (
            <Button.Confirm
              content="Pardon"
              tooltip="Pardon"
              icon="gavel"
              px="2rem"
              py=".25rem"
              mt="1rem"
              height="100%"
              onClick={() => act('pardon')}
            />
          )}
        </Flex>
      )}
    </>
  );
};
