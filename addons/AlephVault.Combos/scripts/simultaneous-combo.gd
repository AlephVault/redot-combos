extends "./combo.gd"
## Simultaneous combos are easier to understand: when
## a relevant key or action is pressed, it is checked
## whether the other relevant keys or actions are also
## pressed. Then, the callback resolves.

class_name AVComboSimultaneous

## This is the entry type. Right now, only "mapped"
## is supported.
enum EntryType {
	MAPPED  # Stands for an "Input Map" defined input.
}

## This is the entry. It is characterized by its type
## and the expected argument.
class Entry:
	"""
	A simple combo entry.
	"""

	var _type: EntryType
	
	## The combo entry type.
	var type: EntryType:
		get:
			return _type
		set(value):
			assert(true, "This property is read-only")

	var _arg
	
	## The combo entry argument (e.g. action when the
	## type is EntryType.MAPPED).
	var arg:
		get:
			return _arg
		set(value):
			assert(true, "This property is read-only")

	var _satisfied: bool
	
	## Whether it's satisfied or not.
	var satisfied: bool:
		get:
			return _satisfied
		set(value):
			assert(true, "This property is read-only")

	## Clears the current combo entry. This is called
	## when the entire combo succeeds.
	func clear():
		_satisfied = false
	
	## Checks the current combo entry. It will update
	## the value of the satisfied property: If it was
	## "just pressed", according to the input type,
	## it will be marked as satisfied. If it is "not
	## pressed", according to the input type, it will
	## be marked as not satisfied.
	func check():
		if _type == EntryType.MAPPED:
			if Input.is_action_just_pressed(arg):
				_satisfied = true
			elif not Input.is_action_pressed(arg):
				_satisfied = false

	func _init(type: EntryType, arg):
		_type = type
		_arg = arg
 
var _entries: Array[Entry]

## The combo entries. These will be evaluated
## simultaneously.
var entries: Array[Entry]:
	get:
		return _entries
	set(value):
		assert(true, "This property is read-only")

var _longpress_time: float

## The time this combo must be pressed for, for
## it to succeed.
var longpress_time: float:
	get:
		return _longpress_time
	set(value):
		assert(true, "This property is read-only")

var _current_longpress_time: float

## Checks all the simultaneous entries. If they
## are all satisfied, then the combo triggers
## its callback and clears itself.
func check(delta: float):
	for entry in _entries:
		entry.check()

	var all_satisfy: bool = true
	var index: int = 0
	for entry in _entries:
		if not entry.satisfied:
			all_satisfy = false
			break
		index += 1
	
	if all_satisfy:
		_current_longpress_time += delta
		if _current_longpress_time > longpress_time:
			clear()
			_callback.call()
	else:
		_current_longpress_time = 0

## Clears the current combo by clearing each of
## the simultaneous entries.
func clear():
	_current_longpress_time
	for entry in _entries:
		entry.clear()

## Initialiation of the combo.
func _init(callback: Callable, entries: Array[Entry], longpress_time: float = 0):
	super(callback)
	if entries == null or len(entries) == 0:
		assert(true, "This combo has no entries")
		_entries = []
	else:
		_entries = entries
	_longpress_time = max(0, longpress_time)
