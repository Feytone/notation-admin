local wi = ScrW()/1920
local he = ScrH()/1080

surface.CreateFont("Helvetica",{font = "Helvetica",size = 20*wi,weight = 450*he})

local white = Color(255,255,255)
local black = Color(0,0,0)

net.Receive("notecomp",function(len,ply)

	local adminpl = net.ReadEntity()

	local main = vgui.Create("DFrame")
	main:SetSize(500*wi,300*he)
	main:Center()
	main:SetDraggable(false)
	main:ShowCloseButton(true)
	main:SetTitle("")
	main:MakePopup()
	main.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94))
		draw.RoundedBox(0,0,0,w,30*he,Color(101, 198, 187))
		draw.SimpleText("Noter un Administrateur","Helvetica",w/2,15*he,white,1,1)
		draw.SimpleText("Notez "..adminpl:Name().." sur 5 :","Helvetica",w/2-2*wi,h/2,white,2,1)
	end

	local DComboBoxa = vgui.Create( "DComboBox",main )
	DComboBoxa:SetPos( main:GetWide()/2+2*wi, main:GetTall()/2-15*he )
	DComboBoxa:SetSize( 100, 30 )
	DComboBoxa:SetValue( "note" )
	DComboBoxa:AddChoice( "1" )
	DComboBoxa:AddChoice( "2" )
	DComboBoxa:AddChoice( "3" )
	DComboBoxa:AddChoice( "4" )
	DComboBoxa:AddChoice( "5" )

	local validb = vgui.Create("DButton",main)
	validb:SetPos(main:GetWide()/2-100*wi,main:GetTall()-70*he)
	validb:SetSize(200*wi,50*he)
	validb:SetText("")
	validb.Paint = function()
		draw.RoundedBox(0,0,0,200*wi,70*he,Color(101,198,187))
		draw.SimpleText("Envoyer la note","Helvetica",100*wi,25*he,white,1,1)
	end
	validb.DoClick = function()
		local notead = DComboBoxa:GetValue()
		if !sql.TableExists("notes_admin") then
    		sql.Query("CREATE TABLE notes_admin ( SteamID TEXT, Note VARCHAR(1), Nombre VARCHAR(50000) UNSIGNED )") print("Table créée")
    	end
    	sql.Query("INSERT OR IGNORE INTO notes_admin VALUES( SteamID='" .. adminpl:SteamID() .. "' )") 
    	sql.Query("REPLACE INTO notes_admin SET Note=Note+'"..notead.."', Nombre=Nombre+1 WHERE SteamID='"..adminpl:SteamID().."' ")
    end


end)

net.Receive("notecomp-admin", function(len,ply)

	if !sql.TableExists("notes_admin") then sql.Query("CREATE TABLE notes_admin ( SteamID TEXT, Note VARCHAR(1), Nombre VARCHAR(50000) UNSIGNED )") print("Table créée") end
	sql.Query("INSERT OR IGNORE INTO notes_admin VALUES( SteamID='" .. LocalPlayer():SteamID() .. "' )") print("SteamID inséré")

	local main = vgui.Create("DFrame")
	main:SetSize(500*wi,500*he)
	main:Center()
	main:SetDraggable(false)
	main:ShowCloseButton(true)
	main:SetTitle("")
	main:MakePopup()
	main.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94))
		draw.RoundedBox(0,0,0,w,30*he,Color(101, 198, 187))
		draw.SimpleText("Notes de chaque administrateur","Helvetica",w/2,15*he,white,1,1)
	end

	local Scroll = vgui.Create( "DScrollPanel", main )
	Scroll:SetSize( 115*wi, 470*he )
	Scroll:SetPos( 0, 30*he )

	local List	= vgui.Create( "DIconLayout", Scroll )
	List:SetSize( 100*wi, 470*he )
	List:SetPos( 0, 0 )
	List:SetSpaceY( 0 )
	List:SetSpaceX( 0 )

	local getall = sql.Query("SELECT SteamID FROM notes_admin")
	local notee = ""
	local nombr = ""

	for k,v in pairs(getall) do
		local ListItem = List:Add( "DButton" )
		ListItem:SetSize( 100*wi, 30*he )
		ListItem:SetText("")
		ListItem.Paint = function() 
			draw.RoundedBox(0,0,0,100*wi,30*he,Color(239, 72, 54))
			draw.RoundedBox(0,2,2,96*wi,26*he,white)
			draw.SimpleText(player.GetBySteamID(v):Name(),"Helvetica", 50*wi, 15*he,black,1,1)
		end
		ListItem.DoClick = function()
			notee = sql.QueryValue("SELECT Note FROM notes_admin WHERE SteamID='"..v.."'")
			nombr = sql.QueryValue("SELECT Nombre FROM notes_admin WHERE SteamID='"..v.."'")
		end
	end

	local oth = vgui.Create("DPanel",main)
	oth:SetPos(116*wi,30*he)
	oth:SetSize(384*wi,470*he)
	oth.Paint = function(self,w,h)
		draw.SimpleText("Administrateur sélectionné : "..player.GetBySteamID(v):Name(),"Helvetica",w/2,40*he,black,1,0)
		draw.SimpleText("Moyenne des Notes : "..notee/nombr,"Helvetica",20*wi,80*he,black,0,0)
		draw.SimpleText("Nombre de notes : "..nombr,"Helvetica",20*wi,120*he,black,0,0)
	end




end)