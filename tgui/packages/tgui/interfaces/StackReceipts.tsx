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
  let { stack_amount, stack_name } = data;

  const [localReceipts, setLocalReceipts] = useState(() =>
    data.stack_receipts.map((r) => ({ ...r })),
  );

  const handleBuildClick = (
    receipt: Receipt,
    index: number,
    multiplier: number,
  ) => {
    const cost = receipt.req_amount * multiplier;
    if (cost > stack_amount) return;

    act('make', {
      multiplier,
      id: receipt.id,
    });

    stack_amount -= cost;

    const updated = localReceipts.map((rec) => {
      const maxAllowed = Math.min(
        20,
        Math.floor(stack_amount / rec.req_amount),
      );
      const clamped = Math.max(1, Math.min(rec.amount_to_build, maxAllowed));
      return {
        ...rec,
        amount_to_build: clamped,
      };
    });

    setLocalReceipts(updated);
  };

  return (
    <Window width={440} height={500}>
      <Window.Content>
        <Section fill scrollable title={'Construction using the ' + stack_name}>
          <Stack fill vertical>
            <Box>
              Amount left: {stack_amount}
              <hr color="#4972a2" />
            </Box>
            <Box width="100%">
              {localReceipts.length > 0 &&
                localReceipts.map((receipt, index) => (
                  <Stack key={index} justify="space-between">
                    <Stack.Item width="100%">
                      {receipt.empty_line_next ? (
                        <hr
                          style={{
                            position: 'relative',
                            top: '6px',
                          }}
                          color="#4972a2"
                        />
                      ) : (
                        ''
                      )}
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
                        left="8px"
                        disabled={
                          !(
                            receipt.can_build &&
                            stack_amount >= receipt.req_amount
                          )
                        }
                        onClick={() => {
                          handleBuildClick(receipt, index, 1);
                        }}
                      >
                        {receipt.title}
                        {` (${receipt.req_amount} ${receipt.singular_name}${receipt.req_amount > 1 ? 's' : ''})`}
                      </Button>
                      {receipt.is_multi && receipt.req_amount < stack_amount ? (
                        <span style={{ marginLeft: '8px' }}>
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
                            onClick={() => {
                              handleBuildClick(
                                receipt,
                                index,
                                receipt.amount_to_build,
                              );
                            }}
                          >
                            x
                          </Button>
                        </span>
                      ) : (
                        ''
                      )}
                    </Stack.Item>
                  </Stack>
                ))}

              <hr
                style={{ position: 'relative', top: '6px' }}
                color="#4972a2"
              />
            </Box>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
