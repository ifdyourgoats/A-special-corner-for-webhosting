--[[

A few important things to note before using this script:

- for now it doesn't get the name of the author of the first map code, so it has to be done using /info @mapcode instead
- it cannot find the author for 4-digit maps and lower, so use /info @mapcode for those instead
- some usernames are shown with #0000, which might belong to those who changed theirs before the name tag update; so replace all "#0000" with "" in an editing program if they have to be removed.

]]

host = " INSERT USERNAME#XXXX HERE "

str = [[ INSERT MAP CODES HERE ]]

maps = {}
page = {}
pageN = {}
list = ""
lineNumber= ""

for i in string.gmatch(str, "@%d+") do
		maps[#maps+1] = i
end

ui.addTextArea(1, lineNumber, host, 520, 35, 35, 280, nil, nil, 1, true)
ui.addTextArea(0, list, host, 570, 35, 220, 320, nil, nil, 1, true)

run = true
round = 1
	function eventLoop(ct, tr)
		if round <= #maps then
			if ct % 3500 < 300 then -- this here is only to ensure that it does not repeat more than once per three seconds (might sometimes change map after 7 or 10 seconds)
				lineNumber= lineNumber .. "<p align='right'>" .. tostring(round) .. "</p>"
				ui.updateTextArea(1, lineNumber, host)
				round = round + 1
				tfm.exec.newGame(maps[round])
				if tfm.get.room.xmlMapInfo then
					list = list .. maps[round-1] .. " - " .. tfm.get.room.xmlMapInfo.author .. "\n"
				else -- some maps don't have an author, hence this else part
					list = list .. maps[round-1] .. " -\n"
				end
				ui.updateTextArea(0, list, host)
				if round % 18 == 0 then
					page[#page+1] = list
					pageN[#pageN+1] = lineNumber
					list = ""
					lineNumber=""
				end
			end
		elseif tfm.get.room.xmlMapInfo and run then
			run = false
			ui.addTextArea(3, "<p align='center'><a href='event:prev'>Prev</a> - <a href='event:print'>Print</a> - <a href='event:next'>Next</a></p>", host, 570, 370, 220, 20, nil, nil, 1, true)
			page[#page+1] = list
			pageN[#pageN+1] = lineNumber
			currentPage = #page
			ui.addTextArea(4, tostring(currentPage) .. " / " .. tostring(#page), host, 745, 330, 85, 60, nil, nil, 0, true)
		end
end

function changePage(cP)
		ui.updateTextArea(0, page[cP], host)
		ui.updateTextArea(1, pageN[cP], host)
		ui.updateTextArea(4, tostring(cP) .. " / " .. tostring(#page), host)
end

function eventTextAreaCallback(textAreaID, player, callback)
		if callback == "prev" and currentPage > 1 then
			currentPage = currentPage - 1
			changePage(currentPage)
		elseif callback == "next" and currentPage < #page then
			currentPage = currentPage + 1
			changePage(currentPage)
		elseif callback == "print" then
			print("\n" .. page[currentPage])
		end
end
