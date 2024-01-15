local otherTurrets = {}

local originalTargetAreaSet = TargetAreaObject.TargetAreaSet
function TargetAreaObject:TargetAreaSet(area_state)
	originalTargetAreaSet(self, area_state)
	if #otherTurrets > 1 then
		local center = otherTurrets[1].target_area_center
		local radius = otherTurrets[1].target_area_radius
		for i = 2, #otherTurrets do
			local obj = otherTurrets[i]
			local newCenter = obj:TargetAreaClamp(center, obj.area_state)
			obj.target_area_center = newCenter or obj.target_area_center
			obj.target_area_radius = radius
			obj:OnAttackTargetChanged()
			obj:ShowRanges()
		end
		otherTurrets[1]:OnAttackTargetChanged()
		otherTurrets[1]:ShowRanges()
		otherTurrets = {}
	end
end

local originalCreateBinActions = MultiSelectAdapter.CreateBinActions
function MultiSelectAdapter:CreateBinActions(bin, host)
	originalCreateBinActions(self, bin, host)
	if #bin > 1 and IsKindOf(bin[1], "TargetAreaObject") then
		XAction:new({
			ActionId = "BrrainzTargetArea",
			ActionSortKey = "2000",
			ActionIcon = "UI/Icons/Infopanels/attack",
			ActionToolbar = "ip_actions",
			RolloverTemplate = "Rollover",
			ActionState = function(self, host)
				self.ActionIcon = "UI/Icons/Infopanels/attack"
				self.ActionName = "Target Areas"
				self.RolloverText = "Choose Target Areas."
				self.RolloverTitle = "Target Areas"
				self.RolloverHint = ""
			end,
			OnAction = function()
				for i = 1, #bin do
					otherTurrets[#otherTurrets + 1] = bin[i]
				end
				bin[1]:TargetAreaPlace()
			end
		}, host)
	end
end

-- add a new shortcut to the game

PlaceObj("XTemplate", {
	group = "Shortcuts",
	id = "BrrainzShortcuts",
	save_in = "Common",
	PlaceObj("XTemplateAction", {
		"comment",
		"Merge turret targets",
		"RolloverText",
		"Merge turret targets",
		"ActionId",
		"DE_MultiAim",
		"ActionTranslate",
		false,
		"ActionName",
		"Merge Turret Targets",
		"ActionIcon",
		"CommonAssets/UI/Icons/bacteria bug insect protection security virus.png",
		"ActionShortcut",
		"Ctrl-Shift-T",
		"OnAction",
		function(self, host, source, ...)
			if #Selection < 2 then
				return
			end
			local center = Selection[1].target_area_center
			if center then
				for i = 2, #Selection do
					local obj = Selection[i]
					obj.target_area_center = center
					obj:OnAttackTargetChanged()
					obj:ShowRanges()
				end
			end
		end,
		"__condition",
		function(parent, context)
			return true
		end,
		"replace_matching_id",
		true
	})
})
XTemplateSpawn("BrrainzShortcuts", XShortcutsTarget)
