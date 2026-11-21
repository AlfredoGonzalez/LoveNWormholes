extends SceneTree
## Headless test runner: godot --headless --path . --script res://tools/run_tests.gd
## Runs every res://tests/test_*.gd (a TestCase subclass) and exits non-zero on any failure.

func _init() -> void:
	var total_checks := 0
	var failed := 0
	var files: Array[String] = []
	var dir := DirAccess.open("res://tests")
	if dir == null:
		push_error("tests/ folder missing")
		quit(2)
		return
	for f in dir.get_files():
		if f.begins_with("test_") and f.ends_with(".gd"):
			files.append(f)
	files.sort()
	for f in files:
		var script: GDScript = load("res://tests/" + f)
		var t = script.new()
		for m in t.get_method_list():
			var mname: String = m["name"]
			if mname.begins_with("test_"):
				t.failures.clear()
				t.call(mname)
				if t.failures.is_empty():
					print("  ok   %s::%s" % [f, mname])
				else:
					failed += 1
					print("  FAIL %s::%s" % [f, mname])
					for msg in t.failures:
						print("       - " + msg)
		total_checks += t.checks
	print("%d test files, %d checks, %d failing tests" % [files.size(), total_checks, failed])
	quit(1 if failed > 0 else 0)
