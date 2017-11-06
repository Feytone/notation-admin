-- Addon créé par Feytone
-- Partie Configurable

ConfigCommande = "!noteid" -- Commande que l'admin entrera pour "obliger" le joueur à le noter
ConfigCommandeAdmin = "!noteadmin" -- Commande pour afficher le menu des statistiques de l'administration

RestricGroups = {["superadmin"] = true, ["admin"] = true} -- Groupes qui pourront faire la commande Config.Commande
RestricGroupsShow = {["superadmin"] = true} -- Groupes qui pourront faire la commande Config.CommandeAdmin