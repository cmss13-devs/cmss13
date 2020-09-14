# LICENSE

The code for CM-SS13 is licensed under the [GNU Affero General Public License v3](http://www.gnu.org/licenses/agpl.html), which can be found in full in [/LICENSE-AGPL3](/LICENSE-AGPL3).

Assets including icons and sound are under the [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated. Authorship for assets including art and sound under the CC BY-SA license is defined as the active development team of CM-SS13 unless stated otherwise (by author of the commit). 

All code is assumed to be licensed under AGPL v3 unless stated otherwise by file header. Commits before 9a001bf520f889b434acd295253a1052420860af are assumed to be licensed under GPLv3 and can be used in closed source repo.


# CONTRIBUTING TO CM-SS13

## Getting Started

CM-SS13 doesn't have a list of goals and features to add; we instead allow freedom for developers to suggest and create their ideas for the game. That doesn't mean we aren't determined to squash bugs, which unfortunately pop up a lot due to the deep complexity of the game. Here are some useful starting guides, if you want to contribute or if you want to know what challenges you can tackle with zero knowledge about the game's code structure.

Wile developers have the freedom to work on whatever they want, it falls to the team as a whole to decide if changes to the repository should be merged or not. This means that a merge request or change may be denied at the end, so understand that creative freedom does not grant you full reigns to commit anything to the repository without review, and you may have to deal with change requests or potential denial of your change.

To start contributing:

1. Download and install your git client. [GitKraken is recommended](https://www.gitkraken.com/).

2. [Register and log into Gitlab.](https://gitlab.com/) Wait for the Repository Owner to grant you access.

3. [Ensure you have Gitlab 2FA set up.](https://docs.gitlab.com/ee/user/profile/account/two_factor_authentication.html)

4. [Set up a Gitlab SSH key connection.](https://docs.gitlab.com/ee/ssh/)

5. Clone the repository with your git client.

## Meet the Team

**Host**

The Owner is responsible for controlling, adding, and removing maintainers from the project. While the Head Developer is officially in charge of the Development team, the Owner is a formal position to ensure ownership of the repository remains in the hands of the Hosts.

**Head Developer**

The Head Developer has the final say on what changes get into and out of the repository. He or she has full veto power on any feature or balance additions, changes, or removals, and establishes a general, personally-preferred direction for the game. The Head Developer is also the Development team lead, and manages team structure, direction, composition and integrity.

**System Administrator**

The System Administrator assists the Host & Vice Host in managing and maintaining the security and day-to-day operation of the game server and its myriad configuration details. They must be available and online often and easily enough via readily-available means of communication i.e. Discord for emergencies.

While not directly a part of the development team, the System Administrator has access to branch switching, repository access, and relevant dev channels for the purpose of supporting the team when needed.

**Lead Spriter**

The Lead Spriter controls sprites and aesthetic that get into the game. New or modified art assets fall to the Lead Spriter, who can decide whether or not a sprite tweak is both merited and a suitable replacement, and may request changes on any MR on the grounds that the sprite changes to not fit the art style and standards. Large changes to art-direction should be referenced to the rest of the team, but the ultimate discretion falls to the Lead Spriter. They also maintain Fax Templates & Logos, Forum graphics, and help curate wiki content. These tasks can be delegated at their discretion. They also handle all incoming spriter applicantions as well as direct changes to the spriting test. They are also responsible for managing the Sprite team.

**Lead Mapper**

The Lead Mapper oversees the management of mapping content going into the repository. They have the final say on any design and gameplay decisions when related to maps, and may request changes on any MR on the grounds that the proposed map changes do not fit the mapping standards. They are also responsible for managing the Mapping team.

**Developers**

Developers refers to everyone in the development team. As a part of the development team, you are required to meet the guidelines and standards set by the Leads and the team when contributing to the repository. As well as contributing to the repository, Developers are in charge of handling the review of open MRs, as well as the management of suggestions and issues.

**Contributors**

Contributors refer to anyone outside of the development team contributing to the repository in the form of MRs. Much like Developers, you are required to follow this document with regards to code quality and standards. As a contributor, you may only open MRs with changes related to bugs, runtimes, or Accepted Suggestions on the Gitlab issue tracker, which are handled by the development team.

## Merge Requests
All Merge Requests (except Dev to Master MRs) must either target a work-in-progress branch, or the Dev branch. No one may push to master.

All features added to Dev must come through a Merge Request. No one, except for changelog merges during a Dev to Master MR, may push to Dev without a Merge Request.

All Merge Requests (except Dev to Master MRs) should be appropriately tagged. Any MR that is not complete and ready for review should be marked with a WIP: in the title and the DO NOT MERGE tag. Add any tags that apply to your MR, without being excessive.

Merge Requests should include a copy of the changelog entries for that branch in its description or, if no changelog is required (hotfixes, typo corrections, and other very minor changes) include a description of the changes manually (unless it can be fully explained in the MR title).

Merge Requests targeting Dev should be set to squash commits and remove the branch when the merge is complete to keep the repository clean. Merge requests to Master should never do this.

All Merge Requests must wait for the CI pipeline to complete before merging unless there is a confirmed issue with the unit tests themselves.

All Merge Requests require two valid Approvals to merge into Dev immediately, or one valid Approval by a Developer or higher and at least 24 hours of awaiting further approval. See Approvals below to determine who/when to approve an MR. MRs should only be approved once all discussions opened during review of the MR are resolved.

All Merge Requests should have one of the following tags:
- ``Pending Review``: The MR is awaiting code review, or has addressed all comments and is awaiting re-review.
- ``Awaiting Author``: The MR has comments to address before progressing further.
- ``Needs Testing``: The MR needs further testing, potentially in a live environment.

Merge requests should not include multiple sweeping changes unrelated to each other. Developers must split up and create multiple MRs for each of their changes where necessary so as to keep them organized as their own standalone feature or change. The only time multiple changes in an MR is acceptible is when submitting bugfixes to the repository.

Once a Merge Request is approved and merged into Dev, ensure that all changelog files are forwarded to the Wiki Maintainer, as well as any art assets or additional information they request; changes that are not included in the Changelog, but can be accessed or interacted with by players, should additionally be forwarded to the Wiki Maintainer.

**Changelogs follow a specific format. To correctly create a changelog, make a copy of Example.yml and do the following:**
1. Rename your copy to your name and some identifying information (usually the branch name, or something similar), following the format of the example.
2. Open the renamed copy and change the Author to be a complete list of contributors to the branch or, if you feel the need to make a given change anonymous, you may use the pseudonym ‘John Titor’ instead.
3. Follow the instructions provided in the file to correctly assemble a discrete list of changes. Where possible, provide a link or reference to the Gitlab issues related to each change, by ID number (i.e. #3445).
4. Ensure that you are using your escape characters appropriately. If you want to have a quotation mark “ appear in the changelog entry, you need to escape it, i.e. \” so that the changelog generator doesn’t get confused.
5. Ensure that you are indenting the entries with the correct number of spaces, as described in the file’s instructions.
Include the .yml file in your staged changes when pushing to your branch.

These files are used by the changelog generation tool (see Dev Tool Usage below) to create cohesive, conflict-free changelog entries.


## Issues Tracker
Open issues are categorized into two tags, bugs & suggestions.

### Bugs
Bugs must be submitted using the bug template and should be reproduced by a member of the development team where possible. They should be tagged as bugs, as well as any relevant sub-categories that apply to them. If the bug could not be reproduced, the "Could not reproduce" tag should be applied.

If the bug in question is related to any change that may have been implemented by an active member of the development team, the Issue should be assigned to the person in question.

When attempting to fix a bug, if unassigned, Developers must assign themselves to the issue.

### Suggestions
All suggestions should be marked with a 1 month due date upon opening, and should be tagged as suggestions, as well as any relevant sub-categories. Once the due date is reached, suggestions should be closed.

If a developer wishes to work on a suggestion, they must assign themselves, as well as swap the suggestion tag with an accepted suggestion tag. They may also give the suggestion a new 1 month due date.

Accepted suggestions are not to be considered as guaranteed upcoming changes, and developers must not make promises when speaking to the community.

## Specifications

As mentioned before, you are expected to follow these specifications in order to make everyone's lives easier. It'll save both your time and ours, by making sure you don't have to make any changes and we don't have to ask you to.

### Object Oriented Code
As BYOND's Dream Maker (henceforth "DM") is an object-oriented language, code must be object-oriented when possible in order to be more flexible when adding content to it.

#### Encapsulation
While procs for getting variables are not required within DM, procs for setting should be preferred where possible. Code that modifies another datum's variables should be encapsulated into calling the other datum's setter procs if that variable is broadly used. Ensure that both the variable and the parameters are valid before using them.

For example:
````DM
for(var/obj/item/food in mre_packet)
	food.add_poison(2)

/obj/item/food/proc/add_poison(var/amount)
	poison += amount
````

#### Abstraction
Front-end usage of a datum and its procs should be easy to use and understand, and when called by other datums it should hide internal implementation details. Datums should only reveal operations relevant for the other datums.

#### Inheritance & Polymorphism
Variables, procs, flags, and code should be inherited where possible to cut down on copy-pasted code. If two separate datums require the same code to function, they should inherit said code from their common parent. Additional differences in procs can then be defined on the child-level after using ``..()`` to call the parent's verison of the proc.

Subtypes of datums should be polymorphic where possible, with their procs and functionality inheriting from parent defines and adjusting them to meet requirements.

For example:
````DM
/obj/item/proc/add_poison(var/amount)
	poison += amount

/obj/item/food/add_poison(var/amount)
	..()
	//Make the food turn green
	if(poison >= poison_overflow_threshold)
		color = "#ff0000"

/obj/item/weapon/add_poison(var/amount)
	..()
	//Make the weapon deal poison damage
	if(poison)
		flags_atom |= WEAPON_POISONOUS

````

### All BYOND paths must contain the full path
(i.e. absolute pathing)

DM will allow you nest almost any type keyword into a block, such as:

```DM
datum
	datum1
		var
			varname1 = 1
			varname2
			static
				varname3
				varname4
		proc
			proc1()
				code
			proc2()
				code

		datum2
			varname1 = 0
			proc
				proc3()
					code
			proc2()
				..()
				code
```

The use of this is not allowed in this project as it makes finding definitions via full text searching next to impossible. The only exception is the variables of an object may be nested to the object, but must not nest further.

The previous code made compliant:

```DM
/datum/datum1
	var/varname1
	var/varname2
	var/static/varname3
	var/static/varname4

/datum/datum1/proc/proc1()
	code
/datum/datum1/proc/proc2()
	code
/datum/datum1/datum2
	varname1 = 0
/datum/datum1/datum2/proc/proc3()
	code
/datum/datum1/datum2/proc2()
	..()
	code
```

### No overriding type safety checks
The use of the : operator and ?. proc call operator to override type safety checks is not allowed. You must cast the variable to the proper type. Do not use ?. over checking for a variable's existence (e.g. client && client.prefs instead of client?.prefs).

### Type paths must begin with a /
eg: `/datum/thing`, not `datum/thing`

### Type paths must be lowercase
eg: `/datum/thing/blue`, not `datum/thing/BLUE` or `datum/thing/Blue`

### Datum type paths must began with "datum"
In DM, this is optional, but omitting it makes finding definitions harder.

### Do not use text/string based type paths
Do not put type paths in a text format, as there are no compile errors if the type path no longer exists. Here is an example:

```DM
//Good
var/path_type = /obj/item/baseball_bat

//Bad
var/path_type = "/obj/item/baseball_bat"
```

### Use var/type/name format when declaring variables
While DM allows other ways of declaring variables, this one should be used for consistency. Defining lists can be abstract when only a single datum type is known (``var/list/datum_list``).

### Tabs, not spaces
You must use tabs to indent your code, NOT SPACES.

(You may use spaces to align something, but you should tab to the block level first, then add the remaining spaces)

### Snake case naming convention
All variables, procs, and files should use snake case.

```DM
var/snake_case_variable

/mob/living/simple_mob/snake/proc/attack_prey(var/mob/target_prey)
	...
```

### No hacky code
Hacky code, such as adding specific checks, is highly discouraged and only allowed when there is ***no*** other option. ('I couldn't immediately think of a proper way so thus there must be no other option' is not gonna cut it here. If you can't think of anything else, say that outright and admit that you need help with it. The team exists for a reason.)

You can avoid hacky code by using object-oriented methodologies, such as overriding a proc or sectioning code into functions and then overriding them as required.

### No duplicated code
Copying code from one place to another may be suitable for small, short-time projects, but CM is a long-term project and highly discourages this.

Instead you can use object orientation, or simply placing repeated code in a function, to obey this specification easily.

Repeated code sometimes may be necessary, but it should only be considered when all other options are unavailable.

### Startup/Runtime setup of lists and the usage of LAZY operations
First, read the comments in [this BYOND thread](http://www.byond.com/forum/?post=2086980&page=2#comment19776775), starting where the link takes you.

Lazy instantiation as a whole is about not instantiating objects before you actually use them. In terms of lists this means only declaring (but not defining) your list in the definition or defining it as null.

Before you use the list in your code (anywhere), you use `LAZYINITLIST(L)`, which just checks if the list has been defined and creates it for you if not.

When adding or removing elements to/from the list, use `LAZYREMOVE(L, I)`/`LAZYADD(L, I)`. It's just a wrapper for checking if the list exists first, but for additions it will create the list if it doesn't exist, and for removals it also nulls the list if it's empty after the removal. Therefore it's important to be consistent about your use of lazy instantiation. `LAZYINSERT(L, I, X)` does the obvious, but `LAZYDISTINCTADD(L, I)` only inserts into the list if `I` does not already exist in the list.

All the above are for indexed lists. If you use associative lists, use `LAZYSET(L, A, I)`, which performs `L[A] = I`.

For list access, use `LAZYACCESS(L, I)`, which gets you `L[I]`.

Other defines are `LAZYLEN(L)` which gives you the length of the list, `LAZYISIN(L, I)` which is basically an `in` keyword replacement, and `LAZYCLEARLIST(L)` which clears the full list for you.

One important thing to note is that all these defines have null safety. I.e. it'll check if the list exists first for you and create it if it doesn't when needed.

### Use `Initialize()` over `New()` for atoms
Our game controller is pretty good at handling long operations and lag, but it can't control what happens when the map is loaded, which calls `New` for all atoms on the map. If you're creating a new atom, use the `Initialize` proc to do what you would normally do in `New`. This cuts down on the number of proc calls needed when the world is loaded.

You should only ever use `New` when it is absolutely necessary.

While we require bringing out of date code up to date when you make unrelated changes near the out of date code, that is not the case for `New` -> `Initialize` conversions. These systems are generally more dependant on parent and children procs so unrelated random conversions of existing things can cause bugs that take months to figure out.

### Use `qdel()` over `del()` for deleting atoms
To tie in with using Initialize, atoms must use the garbage collector's `qdel(atom)` function in order to queue deletions instead of hard-calling `del()`. The priority of an atom's deletion can be marked with qdel hints (such as GC_HINT_DELETE_NOW).

All datums must correctly nullify and delete all stored references to other datums within their `Dispose()` proc. The `Dispose()` proc should also never be directly called outside of the garbage collector.

### No magic numbers or strings
This means stuff like having a "mode" variable for an object set to "1" or "2" with no clear indicator of what that means. Make these #defines with a name that more clearly states what it's for. For instance:
````DM
/datum/proc/do_the_thing(thing_to_do)
	switch(thing_to_do)
		if(1)
			(...)
		if(2)
			(...)
````
There's no indication of what "1" and "2" mean! Instead, you'd do something like this:
````DM
#define DO_THE_THING_REALLY_HARD 1
#define DO_THE_THING_EFFICIENTLY 2
/datum/proc/do_the_thing(thing_to_do)
	switch(thing_to_do)
		if(DO_THE_THING_REALLY_HARD)
			(...)
		if(DO_THE_THING_EFFICIENTLY)
			(...)
````
This is clearer and enhances readability of your code! Get used to doing it!

Use TRUE and FALSE for boolean logic instead of 1 and 0.
````DM
/datum/proc/do_the_thing(thing_to_do)
	switch(thing_to_do)
		if(DO_THE_THING_REALLY_HARD)
			return TRUE
		if(DO_THE_THING_EFFICIENTLY)
			return FALSE
````

### Control statements
(if, while, for, etc)

* All control statements must not contain code on the same line as the statement (`if (blah) return`)
* All control statements comparing a variable to a number should use the formula of `thing` `operator` `number`, not the reverse (eg: `if (count <= 10)` not `if (10 >= count)`)

### Use early return
Do not enclose a proc in an if-block when returning on a condition is more feasible
This is bad:
````DM
/datum/datum1/proc/proc1()
	if (thing1)
		if (!thing2)
			if (thing3 == 30)
				do stuff
````
This is good:
````DM
/datum/datum1/proc/proc1()
	if (!thing1)
		return
	if (thing2)
		return
	if (thing3 != 30)
		return
	do stuff
````
This prevents nesting levels from getting deeper then they need to be.

### Use Type macros for commonly used typechecks
If you need to use a typecheck multiple times for a specific type path, create an istype macro within the #define/type_check folder.
````DM
#define isbrain(A) (istype(A, /mob/living/brain))
````

### Develop Secure Code

* Player input must always be escaped safely, we recommend you use stripped_input in all cases where you would use input. Essentially, just always treat input from players as inherently malicious and design with that use case in mind

* Calls to the database must be escaped properly - use sanitizeSQL to escape text based database entries from players or admins, and isnum() for number based database entries from players or admins.

* All calls to topics must be checked for correctness. Topic href calls can be easily faked by clients, so you should ensure that the call is valid for the state the item is in. Do not rely on the UI code to provide only valid topic calls, because it won't.

* Information that players could use to metagame (that is, to identify round information and/or antagonist type via information that would not be available to them in character) should be kept as administrator only.

* It is recommended as well you do not expose information about the players - even something as simple as the number of people who have readied up at the start of the round can and has been used to try to identify the round type.

* Where you have code that can cause large-scale modification and *FUN*, make sure you start it out locked behind one of the default admin roles - use common sense to determine which role fits the level of damage a function could do.

### Files
* Because runtime errors do not give the full path, try to avoid having files with the same name across folders.

* File names should not be mixed case, or contain spaces or any character that would require escaping in a uri.

* Files and path accessed and referenced by code simply being #included should be strictly lowercase to avoid issues on filesystems where case matters.

### Mapping Standards
* TGM Format & Map Merge
	* All new maps submitted to the repo through a merge request must be in TGM format (unless there is a valid reason present to have it in the default BYOND format.) This is done using the [Map Merge](https://github.com/tgstation/tgstation/wiki/Map-Merger) utility included in the repo to convert the file to TGM format.
	* Likewise, you MUST run Map Merge prior to opening your MR when updating existing maps to minimize the change differences (even when using third party mapping programs such as FastDMM.)
		* Failure to run Map Merge on a map after using third party mapping programs (such as FastDMM) greatly increases the risk of the map's key dictionary becoming corrupted by future edits after running map merge. Resolving the corruption issue involves rebuilding the map's key dictionary; id est rewriting all the keys contained within the map by reconverting it from BYOND to TGM format - which creates very large differences that ultimately delay the MR process and is extremely likely to cause merge conflicts with other merge requests.

* Variable Editing (Var-edits)
	* While var-editing an item within the editor is perfectly fine, it is **STRONGLY PREFERRED** that when you are changing the base behavior of an item (how it functions) that you make a new subtype of that item within the code, especially if you plan to use the item in multiple locations on the same map, or across multiple maps. This makes it easier to make corrections as needed to all instances of the item at one time as opposed to having to find each instance of it and change them all individually.
	* Please attempt to clean out any dirty variables that may be contained within items you alter through var-editing. For example, due to how DM functions, changing the `pixel_x` variable from 23 to 0 will leave a dirty record in the map's code of `pixel_x = 0`. Likewise this can happen when changing an item's icon to something else and then back. This can lead to some issues where an item's icon has changed within the code, but becomes broken on the map due to it still attempting to use the old entry.
	* Areas should not be var-edited on a map to change it's name or attributes. All areas of a single type and it's altered instances are considered the same area within the code, and editing their variables on a map can lead to issues with powernets and event subsystems which are difficult to debug.

### User Interfaces
* All new player-facing user interfaces must use nanoui. 
* Raw HTML is permitted for admin and debug UIs.

### Operators
#### Spacing

* Operators that should be separated by spaces
	* Boolean and logic operators like &&, || <, >, ==, etc (but not !)
	* Bitwise AND &
	* Argument separator operators like , (and ; when used in a forloop)
	* Assignment operators like = or += or the like
* Operators that should not be separated by spaces
	* Bitwise OR |
	* Access operators like . and :
	* Parentheses ()
	* logical not !

Math operators like +, -, /, *, etc are up in the air, just choose which version looks more readable.

#### Use
* Bitwise AND - '&'
	* Should be written as ```bitfield & bitflag``` NEVER ```bitflag & bitfield```, both are valid, but the latter is confusing and nonstandard.
* Associated lists declarations must have their key value quoted if it's a string
	* WRONG: list(a = "b")
	* RIGHT: list("a" = "b")

### Dream Maker Quirks/Tricks
Like all languages, Dream Maker has its quirks, some of them are beneficial to us, like these

#### In-To for-loops
```for(var/i = 1, i <= some_value, i++)``` is a fairly standard way to write an incremental for loop in most languages (especially those in the C family), but DM's ```for(var/i in 1 to some_value)``` syntax is oddly faster than its implementation of the former syntax; where possible, it's advised to use DM's syntax. (Note, the ```to``` keyword is inclusive, so it automatically defaults to replacing ```<=```; if you want ```<``` then you should write it as ```1 to some_value-1```). You can use the step keyword to iterate at different steps ```(e.g. i-- or i -= 2)```. It would go like for ```(var/i in 100 to 0 step -1)```.

HOWEVER, if either ```some_value``` or ```i``` changes within the body of the for (underneath the ```for(...)``` header) or if you are looping over a list AND changing the length of the list then you can NOT use this type of for-loop!

### Operator precedence
See [The BYOND reference](http://www.byond.com/docs/ref/#/operator)

Placement of operators and bracketing can affect the outcome of certain logic within DM code, and it's important to make sure you are writing the correct condition checking when making situationals.

A common mistake that's easy to fall for is that bitwise AND has a lower operator precedence than equality checks, so `a & b == c` evaluates to `a & (b == c)` instead of `(a & b) == c` as most sane people would probably expect

### for(var/A in list) VS for(var/i in 1 to list.len)
The former is faster than the latter, as shown by the following profile results:
https://file.house/zy7H.png
Code used for the test in a readable format:
https://pastebin.com/w50uERkG


#### Istypeless for loops
A name for a differing syntax for writing for-each style loops in DM. It's NOT DM's standard syntax, hence why this is considered a quirk. Take a look at this:
```DM
var/list/bag_of_items = list(sword, apple, coinpouch, sword, sword)
var/obj/item/sword/best_sword
for(var/obj/item/sword/S in bag_of_items)
	if(!best_sword || S.damage > best_sword.damage)
		best_sword = S
```
The above is a simple proc for checking all swords in a container and returning the one with the highest damage, and it uses DM's standard syntax for a for-loop by specifying a type in the variable of the for's header that DM interprets as a type to filter by. It performs this filter using ```istype()``` (or some internal-magic similar to ```istype()``` - this is BYOND, after all). This is fine in its current state for ```bag_of_items```, but if ```bag_of_items``` contained ONLY swords, or only SUBTYPES of swords, then the above is inefficient. For example:
```DM
var/list/bag_of_swords = list(sword, sword, sword, sword)
var/obj/item/sword/best_sword
for(var/obj/item/sword/S in bag_of_swords)
	if(!best_sword || S.damage > best_sword.damage)
		best_sword = S
```
specifies a type for DM to filter by. 

With the previous example that's perfectly fine, we only want swords, but here the bag only contains swords? Is DM still going to try to filter because we gave it a type to filter by? YES, and here comes the inefficiency. Wherever a list (or other container, such as an atom (in which case you're technically accessing their special contents list, but that's irrelevant)) contains datums of the same datatype or subtypes of the datatype you require for your loop's body,
you can circumvent DM's filtering and automatic ```istype()``` checks by writing the loop as such:
```DM
var/list/bag_of_swords = list(sword, sword, sword, sword)
var/obj/item/sword/best_sword
for(var/s in bag_of_swords)
	var/obj/item/sword/S = s
	if(!best_sword || S.damage > best_sword.damage)
		best_sword = S
```
Of course, if the list contains data of a mixed type then the above optimisation is DANGEROUS, as it will blindly typecast all data in the list as the specified type, even if it isn't really that type, causing runtime errors.

#### Dot variable
Like other languages in the C family, DM has a ```.``` or "Dot" operator, used for accessing variables/members/functions of an object instance.
eg:
```DM
var/mob/living/carbon/human/H = YOU_THE_READER
H.gib()
```
However, DM also has a dot variable, accessed just as ```.``` on its own, defaulting to a value of null. Now, what's special about the dot operator is that it is automatically returned (as in the ```return``` statement) at the end of a proc, provided the proc does not already manually return (```return count``` for example.) Why is this special?

With ```.``` being everpresent in every proc, can we use it as a temporary variable? Of course we can! However, the ```.``` operator cannot replace a typecasted variable - it can hold data any other var in DM can, it just can't be accessed as one, although the ```.``` operator is compatible with a few operators that look weird but work perfectly fine, such as: ```.++``` for incrementing ```.'s``` value, or ```.[1]``` for accessing the first element of ```.```, provided that it's a list.

## Globals versus static

DM has a var keyword, called global. This var keyword is for vars inside of types. For instance:

```DM
mob
	var
		global
			thing = TRUE
```
This does NOT mean that you can access it everywhere like a global var. Instead, it means that that var will only exist once for all instances of its type, in this case that var will only exist once for all mobs - it's shared across everything in its type. (Much more like the keyword `static` in other languages like PHP/C++/C#/Java)

Isn't that confusing? 

There is also an undocumented keyword called `static` that has the same behaviour as global but more correctly describes BYOND's behaviour. Therefore, we always use static instead of global where we need it, as it reduces suprise when reading BYOND code.

## Bitflags
Bitflags are a method of defining properties of an atom in order to pass or fail checks in other sections of the code. Bitflags should be used as a replacement for any single true/false boolean variable that may be tied to a type, so that atom defines do not end up with hundreds of unique booleans to track.

For instance:

```DM
#define ITEM_FLAG_UNACIDABLE        1
#define ITEM_FLAG_INDESTRUCTIBLE    2
#define ITEM_FLAG_BOUNCY            4
#define ITEM_FLAG_SQUEAKY           8

/obj/attackby()
    if(flags_atom & ITEM_FLAG_BOUNCY)
        ...

/obj/item/rubber_ball
    flags_atom = ITEM_FLAG_UNACIDABLE|ITEM_FLAG_BOUNCY
```

## Span Macros
In the case where span classes are required, for strings and text to be displayed to a user, span macros should be used to encapsulate and style where necessary.

For instance:

```DM
to_chat(SPAN_WARNING("You are on fire!"))
```

### Other Notes
* Code should be modular where possible; if you are working on a new addition, then strongly consider putting it in its own file unless it makes sense to put it with similar ones (i.e. a new tool would go in the "tools.dm" file)

* Bloated code may be necessary to add a certain feature, which means there has to be a judgement over whether the feature is worth having or not. You can help make this decision easier by making sure your code is modular.

* You are expected to help maintain the code that you add, meaning that if there is a problem then you are likely to be approached in order to fix any issues, runtimes, or bugs.

* Do not divide when you can easily convert it to multiplication. (ie `4/2` should be done as `4*0.5`, because it's slightly faster)

* If you used regex to replace code during development of your code, post the regex in your MR for the benefit of future developers.

* Changes to the `/config` tree must be made in a way that allows for updating server deployments while preserving previous behaviour. This is due to the fact that the config tree is to be considered owned by the server and not necessarily updated alongside the remainder of the code. The code to preserve previous behaviour may be removed at some point in the future given the OK by developers.

* English/British spelling on var/proc names
	* Color/Colour - both are fine, but keep in mind that BYOND uses `color` as a base variable
* Space usage in control statements
	* `if()` and `if ()` - Spaces should be used between conditions, but never between brackets: `if(istype(src, /obj/item) && (unacidable || indestructible))`
* Space usage in lists
	* Lists should only have spaces after commas: `var/list/new_list = list(foo, bar, x, y)`

## Merge Request Process


* Make sure your merge request complies.

* You are going to be expected to document all your changes in the merge request. Failing to do so will mean delaying it as we will have to question why you made the change. On the other hand, you can speed up the process by making the merge request readable and easy to understand, with diagrams or before/after data.

* Use the changelog system to document your change, which prevents our players from being caught unaware by changes.

* If you are proposing multiple changes, which change many different aspects of the code, you are expected to section them off into different merge requests in order to make it easier to review them and to deny/accept the changes that are deemed acceptable.

* If your merge request is accepted, the code you add no longer belongs exclusively to you but to everyone; everyone is free to work on it, but you are also free to support or object to any changes being made, which will likely hold more weight, as you're the one who added the feature. It is a shame this has to be explicitly said, but there have been cases where this would've saved some trouble.

* Explain why you are submitting the merge request, and how you think your change will be beneficial to the game. Failure to do so will be grounds for rejecting the MR.

* If your merge request is not finished make sure it is at least testable in a live environment. merge requests that do not at least meet this requirement will be closed. You may reopen the merge request when you're ready, or make a new one.

### Approvals
Valid Approvals are required for an MR to be merged to Dev. Approving an MR implies that certain actions have been taken by the approving party and that certain conditions are met:
1. For MRs that include coding changes, at least one of the approving parties must be a Coder or a Developer+.
2. For MRs that include spriting changes, at least one of the approving parties must be a Spriter+. The Lead Spriter may waive this requirement on a case-by-case basis.
3. For MRs that include mapping changes, at least one of the approving parties must be a Mapper or a Senior Developer+.
4. For MRs with a mixture of changes, all of the above requirements must be met; a Developer+ counts as a Coder and Mapper for this purpose and only one Developer is required in such a case. Additionally, Spriters who contribute to the MR may permit an approving Developer to review the MR in lieu of another Spriter doing so; the Lead Spriter may veto this to review it themselves at their discretion.
5. The approving party must observe all changes in the MR relevant to their rank and conclude that they fit our standards of quality.
6. Approving parties must ensure that necessary testing has been conducted in a satisfactory manner (see Testing below).

All Merge Requests must wait for the CI pipeline to complete before merging unless there is a confirmed issue with the unit tests themselves.

Merge Requests require two valid Approvals to merge into Dev immediately, or one valid Approval by a Developer or higher and at least 24 hours of awaiting further approval. MRs should only be approved once all discussions opened during review of the MR are resolved.

Once a Merge Request is approved and merged into dev, ensure that all changelog files are forwarded to the Wiki Maintainer, as well as any art assets or additional information they request.

## Updating Master
The master branch, in place to act as the stable build of the game, should remain separate from upcoming changes in the dev branch.

In order to update master with new changes, a "dev to master" must be overseen by the Head Developer. This is performed by submitting a Merge Request from dev into master. Before merge, all changelogs must be compiled via the changelog generation tool.

Dev to masters must be preceded by a period of live testing on the dev branch, and any new runtimes and bugs must be handled before a merge is considered.

## Testing
Testing of new features is absolutely vital to ensuring smooth integration of new and changed content. It’s also deceptively necessary even for small bugfixes and features or tiny tweaks; it’s all too easy to change just a line or two, assume that it works, and push it because it compiles.

## Unit Testing
Unit Testing allows you to run large scale tests quickly by writing out a set of instructions for the server to run by itself. They can be defined under ```/test``` and can be triggered in the debug tools, as well as during any MR build test. When the code can be tested quickly by the server, consider writing a unit test for it (meaning if your code has to wait for an event or sleep, don't write a test).

### Before Merging
The following are mandatory before merging an MR into Dev, to be overridden only by those with Dev to Master merge permissions, and only in emergency or immediately-rectifiable cases (i.e. a single forgotten escape character or quotation mark to close a string).
1. Compile locally. This is to save you time waiting for the pipeline to fail.
2. Run a local instance and directly test that the intended change has occurred. Enlist additional help in #dev-test if you need extra hands. Some high-level changes are too complex to fully test without the server’s population stressing them, but it’s best to at least test that the new content doesn’t produce runtime errors or etc.
3. Test for unintended consequences where possible. Consider what other elements of the game may interact with the change and simulate what might occur. For example, test what happens when a machine is blown up while it’s performing some process, ensure that a new action can’t be taken while stunned or knocked down, and so on.
4. Observe that the CI pipeline for your MR has completed with no issues.

### Local Testing
Dream Daemon can be unintuitive to set up. This document will cover the basic steps for setting up a local instance for testing with. It won’t go over port forwarding; Google handles that nicely.

1. Compile, if you haven’t already.
2. Start Dream Daemon from the gear icon in the BYOND hub.
3. Locate and select the Colonial Marines repository .dmb file for running.
4. Set the trust level to Trusted.
5. Set a fixed port, and forward it if you haven’t already.
6. Ensure that your repository has btime.dll in the same directory as the .dmb file generated from compiling. This is necessary for the process scheduler to function.
7. Press Go, wait for the server to spin up, and enter with the small yellow Join button.

Be sure Dream Daemon is inactive when compiling, as it locks up assets and prevents recompiling in some cases.

Unit tests can be run locally with `DreamDaemon ColonialMarinesALPHA.dme someport -trusted -params "run_tests=1&verbose_tests=1"` or by hosting a server and using the debug verbs for running test cases. If you've only made changes relevant to one test set you can use the world parameter `test_set` to run only the specified test set, i.e. 
``-params "run_tests=1&verbose_tests=1&test_set=\"Maps\""``

### Live Testing
The Host, System Administrator, Head Developer, and Senior Developers can change which branch is active on the game server. This allows the Team to test a feature without spoiling other upcoming features in Dev, to test Dev features for a short time to gather feedback before permanent release, and so on.

Senior Developers+ may authorize a test. The Head Dev must be informed of what is being tested and when, prior to conducting the test; it is not necessary to request specific permission to run a test so long as it is authorized by a Senior Developer+, only to ensure that the Head Dev is aware of it.

Public tests must be supervised by at least one Developer+, with the change owner either being present or authorising another Developer+ to oversee their test. Any stand-in Developers for the author must be fully aware of the test's changes and functionality.

Upon completing the public test, follow up with the Head Dev and describe the results of the test and what actions will be taken in response to the collected data. It is among the Head Dev’s responsibilities to compare the Team’s perspective on experimental features to feedback from the community - informing them is essential.
