--
-- Author: liyang
-- Date: 2015-10-25 00:00:00
--
local ShuiGuan = class("ShuiGuan", function(x,y,shuiguanIndex)
	shuiguanIndex = shuiguanIndex or math.round(math.random()*1000 % 3)
	local sprite = display.newSprite("#shuiguan0_"..shuiguanIndex..".png")
	sprite.shuiguanIndex = shuiguanIndex
	sprite.x = x
	sprite.y = y
	--水管方向 0不变 1 90度 2 180度 3 270度
	sprite.direction = 0
	--水管颜色 0 灰色  1左侧绿 2右侧红 3成功绿
	sprite.yel = 0
	return sprite
end)

function ShuiGuan:ctor()

end

function ShuiGuan:changeDirection()
	if self.direction < 3 then
		self.direction = self.direction + 1
	else
		self.direction = 0
	end
	self:stopAllActions()
	local rotationAction = cc.RotateTo:create(0.1,self.direction * 90)
	self:runAction(rotationAction)
end

function ShuiGuan:changeType(yel)
	self.yel = yel
	local str = string.format("shuiguan%d_%d.png",self.yel,self.shuiguanIndex)
	self:setSpriteFrame(display.newSpriteFrame(str))
end

function ShuiGuan.getWidth()
	local sprite = display.newSprite("#shuiguan0_0.png")
	return sprite:getContentSize().width
end

return ShuiGuan