import type { BooleanLike } from 'common/react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

type TraitsPickerData = {
  trait_points: number;
  starting_points: number;
  traits: Trait[];
  categories: {
    name: string;
    traits: Trait[];
    mutually_exclusive: BooleanLike;
  }[];
};

type Trait = {
  name: string;
  desc: string;
  cost: number;
  type: string;
};

export const TraitsPicker = () => {
  const { data } = useBackend<TraitsPickerData>();

  const { categories, traits, trait_points, starting_points } = data;

  const [selected, setSelected] = useState(categories[0]);

  const disableAll =
    selected.mutually_exclusive &&
    selected.traits.some((trait) =>
      traits.flatMap((trait) => trait.name).includes(trait.name),
    );

  return (
    <Window width={900} height={545} theme="crtblue">
      <Window.Content>
        <Stack>
          <Stack.Item width="70%">
            <Section
              title={categories.map((category) => (
                <Button
                  key={category.name}
                  selected={selected === category}
                  onClick={() => setSelected(category)}
                >
                  {category.name}
                </Button>
              ))}
              scrollable
              height="490px"
            >
              <Stack vertical height="430px">
                <Stack.Item>
                  <Stack vertical>
                    {selected.traits.map((trait) => (
                      <Stack.Item key={trait.name}>
                        <RenderTrait trait={trait} disabled={!!disableAll} />
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item width="50%">
            <Section
              title={`Added (${starting_points - trait_points}/${starting_points} points)`}
              fill
            >
              <Stack vertical>
                {traits.map((trait) => (
                  <Stack.Item key={trait.name}>
                    <RenderTrait trait={trait} />
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const RenderTrait = (props: {
  readonly trait: Trait;
  readonly disabled?: boolean;
}) => {
  const { trait, disabled } = props;

  const { act, data } = useBackend<TraitsPickerData>();

  const { traits, trait_points } = data;

  const activated = traits.flatMap((trait) => trait.name).includes(trait.name);

  return (
    <Section
      title={trait.name}
      mt={1}
      p={2}
      buttons={
        <Button
          selected={activated}
          onClick={() =>
            act(activated ? 'remove' : 'add', { type: trait.type })
          }
          disabled={
            !activated && ((trait.cost > 0 && trait_points === 0) || disabled)
          }
        >
          {activated ? 'Remove' : 'Add'}
        </Button>
      }
    >
      {trait.desc}
    </Section>
  );
};
