-- jnvui/tests/test_all.lua
-- Run all tests

print(string.rep("=", 50))
print("Running all jnvui tests")
print(string.rep("=", 50))
print()

-- Test 1
print("[1/6] Component creation")
dofile(vim.fn.stdpath("config") .. "/lua/jnvui/tests/test_component.lua")
print()

-- Test 2
print("[2/6] Element creation")
dofile(vim.fn.stdpath("config") .. "/lua/jnvui/tests/test_element.lua")
print()

-- Test 3
print("[3/6] Error: nil component")
dofile(vim.fn.stdpath("config") .. "/lua/jnvui/tests/test_error_nil_component.lua")
print()

-- Test 4
print("[4/6] Error: invalid buffer")
dofile(vim.fn.stdpath("config") .. "/lua/jnvui/tests/test_error_invalid_buffer.lua")
print()

-- Test 5
print("[5/6] Mount/unmount")
dofile(vim.fn.stdpath("config") .. "/lua/jnvui/tests/test_mount_unmount.lua")
print()

-- Test 6
print("[6/6] Error: useState outside component")
dofile(vim.fn.stdpath("config") .. "/lua/jnvui/tests/test_usestate_error.lua")
print()

print(string.rep("=", 50))
print("All tests completed!")
print(string.rep("=", 50))
