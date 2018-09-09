--------------------一定値-------------------
black  = "<font size='15' color='#000000'>"
red    = "<font size='15' color='#FF0000'>"
tail   = "</font></a>"
back   = 0x9acd32
border = 0x228b22
s1b    = "<font size='47' color='#000000'>"
s1r    = "<font size='47' color='#FF0000'>"
s2     = "</font>"
space  = "<font size='35'> </font>"
backwh = 0xffffff
backbl = 0x000000
teban  = "<font size='110' color='#ffff00'>□</font>"
----------------------------------------------

tfm.exec.disableAfkDeath(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoShaman(true)

----------------------------------------------

--------------------------------------初期状態------------------------------------
player = {}
for i=1,8 do
    player[i] = {name = "noplayer", sum = 0, bonus = 0, numsum = 0}
end
seat   = {false,false,false,false,false,false,false,false}
now    = 0
change = 0
changedice = {false,false,false,false,false}
nowplaying = false
round  = 1
done   = false

dice = {}
math.randomseed(os.time())
for i=1,5 do
    dice[i] = math.random(6)
end

for name,player in pairs(tfm.get.room.playerList) do
    tfm.exec.bindKeyboard(name,32,true,true)
    system.bindMouse(name,true)
end

tfm.exec.newGame(7030454)
tfm.exec.setGameTime(99999)
---------------------------------------------------------------------------------
--入室者も初期化
function eventNewPlayer(name)
    tfm.exec.bindKeyboard(name,32,true,true)
    system.bindMouse(name,true)
    tfm.exec.respawnPlayer(name)
    totalscore()
    dicedisp()
end


---------------------------------------------------------------------------------
--プレイヤーが退出時の動作
function eventPlayerLeft(name)
    for i=1,8 do
        if name==player[i].name then seat[i] = false end
    end
end

---------------------------------------------------------------------------------
--席でスペースを押した時にプレイ可能
--着席者が現れてから30秒後にゲーム開始
function eventKeyboard(name,key,down,x,y)
    local seated = false
    for i=1,8 do
        if name == player[i].name then seated = true break end
    end

    local timeset1 = 1
    local timeset2 = 1
    for i=1,8 do
        if player[i].name ~= "noplayer" then timeset1 = timeset1 + 1 end
    end

    if key == 32 and not(seated) and not(nowplaying) then
        if x>40 and x<110 then
            if y>30 and y<100 and not(seat[1]) then
                player[1].name = name
                seat[1]        = true
                ui.updateTextArea(10001,black..name..": "..tostring(0).."</font>",nil)
	          elseif y>160 and y<230 and not(seat[5]) then
                player[5].name = name
                seat[5]        = true
                ui.updateTextArea(10005,black..name..": "..tostring(0).."</font>",nil)
	          end
        elseif x>160 and x<230 then
            if y>30 and y<100 and not(seat[2]) then
                player[2].name = name
                seat[2]        = true
                ui.updateTextArea(10002,black..name..": "..tostring(0).."</font>",nil)
	          elseif y>160 and y<230 and not(seat[6]) then
                player[6].name = name
                seat[6]        = true
                ui.updateTextArea(10006,black..name..": "..tostring(0).."</font>",nil)
	          end
        elseif x>280 and x<350 then
            if y>30 and y<100 and not(seat[3]) then
                player[3].name = name
                seat[3]        = true
                ui.updateTextArea(10003,black..name..": "..tostring(0).."</font>",nil)
	          elseif y>160 and y<230 and not(seat[7]) then
                player[7].name = name
                seat[7]        = true
                ui.updateTextArea(10007,black..name..": "..tostring(0).."</font>",nil)
	          end
        elseif x>400 and x<470 then
            if y>30 and y<100 and not(seat[4]) then
                player[4].name = name
                seat[4]        = true
                ui.updateTextArea(10004,black..name..": "..tostring(0).."</font>",nil)
	          elseif y>160 and y<230 and not(seat[8]) then
                player[8].name = name
                seat[8]        = true
                ui.updateTextArea(10008,black..name..": "..tostring(0).."</font>",nil)
	          end
        end
    end

    for i=1,8 do
        if player[i].name ~= "noplayer" then timeset2 = timeset2 + 1 end
    end
    if timeset1*timeset2==timeset2 and timeset2>1 then tfm.exec.setGameTime(30) end
end

--------------------------------サイコロのテキスト--------------------------------
function dicedisp()
for i=1,5 do
    if changedice[i] then
        s = s1r..space..dice[i]..s2
    else
        s = s1b..space..dice[i]..s2
    end
    ui.addTextArea(1000+i,s,nil,705,30+(i-1)*75,60,60,backwh,backbl,1,false)
end
end
dicedisp()

-----------------------------選択肢のテキスト(プレイヤーのみ表示)--------------------
function choiceText()
    for i=1,8 do
    s = "<a href='event:1sum'>"..black.."1の合計"..tail
    ui.addTextArea(8*0+i,s,player[i].name,30,300,100,20,back,border,0.7,false)
    s = "<a href='event:2sum'>"..black.."2の合計"..tail
    ui.addTextArea(8*1+i,s,player[i].name,140,300,100,20,back,border,0.7,false)
    s = "<a href='event:3sum'>"..black.."3の合計"..tail
    ui.addTextArea(8*2+i,s,player[i].name,250,300,100,20,back,border,0.7,false)
    s = "<a href='event:4sum'>"..black.."4の合計"..tail
    ui.addTextArea(8*3+i,s,player[i].name,360,300,100,20,back,border,0.7,false)
    s = "<a href='event:5sum'>"..black.."5の合計"..tail
    ui.addTextArea(8*4+i,s,player[i].name,470,300,100,20,back,border,0.7,false)
    s = "<a href='event:6sum'>"..black.."6の合計"..tail
    ui.addTextArea(8*5+i,s,player[i].name,30,330,100,20,back,border,0.7,false)
    s = black.."ボーナス".."</font>"
    ui.addTextArea(8*6+i,s,player[i].name,140,330,100,20,back,border,0.7,false)
    s = "<a href='event:3card'>"..black.."3カード"..tail
    ui.addTextArea(8*7+i,s,player[i].name,250,330,100,20,back,border,0.7,false)
    s = "<a href='event:4card'>"..black.."4カード"..tail
    ui.addTextArea(8*8+i,s,player[i].name,360,330,100,20,back,border,0.7,false)
    s = "<a href='event:full'>"..black.."フルハウス"..tail
    ui.addTextArea(8*9+i,s,player[i].name,470,330,100,20,back,border,0.7,false)
    s = "<a href='event:sstr'>"..black.."小ストレート"..tail
    ui.addTextArea(8*10+i,s,player[i].name,30,360,100,20,back,border,0.7,false)
    s = "<a href='event:bstr'>"..black.."大ストレート"..tail
    ui.addTextArea(8*11+i,s,player[i].name,140,360,100,20,back,border,0.7,false)
    s = "<a href='event:yaht'>"..black.."ヤッツィー"..tail
    ui.addTextArea(8*12+i,s,player[i].name,250,360,100,20,back,border,0.7,false)
    s = "<a href='event:regoal'>"..black.."リゴール"..tail
    ui.addTextArea(8*13+i,s,player[i].name,360,360,100,20,back,border,0.7,false)
    s = "<a href='event:chance'>"..black.."チャンス"..tail
    ui.addTextArea(8*14+i,s,player[i].name,470,360,100,20,back,border,0.7,false)
    end
end

---------------------------------合計得点のテキスト-------------------------------
function totalscore()
for i=1,4 do
    s = black..player[i].name..": "..player[i].sum.."</font>"
    ui.addTextArea(10000+i,s,nil,30+120*(i-1),100,100,40,back,border,0.7,false)
end
for i=5,8 do
    s = black..player[i].name..": "..player[i].sum.."</font>"
    ui.addTextArea(10000+i,s,nil,30+120*(i-5),230,100,40,back,border,0.7,false)
end
end
totalscore()

---------------------------------選択肢を選んだ時の動作---------------------------
function eventTextAreaCallback(id,name,cb)
    local dicenum = {}
    for i=1,6 do dicenum[i] = 0 end
    local tmp = 0
    score = 0
    done  = false
    if name == player[now].name then
    if cb == "1sum" then
        for i=1,5 do
            if dice[i] == 1 then score = score + 1 end
        end
        if score == 0 then
            ui.addPopup(1,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum    = player[now].sum + score
            player[now].bonus  = player[now].bonus + 1
            player[now].numsum = player[now].numsum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*0+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "2sum" then
        for i=1,5 do
            if dice[i] == 2 then score = score + 1 end
        end
        score = score * 2
        if score == 0 then
            ui.addPopup(2,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum    = player[now].sum + score
            player[now].bonus  = player[now].bonus + 1
            player[now].numsum = player[now].numsum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*1+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "3sum" then
        for i=1,5 do
            if dice[i] == 3 then score = score + 1 end
        end
        score = score * 3
        if score == 0 then
            ui.addPopup(3,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum    = player[now].sum + score
            player[now].bonus  = player[now].bonus + 1
            player[now].numsum = player[now].numsum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*2+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "4sum" then
        for i=1,5 do
            if dice[i] == 4 then score = score + 1 end
        end
        score = score * 4
        if score == 0 then
            ui.addPopup(4,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum    = player[now].sum + score
            player[now].bonus  = player[now].bonus + 1
            player[now].numsum = player[now].numsum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*3+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "5sum" then
        for i=1,5 do
            if dice[i] == 5 then score = score + 1 end
        end
        score = score * 5
        if score == 0 then
            ui.addPopup(5,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum    = player[now].sum + score
            player[now].bonus  = player[now].bonus + 1
            player[now].numsum = player[now].numsum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*4+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "6sum" then
        for i=1,5 do
            if dice[i] == 6 then score = score + 1 end
        end
        score = score * 6
        if score == 0 then
            ui.addPopup(6,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum    = player[now].sum + score
            player[now].bonus  = player[now].bonus + 1
            player[now].numsum = player[now].numsum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*5+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if done then
        ui.updateTextArea(8*6+now,black..tostring(player[now].numsum-63).."</font>",player[now].name)
    end
    if player[now].bonus == 6 then
        player[now].bonus = 7
        if player[now].numsum >=63 then
            score = 30
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*6+now,red..tostring(score).."</font>",name)
        else
            ui.updateTextArea(8*6+now,red..tostring(0).."</font>",name)   
        end
    end

    if cb == "3card" then
        for i=1,5 do
            dicenum[dice[i]] = dicenum[dice[i]] + 1
        end
        for i=1,6 do
            if dicenum[i] >= 3 then score = dice[1]+dice[2]+dice[3]+dice[4]+dice[5] end
        end
        if score == 0 then
            ui.addPopup(7,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*7+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "4card" then
        for i=1,5 do
            dicenum[dice[i]] = dicenum[dice[i]] + 1
        end
        for i=1,6 do
            if dicenum[i] >= 4 then score = dice[1]+dice[2]+dice[3]+dice[4]+dice[5] end
        end
        if score == 0 then
            ui.addPopup(8,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*8+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "full" then
        for i=1,5 do
            dicenum[dice[i]] = dicenum[dice[i]] + 1
        end
        tmp = 1
        for i=1,6 do
            if dicenum[i]==2 then tmp = tmp * 2 end
            if dicenum[i]==3 then tmp = tmp * 3 end
        end
        if tmp == 6 then score = 30 end
        if score == 0 then
            ui.addPopup(9,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*9+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "sstr" then
        tmp = 1
        for i=1,5 do
            if dice[i]==1 then tmp = tmp * 2 end
            if dice[i]==2 then tmp = tmp * 3 end
            if dice[i]==3 then tmp = tmp * 5 end
            if dice[i]==4 then tmp = tmp * 7 end
            if dice[i]==5 then tmp = tmp * 11 end
            if dice[i]==6 then tmp = tmp * 13 end
        end

        if tmp%210==0 or tmp%1155==0 or tmp%5005==0 then score = 15 end
        if score == 0 then
            ui.addPopup(10,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*10+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "bstr" then
        tmp = 1
        for i=1,5 do
            if dice[i]==1 then tmp = tmp * 2 end
            if dice[i]==2 then tmp = tmp * 3 end
            if dice[i]==3 then tmp = tmp * 5 end
            if dice[i]==4 then tmp = tmp * 7 end
            if dice[i]==5 then tmp = tmp * 11 end
            if dice[i]==6 then tmp = tmp * 13 end
        end
        if tmp%2310==0 or tmp%15015==0 then score = 20 end
        if score == 0 then
            ui.addPopup(11,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*11+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "yaht" then
        for i=1,5 do
            dicenum[dice[i]] = dicenum[dice[i]] + 1
        end
        for i=1,6 do
            if dicenum[i] == 5 then score = 50 end
        end
        if score == 0 then
            ui.addPopup(12,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*12+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "regoal" then
        for i=1,5 do
            dicenum[dice[i]] = dicenum[dice[i]] + 1
        end
        for i=1,6 do
            if dicenum[i] == 4 then tmp = i end
        end
        if tmp~=0 then
            if dicenum[7-tmp]==1 then score = 50 end
        end
        if score == 0 then
            ui.addPopup(13,1,"0点ですがいいですか?",name,300,200,200,30,false)
        else
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*13+now,red..tostring(score).."</font>",name)
            done = true
        end
    end

    if cb == "chance" then
        score = dice[1]+dice[2]+dice[3]+dice[4]+dice[5]
        player[now].sum = player[now].sum + score
        s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
        ui.updateTextArea(10000+now,s,nil)
        ui.updateTextArea(8*14+now,red..tostring(score).."</font>",name)
        done = true
    end

    if cb == "redice" then
        if change < 2 then
            change = change + 1
            for i=1,5 do
                if changedice[i] then dice[i] = math.random(6) end
            end
        end

        if change == 2 then
            ui.updateTextArea(999,"振り直す",player[now].name)
        end
        for i=1,5 do
            ui.updateTextArea(1000+i,s1b..space..dice[i]..s2,nil)
        end
        for i=1,5 do
            changedice[i] = false
        end
    end

    if done then nextPlayer() end
    end
end


--------------------------------サイコロを選んだ時の動作---------------------------
function eventMouse(name,x,y)
    if now ~= 0 then
    if name == player[now].name then
        if x>705 and x<765 then
            for i=1,5 do
                if y>30+(i-1)*75 and y<90+(i-1)*75 then
                    if changedice[i] then
                        changedice[i] = false
                        ui.updateTextArea(1000+i,s1b..space..dice[i]..s2,nil)
                    else
                        changedice[i] = true
                        ui.updateTextArea(1000+i,s1r..space..dice[i]..s2,nil)
                    end
                end
            end
        end
    end
    end
end


-----------------------------0点のときのポップアップ解答----------------------------
function eventPopupAnswer(id,name,ans)
    if name == player[now].name then
    if ans=="yes" then
        if id>=1 and id<=6 then
            player[now].sum    = player[now].sum + score
            player[now].bonus  = player[now].bonus + 1
            player[now].numsum = player[now].numsum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*(id-1)+now,red..tostring(score).."</font>",name)
        else
            player[now].sum = player[now].sum + score
            s = black..player[now].name..": "..tostring(player[now].sum).."</font>"
            ui.updateTextArea(10000+now,s,nil)
            ui.updateTextArea(8*id+now,red..tostring(score).."</font>",name)
        end
        nextPlayer()
    end
    end
end



---------------------------------手番を次の人に渡す---------------------------------
--ゲーム終了の場合は1を返す
function rotate()
    local x
    local y
    now = now + 1
    if now > 8 then now = 1 round = round + 1 end
    while true do
        if not(seat[now]) then
            now = now + 1
            if now > 8 then now = 1 round = round + 1 end
        else
            break
        end
    end

    if now>=1 and now<=4 then
        x = 30 + 120 * (now - 1) -14
        y = -15
    else
        x = 30 + 120 * (now - 5) -14
        y = 115
    end

    if round < 15 then
        change = 0
        for i=1,5 do
            dice[i]       = math.random(6)
            changedice[i] = false
        end

        for i=1,5 do
            ui.updateTextArea(1000+i,s1b..space..dice[i]..s2,nil)
        end
        tfm.exec.setGameTime(45)

        ui.addTextArea(9999,teban,nil,x,y,150,150,nil,nil,0,false)
        return 0
    else
        ui.removeTextArea(9999,nil)
        return 1
    end
end


--------------------------------30秒経過したらスキップ------------------------------
function eventLoop(time,rem)
    if rem <= 0.5 then
        if not(nowplaying) then
            choiceText()
            nowplaying = true
        end

        nextPlayer()
    end
end


-------------------------------手番を渡したときの初期化----------------------------
--終了の場合は初期状態に戻し、結果を表示
function nextPlayer()
    local tmp
    if now ~= 0 then ui.removeTextArea(999,player[now].name) end
    if rotate() == 0 then
        s = "<a href='event:redice'>振り直す</a>"
        ui.addTextArea(999,s,player[now].name,640,350,45,15,nil,nil,1,false)
    else
        tfm.exec.newGame(7030454)
        tfm.exec.setGameTime(99999)

        for name,ver in pairs(tfm.get.room.playerList) do
            tfm.exec.setPlayerScore(name,0,false)
            for i=1,8 do
                if player[i].name==name then
                    tfm.exec.setPlayerScore(name,player[i].sum,false)
                end
            end
        end

        for i=1,8 do
            player[i] = {name = "noplayer", sum = 0, bonus = 0, numsum = 0}
        end
        seat   = {false,false,false,false,false,false,false,false}
        now    = 0
        nowplaying = false
        round  = 1
        change = 0
        for i=1,5 do
            changedice[i] = false
        end

        --選択肢の表示を消す
        for i=1,120 do
            ui.removeTextArea(i,nil)
        end

        --合計得点の表示を初期化
        for i=1,8 do
            s = black..player[i].name..": "..player[i].sum.."</font>"
            ui.updateTextArea(10000+i,s,nil)
        end
    end
end
