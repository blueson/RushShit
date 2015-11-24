local GameScene = class("GameScene", function()
	return display.newScene("GameScene")
end)

local game_data = require("app.data.game_data")
local ShuiGuan = import("app.item.ShuiGuan")

function GameScene:ctor()
	self:addNodeEventListener(cc.NODE_EVENT, function(event)
		if event.name == "enterTransitionFinish" then
			self:initShuiGuan()
		end
	end)

	self.firstX = (display.width - ShuiGuan.getWidth() * game_data.xCount) / 2
	self.firstY = (display.height - ShuiGuan.getWidth() * game_data.yCount) / 2 - 30
	print("shuiguan.width:"..ShuiGuan.getWidth())
	print("firstX:"..self.firstX)
	print("firstY:"..self.firstY)
end

function GameScene:initShuiGuan()
	self.shuiguanList = {}
	local shuiguan = ShuiGuan.new(1,1);
	shuiguan:pos(self.firstX,self.firstY):addTo(self)
	-- for y=1,game_data.yCount do
	-- 	for x=1,game_data.xCount do
			
	-- 	end
	-- end
end

return GameScene