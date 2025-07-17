import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  DmIcon,
  NumberInput,
  Section,
  Stack,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Receipt = {
  id: number;
  title: string;
  singular_name: string;
  req_amount: number;
  is_multi: boolean;
  maximum_to_build: number;
  can_build: boolean;
  amount_to_build: number;
  empty_line_next: boolean;
  icon?: string;
  icon_state?: string;
};

type StackData = {
  stack_receipts: Receipt[];
  stack_name: string;
  stack_amount: number;
};

export const StackReceipts = () => {
  const { act, data } = useBackend<StackData>();
  const { stack_amount, stack_name } = data;

  const [localReceipts, setLocalReceipts] = useState(() =>
    data.stack_receipts.map((r) => ({ ...r })),
  );

  return (
    <Window width={440} height={500}>
      <Window.Content>
        <Section fill scrollable>
          <Stack fill vertical>
            <Box>
              <h1>Construction using the {stack_name}</h1>
              Amount left: {stack_amount}
              <hr />
            </Box>
            <Box width="100%">
              {localReceipts.length > 0 &&
                localReceipts.map((receipt, index) => (
                  <Stack key={index} justify="space-between">
                    <Stack.Item width="100%">
                      {receipt.empty_line_next ? <hr /> : ''}
                      {receipt.icon && receipt.icon_state ? (
                        <DmIcon
                          icon={receipt.icon}
                          icon_state={receipt.icon_state}
                          height="32px"
                          width="32px"
                          style={{ position: 'relative', top: '6px' }}
                        />
                      ) : (
                        ''
                      )}
                      <Button
                        disabled={
                          !(
                            receipt.can_build &&
                            stack_amount >= receipt.req_amount
                          )
                        }
                        onClick={() =>
                          act('make', {
                            multiplier: 1,
                            id: receipt.id,
                          })
                        }
                      >
                        {receipt.title}
                        {` (${receipt.req_amount} ${receipt.singular_name}${receipt.req_amount > 1 ? 's' : ''})`}
                      </Button>
                      {receipt.is_multi && receipt.req_amount < stack_amount ? (
                        <>
                          {' |'}
                          <NumberInput
                            value={receipt.amount_to_build}
                            maxValue={Math.min(
                              20,
                              Math.floor(stack_amount / receipt.req_amount),
                            )}
                            minValue={1}
                            step={1}
                            stepPixelSize={3}
                            width="30px"
                            onChange={(value) => {
                              const updated = [...localReceipts];
                              updated[index] = {
                                ...updated[index],
                                amount_to_build: value,
                              };
                              setLocalReceipts(updated);
                            }}
                          />
                          <Button
                            onClick={() =>
                              act('make', {
                                multiplier: receipt.amount_to_build,
                                id: receipt.id,
                              })
                            }
                          >
                            x
                          </Button>
                        </>
                      ) : (
                        ''
                      )}
                    </Stack.Item>
                  </Stack>
                ))}

              <hr />
            </Box>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
