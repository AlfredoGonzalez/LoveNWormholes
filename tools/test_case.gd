class_name TestCase
extends RefCounted
## Base class for tests. Methods named test_* are run by tools/run_tests.gd.

var failures: Array[String] = []
var checks := 0

func assert_true(cond: bool, msg := "") -> void:
	checks += 1
	if not cond:
		failures.append("assert_true failed. %s" % msg)

func assert_eq(actual, expected, msg := "") -> void:
	checks += 1
	if typeof(actual) != typeof(expected) or actual != expected:
		failures.append("expected %s, got %s. %s" % [str(expected), str(actual), msg])

func assert_near(actual: float, expected: float, eps := 0.0001, msg := "") -> void:
	checks += 1
	if absf(actual - expected) > eps:
		failures.append("expected ~%s, got %s. %s" % [str(expected), str(actual), msg])
