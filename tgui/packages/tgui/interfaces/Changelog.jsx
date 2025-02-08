import { classes } from 'common/react';
import dateformat from 'dateformat';
import yaml from 'js-yaml';
import { Component, Fragment } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Section,
  Stack,
  Table,
  Tooltip,
} from '../components';
import { Window } from '../layouts';

const changeTypes = {
  bugfix: { icon: 'bug', color: 'green', desc: 'Fix' },
  fix: { icon: 'bug', color: 'green', desc: 'Fix' },
  wip: { icon: 'hammer', color: 'orange', desc: 'WIP' },
  qol: { icon: 'hand-holding-heart', color: 'green', desc: 'QOL' },
  soundadd: { icon: 'tg-sound-plus', color: 'green', desc: 'Sound add' },
  sounddel: { icon: 'tg-sound-minus', color: 'red', desc: 'Sound del' },
  add: { icon: 'check-circle', color: 'green', desc: 'Addition' },
  expansion: { icon: 'check-circle', color: 'green', desc: 'Addition' },
  rscadd: { icon: 'check-circle', color: 'green', desc: 'Addition' },
  rscdel: { icon: 'times-circle', color: 'red', desc: 'Removal' },
  imageadd: { icon: 'tg-image-plus', color: 'green', desc: 'Sprite add' },
  imagedel: { icon: 'tg-image-minus', color: 'red', desc: 'Sprite del' },
  spellcheck: { icon: 'spell-check', color: 'green', desc: 'Spellcheck' },
  experiment: { icon: 'radiation', color: 'yellow', desc: 'Experiment' },
  balance: { icon: 'balance-scale-right', color: 'yellow', desc: 'Balance' },
  code_imp: { icon: 'code', color: 'green', desc: 'Code improvement' },
  refactor: { icon: 'tools', color: 'green', desc: 'Code refactor' },
  config: { icon: 'cogs', color: 'purple', desc: 'Config' },
  admin: { icon: 'user-shield', color: 'purple', desc: 'Admin' },
  server: { icon: 'server', color: 'purple', desc: 'Server' },
  tgs: { icon: 'toolbox', color: 'purple', desc: 'Server (TGS)' },
  tweak: { icon: 'wrench', color: 'green', desc: 'Tweak' },
  ui: { icon: 'desktop', color: 'blue', desc: 'UI' },
  mapadd: { icon: 'earth-africa', color: 'yellow', desc: 'Map add' },
  maptweak: { icon: 'map-location-dot', color: 'green', desc: 'Map tweak' },
  unknown: { icon: 'info-circle', color: 'label', desc: 'Unknown' },
};

