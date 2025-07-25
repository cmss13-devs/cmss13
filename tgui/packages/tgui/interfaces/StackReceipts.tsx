import { useEffect, useRef, useState } from 'react';
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
  req_amount?: number;
  is_multi?: boolean;
  maximum_to_build?: number;
  can_build?: boolean;
  amount_to_build?: number;
  empty_line_next: boolean;
  icon?: string;
  icon_state?: string;
  stack_sub_receipts?: Receipt[];
};

type StackData = {
  stack_receipts: Receipt[];
  stack_name: string;
  stack_amount: number;
  singular_name: string;
};

export const StackReceipts = () => {
  const { act, data } = useBackend<StackData>();
  const scrollRef = useRef<HTMLDivElement>(null);
  const { stack_amount, stack_name } = data;

  const [receiptStack, setReceiptStack] = useState<Receipt[][]>([
    data.stack_receipts.map((r) => ({ ...r })),
  ]);

  const currentReceipts = receiptStack[receiptStack.length - 1];

  const pluralize = (count: number, singular: string) =>
    count === 1 ? singular : `${singular}s`;

  const handleBuildClick = (receipt: Receipt, multiplier: number) => {
    act('make', {
      multiplier,
      id: receipt.id,
    });
  };

  useEffect(() => {
    const updated = receiptStack[receiptStack.length - 1].map((receipt) => {
      const req = receipt.req_amount ?? 1;
      const maxAllowed = Math.min(20, Math.floor(stack_amount / req));
      const clampedAmount = Math.max(
        1,
        Math.min(receipt.amount_to_build ?? 1, maxAllowed),
      );

      return {
        ...receipt,
        amount_to_build: clampedAmount,
      };
    });

    setReceiptStack((prev) => {
      const last = prev[prev.length - 1];
      const changed = last.some(
        (r, i) => r.amount_to_build !== updated[i].amount_to_build,
      );

      if (!changed) return prev;

      const newStack = [...prev];
      newStack[newStack.length - 1] = updated;
      return newStack;
    });
  }, [stack_amount, receiptStack.length]);

  return (
    <Window width={440} height={500}>
      <Window.Content className="StackReceipts">
        <Section
          ref={scrollRef}
          fill
          scrollable
          title={
            <>
              <Box>Construction using the {stack_name}</Box>
              <small style={{ fontWeight: 'normal' }}>
                Amount left: {stack_amount}
              </small>
            </>
          }
        >
          <Stack fill vertical>
            <Box width="100%">
              {currentReceipts.length > 0 &&
                currentReceipts.map((receipt, index) => (
                  <Stack key={index} justify="space-between">
                    <Stack.Item width="100%" style={{ whiteSpace: 'nowrap' }}>
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
                      {receipt.stack_sub_receipts ? (
                        <Box style={{ marginTop: '16px' }}>
                          <Button
                            className="StackButton"
                            left="40px"
                            onClick={() => {
                              setReceiptStack((prev) => [
                                ...prev,
                                receipt.stack_sub_receipts!,
                              ]);
                              scrollRef.current?.scrollTo({
                                top: 0,
                                behavior: 'smooth',
                              });
                            }}
                          >
                            {receipt.title}
                          </Button>
                        </Box>
                      ) : (
                        <>
                          {receipt.icon && receipt.icon_state ? (
                            <DmIcon
                              icon={receipt.icon}
                              icon_state={receipt.icon_state}
                              height="32px"
                              width="32px"
                              style={{
                                position: 'relative',
                                top: '6px',
                                whiteSpace: 'nowrap',
                              }}
                            />
                          ) : (
                            ''
                          )}
                          <Button
                            className="StackButton"
                            left="8px"
                            disabled={
                              !(
                                receipt.can_build &&
                                stack_amount >= (receipt.req_amount ?? 0)
                              )
                            }
                            onClick={() => {
                              handleBuildClick(receipt, 1);
                            }}
                          >
                            {receipt.title}
                            {` (${receipt.req_amount} ${pluralize(receipt.req_amount ?? 0, data.singular_name)})`}
                          </Button>
                          {receipt.is_multi &&
                          (receipt.req_amount ?? 0) < stack_amount ? (
                            <span style={{ marginLeft: '8px' }}>
                              {' |'}
                              <NumberInput
                                tabbed
                                className="StackNumberInput"
                                value={receipt.amount_to_build ?? 1}
                                maxValue={Math.min(
                                  20,
                                  Math.floor(
                                    stack_amount / (receipt.req_amount ?? 1),
                                  ),
                                )}
                                minValue={1}
                                step={1}
                                stepPixelSize={3}
                                width="30px"
                                onChange={(value) => {
                                  setReceiptStack((prev) => {
                                    const newStack = [...prev];
                                    const lastLevel = [
                                      ...newStack[newStack.length - 1],
                                    ];
                                    lastLevel[index] = {
                                      ...lastLevel[index],
                                      amount_to_build: value,
                                    };
                                    newStack[newStack.length - 1] = lastLevel;
                                    return newStack;
                                  });
                                }}
                              />
                              <Button
                                onClick={() => {
                                  handleBuildClick(
                                    receipt,
                                    receipt.amount_to_build ?? 0,
                                  );
                                }}
                                className="StackButton"
                              >
                                x
                              </Button>
                            </span>
                          ) : (
                            ''
                          )}
                        </>
                      )}
                    </Stack.Item>
                  </Stack>
                ))}

              {receiptStack.length > 1 && (
                <Box width="100%" style={{ marginTop: '10px' }}>
                  <Button
                    className="StackButton"
                    onClick={() => {
                      setReceiptStack((prev) => prev.slice(0, -1));
                      scrollRef.current?.scrollTo({
                        top: 0,
                        behavior: 'smooth',
                      });
                    }}
                  >
                    Back
                  </Button>
                </Box>
              )}
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
