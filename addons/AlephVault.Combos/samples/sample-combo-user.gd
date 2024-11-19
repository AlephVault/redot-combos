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
