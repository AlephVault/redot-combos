# AlephVault - Combos

This repository contains a Redot package to create "combos" (as in fight games, incl. special attacks) for your games.

## Installation

This package might be available in the Redot/Godot Asset Library. However, it can also be installed right from this repository,
provided the contents of the `addons/` directory are added into the project's `addons/` directory.

## Usage

Once added to the project, the global namespace class `AlephVault__Combos` will be available.

There are many features made available in that namespace:

### The base Combo class

There's a base `AlephVault__Combos.Combo` class from which two combo sub-classes are available.

This class contains the following common details about the combos:

1. There's a `callback` that will trigger when this combo succeeds.
2. There's a `check(delta)` method that should (this applies for respective combo subclasses)
   be invoked either in `_process(delta)` or `_physics_process(delta)` of some node subclass.
   This method ensures the combo is checked for validity (proper input is triggered) and then
   will trigger the said `callback` on success. The implementation, however, is delegated to
   the derived classes.
3. There's also a `clear()` method. That method's implementation is delegated to the derived
   classes. The idea of this method is to clear whatever status of the combo is set right now.
   This means that, after this method is called, the user must restart the execution of the
   combo.

### The reliance on input mappings

These combos, so far, rely only on input mappings. This means that, in all the examples that
will be given here, it is assumed that the user will have those input names as properly mapped
into the project's `Input Map` section. **If the maps are not created, these examples will not
work at all**.

Future versions will add options to directly rely on joystick buttons, keyboard keys, or even
mouse buttons. But, for now, this package only supports `Input Map`-declared inputs.

### Simultaneous combos

This class will be publicly available: `AlephVault__Combos.SimultaneousCombo`.

There are some combos with a simultaneous mechanic: it doesn't matter which keys are pressed
in which order, as long as they're all pressed. Consider the following example, where a combo
expects for inputs "Button1", "Button2" and "DPadUp" to be pressed simultaneously and, on
success, it will print `Hello World`:

```gdscript
extends Node

var _combo = AlephVault__Combos.SimultaneousCombo.new(
	func():
		print("Hello World"),
	[
		AlephVault__Combos.SimultaneousCombo.Entry.new(
			AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "Button1"
		),
		AlephVault__Combos.SimultaneousCombo.Entry.new(
			AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "Button2"
		),
		AlephVault__Combos.SimultaneousCombo.Entry.new(
			AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "DPadUp"
		),
	]
)

func _process(delta):
    _combo.check(delta)
```

There are some things to understand here:

