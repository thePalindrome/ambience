print("Ambience 0.0.0 loaded! Wubba lubba dub dub!")

local MUSICVOLUME = 1
local SOUNDVOLUME = 1

local volume = {}
local music = {}
local sounds = {}
local world_path = minetest.get_worldpath()


local function load_volumes()
    local file, err = io.open(world_path.."/ambience_volumes", "r")
    if err then
        return 
    end
    for line in file:lines() do
        local config_line = string.split(line, ":")
        volume[config_line[1]] = {music=config_line[2],sound=config_line[3]}
    end
    file:close()
end

local function load_config()
    -- Load /ambience_music/config and /ambience_sounds/config
end

local function load_music()
    music = minetest.get_dir_list(world_path.."/ambience_music", "r")
end

local function load_sounds()
    sounds = minetest.get_dir_list(world_path.."/ambience_sounds", "r")
end


load_volumes()
load_config
load_music()
load_sounds()

local function play_music(player,filename)
	local db = volume[player:get_player_name()]
	if db.music_handle ~= nil then
		minetest.sound_stop(db.music_handle)
	end
	db.music_handle = minetest.sound_play(filename, {
		to_player = player:get_player_name(),
		gain = 1.0,
	})
end

minetest.register_on_joinplayer(function(player)
    if volume[player:get_player_name()] == nil then
        volume[player:get_player_name()] = {music=MUSICVOLUME, sound=SOUNDVOLUME}
    end
    volume[player:get_player_name()].music_handle = nil
    volume[player:get_player_name()].sound_handle = nil
end)
minetest.register_chatcommand("volume", {
    description = "View sliders to set sound a music volume",
    func = function(name,param)
        minetest.show_formspec(name, "ambience:volume",
            "size[6,3.5]" ..
            "label[0,0.5;Music]" ..
            "scrollbar[0,1;5.8,0.4;horizontal;music;" .. volume[name].music * 1000 .. "]" ..
            "label[0,1.5;Sound]" ..
            "scrollbar[0,2;5.8,0.4;horizontal;sound;" .. volume[name].sound * 1000 .. "]" ..
            "button_exit[2,2.8;2,0.8;quit;Done]"
            )
    end,
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "ambience:volume" then
        return false
    end
    minetest.log(dump(fields))
    if fields.quit ~= "true" then
        volume[player:get_player_name()].music = tonumber(string.split(fields.music,":")[2]) / 1000
        volume[player:get_player_name()].sound = tonumber(string.split(fields.sound,":")[2]) / 1000
    end
    if fields.quit then
        local file, err = io.open(world_path.."/ambience_volumes", "w")
        if not err then
            for item in pairs(volume) do
                file:write(item..":"..volume[item].music..":"..volume[item].sound.."\n")
            end
            file:close()
        end
    end
    return true
end)

local delay = 0
minetest.register_globalstep(function(dtime)
delay += dtime
if delay < 5 then
    return
end

delay = 0

    for _,player in ipairs(minetest.get_connected_players()) do

        if volume[player:get_player_name()].music_handle == nil then -- only play one song at a time
            -- Pick a song, roll the dice
        end

        -- Somehow decide on ambient sounds (these can overlap)

    end

end)
