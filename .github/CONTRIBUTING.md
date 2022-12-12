# CONTRIBUTING TO CM-SS13

- [CONTRIBUTING TO CM-SS13](#contributing-to-cm-ss13)
	- [Reporting Issues](#reporting-issues)
	- [Introduction](#introduction)
	- [Getting Started](#getting-started)
	- [Meet the Team](#meet-the-team)
		- [Head Developer and Project Manager](#head-developer-and-project-manager)
		- [Maintainers](#maintainers)
		- [Issue Managers](#issue-managers)
	- [Issues Tracker](#issues-tracker)
	- [Development Guides](#development-guides)
			- [Writing readable code](#writing-readable-code)
			- [Writing sane code](#writing-sane-code)
			- [Writing understandable code](#writing-understandable-code)
			- [Misc](#misc)
	- [Pull Request Process](#pull-request-process)
	- [Good Boy Points](#good-boy-points)
	- [Porting features/sprites/sounds/tools from other codebases](#porting-featuresspritessoundstools-from-other-codebases)
	- [Banned content](#banned-content)

## Reporting Issues

If you ever encounter a bug in-game, the best way to let a coder know about it is with our GitHub Issue Tracker. Please make sure you use the supplied issue template.

(If you don't have an account, making a new one takes only one minute.)

If you have difficulty, ask for help in the #development channel on our discord.

## Introduction

Hello and welcome to CM-SS13's contributing page. You are here because you are curious or interested in contributing - thank you! Everyone is free to contribute to this project as long as they follow the simple guidelines and specifications below; at CM-SS13, we strive to maintain code stability and maintainability, and to do that, we need all pull requests to hold up to those specifications. It's in everyone's best interests - including yours! - if the same bug doesn't have to be fixed twice because of duplicated code.

First things first, we want to make it clear how you can contribute (if you've never contributed before), as well as the kinds of powers the team has over your additions, to avoid any unpleasant surprises if your pull request is closed for a reason you didn't foresee.

## Getting Started

CM-SS13 doesn't have a list of goals and features to add; we instead allow freedom for contributors to suggest and create their ideas for the game. That doesn't mean we aren't determined to squash bugs, which unfortunately pop up a lot due to the deep complexity of the game. Here are some useful starting guides, if you want to contribute or if you want to know what challenges you can tackle with zero knowledge about the game's code structure.

There is an open list of approachable issues for [your inspiration here](https://github.com/cmss13-devs/cmss13/issues?q=is%3Aopen+is%3Aissue+label%3A%22Good+First+Issue%22).

You can of course, as always, ask for help on the Discord channels or the forums. We're just here to have fun and help out, so please don't expect professional support.

## Meet the Team

### Head Developer and Project Manager

The Head Developer and Project Manager are responsible for controlling, adding, and removing maintainers from the project. In addition to filling the role of a normal maintainer, they have sole authority on who becomes a maintainer, as well as who remains a maintainer and who does not.

### Maintainers

Maintainers are quality control. If a proposed pull request doesn't meet the following specifications, they can request you to change it, or simply just close the pull request. Maintainers are required to give a reason for closing the pull request.

Maintainers can revert your changes if they feel they are not worth maintaining or if they did not live up to the quality specifications.

<details>
<summary>Maintainer Guidelines</summary>

These are the few directives we have for project maintainers.

- Do not merge PRs you create.
- Do not merge PRs until 24 hours have passed since it was opened. Exceptions include:
  - Emergency fixes.
    - Try to get secondary maintainer approval before merging if you are able to.
  - PRs with empty commits intended to generate a changelog.
- Do not merge PRs that contain content from the [banned content list](./CONTRIBUTING.md#banned-content).

These are not steadfast rules as maintainers are expected to use their best judgement when operating.

Our team is entirely voluntary, as such we extend our thanks to maintainers, issue managers, and contributors alike for helping keep the project alive.

</details>

### Issue Managers

Issue Managers help out the project by labelling bug reports and PRs and closing bug reports which are duplicates or are no longer applicable.

<details>
<summary>What You Can and Can't Do as an Issue Manager</summary>

This should help you understand what you can and can't do with your newfound github permissions.

Things you **CAN** do:
* Label issues appropriately
* Close issues when appropriate

Things you **CAN'T** do:
* Close PRs: Only maintainers are allowed to close PRs. Do not hit that button.
* Label PRs, leave that for maintainers to handle.

</details>

## Issues Tracker
Potential bugs can be submitted to the project issue tracker on GitLab. While we appreciate suggestions, they should **not** be posted here to make triaging technical issues and fixing bugs easier.

When submitting an issue, use the provided template. A few things to keep in mind for a good issue report maximizing the chance of finding and fixing it:

 * Search quickly for existing related issues - add info there if applicable rather than duplicating them
 * Stay factual and as concise as possible
 * If possible, attempt to reproduce and confirm the issue, and detail steps

The tracker is a powerful tool - it might look pointless, but ensures what's there can be known by anyone, team members and contributors alike, and won't be forgotten. This maximizes chances of issues being resolved. Don't be afraid to use it.

## Development Guides

#### Writing readable code
[Style guidelines](./guides/STYLES.md)

#### Writing sane code
[Code standards](./guides/STANDARDS.md)

#### Writing understandable code
[Autodocumenting code](./guides/AUTODOC.md)

#### Misc
[UI Development](../tgui/README.md)

[Embedding tgui components in chat](../tgui/docs/chat-embedded-components.md)

## Pull Request Process

There is no strict process when it comes to merging pull requests. Pull requests will sometimes take a while before they are looked at by a maintainer; the bigger the change, the more time it will take before they are accepted into the code. Every team member is a volunteer who is giving up their own time to help maintain and contribute, so please be courteous and respectful. Here are some helpful ways to make it easier for you and for the maintainers when making a pull request.

* Make sure your pull request complies to the requirements outlined here

* You are expected to have tested your pull requests if it is anything that would warrant testing. Text only changes, single number balance changes, and similar generally don't need testing, but anything else does. This means by extension web edits are disallowed for larger changes.

* You are going to be expected to document all your changes in the pull request. Failing to do so will mean delaying it as we will have to question why you made the change. On the other hand, you can speed up the process by making the pull request readable and easy to understand, with diagrams or before/after data. Should you be optimizing a routine you must provide proof by way of profiling that your changes are faster.

* We ask that you use the changelog system to document your player facing changes, which prevents our players from being caught unaware by said changes - you can find more information about this [on this wiki page](http://tgstation13.org/wiki/Guide_to_Changelogs).

* If you are proposing multiple changes, which change many different aspects of the code, you are expected to section them off into different pull requests in order to make it easier to review them and to deny/accept the changes that are deemed acceptable.

* If your pull request is accepted, the code you add no longer belongs exclusively to you but to everyone; everyone is free to work on it, but you are also free to support or object to any changes being made, which will likely hold more weight, as you're the one who added the feature. It is a shame this has to be explicitly said, but there have been cases where this would've saved some trouble.

* Please explain why you are submitting the pull request, and how you think your change will be beneficial to the game. Failure to do so will be grounds for rejecting the PR.

* If your pull request is not finished, you may open it as a draft for potential review. If you open it as a full-fledged PR make sure it is at least testable in a live environment. Pull requests that do not at least meet this requirement will be closed. You may request a maintainer reopen the pull request when you're ready, or make a new one.

* While we have no issue helping contributors (and especially new contributors) bring reasonably sized contributions up to standards via the pull request review process, larger contributions are expected to pass a higher bar of completeness and code quality *before* you open a pull request. Maintainers may close such pull requests that are deemed to be substantially flawed. You should take some time to discuss with maintainers or other contributors on how to improve the changes.

* After leaving reviews on an open pull request, maintainers may convert it to a draft. Once you have addressed all their comments to the best of your ability, feel free to mark the pull as `Ready for Review` again.

## Good Boy Points

Each GitHub account has a score known as Good Boy Points, or GBP. This is a system we use to ensure that the codebase stays maintained and that contributors fix bugs as well as add features.

The GBP gain or loss for a PR depends on the type of changes the PR makes, represented by the tags assigned to the PR by the CM-SS13 github bot or maintainers. Generally speaking, fixing bugs, updating sprites, or improving maps increases your GBP score, while adding mechanics, or rebalancing things will cost you GBP.

The GBP change of a PR is the sum of greatest positive and lowest negative values it has. For example, a PR that has tags worth +10, +4, -1, -7, will net 3 GBP (10 - 7).

Negative GBP increases the likelihood of a maintainer closing your PR. With that chance being higher the lower your GBP is. Be sure to use the proper tags in the changelog to prevent unnecessary GBP loss. Maintainers reserve the right to change tags as they deem appropriate.

There is no benefit to having a higher positive GBP score, since GBP only comes into consideration when it is negative.

You can see each tag and their GBP values [Here](https://github.com/cmss13-devs/cmss13/blob/master/.github/gbp.toml).

## Porting features/sprites/sounds/tools from other codebases

If you are porting features/tools from other codebases, you must give them credit where it's due. Typically, crediting them in your pull request and the changelog is the recommended way of doing it. Take note of what license they use though, porting stuff from AGPLv3 and GPLv3 codebases are allowed.

Regarding sprites & sounds, you must credit the artist and possibly the codebase.


## Banned content
Do not add any of the following in a Pull Request or risk getting the PR closed:
* Code which violates GitHub's [terms of service](https://github.com/site/terms).
