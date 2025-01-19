includes("$(scriptdir)/../shared/game_shared.lua")

add_requires("opengl")

target("vgui")
do
  set_kind("shared")
  on_build("windows", function(target)
    local vgui_libdir = path.join(os.projectdir(), "utils", "vgui", "lib", "win32_vc6")
    os.cp(path.join(vgui_libdir, "vgui.lib"), target:targetfile())
  end)
  on_build("linux", "macosx", function(target)
    local ext_lib = target:is_plat("linux") and "so" or "dylib"
    local vgui_libdir = path.join(os.projectdir(), "utils", "vgui", "lib", "linux")
    os.cp(path.join(vgui_libdir, "vgui.%s"):format(ext_lib), target:targetfile())
  end)
end

target("SDL2")
do
  set_kind("shared")
  if is_plat("macosx") then
    set_suffixname("-2.0")
    set_extension(".dylib.0")
  elseif not is_plat("windows") then
    set_suffixname("-2.0")
    set_extension(".so.0")
  end
  on_build("windows", function(target)
    local sdl2_libdir = path.join(os.projectdir(), "external", "SDL2", "lib")
    os.cp(path.join(sdl2_libdir, "SDL2.lib"), target:targetfile())
  end)
  on_build("linux", "macosx", function(target)
    local ext_lib = target:is_plat("linux") and "so" or "dylib"
    local sdl2_libdir = path.join(os.projectdir(), "external", "SDL2", "lib")
    os.cp(path.join(sdl2_libdir, "libSDL2-2.0.%s.0"):format(ext_lib), target:targetfile())
  end)
end

target("client")
do
  set_defaults()
  set_kind("shared")
  add_deps("vgui", "SDL2")
  add_packages("opengl", "libnyquist", "openal")

  -- compiler flags
  if is_plat("windows") then
    add_links("delayimp", "winsock32")
  end
  if is_plat("macosx") then
    add_frameworks("Carbon")
  end
  add_includedirs(
    "../server",
    "../server/entities",
    "../server/entities/NPCs",
    "../server/gamerules",
    "../shared/entities",
    "../shared/entities/items/weapons",
    "$(scriptdir)",
    "input",
    "particleman",
    "rendering",
    "ui",
    "ui/hud",
    "ui/vgui",
    "ui/vgui/utils",
    "../../public",
    "../../common",
    "../shared",
    "../shared/player_movement",
    "../shared/saverestore",
    "../shared/utils",
    "../../engine",
    "../../../utils/vgui/include"
  )
  add_defines("CLIENT_DLL", "HL_DLL")

  -- sources
  add_files(
    "*.cpp|DelayLoad.cpp",
    "hl/*.cpp",
    "input/*.cpp",
    "networking/*.cpp",
    "particleman/*.cpp",
    "prediction/*.cpp",
    "rendering/*.cpp",
    "sound/*.cpp",
    "ui/*.cpp",
    "ui/hud/*.cpp",
    "ui/vgui/*.cpp",
    "ui/vgui/utils/*.cpp",
    "../../public/*.cpp"
  )
  add_game_shared_sources()
  add_pcxxheader("ui/hud/hud.h")

  -- hooks
  on_config(function (target)
    local msvc = import("core.tool.toolchain").load("msvc", { plat = target:get("plat"), arch = target:get("arch") })
    if target:is_plat("windows") and msvc then
      target:add("ldflags", "/DELAYLOAD:openal-hlu.dll")
      target:add("files", "DelayLoad.cpp")
    end
  end)
end
