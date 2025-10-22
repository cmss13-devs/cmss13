import { classes } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, NoticeBox, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  recommendations: {
    rank: string;
    name: string;
    ref: string;
    recommender_name: string;
    reason: string;
    recommender_rank: String;
  }[];
};

export const IcMedalsPanel = (props) => {
  const { act, data } = useBackend<Data>();

  const COMMENDATION_RIBBON = 'ribbon of commendation';
  const LEADERSHIP_RIBBON = 'distinguished leadership ribbon';
  const PROFICIENCY_RIBBON = 'technical proficiency ribbon';
  const PURPLE_HEART_MEDAL = 'purple heart medal';
  const VALOR_MEDAL = 'medal of valor';
  const SILVER_STAR_MEDAL = 'silver star medal';
  const GAL_CROSS_MEDAL = 'galactic cross medal';

  const [recommendationMedalTypes, setRecommendationMedalTypes] = useState<
    string[]
  >([]);

  return (
    <Window width={600} height={400} theme={'ntos'}>
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
                        tooltip="Ribbon of Commendation"
                        color={
                          recommendationMedalTypes[index] ===
                          COMMENDATION_RIBBON
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = COMMENDATION_RIBBON;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            COMMENDATION_RIBBON.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                    <Flex.Item>
                      <Button
                        tooltip="Distinguished Leadership Ribbon"
                        color={
                          recommendationMedalTypes[index] === LEADERSHIP_RIBBON
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = LEADERSHIP_RIBBON;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            LEADERSHIP_RIBBON.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                    <Flex.Item>
                      <Button
                        tooltip="Technical Proficiency Ribbon"
                        color={
                          recommendationMedalTypes[index] === PROFICIENCY_RIBBON
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = PROFICIENCY_RIBBON;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            PROFICIENCY_RIBBON.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                  </Flex>
                  <Flex direction="column">
                    <Flex.Item>
                      <Button
                        tooltip="Purple Heart Medal"
                        color={
                          recommendationMedalTypes[index] === PURPLE_HEART_MEDAL
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = PURPLE_HEART_MEDAL;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            PURPLE_HEART_MEDAL.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                    <Flex.Item>
                      <Button
                        tooltip="Silver Star Medal"
                        color={
                          recommendationMedalTypes[index] === SILVER_STAR_MEDAL
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = SILVER_STAR_MEDAL;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            SILVER_STAR_MEDAL.replace(/ /g, '-'),
                            'medal-icon',
                          ])}
                        />
                      </Button>
                    </Flex.Item>
                  </Flex>
                  <Flex direction="column">
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
                    <Flex.Item>
                      <Button
                        tooltip="Galactic Cross Medal"
                        color={
                          recommendationMedalTypes[index] === GAL_CROSS_MEDAL
                            ? 'green'
                            : ''
                        }
                        onClick={() => {
                          const new_array = [...recommendationMedalTypes];
                          new_array[index] = GAL_CROSS_MEDAL;
                          setRecommendationMedalTypes(new_array);
                        }}
                      >
                        <span
                          className={classes([
                            'medal32x32',
                            GAL_CROSS_MEDAL.replace(/ /g, '-'),
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