export class Changelog extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: 'Loading changelog data...',
      selectedDate: '',
      selectedIndex: 0,
    };
    this.dateChoices = [];
  }

  setData(data) {
    this.setState({ data });
  }

  setSelectedDate(selectedDate) {
    this.setState({ selectedDate });
  }

  setSelectedIndex(selectedIndex) {
    this.setState({ selectedIndex });
  }

  getData = (date, attemptNumber = 1) => {
    const { act } = useBackend();
    const self = this;
    const maxAttempts = 6;

    if (attemptNumber > maxAttempts) {
      return this.setData(
        'Failed to load data after ' + maxAttempts + ' attempts',
      );
    }

    act('get_month', { date });

    fetch(resolveAsset(date + '.yml')).then(async (changelogData) => {
      const result = await changelogData.text();
      const errorRegex = /^Cannot find/;

      if (errorRegex.test(result)) {
        const timeout = 50 + attemptNumber * 50;

        self.setData('Loading changelog data' + '.'.repeat(attemptNumber + 3));
        setTimeout(() => {
          self.getData(date, attemptNumber + 1);
        }, timeout);
      } else {
        self.setData(yaml.load(result, { schema: yaml.CORE_SCHEMA }));
      }
    });
  };

  componentDidMount() {
    const {
      data: { dates = [] },
    } = useBackend();

    if (dates) {
      dates.forEach((date) =>
        this.dateChoices.push(dateformat(date, 'mmmm yyyy', true)),
      );
      this.setSelectedDate(this.dateChoices[0]);
      this.getData(dates[0]);
    }
  }

  render() {
    const { data, selectedDate, selectedIndex } = this.state;
    const {
      data: { dates },
    } = useBackend();
    const { dateChoices } = this;

    const dateDropdown = dateChoices.length > 0 && (
      <Stack mb={1}>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === 0}
            icon={'chevron-left'}
            onClick={() => {
              const index = selectedIndex - 1;

              this.setData('Loading changelog data...');
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
        <Stack.Item>
          <Dropdown
            displayText={selectedDate}
            options={dateChoices}
            onSelected={(value) => {
              const index = dateChoices.indexOf(value);

              this.setData('Loading changelog data...');
              this.setSelectedIndex(index);
              this.setSelectedDate(value);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
            selected={selectedDate}
            width="150px"
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            className="Changelog__Button"
            disabled={selectedIndex === dateChoices.length - 1}
            icon={'chevron-right'}
            onClick={() => {
              const index = selectedIndex + 1;

              this.setData('Loading changelog data...');
              this.setSelectedIndex(index);
              this.setSelectedDate(dateChoices[index]);
              window.scrollTo(
                0,
                document.body.scrollHeight ||
                  document.documentElement.scrollHeight,
              );
              return this.getData(dates[index]);
            }}
          />
        </Stack.Item>
      </Stack>
    );

    const header = (
      <Section>
        <h1>Colonial Marines Space Station 13</h1>
        <p>
          <b>Thanks to: </b>
          Baystation 12, /tg/station, /vg/station, NTstation, CDK Station devs,
          FacepunchStation, GoonStation devs, the original Space Station 13
          developers, Invisty for the title image and the countless others who
          have contributed to the game, issue tracker or wiki over the years.
        </p>
        <p>
          {'Current project maintainers can be found '}
          <a href="https://github.com/orgs/cmss13-devs/people">here</a>
          {', recent GitHub contributors can be found '}
          <a href="https://github.com/cmss13-devs/cmss13/pulse/monthly">here</a>
          .
        </p>
        <p>
          {'You can also join our discord '}
          <a href="https://discord.gg/cmss13">here</a>.
        </p>
        {dateDropdown}
      </Section>
    );

    const footer = (
      <Section>
        {dateDropdown}
        <h3>CM 13 Development Team</h3>
        <h3>Colonial Marines Space Station 13 License</h3>
        <p>
          {'All code after '}
          <a
            href={
              'https://github.com/cmss13-devs/cmss13/commit/' +
              '9a001bf520f889b434acd295253a1052420860af'
            }
          >
            commit 9a001bf520f889b434acd295253a1052420860af on 2020/14/9
          </a>
          {' is licensed under '}
          <a href="https://www.gnu.org/licenses/agpl-3.0.html">GNU AGPL v3</a>
          {'. All code before that commit is licensed under '}
          <a href="https://www.gnu.org/licenses/gpl-3.0.html">GNU GPL v3</a>
          {', including tools unless their readme specifies otherwise. See '}
          <a href="https://github.com/cmss13-devs/cmss13/blob/master/LICENSE">
            LICENSE
          </a>
          {' and '}
          <a href="https://github.com/cmss13-devs/cmss13/blob/master/LICENSE-GPL3">
            GPLv3.txt
          </a>
          {' for more details.'}
        </p>
        <p>
          The TGS DMAPI API is licensed as a subproject under the MIT license.
          {' See the footer of '}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/__DEFINES/tgs.dm'
            }
          >
            code/__DEFINES/tgs.dm
          </a>
          {' and '}
          <a
            href={
              'https://github.com/tgstation/tgstation/blob/master' +
              '/code/modules/tgs/LICENSE'
            }
          >
            code/modules/tgs/LICENSE
          </a>
          {' for the MIT license.'}
        </p>
        <p>
          {'All assets including icons and sound are under a '}
          <a href="https://creativecommons.org/licenses/by-sa/3.0/">
            Creative Commons 3.0 BY-SA license
          </a>
          {' unless otherwise indicated.'}
        </p>
      </Section>
    );

    const changes =
      typeof data === 'object' &&
      Object.keys(data).length > 0 &&
      Object.entries(data)
        .reverse()
        .map(([date, authors]) => (
          <Section key={date} title={dateformat(date, 'd mmmm yyyy', true)}>
            <Box ml={3}>
              {Object.entries(authors).map(([name, changes]) => (
                <Fragment key={name}>
                  <h4>{name} changed:</h4>
                  <Box ml={3}>
                    <Table>
                      {changes.map((change) => {
                        const changeKey = Object.keys(change)[0];
                        const changeType =
                          changeTypes[changeKey] || changeTypes['unknown'];
                        return (
                          <Table.Row key={changeKey + change[changeKey]}>
                            <Table.Cell
                              className={classes([
                                'Changelog__Cell',
                                'Changelog__Cell--Icon',
                              ])}
                            >
                              <Tooltip
                                position="right"
                                content={changeType.desc}
                              >
                                <Icon
                                  color={changeType.color}
                                  name={changeType.icon}
                                />
                              </Tooltip>
                            </Table.Cell>
                            <Table.Cell className="Changelog__Cell">
                              {change[changeKey]}
                            </Table.Cell>
                          </Table.Row>
                        );
                      })}
                    </Table>
                  </Box>
                </Fragment>
              ))}
            </Box>
          </Section>
        ));

    return (
      <Window title="Changelog" width={675} height={650}>
        <Window.Content scrollable>
          {header}
          {changes}
          {typeof data === 'string' && <p>{data}</p>}
          {footer}
        </Window.Content>
      </Window>
    );
  }
}