1. Combos are checked on each frame (it's everything about checking Input stuff). These
   combos are not the exception to that rule.
2. When the three keys are pressed, the combo triggers and `Hello World` is printed to
   the debug interface. After that, the combo is reset. This means that the player will
   have to press the three (in this case, there are three) keys again.
3. Ensure the mapping names (when using MAPPING-typed entries, which is supported since
   the first version of this package) are properly defined in the project's `Input Map`
   configuration section.
4. Please notice that keyboards have a buffer capacity. Don't define combos with more
   than 4 inputs if those inputs are expected to be mapped against keyboard keys.

#### Long-press simultaneous combos

Certain games might require players not to just press a single key or set of keys or
whatever action is defined, but also _to keep them pressed for some time_. In this case,
we can add a custom press time to our combo:

```gdscript
extends Node

var _combo = AlephVault__Combos.SimultaneousCombo.new(
	func():
		print("Hello World"),
	[
		AlephVault__Combos.SimultaneousCombo.Entry.new(
			AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "Button1"
		),
		AlephVault__Combos.SimultaneousCombo.Entry.new(
			AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "Button2"
		),
		AlephVault__Combos.SimultaneousCombo.Entry.new(
			AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "DPadUp"
		),
	], 3  # Expressed in seconds
)

func _process(delta):
    _combo.check(delta)
```

In this case, the player must press these keys for three (3) seconds (without releasing
any of them in the middle) for the combo to succeed. Not just press them the first time.

### Sequential Combos

This class will be publicly available: `AlephVault__Combos.SequentialCombo`.

Most games making use of combos implement them as, actually, _sequential_ combos rather than
simultaneous combos. Sequential combos require certain keys being pressed in certain order,
and always... not taking that much. The typicall maximum allowed delay between keys in the
sequence is between 0.25 seconds and 1 second, but users are free to configure this.

Some well-known examples of sequential combo is:

1. In Mortal Kombat saga, Liu Kang's low fireball is: `> > LowPunch`.
2. The Konami code: `^ ^ v v < > < > B A {start}`.
3. Super Smash Bros has small and shared combos: `> B`, `^ B`, `v B`, `B`, ...

Implementing the Konami code would look like this, provided all the inputs are properly
defined in the input map:

```gdscript
extends Node

var _combo = AlephVault__Combos.SequentialCombo.new(
	func():
		print("Hello World"),
	[
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "DPadUp"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "DPadUp"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "DPadDown"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "DPadDown"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "DPadLeft"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "DPadRight"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "DPadLeft"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "DPadRight"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "ButtonA"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "ButtonB"
		),
		AlephVault__Combos.SequentialCombo.Entry.new(
			AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "ButtonStart"
		),
	], 0.5  # At most 0.5 seconds between key pressed before the combo resets.
)

func _process(delta):
    _combo.check(delta)
```

There are some things to understand here:

1. Combos are checked on each frame, also for this class.
2. When the whole sequence is completed, the `Hello World` message will be printed.
3. Same care about the mapping names.
4. Same care about the keyboard buffer.

### Combo Sets

This class will be publicly available: `AlephVault__Combos.ComboSet`.

ComboSets allow checking and clearing several combos in a loop. They're **not** combo subclasses
but a convenience class to group many combos together. An example is also given in the `samples/`
directory and looks like this:

```gdscript
extends Node

var _set: AlephVault__Combos.ComboSet = AlephVault__Combos.ComboSet.new([
	AlephVault__Combos.SimultaneousCombo.new(
		func():
			print("Combo A succeeded"),
		[
			AlephVault__Combos.SimultaneousCombo.Entry.new(
				AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "B1"
			),
			AlephVault__Combos.SimultaneousCombo.Entry.new(
				AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "B2"
			),
			AlephVault__Combos.SimultaneousCombo.Entry.new(
				AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "Right"
			),
		]
	),
	AlephVault__Combos.SimultaneousCombo.new(
		func():
			print("Combo B succeeded"),
		[
			AlephVault__Combos.SimultaneousCombo.Entry.new(
				AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "B3"
			),
			AlephVault__Combos.SimultaneousCombo.Entry.new(
				AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "B4"
			),
			AlephVault__Combos.SimultaneousCombo.Entry.new(
				AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "Down"
			),
			AlephVault__Combos.SimultaneousCombo.Entry.new(
				AlephVault__Combos.SimultaneousCombo.EntryType.MAPPED, "Left"
			),
		], 3
	),
	AlephVault__Combos.SequentialCombo.new(
		func():
			print("Combo C succeeded"),
		[
			AlephVault__Combos.SequentialCombo.Entry.new(
				AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "B1"
			),
			AlephVault__Combos.SequentialCombo.Entry.new(
				AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "B2"
			),
			AlephVault__Combos.SequentialCombo.Entry.new(
				AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "B3"
			),
		], 0.5
	),
	AlephVault__Combos.SequentialCombo.new(
		func():
			print("Combo D succeeded"),
		[
			AlephVault__Combos.SequentialCombo.Entry.new(
				AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "Up"
			),
			AlephVault__Combos.SequentialCombo.Entry.new(
				AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "Up"
			),
			AlephVault__Combos.SequentialCombo.Entry.new(
				AlephVault__Combos.SequentialCombo.EntryType.MAPPED, "Down"
			),
		], 0.5
	),
])

func _process(delta: float):
	_set.check(delta)
```

Typically, a character in a fight game will have an associated combo set, rather than
individual combos, which will change to a "mirrored" one when the player exchanges ring side
(and thus direction) with the opponent.
