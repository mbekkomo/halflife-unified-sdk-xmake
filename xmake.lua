set_xmakever("2.9.7")

set_project("halflife-mod")
set_version("0.0.0")

add_rules("mode.debug", "mode.release", "mode.releasedbg")
add_rules("mode.asan", "mode.lsan", "mode.ubsan")

-- TODO: add defaults
function set_defaults()
end
