import { KEY } from 'common/keys';
import type { BooleanLike } from 'common/react';
import { useBackend } from 'tgui/backend';
import {
  Autofocus,
  Box,
  Button,
  Collapsible,
  Divider,
  Icon,
  Image,
  Section,
  Stack,
  Tooltip,
} from 'tgui/components';
import { DAMAGE_COLORS } from 'tgui/constants';
import { Window } from 'tgui/layouts';

const valueColors = {
  ...DAMAGE_COLORS,
  shield: 'purple',
  health: 'teal',
  plasma: 'teal',
  crowd_control: '#ff8c42',
} as const;

type DescriptionPart =
  | string
  | {
      text: string;
      kind: keyof typeof valueColors | null;
    };

function AbilityDescription(props: {
  readonly description: string | DescriptionPart[] | null;
}) {
  const { description } = props;
  if (!Array.isArray(description)) {
    return description;
  }
  return (
    <Box inline>
      {description.map((part, index) =>
        typeof part === 'string' ? (
          part
        ) : (
          <Box
            key={index}
            inline
            bold
            color={part.kind ? valueColors[part.kind] : undefined}
          >
            {part.text}
          </Box>
        ),
      )}
    </Box>
  );
}

type AbilityStat = {
  label: string;
  parts: DescriptionPart[];
};

type Ability = {
  name: string;
  description: string | null;
  stats: AbilityStat[];
  costs: AbilityStat[];
  icon: string;
};

function AbilityTooltip(props: { readonly ability: Ability }) {
  const { description, stats = [], costs = [] } = props.ability;
  const rows = [...costs, ...stats];
  return (
    <>
      {description && <Box>{description}</Box>}
      {description && rows.length > 0 && <Divider />}
      {rows.map((row, index) => (
        <Box key={index}>
          {row.label}: <AbilityDescription description={row.parts} />
        </Box>
      ))}
    </>
  );
}

type Data = {
  currentCaste?: BooleanLike;
  windowTitle?: string;
  notice?: string;
  name: string;
  caste: string;
  summary: string;
  tackleMin: number;
  canTackle: BooleanLike;
  tackleMax: number;
  flavor: string | null;
  stats: StatChange[];
  showCurrentStats: BooleanLike;
  resources: Resource[];
  description?: string;
  portrait: string;
  gained: Ability[];
  lost: Ability[];
  buttons: string[];
};

type StatChange = {
  name: string;
  icon: string;
  amount: number;
  chevrons: number;
  current: number | string;
};

type Resource = {
  name: string;
  icon: string;
  before: number;
  after: number;
  current?: number | null;
  description: string | null;
};

function Resources(props: { readonly resources: Resource[] }) {
  return (
    <Section title="Resources">
      {props.resources.map((resource) => (
        <Stack key={resource.name} align="center" my={0.5}>
          <Stack.Item>
            <Image src={resource.icon} fixErrors width="32px" height="32px" />
          </Stack.Item>
          <Stack.Item grow>
            <Box bold>{resource.name}</Box>
            {resource.description && <Box>{resource.description}</Box>}
          </Stack.Item>
          <Stack.Item nowrap>
            {resource.before !== resource.after && (
              <>
                {resource.before}{' '}
                <Icon
                  name={
                    resource.after > resource.before
                      ? 'chevron-up'
                      : 'chevron-down'
                  }
                  color={
                    resource.after > resource.before ? '#76bf83' : '#e07778'
                  }
                />{' '}
              </>
            )}
            <b>
              {typeof resource.current === 'number' && `${resource.current} / `}
              {resource.after}
            </b>
          </Stack.Item>
        </Stack>
      ))}
    </Section>
  );
}

