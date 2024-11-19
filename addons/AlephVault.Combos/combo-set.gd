extends Object
## This class is a shortcut to defining a set
## of combos.

const _ComboBase = preload("./combo.gd")

var _combos: Array[_ComboBase] = []

## The list of combos.
var combos: Array[_ComboBase]:
	get:
		return _combos

## Performs a check in all the combos.
func check(delta: float):
	for combo in _combos:
		combo.check(delta)

func _init(combos: Array[_ComboBase]):
	if combos == null or len(combos) == 0:
		assert(true, "This combo set is empty")
		_combos = []
	else:
		_combos = combos
