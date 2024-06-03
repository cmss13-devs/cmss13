// TODO- migrate to tsx

import React, { useEffect, useRef, useState } from 'react';

import { Box } from '../../components';
import { Window } from '../../layouts';

const generateRandomFileHierarchy = () => {
  const levels = [
    'Datacore',
    'Records',
    'System',
    'Scripts',
    'Logs',
    'Backups',
    'Configs',
  ];
  const files = [
    'record.txt',
    'data.txt',
    'document.doc',
    'user_log_image.png',
    'spreadsheet_data.xls',
    'cameralog.mp4',
  ];

  const getRandomInt = (max) => Math.floor(Math.random() * max);

  const generateLevel = (depth) => '  '.repeat(depth);

  const generatePath = (depth) => {
    let path = '';
    for (let i = 0; i < depth; i++) {
      const randomIndex = getRandomInt(levels.length);
      path += `${levels[randomIndex]}/`;
    }
    return path;
  };

  const randomHierarchy = [];
  for (let i = 0; i < 100; i++) {
    const depth = getRandomInt(5) + 1;
    const level = generateLevel(depth);
    const path = generatePath(depth);
    const fileName = files[getRandomInt(files.length)];
    randomHierarchy.push(`${level}-- ${path}${fileName}`);
  }

  return randomHierarchy;
};

export const TerminalHack = (props) => {
  const [history, setHistory] = useState([]);
  const windowRef = useRef(null);
  const [showHackingMessage, setShowHackingMessage] = useState(true);
  const [showSuccessMessage, setShowSuccessMessage] = useState(false);

  useEffect(() => {
    if (!windowRef?.current) return;
    const generateRandomInterval = () =>
      Math.floor(Math.random() * (2000 - 1000 + 1)) + 1000;

    const startDelay = 2000;
    const stopDelay = 20000;
    let timer;

    const startGeneratingContent = () => {
      const intervalId = setInterval(() => {
        setHistory((prevHistory) => [
          ...prevHistory,
          ...generateRandomFileHierarchy(),
        ]);
        setShowHackingMessage(false);
        if (windowRef.current) {
          windowRef.current.scrollIntoView({
            behavior: 'smooth',
            block: 'end',
          });
        }
      }, generateRandomInterval());

      timer = setTimeout(() => {
        clearInterval(intervalId);
        setShowSuccessMessage(true);
      }, stopDelay);
    };

    const showMessageTimer = setTimeout(startGeneratingContent, startDelay);
    return () => {
      clearTimeout(timer);
      clearTimeout(showMessageTimer);
    };
  }, []);

  return (
    <Window width={700} height={600} theme="crtred">
      <Window.Content className="terminal-hack">
        {showHackingMessage && (
          <Box className="terminal-message-hack fade-in">
            Accessing System...
          </Box>
        )}
        {showSuccessMessage ? (
          <Box ref={windowRef} className="terminal-message-hack fade-in">
            Successfully Authorized...
          </Box>
        ) : (
          <Box className="terminal-output-hack">
            {history.map((item, index) => (
              <Box key={index} className="terminal-line-hack">
                {item}
              </Box>
            ))}
          </Box>
        )}
        {/* fix this later, temporary workaround */}
        <div ref={windowRef} />
      </Window.Content>
    </Window>
  );
};
