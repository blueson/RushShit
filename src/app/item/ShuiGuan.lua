--
-- Author: liyang
-- Date: 2015-10-25 00:00:00
--
local ShuiGuan = class("ShuiGuan", function(x,y,shuiguanIndex)
	shuiguanIndex = shuiguanIndex or math.round(math.random()*1000 % 4)
	local sprite = display.newSprite("#shuiguan_0_"..shuiguanIndex..".png")
	sprite.shuiguanIndex = shuiguanIndex
	sprite.x = x
	sprite.y = y
	--水管方向 0不变 1 90度 2 180度 3 270度
	sprite.direction = 0
	--水管颜色 0 灰色  1左侧绿 2右侧红 3成功绿
	sprite.type = 0
	return sprite
end)

function ShuiGuan:ctor()

end

function ShuiGuan.getWidth()
	local sprite = display.newSprite("#shuiguan_0_0.png")
	return sprite:getContentSize().width
end

return ShuiGuan