local objective = Traitormod.RoleManager.Objectives.Objective:new()

objective.Name = "RepairHull"
objective.AmountPoints = 400
objective.Amount = 2000

function objective:Start(target)
    self.Progress = 0

    self.Text = string.format("Repair (%s/%s) damage from the hull.", self.Progress, self.Amount, self.MinCondition)

    return true
end

function objective:HullRepaired(character, amount)
    if character ~= self.Character then return end

    self.Progress = self.Progress - amount
    self.Text = string.format("Repair (%s/%s) damage from the hull.", math.floor(self.Progress), self.Amount, self.MinCondition)
end

function objective:IsCompleted()
    if self.Progress >= self.Amount then
        return true
    end

    return false
end

return objective