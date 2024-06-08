import { BooleanLike } from 'common/react';
import React, { createRef, useState } from 'react';

import { useBackend } from '../backend';
import { Flex, Section } from '../components';
import { ButtonCheckbox } from '../components/Button';
import { Window } from '../layouts';
interface FormTypes {
  awaiting_admin_approval: BooleanLike;
  report_details: FormDetails;
}

// all the information necessary to pass into the github api
type FormDetails = {
  steps: string;
  title: string;
  description: string;
  expected_behavior: string;
};

const InputTitle = (props) => {
  return (
    <h2>
      {props.children}
      {props.required && <span className="input-title-required">{' *'}</span>}
    </h2>
  );
};

export const BugReportForm = (props) => {
  const { act, data } = useBackend<FormTypes>();
  const { awaiting_admin_approval, report_details } = data;
  const [checkBox, setCheckbox] = useState(false);

  const [title, setTitle] = useState(report_details?.title || '');
  const [steps, setSteps] = useState(report_details?.steps || '');
  const [description, setDescription] = useState(
    report_details?.description || '',
  );
  const [expected_behavior, setExpectedBehavior] = useState(
    report_details?.expected_behavior || '',
  );

  const titleRef = createRef<HTMLInputElement>();
  const stepsRef = createRef<HTMLTextAreaElement>();
  const descriptionRef = createRef<HTMLInputElement>();
  const expectedBehaviorRef = createRef<HTMLInputElement>();

  const submit = () => {
    if (!title || !description || !expected_behavior || !steps || !checkBox) {
      alert('Please fill out all required fields!');
      return;
    }
    const updatedReportDetails = {
      title,
      steps,
      description,
      expected_behavior,
    };
    act('confirm', updatedReportDetails);
  };

  return (
    <Window title={'Bug Report Form'} width={600} height={600}>
      <Window.Content>
        <Section fill scrollable>
          <Flex direction="column" height="100%">
            <Flex.Item className="text-center">
              <a
                href="https://github.com/cmss13-devs/cmss13/issues"
                target="_blank"
                rel="noreferrer"
                className="link"
              >
                GitHub Repository
              </a>
            </Flex.Item>
            <Flex.Item>
              <InputTitle required>{'Title'}</InputTitle>
              <input
                width="100%"
                ref={titleRef}
                className="textarea"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'Description'}</InputTitle>
              {'Give a short description of the bug'}
              <input
                width="100%"
                ref={descriptionRef}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                className="textarea"
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>
                {"What's the difference with what should have happened?"}
              </InputTitle>
              {'Give a short description of what you expected to happen'}
              <input
                width="100%"
                ref={expectedBehaviorRef}
                value={expected_behavior}
                onChange={(e) => setExpectedBehavior(e.target.value)}
                className="textarea"
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>
                {'How do we reproduce this bug?'}
              </InputTitle>
              {'Give a list of steps to reproduce this issue'}
              <textarea
                rows={4}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={steps}
                onChange={(e) => setSteps(e.target.value)}
                ref={stepsRef}
                placeholder="1.\n2.\n3."
              />
            </Flex.Item>
            <Flex.Item my={2} className={'text-center'}>
              <ButtonCheckbox
                checked={checkBox}
                onClick={() => {
                  setCheckbox(!checkBox);
                }}
              >
                {awaiting_admin_approval
                  ? 'I confirm that this bug report follows all TOS'
                  : "I couldn't find an existing issue about this on Github"}
                {!checkBox && (
                  <span className="input-title-required">{' *'}</span>
                )}
              </ButtonCheckbox>
            </Flex.Item>
            <Flex.Item my={2}>
              <Flex className="flex-center">
                <Flex.Item mx={1}>
                  <div className="button-cancel" onClick={() => act('cancel')}>
                    {awaiting_admin_approval ? 'Reject' : 'Cancel'}
                  </div>
                </Flex.Item>
                <Flex.Item mx={1}>
                  <div className="button-submit" onClick={submit}>
                    {awaiting_admin_approval ? 'Approve' : 'Submit'}
                  </div>
                </Flex.Item>
              </Flex>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
