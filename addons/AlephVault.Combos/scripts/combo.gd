extends Object
## This is the base combo class. Children
## classes are defined in this package, but
## there are common concepts: a callable that
## will be triggered when the combo succeeds,
## the ability to manually clear a combo, and
## the ability to check a combo for completion,
## which should be done in a _process or perhaps
## _physics_process callback. Chcking a combo
## for completion is combo-dependent and will
## trigger its callback on completion.

var _callback: Callable

## The callback that will be executed.
var callback: Callable:
	get:
		return _callback

## Checks the entire combo for status and
## completion. It will, most likely, update
## the combo status at some point. Also, it
## will execute the callback specified at
## the `callback` property.
func check(_delta: float):
	assert(true, "AVCombo's check() is not implemented")

## Clears the combo (resets its state so it
## doesn't remember anything and can be run
## from scratch by the player).
func clear():
	assert(true, "AVCombo's clear() is not implemented")

func _init(callback: Callable):
	if callback == null:
		assert(true, "This combo will not work: its callback is null")
		_callback = (func() -> void: pass)
	else:
		_callback = callback
