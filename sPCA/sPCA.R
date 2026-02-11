# ==============================================================================
# SCRIPT sPCA - SPODOPTERA (OPTIMISÉ CLUSTER)
# ==============================================================================
library(adegenet)
library(spdep)
library(maps)
library(readr)

# Configuration environnement
setwd("/home/durandk/scratch_durandk/GenFAW600/PCA_596ind/sPCA/")
Sys.setenv(OMP_NUM_THREADS = 12)

# ==============================================================================
# 1. PRÉPARATION DES DONNÉES (À NE FAIRE QU'UNE FOIS)
# ==============================================================================

if (!file.exists("X_matrix.rds") || !file.exists("coords_jitter.rds")) {
    
    cat("▶ Phase de préparation des matrices...\n")
    
    # Chargement genlight (plus léger que genind)
    if (file.exists("genlight.rds")) {
        gl <- readRDS("genlight.rds")
    } else {
        gl <- read.PLINK("GenFAW_max5miss_pruned.raw")
        saveRDS(gl, "genlight.rds")
    }

    # Subsampling 20k loci
    set.seed(123)
    n_keep <- 20000
    gl_sub <- gl[, sample(nLoc(gl), n_keep)]
    
    # Conversion en genind
    gi <- gl2gi(gl_sub, ploidy = 2)
    rm(gl, gl_sub) # Libération mémoire
    
    # Alignement Métadonnées / Coordonnées
    metadata <- read_delim("merged_data_pop_sNMF.csv", delim = ",", trim_ws = TRUE)
    ids_genetique <- indNames(gi)
    coords_ordonnees <- metadata[match(ids_genetique, metadata$ID), ]
    
    xy_raw <- as.matrix(coords_ordonnees[, c("longitude", "latitude")])
    xy <- jitter(xy_raw, amount = 0.5)
    
    # Création de la matrice X (Crucial pour la sPCA)
    cat("▶ Transformation en matrice X (NA method: mean)...\n")
    X <- tab(gi, NA.method = "mean")
    
    # Sauvegardes intermédiaires
    saveRDS(X, "X_matrix.rds")
    saveRDS(xy, "coords_jitter.rds")
    saveRDS(gi, "genind_subsampled.rds")
    
    rm(gi) ; gc()
}

# ==============================================================================
# 2. CALCUL DE LA sPCA (LE COEUR DU JOB SLURM)
# ==============================================================================

cat("▶ Chargement des matrices pour calcul sPCA...\n")
X <- readRDS("X_matrix.rds")
xy <- readRDS("coords_jitter.rds")

# Sécurité : Si nb_gabriel.rds n'existe pas encore (calculé en local)
if (!file.exists("nb_gabriel.rds")) {
    cat("▶ Création automatique du réseau de Gabriel...\n")
    # Note: On utilise graph2nb pour éviter le mode interactif sur le cluster
    nb_gabriel <- graph2nb(gabrielneigh(xy), sym = TRUE)
    saveRDS(nb_gabriel, "nb_gabriel.rds")
} else {
    nb_gabriel <- readRDS("nb_gabriel.rds")
}

# Transformation en poids
lw_gabriel <- nb2listw(nb_gabriel, style = "W")

cat("▶ Lancement de la sPCA (C'est l'étape longue)...\n")
# nfposi = 3 pour capturer tes 3 axes d'invasion
spca_sf <- spca(X, cn = lw_gabriel, xy = xy, scannf = FALSE, nfposi = 3, nfnega = 0)

# Sauvegarde finale
saveRDS(spca_sf, "spca_sf_final_results.rds")

# ==============================================================================
# 3. EXPORT DES GRAPHIQUES
# ==============================================================================
cat("▶ Génération des PDF...\n")

pdf("Resultats_sPCA_Spodoptera_Gabriel.pdf", width = 14, height = 10)

    # 1. Évaluation de la structure spatiale
    plot(spca_sf, main = "Valeurs propres (Axes Globaux)")

    # 2. Visualisation Multivariée (Combine les 3 axes en couleurs RGB)
    # C'est la meilleure carte pour voir les routes d'invasion
    colorplot(spca_sf, xy, main = "Routes d'invasion (Axes 1-3)")
    maps::map("world", add = TRUE, col = "gray70")

    # 3. Visualisation du réseau utilisé
    plot(nb_gabriel, xy, col="#e41a1c", pch=20, cex=0.5, main="Réseau Gabriel (Type 2)")
    maps::map("world", add = TRUE)

dev.off()
# ==============================================================================
# 4. TEST DE SIGNIFICATION (Global.rtest)
# ==============================================================================
cat("▶ Lancement du test de permutation (999 répétitions)...\n")

# On teste si la structure globale (les axes positifs) est statistiquement significative
# nrepet = 999 est le standard pour une p-value robuste
# On utilise parallel = TRUE pour exploiter les cœurs demandés sur SLURM
test_global <- global.rtest(X, lw_gabriel, nrepet = 999)

# Sauvegarde du test pour l'interpréter plus tard
saveRDS(test_global, "test_signification_spca.rds")

# Ajout du résultat au PDF
pdf("Test_Signification_Invasion.pdf", width = 8, height = 6)
  plot(test_global, main = "Test de Permutation : Structure Globale")
dev.off()

cat("▶ Valeur de p du test global :", test_global$pvalue, "\n")
if(test_global$pvalue < 0.05) {
  cat("✅ RÉSULTAT SIGNIFICATIF : La structure d'invasion est réelle.\n")
} else {
  cat("⚠️ RÉSULTAT NON SIGNIFICATIF : Structure spatiale potentiellement aléatoire.\n")
}
