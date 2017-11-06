util.AddNetworkString("notecomp")
util.AddNetworkString("notecomp-admin")

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
		net.Send(ply)
		else print("La commande n'a pas fonctionné")
	end
end)

if !sql.TableExists("notes_admin") then
    sql.Query("CREATE TABLE notes_admin ( SteamID TEXT, Note VARCHAR(1), Nombre VARCHAR(50000) UNSIGNED )") print("Table créée tout en haut")
end