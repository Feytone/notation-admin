util.AddNetworkString("notecomp")
util.AddNetworkString("notecomp-admin")
util.AddNetworkString("validnoteadd_notation")
util.AddNetworkString("sendtoreceive_notation")
util.AddNetworkString("sendnono_notation")

if !sql.TableExists("notes_admin") then
    sql.Query("CREATE TABLE notes_admin ( SteamID TEXT, Note SMALLINT UNSIGNED, Nombre SMALLINT UNSIGNED )") print("Table créée tout en haut")
end

print(sql.LastError())

hook.Add("PlayerSay","CommandMtx",function(ply,text)

	if string.StartWith(text,ConfigCommande) and ply:IsValid() and ply:IsPlayer() and RestricGroups[ply:GetUserGroup()] then

			local jouest = player.GetBySteamID(string.sub(text,string.len(ConfigCommande)+2))
				if jouest:IsPlayer() then
					net.Start("notecomp")
					net.WriteEntity(ply)
					net.Send(jouest)
				else print("Le SteamID "..string.sub(text,string.len(ConfigCommande)+2).." n'est pas valide.")
				end

	end
	if ConfigCommandeAdmin == text and ply:IsValid() and ply:IsPlayer() and RestricGroupsShow[ply:GetUserGroup()] then
		print("La commande a fonctionné")

		net.Start("notecomp-admin")
		net.WriteTable(sql.Query("SELECT SteamID FROM notes_admin"))
		net.WriteString(sql.QueryValue("SELECT Note FROM notes_admin WHERE SteamID='"..v.."'"))
		print(sql.LastError())
		net.Send(ply)
	end
end)



net.Receive("validnoteadd_notation", function(len,ply)

	local notead = tonumber(net.ReadString())
	local adminpl = net.ReadEntity()

	if !sql.TableExists("notes_admin") then
    	sql.Query("CREATE TABLE notes_admin ( SteamID TEXT, Note SMALLINT UNSIGNED, Nombre SMALLINT UNSIGNED )") print("Table créée") print(sql.LastError())
    else print("table déjà créée")
    end
    sql.Query("INSERT OR IGNORE INTO notes_admin VALUES( SteamID='" .. tostring(adminpl:SteamID()) .. "' )") print(sql.LastError())
    sql.Query("REPLACE INTO notes_admin (SteamID, Note, Nombre) VALUES(SteamID='" .. tostring(adminpl:SteamID()) .. "', Note=Note+'"..notead.."', Nombre=Nombre+1) ") print(sql.LastError())

end)

net.Receive("sendtoreceive_notation", function(len,ply)

	local noteee = sql.QueryValue("SELECT Note FROM notes_admin WHERE SteamID='"..v.."'")
	local nombre = sql.QueryValue("SELECT Nombre FROM notes_admin WHERE SteamID='"..v.."'")
	net.Start("sendnono_notation")
	net.WriteString(noteee)
	net.WriteString(nombre)
	net.Send(ply)

end)
