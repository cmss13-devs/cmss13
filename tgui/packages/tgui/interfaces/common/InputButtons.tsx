import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import { Box, Button, Flex } from '../../components';

type InputButtonsData = {
  large_buttons: boolean;
  swapped_buttons: boolean;
};

type InputButtonsProps = {
  readonly input: string | number | string[];
  readonly on_submit?: () => void;
  readonly on_cancel?: () => void;
  readonly message?: string;
  readonly submit_disabled?: BooleanLike;
};

export const InputButtons = (props: InputButtonsProps) => {
  const { act, data } = useBackend<InputButtonsData>();
  const { large_buttons, swapped_buttons } = data;
  const { input, message, on_submit, on_cancel, submit_disabled } = props;

  let on_submit_actual = on_submit;
  if (!on_submit_actual) {
    on_submit_actual = () => {
      if (submit_disabled) {
        return;
      }
      act('submit', { entry: input });
    };
  }

  let on_cancel_actual = on_cancel;
  if (!on_cancel_actual) {
    on_cancel_actual = () => {
      act('cancel');
    };
  }

  const submitButton = (
    <Button
      color="good"
      fluid={!!large_buttons}
      height={!!large_buttons && 2}
      onClick={on_submit_actual}
      disabled={submit_disabled}
      m={0.5}
      pl={2}
      pr={2}
      pt={large_buttons ? 0.33 : 0}
      textAlign="center"
      tooltip={large_buttons && message}
      width={!large_buttons && 6}
    >
      {large_buttons ? 'SUBMIT' : 'Submit'}
    </Button>
  );
  const cancelButton = (
    <Button
      color="bad"
      fluid={!!large_buttons}
      height={!!large_buttons && 2}
      onClick={on_cancel_actual}
      m={0.5}
      pl={2}
      pr={2}
      pt={large_buttons ? 0.33 : 0}
      textAlign="center"
      width={!large_buttons && 6}
    >
      {large_buttons ? 'CANCEL' : 'Cancel'}
    </Button>
  );

  return (
    <Flex
      align="center"
      direction={!swapped_buttons ? 'row' : 'row-reverse'}
      fill={1}
      justify="space-around"
    >
      {large_buttons ? (
        <Flex.Item grow>{cancelButton}</Flex.Item>
      ) : (
        <Flex.Item>{cancelButton}</Flex.Item>
      )}
      {!large_buttons && message && (
        <Flex.Item>
          <Box color="label" textAlign="center">
            {message}
          </Box>
        </Flex.Item>
      )}
      {large_buttons ? (
        <Flex.Item grow>{submitButton}</Flex.Item>
      ) : (
        <Flex.Item>{submitButton}</Flex.Item>
      )}
    </Flex>
  );
};
