function GenerateQuads(atlas)
	local sW, sH = atlas:getWidth() / 32, atlas:getHeight() / 32
	local quads = {}
	for y = 0, sH - 1 do
		for x = 0, sW - 1 do
			quads[#quads + 1] = love.graphics.newQuad(x * 32, y * 32, 32, 32, atlas)
		end
	end
	return quads
end

local rand = math.random
function GetRandomColors()
	local arr = {}
	for i = 1, 18 do
		arr[i] = i
	end
	for i = #arr, 2, -1 do
		local r = rand(i)
		arr[i], arr[r] = arr[r], arr[i]
	end
	local slice = {}
	for i = 1, SUBSET do
		slice[i] = arr[i]
	end
	return slice
end
