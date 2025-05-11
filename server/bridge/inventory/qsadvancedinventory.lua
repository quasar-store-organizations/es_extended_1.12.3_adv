if Config.CustomInventory ~= 'qs' then return end
MySQL.ready(function()
    ESX.Items = exports['qs-advancedinventory']:GetItemList()
    local items = MySQL.query.await('SELECT * FROM items')
    for _, v in ipairs(items) do
        ESX.Items[v.name] = { label = v.label, weight = v.weight, rare = v.rare, canRemove = v.can_remove }
    end
end)
---@diagnostic disable-next-line: duplicate-set-field
ESX.GetItemLabel = function(item)
    return exports['qs-advancedinventory']:GetItemLabel(item)
end
exports('GetUsableItems', function()
    return Core.UsableItemsCallbacks
end)
---@diagnostic disable-next-line: duplicate-set-field
ESX.RegisterUsableItem = function(item, cb)
    Core.UsableItemsCallbacks[item] = cb
    exports['qs-advancedinventory']:CreateUsableItem(item, cb)
end
---@diagnostic disable-next-line: duplicate-set-field
ESX.UseItem = function(source, item, ...)
    if ESX.Items[item] then
        local itemCallback = Core.UsableItemsCallbacks[item]
        return exports['qs-advancedinventory']:UseItem(item, source, ...)
    else
        print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(item))
    end
end