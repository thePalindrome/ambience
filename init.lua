print("Ambience 0.0.0 loaded! Wubba lubba dub dub!")

local music_handle = nil -- TODO: Make these per player
local music_gain = 1
local sound_handle = nil
local sound_gain = 1

local function play_music(filename)
	if music_handle ~= nil then
		minetest.sound_stop(music_handle)
	end
	music_handle = minetest.sound_play(filename, {
		gain = 1.0,
	})
end
