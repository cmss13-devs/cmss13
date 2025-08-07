/**
 * @file
 * @copyright 2022 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';
import { Component, createRef, ReactNode, RefObject } from 'react';

import { logger } from '../logging';
import { Box } from './Box';
import { Icon } from './Icon';

type MenuProps = {
  readonly children: any;
  readonly width: string;
  readonly menuRef: RefObject<HTMLElement>;
  readonly onOutsideClick: () => void;
};

class Menu extends Component<MenuProps> {
  private readonly handleClick: (event) => void;

  constructor(props) {
    super(props);
    this.handleClick = (event) => {
      if (!this.props.menuRef.current) {
        logger.log(`Menu.handleClick(): No ref`);
        return;
      }

      if (this.props.menuRef.current.contains(event.target)) {
        logger.log(`Menu.handleClick(): Inside`);
      } else {
        logger.log(`Menu.handleClick(): Outside`);
        this.props.onOutsideClick();
      }
    };
  }

  // eslint-disable-next-line react/no-deprecated
  componentWillMount() {
    window.addEventListener('click', this.handleClick);
  }

  componentWillUnmount() {
    window.removeEventListener('click', this.handleClick);
  }

  render() {
    const { width, children } = this.props;
    return (
      <div
        className={'MenuBar__menu'}
        style={{
          width: width,
        }}
      >
        {children}
      </div>
    );
  }
}

type MenuBarDropdownProps = {
  readonly open: boolean;
  readonly openWidth: string;
  readonly children: any;
  readonly disabled?: boolean;
  readonly display: any;
  readonly onMouseOver: () => void;
  readonly onClick: () => void;
  readonly onOutsideClick: () => void;
  readonly className?: string;
};

class MenuBarButton extends Component<MenuBarDropdownProps> {
  private readonly menuRef: RefObject<HTMLDivElement>;

  constructor(props) {
    super(props);
    this.menuRef = createRef();
  }

  render() {
    const { props } = this;
    const {
      open,
      openWidth,
      children,
      disabled,
      display,
      onMouseOver,
      onClick,
      onOutsideClick,
      ...boxProps
    } = props;
    const { className, ...rest } = boxProps;

    return (
      <div ref={this.menuRef}>
        <Box
          className={classes([
            'MenuBar__MenuBarButton',
            'MenuBar__font',
            'MenuBar__hover',
            className,
          ])}
          {...rest}
          onClick={disabled ? () => null : onClick}
          onMouseOver={onMouseOver}
        >
          <span className="MenuBar__MenuBarButton-text">{display}</span>
        </Box>
        {open && (
          <Menu
            width={openWidth}
            menuRef={this.menuRef}
            onOutsideClick={onOutsideClick}
          >
            {children}
          </Menu>
        )}
      </div>
    );
  }
}

type MenuBarItemProps = {
  readonly entry: string;
  readonly children: any;
  readonly openWidth: string;
  readonly display: ReactNode;
  readonly setOpenMenuBar: (entry: string | null) => void;
  readonly openMenuBar: string | null;
  readonly setOpenOnHover: (flag: boolean) => void;
  readonly openOnHover: boolean;
  readonly disabled?: boolean;
  readonly className?: string;
};

export const Dropdown = (props: MenuBarItemProps) => {
  const {
    entry,
    children,
    openWidth,
    display,
    setOpenMenuBar,
    openMenuBar,
    setOpenOnHover,
    openOnHover,
    disabled,
    className,
  } = props;

  return (
    <MenuBarButton
      openWidth={openWidth}
      display={display}
      disabled={disabled}
      open={openMenuBar === entry}
      className={className}
      onClick={() => {
        const open = openMenuBar === entry ? null : entry;
        setOpenMenuBar(open);
        setOpenOnHover(!openOnHover);
      }}
      onOutsideClick={() => {
        setOpenMenuBar(null);
        setOpenOnHover(false);
      }}
      onMouseOver={() => {
        if (openOnHover) {
          setOpenMenuBar(entry);
        }
      }}
    >
      {children}
    </MenuBarButton>
  );
};

const MenuItemToggle = (props) => {
  const { value, displayText, onClick, checked } = props;
  return (
    <Box
      className={classes([
        'MenuBar__font',
        'MenuBar__MenuItem',
        'MenuBar__MenuItemToggle',
        'MenuBar__hover',
      ])}
      onClick={() => onClick(value)}
    >
      <div className="MenuBar__MenuItemToggle__check">
        {checked && <Icon size={1.3} name="check" />}
      </div>
      {displayText}
    </Box>
  );
};

Dropdown.MenuItemToggle = MenuItemToggle;

const MenuItem = (props) => {
  const { value, displayText, onClick } = props;
  return (
    <Box
      className={classes([
        'MenuBar__font',
        'MenuBar__MenuItem',
        'MenuBar__hover',
      ])}
      onClick={() => onClick(value)}
    >
      {displayText}
    </Box>
  );
};

Dropdown.MenuItem = MenuItem;

const Separator = () => {
  return <div className="MenuBar__Separator" />;
};

Dropdown.Separator = Separator;

type MenuBarProps = {
  readonly children: any;
};

export const MenuBar = (props: MenuBarProps) => {
  const { children } = props;
  return <Box className="MenuBar">{children}</Box>;
};

MenuBar.Dropdown = Dropdown;
