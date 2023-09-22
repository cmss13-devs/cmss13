import { useBackend } from '../backend';
import { Box, Button, Divider, Section, Stack, Tabs, Collapsible } from '../components';
import { Window } from '../layouts';

type Tutorial = {
  name: string;
  path: string;
  id: string;
};

type TutorialCategory = {
  tutorials: Tutorial[];
  name: string;
};

type BackendContext = {
  tutorial_categories: TutorialCategory[];
  completed_tutorials: string[];
};

const TutList = (props, context) => {
  const { data, act } = useBackend<BackendContext>(context);
  const { tutorial_categories, completed_tutorials } = data;
  return (
    <Stack fill vertical>
      <Stack.Item>
        <div
          style={{
            'display': 'flex',
            'align-content': 'center',
            'flex-wrap': 'wrap',
          }}>
          {tutorial_categories.map((category) => (
            <div style={{ 'width': '100%' }}>
              <Collapsible title={category.name} open>
                {category.tutorials.map((tutorial) => (
                  <>
                    <div style={{ 'padding': '2px' }} />
                    <Button
                      content={tutorial.name}
                      color={completed_tutorials.indexOf(tutorial.id) === -1 ? "green" : "default"}
                      onClick={() =>
                        act('select_tutorial', {
                          tutorial_path: tutorial.path,
                        })
                      }
                    />
                  </>
                ))}
              </Collapsible>
              <div style={{ 'padding': '8px' }} />
            </div>
          ))}
        </div>
      </Stack.Item>
    </Stack>
  );
};

export const TutorialList = (props, context) => {
  return (
    <Window width={300} height={400} title="Tutorial List">
      <Window.Content>
        <TutList />
      </Window.Content>
    </Window>
  );
};
