/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { Input, LabeledList, Section } from '../components';

export const meta = {
  title: 'Themes',
  render: (theme, setTheme) => <Story theme={theme} setTheme={setTheme} />,
};

const Story = (props) => {
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Use theme">
          <Input
            placeholder="theme_name"
            value={props.theme}
            onInput={(e, value) => props.setTheme(value)}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
