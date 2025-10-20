#!/usr/bin/env Rscript

# ======================================================================
# Install LEA package (uncomment if not already installed)
# ======================================================================
# install.packages("BiocManager")
# BiocManager::install("LEA", update = TRUE, ask = FALSE)

# Load the LEA package
library(LEA)

# ======================================================================
# Run sNMF analysis (example for K = 2 to 8 — adjust as needed)
# ======================================================================

vcf_file <- "GenFAW600_Whole_biallelic_geno08_Pruned0.5_noASW7.vcf"

project <- snmf(vcf_file, 
                K = 2:8,              # Range of K values to test
                ploidy = 2,           # Diploid organisms (humans, animals, plants)
                entropy = TRUE,       # Compute cross-entropy criterion
                repetitions = 10,     # Number of runs per K for stability
                iterations = 200,     # Iterations per run (increase for higher accuracy)
                CPU = 8,              # Number of CPU cores for parallelization
                project = "new",      # Create a new project directory
                seed = 123)           # Random seed for reproducibility

# ======================================================================
# Save the sNMF project
# ======================================================================
save(project, file = "GenFAW600_Whole_biallelic_geno08_Pruned0.5_noASW7.RData")

# ======================================================================
# Plot cross-entropy results
# ======================================================================

# Load the sNMF project
project <- load.snmfProject("GenFAW600_Whole_biallelic_geno08_Pruned0.5_noASW7.snmfProject")

# Define the range of K values
Ks <- 2:8

# Compute the mean cross-entropy for each K
ce <- sapply(Ks, function(k) mean(cross.entropy(project, K = k)))

# Identify the best K (minimum cross-entropy)
best_K <- Ks[which.min(ce)]
cat("Best K:", best_K, "\n")

# Save the cross-entropy plot as a PDF
pdf("cross_entropy.pdf")
plot(Ks, ce, type = "b", pch = 19, col = "blue",
     xlab = "K (number of clusters)",
     ylab = "Cross-Entropy",
     main = "Cross-Entropy Criterion (sNMF)")
dev.off()

##############################################################################################
# Plot ancestry barplots with ordered metadata
##############################################################################################

# Load metadata file (edit the filename and separator if needed)
metadata <- read.table("metadata_sNMF.ind", header = TRUE, sep = ",")

# Get Q-matrix for the best K
Q_matrix <- Q(project, K = best_K)

# Add a column for original sample order
metadata$index <- 1:nrow(metadata)

# Ensure that population is treated as a factor
metadata$pop <- factor(metadata$pop)

# Reorder samples by population
order_idx <- order(metadata$pop)
Q_matrix_ordered <- Q_matrix[order_idx, ]
metadata_ordered <- metadata[order_idx, ]

# Save ordered outputs (useful for reproducibility)
write.csv(Q_matrix_ordered, "Q_matrix_ordered.csv", row.names = FALSE)
write.csv(metadata_ordered, "metadata_ordered.csv", row.names = FALSE)

# Labels (population names)
labels <- metadata_ordered$pop

# Save the ordered admixture barplot for the best K
pdf("admixture_barplot_pop_bestK.pdf", width = 12, height = 6)
barplot(t(Q_matrix_ordered),
        col = rainbow(best_K),
        border = NA,
        space = 0,
        main = paste("Genetic Structure - K =", best_K),
        names.arg = labels,
        las = 2,               # Rotate labels vertically
        cex.names = 0.6)       # Label size
dev.off()


##############################################################################################
# Plot admixture barplots for all tested K values
##############################################################################################

# Loop over all K values tested in the project
for (k in Ks) {
  Qk <- Q(project, K = k)
  pdf(paste0("admixture_barplot_K", k, ".pdf"), width = 12, height = 6)
  barplot(t(Qk[order_idx, ]),
          col = rainbow(k),
          border = NA,
          space = 0,
          main = paste("Genetic Structure - K =", k),
          names.arg = labels,
          las = 2,
          cex.names = 0.6)
  dev.off()
}

