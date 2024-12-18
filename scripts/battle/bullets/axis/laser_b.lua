local AxisLaserBlue, super = Class(Bullet)

function AxisLaserBlue:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/axis/laser_blue")

    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed

    self:setHitbox(0, 0, self.width, 8)

    self.destroy_on_hit = false
    self.sprite:setAnimation({"battle/bullets/axis/laser_blue", 1/8, true})
    self:setScale(1, 1)
end

local function condition(soul)
	return (soul.moving_x ~= 0 or soul.moving_y ~= 0)
end

function AxisLaserBlue:onCollide(soul)
	if condition(soul) then
		return super.onCollide(self, soul)
	end
end

function AxisLaserBlue:update()
    local soul = Game.battle.soul

    if self.bounce == false then
        goto ending
    end
	if not condition(soul) then
		self.grazed = true
	end

    if self:collidesWith(Game.battle.arena.collider.colliders[1]) then
        if self.physics.direction == -math.pi / 2 then
            self.physics.direction = math.pi / 2
        end
    end

    if self:collidesWith(Game.battle.arena.collider.colliders[2]) then
        if self.physics.direction == 0 then
            self.physics.direction = math.pi
        end
    end

    if self:collidesWith(Game.battle.arena.collider.colliders[3]) then
        if self.physics.direction == math.pi / 2 then
            self.physics.direction = -math.pi / 2
        end
    end

    if self:collidesWith(Game.battle.arena.collider.colliders[4]) then
        if self.physics.direction == math.pi then
            self.physics.direction = 0
        end
    end

    ::ending::
    super.update(self)
end

return AxisLaserBlue