function StatChanges(props: {
  readonly stats: StatChange[];
  readonly showCurrent: BooleanLike;
}) {
  if (!props.stats.length) {
    return null;
  }
  return (
    <Section title={props.showCurrent ? 'Current stats' : 'Base stat changes'}>
      <Stack>
        {props.stats.map((stat) => (
          <Stack.Item key={stat.name} grow basis={0}>
            <Stack align="center">
              <Image src={stat.icon} fixErrors width="32px" height="32px" />
              <Stack.Item>
                <Box>{stat.name}</Box>
                {!!props.showCurrent && <Box bold>{stat.current}</Box>}
                {!!stat.amount && (
                  <Box color={stat.amount > 0 ? '#76bf83' : '#e07778'} bold>
                    <span
                      className="StrainPreview__chevrons"
                      aria-hidden="true"
                    >
                      {Array.from({ length: stat.chevrons }, (_, i) => (
                        <Icon
                          key={i}
                          name={stat.amount > 0 ? 'chevron-up' : 'chevron-down'}
                        />
                      ))}
                    </span>
                    {stat.amount > 0 ? '+' : ''}
                    {stat.amount}
                  </Box>
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
}

function AbilityGroup(props: {
  readonly title: string;
  readonly color: string;
  readonly abilities: Ability[];
}) {
  const { title, color, abilities } = props;
  return (
    <Section title={title}>
      {abilities.length === 0 && <Box color="label">None</Box>}
      <div className="StrainPreview__abilities">
        {abilities.map((ability) => (
          <Tooltip
            key={ability.name}
            content={<AbilityTooltip ability={ability} />}
          >
            <div className="StrainPreview__ability">
              <Box mb={0.5}>{ability.name}</Box>
              <Image
                src={ability.icon}
                fixErrors
                width="40px"
                height="40px"
                style={{ border: `2px solid ${color}` }}
              />
            </div>
          </Tooltip>
        ))}
      </div>
    </Section>
  );
}

export function XenoStrainPreview() {
  const { act, data } = useBackend<Data>();
  return (
    <Window
      width={580}
      height={540}
      theme="hive_status"
      title={data.windowTitle || 'Strain Information'}
    >
      <Window.Content
        onKeyDown={(event) => {
          if (event.defaultPrevented) {
            return;
          }
          if (event.key === KEY.Enter && data.buttons.length > 0) {
            event.preventDefault();
            act('choose', { choice: data.buttons[0] });
          }
        }}
      >
        <Autofocus />
        <Stack fill vertical>
          <Stack.Item grow overflowY="auto">
            <Section>
              <Stack align="center">
                <Stack.Item>
                  <Image
                    src={data.portrait}
                    fixErrors
                    objectFit="contain"
                    width="96px"
                    height="96px"
                  />
                </Stack.Item>
                <Stack.Item grow>
                  <Box color="label">{data.caste}</Box>
                  <h1>{data.name}</h1>
                  <Box mt={1}>{data.summary}</Box>
                  {!!data.canTackle && (
                    <Tooltip content="The minimum is the first attempt that can knock down the target. The maximum guarantees a knockdown.">
                      <Box mt={1}>
                        <b>Base tackle attempts</b> · Min {data.tackleMin} / Max{' '}
                        {data.tackleMax}
                      </Box>
                    </Tooltip>
                  )}
                </Stack.Item>
              </Stack>
              {data.flavor && (
                <Box mt={1} italic color="#cb9dce">
                  {data.flavor}
                </Box>
              )}
            </Section>
            {data.notice && <Section>{data.notice}</Section>}
            <StatChanges
              stats={data.stats}
              showCurrent={data.showCurrentStats}
            />
            <Resources resources={data.resources} />
            <AbilityGroup
              title={data.currentCaste ? 'Abilities' : 'Abilities gained'}
              color={data.currentCaste ? '#cb9dce' : '#76bf83'}
              abilities={data.gained}
            />
            {!data.currentCaste && (
              <AbilityGroup
                title="Abilities lost"
                color="#e07778"
                abilities={data.lost}
              />
            )}
            {!!data.description && (
              <Collapsible title="Full strain description">
                <Section>
                  <Box preserveWhitespace>{data.description}</Box>
                </Section>
              </Collapsible>
            )}
          </Stack.Item>
          <Stack.Item textAlign="center">
            {data.buttons.map((choice) => (
              <Button
                key={choice}
                color={
                  choice === 'De-Evolve'
                    ? 'bad'
                    : ['Evolve', 'Mutate'].includes(choice)
                      ? 'good'
                      : undefined
                }
                minWidth={8}
                fontSize={1.1}
                px={2}
                py={0.5}
                textAlign="center"
                onClick={() => act('choose', { choice })}
              >
                {choice}
              </Button>
            ))}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
