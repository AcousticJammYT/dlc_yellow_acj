local Axis, super = Class(LightEnemyBattler)

function Axis:init()
    super:init(self)

    self.name = "Axis"
    self:setActor("axisboss")

    self.max_health = 750
    self.health = 750
    self.attack = 13
    self.defense = 12
    self.money = 0
    self.experience = 200
    self.spare_percentage = 0

    self.display_damage_on_miss = true

    self.battle_phase = 1
    self.axis_protected = false
    
    self.dialogue_bubble = "ut_wide"
    self.dialogue_offset = {-30, 10}

    self.waves = {
        "axis/basic_axis"
    }

    --[[self.dialogue = {
        "[wave:3][speed:0.5]....."
    }]]

    self.check = "ATK 13 DEF 12\n* Today means the Surface."

    self.text = {
        "* The air thickens.",
        "* Death by metal & magic.",
        "* You feel the furnace's heat\nwaves engulf you.",
        "* Smells like an unfortunate BBQ.",
        "* Axis seems on edge.",
        "* Axis is flipping through the\nRoyal Guard guide book... in his\nmind.",
        "* Axis is having trouble charging\nup his next attack.",
        "* Axis blows into one of his\nvents to clean some dust. You\ndon't know how.",
        "* Axis pinches the end of one of\nhis gloves and releases the air.\nHe finds it amusing.",
        "* Axis thinks this music is a bit\nintense for his tastes."
    }

    self.spareable_text = "* Axis has cooled off."

    self:registerAct("Brace")
    self:registerAct("Scrutinize")
    self:registerAct("Cool")
    --self:registerAct("Compliment")

    self.gauge_size = {250, 18}

    self.damage_offset = {0, 42}
end

function Axis:onDefeat(damage, battler)
    self.hurt_timer = -1
    local sprite = self:getActiveSprite()
    sprite:stopShake()
    if Game.battle.battle_ui.attacking then
        Game.battle.battle_ui:endAttack()
    end
    Game.battle:setState("NONE")
    Game.battle:startCutscene("axis", "death")
end

function Axis:onAct(battler, name)
    if name == "Brace" then
        return "* You ready your trusty shield\nfor whatever awaits."
    elseif name == "Scrutinize" then
        local rnd = math.random(1, 3)
        if rnd == 1 then
            return "* You tell Axis he's not great at\nhis job. If he could frown, he\nwould."
        elseif rnd == 2 then
            return "* You criticize Axis' attack\nstrategy. Steam shoots out of\nhis hearing ducts."
        else
            return "* You say something rude to Axis.\nHe \"HONESTLY DOES NOT APPRECIATE\nIT.\""
        end
    elseif name == "Cool" then
        return "* You pull on your shirt\nrepeatedly in hopes to beat the\nheat. Your effort fails."
    elseif name == "Compliment" then
        Game.battle:startActCutscene("axis", "compliment_one")
        return
    elseif name == "Standard" then
        if self.battle_phase == 9 then
            return "* Perhaps it's better to speak together."
        else
            return "* But there was nothing to say at the moment."
        end
    end

    return super:onAct(self, battler, name)
end

function Axis:getAttackDamage(damage, lane, points, stretch)
    if self.axis_protected == true then
        return 0
    elseif self.battle_phase == 9 then
        return self.health
    else
        return super.getAttackDamage(self, damage, lane, points, stretch)
    end
end

function Axis:onDodge(battler, attacked)
    if self.axis_protected == true then
        if attacked == true then
            Assets.playSound("bell")
        end
    end
end

function Axis:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    if has_spareable_text then
        return self.spareable_text
    elseif self.battle_phase == 9 then
        return "* Axis is staring at you blankly\nuntil you do something."
    end

    return Utils.pick(self.text)
end

function Axis:onHurtEnd()
    self:getActiveSprite():stopShake()
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end

    --[[if self.health <= 50 and self.battle_phase < 9 and self.health > 0 then
        self.battle_phase = 9
        if Game.battle.battle_ui.attacking then
            Game.battle.battle_ui:endAttack()
        end
        Game.battle:startCutscene("axis", "out_of_power")
    elseif self.health <= 150 and self.battle_phase < 8 then
        self.battle_phase = 8
        self.dialogue_override = {
            "DoPDzzzZ_//",
            "GAH. ",
            "YOU WOULD NOT\nLIKE ME AT LOW\nBATTERY.",
            "I AM WARNING YOU\nTO NOT DRAIN\nMY BATTERY."
        }
    elseif self.health <= 450 and self.battle_phase < 5 then
        self.battle_phase = 5
        self.dialogue_override = {
            "ZBsssZ t-t-D\n? d",
            "THAT IS ENOUGH.",
            "UNBEKNOWNST TO\nYOU, I BROUGHT\nA BACKUP PLAN.",
            "PORTABLE\nGENERATORS\n=\nINFINITE BATTERY.",
            "GOOD LUCK."
        }
        self.axis_protected = true
    elseif self.health <= 500 and self.battle_phase < 4 then
        self.battle_phase = 4
        self.dialogue_override = {
            "AZ_a_D?f\nF . .",
            "I A-AM ST_ARTING\nTO REGRET GIVING\nYOU THAT LID.",
            "COULD YOU PLEASE\nDROP IT?",
            "JUST KICK IT\nINTO THE FIERY\nPIT BELOW US.\nSIMPLE."
        }
    elseif self.health <= 600 and self.battle_phase < 3 then
        self.battle_phase = 3
        self.dialogue_override = {
            "BZZT_Zz\nPRpP /",
            "I DID IT AGAIN.\nHOW.",
            "WAIT. THIS IS\nYOUR DOING. OF\nCOURSE IT IS.",
            "DO NOT SHOCK\nME AGAIN, OKAY?"
        }
    elseif self.health <= 700 and self.battle_phase < 2 then
        self.battle_phase = 2
        self.dialogue_override = {
            "ZzzZZKKZ\nDPPP-D_-A - _",
            "WHAT WAS THAT?\nWHAT DID I SAY?",
            "\"ZzzZKKZ\nDPPP-D_-A - _\"\nIS NOT A WORD.",
            "WHY DID I SAY\nTHAT?"
        }
    end]]
end

function Axis:getNextWaves()
    if self.battle_phase == 9 then
        return nil
    else
        return self.waves
    end
end

return Axis