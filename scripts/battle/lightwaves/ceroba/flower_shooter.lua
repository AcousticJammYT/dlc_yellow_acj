local Basic, super = Class(LightWave)

function Basic:init()
    super:init(self)
    self:setArenaSize(256, 180)
    self:setArenaPosition(319, 320) -- orig 320, 385
    self.type = Game.battle:getEnemyBattler("ceroba_geno").phase
    self.time = 10
    self.nextbulletdir = 1
    self.nextringcolor = 1
    self.siner = 0
end

function Basic:onStart()
    self.timer:after(1/2, function()
        Assets.playSound("ceroba_bullet_rise", 1.5)
        self.bigflower_one = self:spawnBullet("ceroba/flower_large", Game.battle.arena.x, Game.battle.arena.top - 40, math.rad(270), 0)
        self.bigflone_x = self.bigflower_one.x
        self.bigflone_y = self.bigflower_one.y
        self.timer:after(1/2, function()
            Assets.playSound("ceroba_bullet_rise", 1.5)
            self.bigflower_two = self:spawnBullet("ceroba/flower_large", Game.battle.arena.x, Game.battle.arena.bottom + 40, math.rad(270), 0)
            self.bigfltwo_x = self.bigflower_two.x
            self.bigfltwo_y = self.bigflower_two.y
        end)
    end)
    self.timer:after(1.5, function()
        self.timer:every(1/3, function()
            Assets.playSound("ceroba_bullet_shot")
            if self.nextbulletdir == 1 then
                self.nextbulletdir = 2
                -- group 1, vertical
                self:spawnBullet("ceroba/flower", self.bigflower_one.x, self.bigflower_one.y, math.rad(90), 4)
                self:spawnBullet("ceroba/flower", self.bigflower_two.x, self.bigflower_two.y, math.rad(270), 4)
            else
                self.nextbulletdir = 1
                -- group 2, horizontal
                self:spawnBullet("ceroba/flower", self.bigflower_one.x, self.bigflower_one.y, math.rad(45), 4)
                self:spawnBullet("ceroba/flower", self.bigflower_one.x, self.bigflower_one.y, math.rad(135), 4)
                self:spawnBullet("ceroba/flower", self.bigflower_two.x, self.bigflower_two.y, math.rad(225), 4)
                self:spawnBullet("ceroba/flower", self.bigflower_two.x, self.bigflower_two.y, math.rad(315), 4)
            end
        end)
        if self.type == 2 then
            self.timer:every(2, function()
                if self.nextringcolor == 1 then
                    self.nextringcolor = 2
                    -- blue ring
                    local ring_b = self:spawnBullet("ceroba/ring_b", self.bigflower_two.x, self.bigflower_two.y)
                else
                    self.nextringcolor = 1
                    -- orange ring
                    local ring_o = self:spawnBullet("ceroba/ring_o", self.bigflower_one.x, self.bigflower_one.y)
                end
            end)
        end
    end)
end

function Basic:update()
    self.siner = self.siner + DT
    local offset = math.sin(self.siner * 3) * 160
    self.timer:after(1.5, function()
        if self.type == 1 then
            self.bigflower_one:setPosition(self.bigflone_x + offset, self.bigflone_y)
            self.bigflower_two:setPosition(self.bigfltwo_x - offset, self.bigfltwo_y)
        else
            self.bigflower_one:setPosition(self.bigflone_x - offset, self.bigflone_y)
            self.bigflower_two:setPosition(self.bigfltwo_x + offset, self.bigfltwo_y)
        end
    end)

    super.update(self)
end

return Basic