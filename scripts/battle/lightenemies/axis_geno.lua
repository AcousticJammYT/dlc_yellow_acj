local Axis, super = Class(LightEnemyBattler)

function Axis:init()
    super:init(self)

    self.name = "Axis"
    self:setActor("axisboss_g")

    self.max_health = 800
    self.health = 800
    self.attack = 19
    self.defense = 15
    self.money = 0
    self.experience = 200
    self.spare_percentage = 0

    if Game:getFlag("steamworks_kills") == 20 then
        self.geno_aborted = false
    else
        self.geno_aborted = true
    end

    self.display_damage_on_miss = true

    self.dialogue_bubble = "ut_wide"
    self.dialogue_offset = {-30, 10}

    self.waves = {
        "axis/axis_g_first"
    }

    --[[self.dialogue = {
        "[wave:3][speed:0.5]....."
    }]]

    self.check = "ATK "..self.attack.." DEF "..self.defense

    self.text = {
        "* Can't hold out forever.",
        "* In your way.",
        "* Outlast his efforts.",
        "* One is all it will take. Keep\ngoing.",
        "* Finish what you started.",
        "* They are responsible.",
        "* A road ahead.",
        "* . . ."
    }

    self.spareable_text = "* Axis has cooled off."

    self:registerAct("Push")
    self:registerAct("Taunt")
    self:registerAct("Toughen")

    self.gauge_size = {250, 18}

    self.damage_offset = {0, 42}
    self.can_shake = false
end

function Axis:spare(pacify)
    Assets.playSound("vaporized")
    self:defeat("SPARED", false)
end

function Axis:onDefeat(damage, battler)
    if Game.battle.battle_ui.attacking then
        Game.battle.battle_ui:endAttack()
    end
    Game.battle:setState("NONE")
    Game.battle:startCutscene("axis_geno", "death")
end

function Axis:getAttackDamage(damage, battler, points)
    return 0
end

function Axis:onAct(battler, name)
    if name == "Check" then
        return "* AXIS -- "..self.check
    elseif name == "Push" then
        return "* You pressure Axis' defense but\nhe stands firm."
    elseif name == "Taunt" then
        return {
            "* You tell Axis that his time is\nup.",
            "* He chooses not to respond."
        }
    elseif name == "Toughen" then
        return {
            "* You grip your sidearm with\nenmity...",
            "* Something stirs inside."
        }
    elseif name == "Standard" then
        return "* But there was nothing to say."
    end

    return super:onAct(self, battler, name)
end

function Axis:hurt(amount, battler, on_defeat, color, anim, attacked)
    Assets.playSound("graze", 2, 0.8)
    local message
    message = self:lightStatusMessage("damage", amount, color or (battler and {battler.chara:getLightDamageColor()}))
    if message and anim then
        message:resetPhysics()
    end
    self.health = self.health - amount

    self:onHurt(amount, battler)

    self:checkHealth(on_defeat, amount, battler)
    return
end

function Axis:getEnemyDialogue()
    if self.geno_aborted then
        if Game.battle.encounter.turns_passed == 7 then
            return "HoW L0NG ARE wE\nGOInG TO DO\nTHIS?"
        elseif Game.battle.encounter.turns_passed == 8 then
            return {"I DID nOT THiNK\nBOTS COuLD GET\nTIR3D.", "BUT HeRE I AM.\nTIRED AS [heck]."}
        elseif Game.battle.encounter.turns_passed == 9 then
            return "STILL_ GoiNG,. ."
        elseif Game.battle.encounter.turns_passed == 10 and not self.tired then
            return {"\"hey axis please\ndo another sick\nattack.\"", "OK BuT JUST\nBEC4USE Y0U ASKED\nNIcELY."}
        end
    end
    return nil
end

function Axis:getNextWaves()
    if self.tired then
        return nil
    elseif Game.battle.encounter.turns_passed == 0 then
        return {"axis/axis_g_first"}
    elseif Game.battle.encounter.turns_passed == 1 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 2 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 3 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 4 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 5 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 6 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 7 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 8 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 9 then
        return {"axis/axis_g_second"}
    elseif Game.battle.encounter.turns_passed == 10 then
        return {"axis/axis_g_second"}
    end
    return nil
end

return Axis