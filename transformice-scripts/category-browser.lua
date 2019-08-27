maps = {}
mapType = "#1"
categories={"p0", "p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9", "p10", "p11", "p17", "p18", "p19", "p24", "p42", "p44"}

tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAfkDeath(true)

showPerm = {}
function regenTextArea(opacity, target)
	ui.addTextArea(0,"<p align='center'>Map: <a href='event:prev'>prev</a> | <a href='event:reload'>↺</a> | <a href='event:next'>next</a></p>",target,645,380,135,40,0x324650,0x212F36,opacity,true)
	ui.addTextArea(1,"<p align='center'><a href='event:showPerm'>▼</a></p>",target,750,40,30,20,0x324650,0x212F36,opacity,true)
	ui.addTextArea(2,"<p align='center'>Opacity: <a href='event:opacityUp'>+</a> | <a href='event:opacityDown'>-</a></p>",target,645,40,90,20,0x324650,0x212F36,opacity,true)
	if showPerm[target] then
		local x = math.ceil(#categories / 8) * 45
		local y = 35
		for k,v in pairs(categories) do
			if (k - 1) % 8 == 0 then
				x = x - 45
				y = 35
			end
			ui.addTextArea(k + 2,"<p align='center'><a href='event:" .. v .. "'>" .. v .. "</a></p>",target,750 - x, 40 + y, 30, 20,0x324650,0x212F36,opacity,true)
			y = y + 35
		end
	end
end

opacity = {}
mapNo = 0
function eventTextAreaCallback(textArea, player, callback)
	if not opacity[player] then
		opacity[player] = 10
	end
	if textArea == 0 then
		if callback == "next" then
			mapNo = mapNo + 1
			if playback then
				tfm.exec.newGame(maps[mapNo])
				if mapNo == #maps then
					playback = false
				end
			else 
				tfm.exec.newGame(mapType)
			end
		elseif callback == "reload" and tfm.get.room.xmlMapInfo.mapCode then
			reload = true
			tfm.exec.newGame(tfm.get.room.xmlMapInfo.mapCode)
		elseif callback == "prev" and mapNo > 1 then
			if not playback then
				mapNo = #maps
			end
			playback = true
			mapNo = mapNo - 1
			tfm.exec.newGame(maps[mapNo])
		end
	elseif textArea == 2 then
		if callback == "opacityUp" then
			if opacity[player] < 10 then
				opacity[player] = opacity[player] + 1
				regenTextArea(opacity[player]/10, player)
			end
		elseif callback == "opacityDown" then
			if opacity[player] > 5 then
				opacity[player] = opacity[player] - 1
				regenTextArea(opacity[player]/10, player)
			end
		end
	elseif callback == "showPerm" then
		if showPerm[player] then
			showPerm[player] = false
			for i=3,#categories+3 do
				ui.removeTextArea(i, player)
			end
			ui.updateTextArea(1, "<p align='center'><a href='event:showPerm'>▲</a></p>", player)
		elseif not showPerm[player] then
			showPerm[player] = true
			regenTextArea(opacity[player]/10, player)
			ui.updateTextArea(1, "<p align='center'><a href='event:showPerm'>▼</a></p>", player)
		end
	else
		for k,v in pairs(categories) do
			if callback == v then
				mapType = "#" .. string.gsub(v, "p", "")
			end
		end
	end
end

t = 3
respawn_t = {}
function eventLoop(ct, tr)
	if t < 3 then
		t = t + 0.5
		ui.updateTextArea(0, "<p align='center'>Reloading in " .. 3.0 - math.floor(t) .. "..</p>", nil)
	elseif t == 3 then
		ui.updateTextArea(0, "<p align='center'>Map: <a href='event:prev'>prev</a> | <a href='event:reload'>↺</a> | <a href='event:next'>next</a></p>", nil)
	end
	for k,v in pairs(respawn_t) do
		if v > 0 then
			respawn_t[k] = v - 0.5
		elseif v == 0 then
			tfm.exec.respawnPlayer(k)
			v = nil
		end
	end
end

function eventNewGame()
	t = 0
	print(mapNo)
	print(#maps)
	if mapNo == #maps + 1 then
		playback = false
	end
	if not playback and tfm.get.room.xmlMapInfo.mapCode then
		if not reload then
			table.insert(maps, tfm.get.room.xmlMapInfo.mapCode)
		end
	end
	reload = false
end

function eventPlayerWon(player,timeElapsed)
	respawn_t[player] = 2
end
	
function eventPlayerDied(player)
	respawn_t[player] = 2
end

regenTextArea(1, nil)
