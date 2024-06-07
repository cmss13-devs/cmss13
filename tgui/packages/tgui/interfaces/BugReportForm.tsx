import React, { createRef, useState } from 'react';

import { useBackend } from '../backend';
import { Flex, Section } from '../components';
import { ButtonCheckbox } from '../components/Button';
import { Window } from '../layouts';

type ReportForm = {
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
  const { act } = useBackend<ReportForm>();
  const [checkBox, setCheckbox] = useState(false);

  const titleRef = createRef<HTMLInputElement>();
  const stepsRef = createRef<HTMLTextAreaElement>();
  const descriptionRef = createRef<HTMLInputElement>();
  const expectedBehaviorRef = createRef<HTMLInputElement>();

  const submit = () => {
    const data: ReportForm = {
      steps: stepsRef.current ? stepsRef.current.value : '',
      title: titleRef.current ? titleRef.current.value : '',
      description: descriptionRef.current ? descriptionRef.current.value : '',
      expected_behavior: expectedBehaviorRef.current
        ? expectedBehaviorRef.current.value
        : '',
    };

    if (
      !data.title ||
      !data.description ||
      !data.expected_behavior ||
      !data.steps ||
      !checkBox
    ) {
      alert('Please fill out all required fields!');
      return;
    }
    act('confirm', data);
  };

  return (
    <Window title={'Bug Report Form'} width={600} height={700}>
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
                Github Repository
              </a>
            </Flex.Item>
            <Flex.Item>
              <InputTitle required>{'Title'}</InputTitle>
              <input width="100%" ref={titleRef} className="textarea" />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'Description'}</InputTitle>
              {'Give a short description of the bug'}
              <input width="100%" ref={descriptionRef} className="textarea" />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>
                {"What's the difference with what should have happened?"}
              </InputTitle>
              {'Give a short description of what you expected to happen'}
              <input
                width="100%"
                ref={expectedBehaviorRef}
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
                {"I couldn't find an existing issue about this on Github"}
                {!checkBox && (
                  <span className="input-title-required">{' *'}</span>
                )}
              </ButtonCheckbox>
            </Flex.Item>
            <Flex.Item my={2}>
              <Flex className="flex-center">
                <Flex.Item mx={1}>
                  <div className="button-default" onClick={submit}>
                    {'Submit'}
                  </div>
                </Flex.Item>
                <Flex.Item mx={1}>
                  <div className="button-default" onClick={() => act('cancel')}>
                    {'Cancel'}
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
