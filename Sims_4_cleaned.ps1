############################################################
#_Programme_d'optimisation_du_jeu_'sims 4'_________________#
# Lors du lancement du jeu : Suppression des caches        #
# A la fermeture du jeu : fermeture de EA Launcher         #
############################################################
#_Création_________________________________________________#
# Créé par: PETIT Kalvin                                   #
# Le : 12 décembre 2023                                    #
############################################################
#_Dernière modification____________________________________#
# Modifié par: PETIT Kalvin                                #
# Le : 03 Janvier 2024                                     #
# Modif : Code rendu adaptable à chaque pc                 #                                 
############################################################

# Définir le chemin de base avec le répertoire utilisateur
$CheminVers = "C:\Users\Kalvin\Documents\Electronic Arts\Les Sims 4"

# Liste des dossiers à supprimer
$DossiersASupprimer = @(
    "cachestr",
    "onlinethumbnailcache"
)

# Suppression des dossiers
foreach ($Dossier in $DossiersASupprimer) {
    $CheminDossier = Join-Path $CheminVers $Dossier

    if (Test-Path $CheminDossier -PathType Container) {
        Remove-Item -Path $CheminDossier -Recurse -Force
        Write-Host "Le dossier $Dossier a été supprimé."
    } else {
        Write-Host "Le dossier $Dossier n'existe pas. Chemin : $CheminDossier"
    }
}

# Liste des fichiers à supprimer
$FichiersASupprimer = @(
    "avatarcache.package",
    "localthumbcache.package"
)

# Suppression des fichiers
foreach ($Fichier in $FichiersASupprimer) {
    $CheminFichier = Join-Path $CheminVers $Fichier

    if (Test-Path $CheminFichier -PathType Leaf) {
        Remove-Item -Path $CheminFichier -Force
        Write-Host "Le fichier $Fichier a été supprimé."
    } else {
        Write-Host "Le fichier $Fichier n'existe pas. Chemin : $CheminFichier"
    }
}

# Chemin de l'exécutable
$CheminExe = Join-Path 'C:\Program Files\EA Games\The Sims 4\Game\Bin' 'TS4_x64.exe'
$NomProcessusJeu = "TS4_x64"
$NomProcessusEA = "EADesktop"

# Vérifier si le fichier existe
if (Test-Path $CheminExe -PathType Leaf) {
    try {
        # Lancer l'exécutable
        Start-Process -FilePath $CheminExe -PassThru -ErrorAction Stop
        Write-Host "L'exécutable a été lancé."

        # Attente supplémentaire pour s'assurer que le jeu est complètement ouvert
        Start-Sleep -Seconds 60

        # Surveiller le processus du jeu
        do {
            Start-Sleep -Seconds 30
        } while (Get-Process -Name $NomProcessusJeu -ErrorAction SilentlyContinue)

        # Arrêter le processus EA
        Stop-Process -Name $NomProcessusEA -Force -ErrorAction SilentlyContinue
        Write-Host "Le processus EA a été arrêté."
    } catch {
        Write-Host "Erreur lors du lancement de l'exécutable : $_"
    }
} else {
    Write-Host "L'exécutable $CheminExe n'existe pas. Chemin : $CheminExe"
}
