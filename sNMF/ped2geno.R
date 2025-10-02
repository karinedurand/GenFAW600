#!/usr/bin/env Rscript

#install.packages("BiocManager", lib = "/home/kdurand/work/R/")
#BiocManager::install("LEA", lib = "/home/kdurand/work/R/", update = TRUE, ask = FALSE)

# charger le package depuis ce dossier
library(LEA, lib.loc = "/home/kdurand/work/R")

################ped2geno error segmentation###############################################################""
# # Arguments : PED file + prefix de sortie
# args <- commandArgs(trailingOnly = TRUE)
# if (length(args) < 2) {
#   stop("Usage: ped2geno.R <input.ped> <output_prefix>")
# }

# pedfile <- args[1]
# outprefix <- args[2]

# message("Conversion PED -> GENO")
# message("Input PED: ", pedfile)
# message("Output prefix: ", outprefix)

# # Appel de la fonction LEA
# ped2geno(pedfile, paste0(outprefix, ".geno"))

# message("Done. Output: ", outprefix, ".geno")



# # Définir le fichier VCF d'entrée
# vcf_file <- "GenFAW600_geno0.8.vcf"  # Remplacez par votre VCF filtré

# # Lancer SNMF (exemple pour K=2 à 5, ajustez selon votre étude)
# project <- snmf(vcf_file, 
#                 K = 2:5,              # Range de K à tester
#                 ploidy = 2,           # Diploïde (humains/plantes/animaux)
#                 entropy = TRUE,       # Calculer l'entropie croisée pour choisir le meilleur K
#                 repetitions = 10,     # Nombre de runs par K pour stabilité
#                 iterations = 200,     # Itérations par run (augmentez à 500-1000 pour précision)
#                 CPU = 4,              # Parallélisation (ajustez à votre machine)
#                 project = "new",      # Créer un nouveau projet
#                 seed = 123)           # Pour reproductibilité

# # Sauvegarder le projet
# save(project, file = "snmf_project.RData")


project <- load.snmfProject("GenFAW600_geno0.8.snmfProject")
# relancer seulement K = 6:8 et ajouter les résultats au projet existant
project <- snmf("GenFAW600_geno0.8.geno",
                K = 6:8,
                repetitions = 10,
                project = "continue",   # <-- IMPORTANT : "continue" pour compléter le projet existant
                entropy = TRUE,
                CPU = 4)                # ajuste CPU selon ta machine
project <- load.snmfProject("GenFAW600_geno0.8.snmfProject")


# recharger et vérifier
project <- load.snmfProject("GenFAW600_geno0.8.snmfProject")
print(unique(project@K))
save(project, file = "snmf_project_updated.RData")

################################################################################################################################
#PLOT
###############################################################################################################################

module load statistics/R/4.3.0
library(LEA, lib.loc = "/home/kdurand/work/R")
# Charger le projet SNMF
project <- load.snmfProject("GenFAW600_geno0.8.snmfProject")


# Définir la plage de K à tester
Ks <- 2:8  

# Calculer la cross-entropy moyenne pour chaque K
ce <- sapply(Ks, function(k) mean(cross.entropy(project, K = k)))

# Identifier le meilleur K
best_K <- Ks[which.min(ce)]
cat("Meilleur K :", best_K, "\n")

# ===============================
# Sauvegarder la courbe cross-entropy
# ===============================
pdf("cross_entropy.pdf")
plot(Ks, ce, type = "b", pch = 19, col = "blue",
     xlab = "K (nombre de clusters)", ylab = "Cross-Entropy",
     main = "Critère d'entropie croisée (SNMF)")
dev.off()

# ===============================
# Sauvegarder le barplot Q-matrix
# ===============================

# Sélectionner le meilleur run pour ce K
best_run <- which.min(cross.entropy(project, K = best_K))
#best_run
#[1] 5
# Extraire la Q-matrix
Q_matrix <- Q(project, K = best_K, run = best_run)

# Sauvegarde barplot en PDF
pdf("admixture_barplot.pdf", width = 10, height = 5)
barplot(t(Q_matrix),
        col = rainbow(best_K),
        border = NA,
        space = 0,
         main = paste("Structure génétique - K =", best_K))
dev.off()

# ===============================
# Sauvegarder un PDF avec barplots pour chaque K
# ===============================
pdf("admixture_barplots_allK.pdf", width = 10, height = 5)

