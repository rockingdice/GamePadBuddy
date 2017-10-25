function initExtensions()
  --Integration with Itemization Browser
  if ItemBrowser then
	  if (not ItemBrowser.list) then
	    -- Lazy initialization
	    ItemBrowser.list = ItemBrowserList:New(ItemBrowserFrame);
	  end
  end


--Integration with Iakoni's Gear Changer
	if GearChangerByIakoni then
		SCENE_MANAGER.scenes['gamepad_inventory_root']:RegisterCallback("StateChange", GearChangerByIakoni.CallBackInventory)
	end
	
--Integration with Iakoni's Skill Changer
	if SkillChangerByIakoni then
		local InventoryScene = SCENE_MANAGER.scenes["gamepad_skills_root"]
		--local inventoryScene = SCENE_MANAGER:GetScene("inventory")
		InventoryScene:RegisterCallback("StateChange", function(oldState, newState) 
			-- states: hiding, showing, shown, hidden
			if(newState == "showing") then
				-- do something if the inventory is beginning to show
				SCBI:SetHidden(false)
			elseif(newState == "hiding") then
				-- do something if the inventory is beginning to hide
				SCBI:SetHidden(true)
			end
		end)
	end
end

--Integration with ArkadiusTradeTools
function GetATTPriceAndStatus(itemLink)
  if not ArkadiusTradeTools then
    return "", ""
  end
	local L = ShissuFramework["func"]._L("ArkadiusTradeTools")
	local itemSales = ArkadiusTradeTools.Modules.Sales:GetItemSalesInformation(itemLink, GetTimeStamp() - 30 * 86400)
	local itemQuality = GetItemLinkQuality(itemLink)
	local itemType = GetItemLinkItemType(itemLink)
	for link, sales in pairs(itemSales) do
		averagePrice = 0
		quantity = 0

		if (link == itemLink) then
			local minPrice = math.huge
			local maxPrice = 0
			local price

			for _, sale in pairs(sales) do
				price = sale.price / sale.quantity

				if (price < minPrice) 
				then 
					minPrice = price 
				end
				if (price > maxPrice) 
				then 
					maxPrice = price 
				end
			end
		end

		for _, sale in pairs(sales) do
			averagePrice = averagePrice + sale.price
			quantity = quantity + sale.quantity
		end

		if (quantity > 0) then
			averagePrice = math.attRound(averagePrice / quantity, 2)
		else
			averagePrice = 0
		end

	if (link == itemLink) then
		if (quantity > 0) then
			if (itemType == ITEMTYPE_MASTER_WRIT) then
				local vouchers = tonumber(GenerateMasterWritRewardText(link):match("%d+"))

				priceString = string.format(L("ATT_FMTSTR_TOOLTIP_PRICE_MASTER_WRIT"), ZO_LocalizeDecimalNumber(averagePrice * vouchers) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t", ZO_LocalizeDecimalNumber(averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
				statsString = string.format(L("ATT_FMTSTR_TOOLTIP_STATS_MASTER_WRIT"), ZO_LocalizeDecimalNumber(#sales), ZO_LocalizeDecimalNumber(quantity))
			else
				priceString = string.format(L("ATT_FMTSTR_TOOLTIP_PRICE_ITEM"), ZO_LocalizeDecimalNumber(averagePrice) .. " |t16:16:EsoUI/Art/currency/currency_gold.dds|t")
				statsString = string.format(L("ATT_FMTSTR_TOOLTIP_STATS_ITEM"), ZO_LocalizeDecimalNumber(#sales), ZO_LocalizeDecimalNumber(quantity))
			end
			return priceString, statsString
		end
	end
end
return L("ATT_STR_NO_PRICE"), ""
end


--Integration with ItemizationBrowser
function GetSetSourceFromIB(name) 
  if not ItemBrowser or not ItemBrowser.list then
    return ""
  end

  local searchInput = name

  for i = 1, #ItemBrowser.list.masterList do
    local data = ItemBrowser.list.masterList[i];

    if ItemBrowser.list:CheckForMatch(data, searchInput) then
      return zo_strformat("<<1>> - <<2>>", data.color:Colorize(data.itemType), data.source)
    end
  end

  return ""
end
