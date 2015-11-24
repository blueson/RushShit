
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
	display.newSprite("main_bg.png")
		:pos(display.cx,display.cy)
		:addTo(self)

	cc.ui.UIPushButton.new({normal = "start.png",pressed = "start.png"},{scale9 = false})
		:onButtonClicked(function()
			display.replaceScene(require("app.scenes.GameScene").new(), "RANDOM", 0.2)
		end)
		:pos(display.cx,display.cy)
		:addTo(self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
