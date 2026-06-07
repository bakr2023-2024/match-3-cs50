PlayState = Class({ __includes = BaseState })

function PlayState:enter()
	self.board = Board(HVW - 16, 16)
	self.board:initTiles()
end

function PlayState:render()
	self.board:render()
end
