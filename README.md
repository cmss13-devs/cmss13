## RUCM-SS13 codebase (fork from CM-SS13)

<a href="https://www.monkeyuser.com/assets/images/2019/131-bug-free.png"><img src="https://img.shields.io/badge/Built_with-Resentment-orange?style=for-the-badge&labelColor=%23D47439&color=%23C36436" width=260px></a> <a href="https://user-images.githubusercontent.com/8171642/50290880-ffef5500-043a-11e9-8270-a2e5b697c86c.png"><img src="https://img.shields.io/badge/Contains-Technical_Debt-blue?style=for-the-badge&color=5598D0&labelColor=62C1EE" width=280px></a> [![forinfinityandbyond](https://user-images.githubusercontent.com/5211576/29499758-4efff304-85e6-11e7-8267-62919c3688a9.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

[![Build Status](https://github.com/cmss13-devs/cmss13/workflows/CI%20Suite/badge.svg)](https://github.com/cmss13-devs/cmss13/actions?query=workflow%3A%22CI+Suite%22)
* **Вебсайт разработчиков оригинального кода:** https://forum.cm-ss13.com/
* **Оригинальный код:** https://github.com/cmss13-devs/cmss13
* **Оригинальная вики:** https://cm-ss13.com/wiki/Main_Page

Это репозиторий RUCM-SS13, форк кодбазы CM-SS13, которая в свою очередь форк игры SpaceStation 13...

Space Station 13 - это параноидальная круговая ролевая игра, действие которой разворачивается на металлической коробке смерти, маскирующейся под космическую станцию, с очаровательной графикой, призванной отобразить научно-фантастическую обстановку и ее опасный подтекст. Данный билд - полная конверсия классической станции 13 под сеттинг мира серии научно фантастических фильмов ужасов "Чужой" в стиле "ролевой командный бой насмерть" 

## :exclamation: Как скомпилировать билд :exclamation:

**2022-04-06** оригинальные ЦМы изменили способ компиляции билда с классического (через byond) на продвинутый.

**Быстрый способ**. Найдите файл `bin/server.cmd` и дважды щелкните на нем для автоматической сборки и размещения сервера на порту 1337.

**Долгий способ**. Найдите файл `bin/build.cmd` и дважды щелкните на нем, чтобы запустить сборку. Сборка состоит из нескольких этапов и может занять около 1-5 минут. Если программа закрывается, это означает, что она завершила свою работу. После этого можно нормально настроить сервер, открыв `colonialmarines.dmb` в DreamDaemon.

**Компилирование кода в DreamMaker напрямую устарело и может приводить к ошибкам**, такие как `'tgui.bundle.js': cannot find file`.

**[Как компилировать в VSCode и другие варианты сборки](tools/build/README.md).**

## Помощь в разработке
[Руководство по помощи в разработке](.github/CONTRIBUTING.md)

[Настройка среды разработки](https://cm-ss13.com/wiki/Guide_to_Git)

## Лицензия

Код для CM-SS13 лицензирован под [GNU Affero General Public License v3](http://www.gnu.org/licenses/agpl.html), с которым можно ознакомиться в полном объеме в [/LICENSE-AGPL3](/LICENSE-AGPL3).

Активы, включая иконки и звук, находятся под лицензией [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) если не указано иное. Авторство на активы, включая искусство и звук, под лицензией CC BY-SA определяется как активная команда разработчиков CM-SS13, если не указано иное (автор коммита).

Предполагается, что код лицензируется по AGPL v3, если в заголовке файла не указано иное. Коммиты до 9a001bf520f889b434acd295253a1052420860af считаются лицензированными по GPLv3 и могут быть использованы в закрытом репозитории.
