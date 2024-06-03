// TODO: migrate to tsx

import React, { useState } from 'react';

import { Box } from '../../components';
import { Window } from '../../layouts';

export const Terminal = (props) => {
  const [input, setInput] = useState('');
  const [history, setHistory] = useState([]);

  const handleInputChange = (e) => {
    setInput(e.target.value);
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      setHistory([...history, input]);
      setInput('');
    }
  };

  return (
    <Window width={700} height={550} theme="crtblue">
      <Window.Content className="terminal">
        <Box className="terminal-path">
          /Home/user/
          <span className="highlight-yellow">files </span>~
        </Box>
        <Box className="terminal-output">
          {history.map((item, index) => (
            <div key={index} className="terminal-line">
              {item}
            </div>
          ))}
        </Box>
        <Box className="terminal-input">
          <span className="prompt">$ </span>
          <input
            type="text"
            value={input}
            onChange={handleInputChange}
            onKeyDown={handleKeyDown}
            autoFocus
            className="invisible-input"
          />
        </Box>
      </Window.Content>
    </Window>
  );
};
