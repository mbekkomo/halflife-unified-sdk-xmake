includes("../shared/game_shared.lua")

target("server")
do
  set_defaults()
  set_kind("shared")

  -- compiler flags
  add_includedirs(
  	"$(scriptdir)",
  	"entities",
  	"entities/items",
  	"../shared/entities",
  	"../shared/entities/items/weapons",
  	"entities/NPCs",
  	"gamerules",
  	"../../engine",
  	"../../common",
  	"../shared",
  	"../shared/player_movement",
  	"../shared/saverestore",
  	"../shared/utils",
  	"../../public"
  )
  add_defines("VALVE_DLL")

  -- sources
  if is_plat("windows") then
    add_files("server.def")
  end
  add_files(
    "*.cpp",
    "bot/*.cpp",
    "config/*.cpp",
    "config/sections/*.cpp",
    "entities/*.cpp",
    "entities/ctf/*.cpp",
    "entities/items/*.cpp",
    "entities/items/weapons/*.cpp",
    "entities/rope/*.cpp",
    "entities/NPCs/*.cpp",
    "entities/NPCs/aliens/*.cpp",
    "entities/NPCs/blackmesa/*.cpp",
    "entities/NPCs/blackops/*.cpp",
    "entities/NPCs/military/*.cpp",
    "entities/NPCs/other/*.cpp",
    "entities/NPCs/racex/*.cpp",
    "entities/NPCs/zombies/*.cpp",
    "gamerules/*.cpp",
    "sound/*.cpp",
    "../../common/*.cpp",
    "../../engine/*.cpp",
    "../../public/*.cpp"
  )
  add_game_shared_sources()
  add_pcxxheader("entities/cbase.h")
end
