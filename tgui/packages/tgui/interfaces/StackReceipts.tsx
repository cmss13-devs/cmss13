import { classes } from 'common/react';
import { Fragment, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, NumberInput, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Receipt = {
  id: number;
  title: string;
  req_amount?: number;
  res_amount?: number;
  is_multi?: boolean;
  maximum_to_build?: number;
  can_build?: boolean;
  amount_to_build?: number;
  empty_line_next: boolean;
  image?: string;
  image_size?: string;
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
  const [cycleIndex, setCycleIndex] = useState(0);

  const currentReceipts = receiptStack[receiptStack.length - 1];

  const pluralize = (count: number, singular: string) =>
    count === 1 ? singular : `${singular}s`;

  const getNotOne = (count: number) => (count === 1 ? '' : `${count} `);

  const handleBuildClick = (receipt: Receipt, multiplier: number) => {
    act('make', {
      multiplier,
      id: receipt.id,
    });
  };

  const updateAmounts = () => {
    const updated = currentReceipts.map((receipt) => {
      const req = receipt.req_amount ?? 1;
      const maxAllowed = Math.min(20, Math.floor(stack_amount / req));
      const clampedAmount = Math.max(
        1,
        Math.min(receipt.amount_to_build ?? 1, maxAllowed),
      );
      return { ...receipt, amount_to_build: clampedAmount };
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
  };

  useEffect(updateAmounts, [stack_amount, receiptStack.length]);

  useEffect(() => {
    // Used to cycle through sub-receipts icons
    const interval = setInterval(() => {
      setCycleIndex((prev) => (prev + 1) % 999);
    }, 1500); // Every 1.5 seconds
    return () => clearInterval(interval);
  }, []);

  const renderIcon = (image?: string, image_size?: string) =>
    image && image_size ? (
      <span
        className={classes([
          `Icon`,
          `stack-receipts${image_size ? image_size : `32x32`}`,
          `${image}`,
        ])}
        style={{
          position: 'relative',
          marginRight: '2px',
        }}
      />
    ) : (
      ''
    );

  const renderReceipt = (receipt: Receipt, index: number) => {
    let materialAmount = receipt.req_amount ?? 1;

    if (receipt.is_multi) {
      materialAmount = (receipt.amount_to_build ?? 1) * materialAmount;
    }

    return (
      <Fragment key={index}>
        {receipt.empty_line_next ? (
          <hr className="HrLine" color="#4972a2" />
        ) : (
          ''
        )}
        <Stack justify="space-between">
          <Stack.Item
            width="100%"
            style={{
              whiteSpace: 'nowrap',
            }}
          >
            {receipt.stack_sub_receipts ? (
              <>
                {renderIcon(
                  receipt.stack_sub_receipts?.[
                    cycleIndex % receipt.stack_sub_receipts.length
                  ]?.image,
                  receipt.stack_sub_receipts?.[
                    cycleIndex % receipt.stack_sub_receipts.length
                  ]?.image_size,
                )}
                <Button
                  className="StackButton"
                  onClick={() => {
                    setReceiptStack((prev) => [
                      ...prev,
                      receipt.stack_sub_receipts!,
                    ]);
                    scrollRef.current?.scrollTo({ top: 0, behavior: 'smooth' });
                  }}
                >
                  {receipt.title}
                </Button>
              </>
            ) : (
              <>
                {renderIcon(receipt.image, receipt.image_size)}
                <Button
                  className="StackButton"
                  disabled={
                    !(
                      receipt.can_build &&
                      stack_amount >= (receipt.req_amount ?? 1)
                    )
                  }
                  onClick={() => {
                    handleBuildClick(receipt, receipt.amount_to_build ?? 1);
                  }}
                >
                  {pluralize(receipt.res_amount ?? 1, receipt.title)}
                  {` (${materialAmount} ${pluralize(
                    materialAmount,
                    data.singular_name,
                  )})`}
                </Button>
                {receipt.is_multi &&
                (receipt.req_amount ?? 1) < stack_amount ? (
                  <span style={{ marginLeft: '8px' }}>
                    {' '}
                    <NumberInput
                      tabbed
                      className="StackNumberInput"
                      value={receipt.amount_to_build ?? 1}
                      maxValue={Math.min(
                        20,
                        Math.floor(stack_amount / (receipt.req_amount ?? 1)),
                      )}
                      minValue={1}
                      step={1}
                      stepPixelSize={3}
                      width="30px"
                      height="24px"
                      onChange={(value) => {
                        setReceiptStack((prev) => {
                          const newStack = [...prev];
                          const lastLevel = [...newStack[newStack.length - 1]];
                          lastLevel[index] = {
                            ...lastLevel[index],
                            amount_to_build: value,
                          };
                          newStack[newStack.length - 1] = lastLevel;
                          return newStack;
                        });
                      }}
                    />
                  </span>
                ) : (
                  ''
                )}
              </>
            )}
          </Stack.Item>
        </Stack>
      </Fragment>
    );
  };

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
                currentReceipts.map((receipt, index) =>
                  renderReceipt(receipt, index),
                )}

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
              <hr className="HrLine" color="#4972a2" />
            </Box>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
