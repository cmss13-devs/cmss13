import { classes } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Flex, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const IcMedalsPanel = (props) => {
  const { act, data } = useBackend();

  const CONDUCT_MEDAL = 'distinguished conduct medal';
  const BRONZE_HEART_MEDAL = 'bronze heart medal';
  const VALOR_MEDAL = 'medal of valor';
  const HEROISM_MEDAL = 'medal of exceptional heroism';

  const [recommendationMedalTypes, setRecommendationMedalTypes] = useState([]);

  return (
    <Window width={600} height={400} theme={'ntos'} resizable>
      <Window.Content scrollable>
        <NoticeBox textAlign="center">
          <Button
            width="350px"
            fontSize="20px"
            icon="medal"
            color="danger"
            onClick={() => act('grant_new_medal')}
          >
            Grant new medal
          </Button>
        </NoticeBox>
        {data.recommendations.map((recommendation, index) => (
          <Section
            key={index}
            title={recommendation.name + ' (' + recommendation.rank + ')'}
          >
            <Stack width="100%">
              <Stack.Item>
                <Flex>
                  <Flex direction="column">
                    <Flex.Item>
                      <Button
                        tooltip="Distinguished Conduct Medal"
                        color={
                          recommendationMedalTypes[index] === CONDUCT_MEDAL
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = CONDUCT_MEDAL;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            CONDUCT_MEDAL.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                    <Flex.Item>
                      <Button
                        tooltip="Medal of Valor"
                        color={
                          recommendationMedalTypes[index] === VALOR_MEDAL
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = VALOR_MEDAL;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            VALOR_MEDAL.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                  </Flex>
                  <Flex direction="column">
                    <Flex.Item>
                      <Button
                        tooltip="Bronze Heart Medal"
                        color={
                          recommendationMedalTypes[index] === BRONZE_HEART_MEDAL
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = BRONZE_HEART_MEDAL;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            BRONZE_HEART_MEDAL.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                    <Flex.Item>
                      <Button
                        tooltip="Medal of Exceptional Heroism"
                        color={
                          recommendationMedalTypes[index] === HEROISM_MEDAL
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = HEROISM_MEDAL;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            HEROISM_MEDAL.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                  </Flex>
                </Flex>
              </Stack.Item>
              <Stack.Item grow textAlign={'center'}>
                <Box>
                  Recommender: {recommendation.recommender_name} (
                  {recommendation.recommender_rank})
                </Box>
                <Box>Reason: {recommendation.reason}</Box>
              </Stack.Item>
              <Stack.Item textAlign="right">
                <Button
                  icon="check"
                  tooltip={
                    !recommendationMedalTypes[index]
                      ? 'Select a medal type first!'
                      : ''
                  }
                  disabled={!recommendationMedalTypes[index]}
                  color="good"
                  onClick={() =>
                    act('approve_medal', {
                      ref: recommendation.ref,
                      medal_type: recommendationMedalTypes[index],
                    })
                  }
                />
                <Button
                  icon="x"
                  color="red"
                  onClick={() => act('deny_medal', { ref: recommendation.ref })}
                />
              </Stack.Item>
            </Stack>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
