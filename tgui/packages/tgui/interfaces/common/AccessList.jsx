import { sortBy } from 'common/collections';
import { useState } from 'react';

import { Button, Section, Stack, Tabs } from '../../components';

const diffMap = {
  0: {
    icon: 'times-circle',
    color: 'bad',
  },
  1: {
    icon: 'stop-circle',
    color: null,
  },
  2: {
    icon: 'check-circle',
    color: 'good',
  },
};

export const AccessList = (props) => {
  const {
    accesses = [],
    selectedList = [],
    accessMod,
    grantAll,
    denyAll,
    grantDep,
    denyDep,
  } = props;
  const [selectedAccessName, setSelectedAccessName] = useState(
    accesses[0]?.name,
  );
  const selectedAccess = accesses.find(
    (access) => access.name === selectedAccessName,
  );
  const selectedAccessEntries = sortBy(
    selectedAccess?.accesses || [],
    (entry) => entry.desc,
  );

  const checkAccessIcon = (accesses) => {
    let oneAccess = false;
    let oneInaccess = false;
    for (let element of accesses) {
      if (selectedList.includes(element.ref)) {
        oneAccess = true;
      } else {
        oneInaccess = true;
      }
    }
    if (!oneAccess && oneInaccess) {
      return 0;
    } else if (oneAccess && oneInaccess) {
      return 1;
    } else {
      return 2;
    }
  };

  return (
    <Section
      title="Access"
      buttons={
        <>
          <Button icon="check-double" color="good" onClick={() => grantAll()}>
            Grant All
          </Button>
          <Button icon="undo" color="bad" onClick={() => denyAll()}>
            Deny All
          </Button>
        </>
      }
    >
      <Stack>
        <Stack.Item>
          <Tabs vertical>
            {accesses.map((access) => {
              const entries = access.accesses || [];
              const icon = diffMap[checkAccessIcon(entries)].icon;
              const color = diffMap[checkAccessIcon(entries)].color;
              return (
                <Tabs.Tab
                  key={access.name}
                  altSelection
                  color={color}
                  icon={icon}
                  selected={access.name === selectedAccessName}
                  onClick={() => setSelectedAccessName(access.name)}
                >
                  {access.name}
                </Tabs.Tab>
              );
            })}
          </Tabs>
        </Stack.Item>
        <Stack.Item grow>
          <Stack>
            <Stack.Item>
              <Button
                fluid
                icon="check"
                color="good"
                onClick={() => grantDep(selectedAccess.regid)}
              >
                Grant Region
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="times"
                color="bad"
                onClick={() => denyDep(selectedAccess.regid)}
              >
                Deny Region
              </Button>
            </Stack.Item>
          </Stack>
          <Stack vertical mt={1}>
            {selectedAccessEntries.map((entry) => (
              <Stack.Item key={entry.desc}>
                <Button.Checkbox
                  fluid
                  checked={selectedList.includes(entry.ref)}
                  onClick={() => accessMod(entry.ref)}
                >
                  {entry.desc}
                </Button.Checkbox>
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
