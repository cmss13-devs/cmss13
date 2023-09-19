import { useBackend } from '../backend';
import { Box, Button, Divider, Section, Stack, Tabs, Collapsible } from '../components';
import { Window } from '../layouts';

type Tutorial = {
  name: string;
  path: string;
};

type TutorialCategory = {
  tutorials: Tutorial[];
  name: string;
};

type BackendContext = {
  tutorial_categories: TutorialCategory[];
};

const TutList = (props, context) => {
  const { data, act } = useBackend<BackendContext>(context);
  const { tutorial_categories } = data;
  return (
    <div
      style={{
        'vertical-align': 'middle',
      }}>
      <Stack fill vertical>
        <Stack.Item>
          {tutorial_categories.map((category) => (
            <Collapsible title={category.name} open>
              {category.tutorials.map((tutorial) => (
                <Button
                  content={tutorial.name}
                  onClick={() =>
                    act('select_tutorial', {
                      tutorial_path: tutorial.path,
                    })
                  }
                />
              ))}
            </Collapsible>
          ))}
        </Stack.Item>
      </Stack>
    </div>
  );
};

export const TutorialList = (props, context) => {
  return (
    <Window width={500} height={600} title="Tutorial List">
      <Window.Content>
        <TutList />
      </Window.Content>
    </Window>
  );
};
