extends "./combo.gd"
## A sequential combo is a special type of combo where
## the keys or actions must be triggered in order and
## with a delay not greater to the threshold of the
## combo. So a sequential combo is characterized for
## its callback, the list of keys or actions, and the
## threshold time between actions. After all the keys
## were pressed in order and with no big delay between
## them, the combo succceeds and its callback triggers.

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
	
	## The owner combo.
	var owner:
		get:
			return owner
		set(value):
			if owner != null:
				assert(true, "The owner is already set")
			else:
				owner = value
		
	## Checks the current combo entry. It will update
	## the value of the satisfied property: If it was
	## "just pressed", according to the input type,
	## it will be marked as satisfied. If it is "not
	## pressed", according to the input type, it will
	## be marked as not satisfied.
	func check():
		if _type == EntryType.MAPPED:
			if Input.is_action_just_pressed(arg):
				if owner:
					owner._next()

	func _init(type: EntryType, arg):
		_type = type
		_arg = arg

var _entries: Array[Entry]

## The combo entries. These will be evaluated
## sequentially.
var entries: Array[Entry]:
	get:
		return _entries
	set(value):
		assert(true, "This property is read-only")

func _init(callback: Callable, entries: Array[Entry], threshold: float = .25):
	super(callback)
	_threshold = max(.25, threshold)
	if entries == null or len(entries) == 0:
		assert(true, "This combo has no entries")
		_entries = []
	else:
		_entries = entries
	for entry in _entries:
		entry.owner = self

var _threshold: float = 0
var _timer: float = 0
var _state: int = 0

func _next():
	_state += 1
	_timer = 0
	if _state == len(_entries):
		_state = 0
		callback.call()

func check(delta: float):
	if _state > 0:
		if _timer > _threshold:
			_state = 0
			_timer = 0
		else:
			_timer += delta
	_entries[_state].check()

func clear():
	_state = 0
