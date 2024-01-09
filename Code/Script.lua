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
					Selection[i].target_area_center = center
				end
			end
			SelectObj(nil)
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
