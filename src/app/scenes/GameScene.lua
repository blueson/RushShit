local GameScene = class("GameScene", function()
	return display.newScene("GameScene")
end)

local game_data = require("app.data.game_data")
local ShuiGuan = import("app.item.ShuiGuan")
local SHUIGUAN_LEFT = 0
local SHUIGUAN_UP = 1
local SHUIGUAN_RIGHT = 2
local SHUIGUAN_DOWN = 3

local SHUIGUAN_GRAY = 0
local SHUIGUAN_RED = 1
local SHUIGUAN_GREEN = 2
local SHUIGUAN_LIGHT_GREEN =3

function GameScene:ctor()
	display.newSprite("main_bg.png"):pos(display.cx,display.cy):addTo(self)

	self:addNodeEventListener(cc.NODE_EVENT, function(event)
		if event.name == "enterTransitionFinish" then
			self:initShuiGuan()
		end
	end)

	self.firstX = (display.width - ShuiGuan.getWidth() * (game_data.xCount + 1)) / 2 + ShuiGuan.getWidth()/2
	self.firstY = (display.height - ShuiGuan.getWidth() * game_data.yCount) / 2 - 100
end

--初始化水管
function GameScene:initShuiGuan()
	self.shuiguanList = {}
	for y=1,game_data.yCount do
		for x=1,game_data.xCount do
			self.shuiguanList[(y -1)*game_data.xCount + x] = self:createAndDropShuiguan(x,y)
		end
	end

	self:checkShuiguan()
end

--创建并移动水管
function GameScene:createAndDropShuiguan(x,y)
	local endPosition = self:positionOfShuiguan(x,y)
	local startPoint = cc.p(endPosition.x,self.firstY + ShuiGuan.getWidth() * game_data.yCount)
	local shuiguan = ShuiGuan.new(x,y):pos(startPoint.x,startPoint.y):addTo(self)
	local speed = y / ShuiGuan.getWidth()
	shuiguan:runAction(cc.MoveTo:create(speed,endPosition))
	shuiguan:setTouchEnabled(true)
	shuiguan:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event,sender)
		print(event.name)
		if event.name == "began" then
			return true
		end

		if event.name == "ended" then
			shuiguan:changeDirection()
			self:clearShuiguan()
			self:checkShuiguan()
		end
	end)
	return shuiguan
end

function GameScene:positionOfShuiguan(x,y)
	local x = self.firstX + ShuiGuan.getWidth() * (x - 1) + ShuiGuan.getWidth()/2
	local y = self.firstY + ShuiGuan.getWidth() * (y - 1) + ShuiGuan.getWidth()/2
	return cc.p(x,y) 
end

function GameScene:clearShuiguan()
	for _,shuiguan in pairs(self.shuiguanList) do
		shuiguan:changeType(SHUIGUAN_GRAY)
	end
end

--检查水管的连接
function GameScene:checkShuiguan()
	for y=1,game_data.yCount do
		self:checkLeftShuiguan(self:getShuiguanInList(1,y),SHUIGUAN_RIGHT,SHUIGUAN_RED)
		self:checkLeftShuiguan(self:getShuiguanInList(game_data.xCount,y),SHUIGUAN_LEFT,SHUIGUAN_GREEN)
	end
end

function GameScene:printShuiguanYel()
	for y=1,game_data.yCount do
		for x=1,game_data.xCount do
			
		end
	end
end

--检查左侧水管的连接
function GameScene:checkLeftShuiguan(shuiguan,dir,yel)
	if shuiguan.yel ~= SHUIGUAN_GRAY then
		return
	end

	local canLeft = self:isConnectLeft(shuiguan)
	local canUp = self:isConnectUp(shuiguan)
	local canRight = self:isConnectRight(shuiguan)
	local canDown = self:isConnectDown(shuiguan)
	if (canLeft and dir == SHUIGUAN_RIGHT) 
		or (canRight and dir == SHUIGUAN_LEFT)
		or (canUp and dir == SHUIGUAN_DOWN)
		or (canDown and dir == SHUIGUAN_UP) then

		shuiguan:changeType(yel)
	end

	if shuiguan.yel == SHUIGUAN_GRAY then
		return
	end

	if canLeft then
		local x = shuiguan.x - 1
		local y = shuiguan.y
		if x >= 1 then
			self:checkLeftShuiguan(self:getShuiguanInList(x,y),SHUIGUAN_LEFT,yel)
		end
	end
	if canUp then
		local x = shuiguan.x
		local y = shuiguan.y + 1
		if y <= game_data.yCount then
			self:checkLeftShuiguan(self:getShuiguanInList(x,y),SHUIGUAN_UP,yel)
		end
	end
	if canRight then
		local x = shuiguan.x + 1
		local y = shuiguan.y
		if x <= game_data.xCount then
			self:checkLeftShuiguan(self:getShuiguanInList(x,y),SHUIGUAN_RIGHT,yel)
		end
	end
	if canDown then
		local x = shuiguan.x
		local y = shuiguan.y - 1
		if y >= 1 then
			self:checkLeftShuiguan(self:getShuiguanInList(x,y),SHUIGUAN_DOWN,yel)
		end
	end
end

--检查右侧水管的连接
function GameScene:checkRightShuiguan(shuiguan)
	
end

function GameScene:getShuiguanInList(x,y)
	local index = (y - 1) * game_data.xCount + x
	return self.shuiguanList[index]
end

--是否连接左边
function GameScene:isConnectLeft(shuiguan)
	local isLeftConnect = false
	if shuiguan.shuiguanIndex == 0 and (shuiguan.direction == 1 or shuiguan.direction == 3) then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 1 then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 2 and (shuiguan.direction == 2 or shuiguan.direction == 3) then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 3 and (shuiguan.direction == 0 or shuiguan.direction == 2 or shuiguan.direction == 3) then
		isLeftConnect = true
	end
	return isLeftConnect
end

--是否连接上边
function GameScene:isConnectUp(shuiguan)
	local isLeftConnect = false
	if shuiguan.shuiguanIndex == 0 and (shuiguan.direction == 0 or shuiguan.direction == 2) then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 1 then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 2 and (shuiguan.direction == 0 or shuiguan.direction == 3) then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 3 and (shuiguan.direction == 0 or shuiguan.direction == 1 or shuiguan.direction == 3) then
		isLeftConnect = true
	end
	return isLeftConnect
end

--是否连接右边
function GameScene:isConnectRight(shuiguan)
	local isLeftConnect = false
	if shuiguan.shuiguanIndex == 0 and (shuiguan.direction == 1 or shuiguan.direction == 3) then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 1 then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 2 and (shuiguan.direction == 0 or shuiguan.direction == 1) then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 3 and (shuiguan.direction == 0 or shuiguan.direction == 1 or shuiguan.direction == 2) then
		isLeftConnect = true
	end
	return isLeftConnect
end

--是否连接下边
function GameScene:isConnectDown(shuiguan)
	local isLeftConnect = false
	if shuiguan.shuiguanIndex == 0 and (shuiguan.direction == 0 or shuiguan.direction == 2) then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 1 then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 2 and (shuiguan.direction == 1 or shuiguan.direction == 2) then
		isLeftConnect = true
	elseif shuiguan.shuiguanIndex == 3 and (shuiguan.direction == 1 or shuiguan.direction == 2 or shuiguan.direction == 3) then
		isLeftConnect = true
	end
	return isLeftConnect
end

return GameScene