for (k in Ks) {
  # Sélectionner le meilleur run pour ce K
  best_run <- which.min(cross.entropy(project, K = k))
  
  # Extraire la Q-matrix
  Q_matrix <- Q(project, K = k, run = best_run)
  
  # Barplot
  barplot(t(Q_matrix),
          col = rainbow(k),
          border = NA,
          space = 0,
          xlab = "Individus",
          ylab = "Proportions d'ancêtres",
          main = paste("Structure génétique - K =", k))
}

dev.off()


# ===============================
# Optionnel : Imputation
# ===============================
# Vérifie que 'vcf_file' est bien défini avant d'exécuter ceci
imputed_geno <- impute(project, vcf_file, K = best_K, run = best_run)
 write.geno(imputed_geno, "imputed.geno")


 # Charger les métadonnées
metadata <- read.table("metadata_sNMF.ind", header = TRUE, sep = "\t")

# Sélectionner le meilleur run pour ce K
best_run <- which.min(cross.entropy(project, K = best_K))

# Extraire la Q-matrix (probabilités d'appartenance aux clusters)
Q_matrix <- Q(project, K = best_K, run = best_run)

# Vérifier que l'ordre correspond entre métadonnées et Q_matrix
# On suppose que les lignes sont dans le même ordre que dans le VCF
stopifnot(nrow(Q_matrix) == nrow(metadata))

# Récupérer les régions pour chaque individu
region_labels <- metadata$REGION

# Sauvegarde du barplot en PDF
pdf("admixture_barplot_region.pdf", width = 10, height = 5)
barplot(t(Q_matrix),
        col = rainbow(best_K),
        border = NA,
        space = 0,
        main = paste("Structure génétique - K =", best_K),
        names.arg = region_labels,   # remplacer les ID par les régions
        las = 2,                     # orientation verticale des labels
        cex.names = 0.8)             # taille des labels
dev.off()

############################################################################################"""
###############################################################################################
metadata <- read.table("metadata_sNMF.ind", header = TRUE, sep = ",")

# Sélectionner le meilleur run pour ce K
best_run <- which.min(cross.entropy(project, K = best_K))

# Extraire la Q-matrix (probabilités d'appartenance aux clusters)
Q_matrix <- Q(project, K = best_K, run = best_run)

# Vérifier que l'ordre correspond entre métadonnées et Q_matrix
# On suppose que les lignes sont dans le même ordre que dans le VCF
stopifnot(nrow(Q_matrix) == nrow(metadata))

# Récupérer les régions pour chaque individu
region_labels <- metadata$REGION

# Sauvegarde du barplot en PDF
pdf("admixture_barplot_region.pdf", width = 10, height = 5)
barplot(t(Q_matrix),
        col = rainbow(best_K),
        border = NA,
        space = 0,
        main = paste("Structure génétique - K =", best_K),
        names.arg = region_labels,   # remplacer les ID par les régions
        las = 2,                     # orientation verticale des labels
        cex.names = 0.8)             # taille des labels
dev.off()

##############################################################################################
##POP ordered
#################################
metadata <- read.table("metadata_sNMF.ind", header = TRUE, sep = ",")
# Ajouter les assignations Q_matrix dans les métadonnées
metadata$index <- 1:nrow(metadata)  # garder la position originale
metadata$pop <- factor(metadata$pop)  # s'assurer que pop est bien un facteur

# Réordonner les échantillons par population
order_idx <- order(metadata$pop)  # indices triés par pop
Q_matrix_ordered <- Q_matrix[order_idx, ]
metadata_ordered <- metadata[order_idx, ]
write.csv(Q_matrix_ordered ,"Q_matrix_ordered.csv")
write.csv(metadata_ordered ,"metadata_ordered.csv")
# Récupérer les labels à afficher sous le graphique (ici la pop)
labels <- metadata_ordered$pop

# Sauvegarde du barplot en PDF
pdf("admixture_barplot_pop.pdf", width = 12, height = 6)
barplot(t(Q_matrix_ordered),
        col = rainbow(best_K),
        border = NA,
        space = 0,
        main = paste("Structure génétique - K =", best_K),
        names.arg = labels,    # labels de population
        las = 2,               # labels verticaux
        cex.names = 0.7)       # taille des noms
dev.off()