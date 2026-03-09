import { classes } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Dropdown,
  Flex,
  NoticeBox,
  Section,
  Stack,
} from 'tgui/components';
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
  medal_types: {
    name: string;
    description: string;
    icon: string;
  }[];
  medal_names: string[];
};

export const IcMedalsPanel = (props) => {
  const { act, data } = useBackend<Data>();

  const medalOptions = data.medal_names;
  const medalTypes = data.medal_types;

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
            onClick={() => act('recommend_new_medal')}
          >
            New Medal Creation
          </Button>
        </NoticeBox>
        {data.recommendations.map((recommendation, index) => (
          <Section
            key={index}
            title={recommendation.name + ' (' + recommendation.rank + ')'}
          >
            <Stack textAlign="left">
              <Stack.Item grow>
                <Dropdown
                  width="auto"
                  selected={recommendationMedalTypes[index]}
                  options={medalOptions}
                  onSelected={(picked) => {
                    const new_array = [...recommendationMedalTypes];
                    new_array[index] = picked;
                    setRecommendationMedalTypes(new_array);
                  }}
                />
              </Stack.Item>
              <Stack.Item>
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
                >
                  Approve
                </Button>
                <Button
                  icon="x"
                  color="red"
                  onClick={() => act('deny_medal', { ref: recommendation.ref })}
                >
                  Refuse
                </Button>
              </Stack.Item>
            </Stack>
            {recommendationMedalTypes[index] && (
              <Section title={recommendationMedalTypes[index]}>
                <Flex direction="row">
                  <Flex.Item grow>
                    <Button tooltip={recommendationMedalTypes[index]} mr="10px">
                      <span
                        className={classes([
                          'medal32x32',
                          medalTypes[
                            recommendationMedalTypes[index]
                          ].name.replace(/ /g, '-'),
                          'medal-icon',
                        ])}
                      />
                    </Button>
                  </Flex.Item>
                  <Flex.Item>
                    {medalTypes[recommendationMedalTypes[index]].description}
                  </Flex.Item>
                </Flex>
              </Section>
            )}
            <Section
              title={
                'Recommender: ' +
                recommendation.recommender_name +
                ' (' +
                recommendation.recommender_rank +
                ')'
              }
            >
              <Stack.Item grow textAlign={'center'}>
                {recommendation.reason}
              </Stack.Item>
            </Section>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
