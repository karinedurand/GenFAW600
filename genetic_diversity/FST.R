library(ggplot2)
library(patchwork)
library(dplyr)
library(readr)
setwd("/home/karine/Documents/Obsidian_Vault/Spodo/GenFAW600/FST/results_w100000/")

# ==============================================================
# 1. Chargement des 15 fichiers FST
# ==============================================================
fst_files <- c(
  "Invasive_east_198_inasive_west.windowed.weir.fst",
  "Invasive_east_198_mexico.windowed.weir.fst",
  "Invasive_east_198_USA_81.windowed.weir.fst",
  "Invasive_east_198_USA_grasses_29.windowed.weir.fst",
  "Zambia_Invasive_east_198.windowed.weir.fst",
  "Mex_Invasive_west_62.windowed.weir.fst",
  "Invasive_west_62_USA_81.windowed.weir.fst",
  "Invasive_west_62_USA_grasses_29.windowed.weir.fst",
  "Zambia_Invasive_west_62.windowed.weir.fst",
  "Mex_USA_81.windowed.weir.fst",
  "Mex_USA_grasses_29.windowed.weir.fst",
  "Zambia_mexico.windowed.weir.fst",
  "USA_81_USA_grasses_29.windowed.weir.fst",
  "Zambia_USA_81.windowed.weir.fst",
  "Zambia_USA_grasses_29.windowed.weir.fst"
)

pair_titles <- c(
  "Invasive_east_198 vs Invasive_west_62",
  "Invasive_east_198 vs Mex_27",
  "Invasive_east_198 vs USA_81",
  "Invasive_east_198 vs USA_grasses_29",
  "Invasive_east_198 vs Zambia_12",
  "Invasive_west_62 vs Mex_27",
  "Invasive_west_62 vs USA_81",
  "Invasive_west_62 vs USA_grasses_29",
  "Invasive_west_62 vs Zambia_12",
  "Mex_27 vs USA_81",
  "Mex_27 vs USA_grasses_29",
  "Mex_27 vs Zambia_12",
  "USA_81 vs USA_grasses_29",
  "USA_81 vs Zambia_12",
  "USA_grasses_29 vs Zambia_12"
)

# Charger tous les fichiers
fst_dataframes <- lapply(fst_files, function(f) read_delim(f, delim = "\t", escape_double = FALSE,   trim_ws = TRUE))


# ==============================================================
# 2. Boucle : 15 Manhattan plots avec style FST_F2_dead_alive
# ==============================================================
plots <- list()

for (i in 1:15) {
  
  df <- fst_dataframes[[i]] %>%
    filter(complete.cases(.)) %>%
    mutate(SNP = row_number())
  
  # Forcer chromosomes 1 à 29
  df$CHROM <- factor(df$CHROM, levels = as.character(1:29))
  df <- df[order(df$CHROM), ]
  
  # Calcul des centres
  vg1 <- df %>%
    group_by(CHROM) %>%
    summarise(
      min_pos = min(SNP),
      max_pos = max(SNP),
      .groups = 'drop'
    ) %>%
    mutate(center = (min_pos + max_pos) / 2) %>%
    rename(chro = CHROM)
  
  # Graphique
  p <- ggplot(df, aes(x = SNP, y = WEIGHTED_FST, color = CHROM)) +
    geom_point(size = 0.3) +
    scale_color_manual(values = rep(c("darkslateblue", "cadetblue"), 15)) +
    scale_x_continuous(
      label = vg1$chro,
      breaks = vg1$center,
      expand = c(0.01, 0.01)
    ) +
    ggtitle(pair_titles[i]) +  # Titre = nom de la comparaison
    xlab('Chromosome') +
    ylab("FST") +
    theme_bw() +
    theme(
      panel.grid = element_blank(),
      legend.position = "none",
      panel.grid.major.x = element_blank(),
      axis.text = element_text(size = 7),
      axis.title = element_text(size = 12),
      plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
      strip.text.y = element_text(size = 10),
      plot.margin = margin(5, 5, 5, 5)
    )
  
  plots[[i]] <- p
}

# ==============================================================
# 3. Assemblage vertical des 15 graphiques
# ==============================================================
p_final <- wrap_elements(plots[[1]]) /
  wrap_elements(plots[[2]]) /
  wrap_elements(plots[[3]]) /
  wrap_elements(plots[[4]]) /
  wrap_elements(plots[[5]]) /
  wrap_elements(plots[[6]]) /
  wrap_elements(plots[[7]]) /
  wrap_elements(plots[[8]]) /
  wrap_elements(plots[[9]]) /
  wrap_elements(plots[[10]]) /
  wrap_elements(plots[[11]]) /
  wrap_elements(plots[[12]]) /
  wrap_elements(plots[[13]]) /
  wrap_elements(plots[[14]]) /
  wrap_elements(plots[[15]])



# ==============================================================
# 4. Afficher & Sauvegarder
# ==============================================================
print(p_final)

ggsave( plot = p_final, width = 16, height = 40, dpi = 300, bg = "white")

ggsave("FST_manhattan_15_pairs_vertical.png",
       plot = p_final, width = 16, height = 40, dpi = 300, bg = "white")
###################################################################################################################
###################################################################################################################
###################################################################################################################

setwd("/home/karine/Documents/Obsidian_Vault/Spodo/GenFAW600/dxy/results/")

# ==============================================================
# 1. Chargement des 15 fichiers FST
# ==============================================================
dxy_files <- c(
  "Invasive_east_198_Invasive_west_62.all_chromosomes.csv",
  "Invasive_east_198_Mex_27.all_chromosomes.csv",
  "Invasive_east_198_USA_81.all_chromosomes.csv",
  "Invasive_east_198_USA_grasses_29.all_chromosomes.csv",
  "Invasive_east_198_Zambia_12.all_chromosomes.csv",
  "Invasive_west_62_Mex_27.all_chromosomes.csv",
  "Invasive_west_62_USA_81.all_chromosomes.csv",
  "Invasive_west_62_USA_grasses_29.all_chromosomes.csv",
  "Invasive_west_62_Zambia_12.all_chromosomes.csv",
  "Mex_27_USA_81.all_chromosomes.csv",
  "Mex_27_USA_grasses_29.all_chromosomes.csv",
  "Mex_27_Zambia_12.all_chromosomes.csv",
  "USA_81_USA_grasses_29.all_chromosomes.csv",
  "USA_81_Zambia_12.all_chromosomes.csv",
  "USA_grasses_29_Zambia_12.all_chromosomes.csv"
)

pair_titles <- c(
  "Invasive_east_198 vs Invasive_west_62",
  "Invasive_east_198 vs Mex_27",
  "Invasive_east_198 vs USA_81",
  "Invasive_east_198 vs USA_grasses_29",
  "Invasive_east_198 vs Zambia_12",
  "Invasive_west_62 vs Mex_27",
  "Invasive_west_62 vs USA_81",
  "Invasive_west_62 vs USA_grasses_29",
  "Invasive_west_62 vs Zambia_12",
  "Mex_27 vs USA_81",
  "Mex_27 vs USA_grasses_29",
  "Mex_27 vs Zambia_12",
  "USA_81 vs USA_grasses_29",
  "USA_81 vs Zambia_12",
  "USA_grasses_29 vs Zambia_12"
)

# Charger tous les fichiers
dxy_dataframes <- lapply(dxy_files, function(f) read_delim(f, delim = "\t", escape_double = FALSE, trim_ws = TRUE)) 

# ==============================================================
# 2. Boucle : 15 Manhattan plots avec style FST_F2_dead_alive
# ==============================================================
Dxy_plots <- list()

for (i in 1:15) {
  
  df <- dxy_dataframes[[i]] %>%
    filter(complete.cases(.)) %>%
    mutate(SNP = row_number())
  
  # Forcer chromosomes 1 à 29
  df$chrom <- factor(df$chrom, levels = as.character(1:29))
  df <- df[order(df$chrom), ]
  
  # Calcul des centres
  vg1 <- df %>%
    group_by(chrom) %>%
    summarise(
      min_pos = min(SNP),
      max_pos = max(SNP),
      .groups = 'drop'
    ) %>%
    mutate(center = (min_pos + max_pos) / 2)   %>%  
    rename(chro = chrom)
  
  # Graphique
  p <- ggplot(df, aes(x = SNP, y = Dxy, color = chrom)) +
    geom_point(size = 0.3) +
    scale_color_manual(values = rep(c("darkslateblue", "cadetblue"), 15)) +
    scale_x_continuous(
      label = vg1$chro,
      breaks = vg1$center,
      expand = c(0.01, 0.01)
    ) +
    ggtitle(pair_titles[i]) +  # Titre = nom de la comparaison
    xlab('Chromosome') +
    ylab("Dxy") +
    theme_bw() +
    theme(
      panel.grid = element_blank(),
      legend.position = "none",
      panel.grid.major.x = element_blank(),
      axis.text = element_text(size = 7),
      axis.title = element_text(size = 12),
      plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
      strip.text.y = element_text(size = 10),
      plot.margin = margin(5, 5, 5, 5)
    )
  
  Dxy_plots[[i]] <- p
}

# ==============================================================
# 3. Assemblage vertical des 15 graphiques
# ==============================================================
p_final <- wrap_elements(Dxy_plots[[1]]) /
  wrap_elements(Dxy_plots[[2]]) /
  wrap_elements(Dxy_plots[[3]]) /
  wrap_elements(Dxy_plots[[4]]) /
  wrap_elements(Dxy_plots[[5]]) /
  wrap_elements(Dxy_plots[[6]]) /
  wrap_elements(Dxy_plots[[7]]) /
  wrap_elements(Dxy_plots[[8]]) /
  wrap_elements(Dxy_plots[[9]]) /
  wrap_elements(Dxy_plots[[10]]) /
  wrap_elements(Dxy_plots[[11]]) /
  wrap_elements(Dxy_plots[[12]]) /
  wrap_elements(Dxy_plots[[13]]) /
  wrap_elements(Dxy_plots[[14]]) /
  wrap_elements(Dxy_plots[[15]])



# ==============================================================
# 4. Afficher & Sauvegarder
# ==============================================================

library(patchwork)

## --- P1 ---
p1 <- (
  wrap_elements(plots[[1]]) /
    wrap_elements(Dxy_plots[[1]]) /
    wrap_elements(plots[[2]]) /
    wrap_elements(Dxy_plots[[2]])
)
ggsave("p1.pdf", plot = p1, width = 11.7, height = 8.3, dpi = 300, bg = "white")

## --- P2 ---
p2 <- (
  wrap_elements(plots[[3]]) /
    wrap_elements(Dxy_plots[[3]]) /
    wrap_elements(plots[[4]]) /
    wrap_elements(Dxy_plots[[4]])
)
ggsave("p2.pdf", plot = p2, width = 11.7, height = 8.3, dpi = 300, bg = "white")

## --- P3 ---
p3 <- (
  wrap_elements(plots[[5]]) /
    wrap_elements(Dxy_plots[[5]]) /
    wrap_elements(plots[[6]]) /
    wrap_elements(Dxy_plots[[6]])
)
ggsave("p3.pdf", plot = p3, width = 11.7, height = 8.3, dpi = 300, bg = "white")

## --- P4 ---
p4 <- (
  wrap_elements(plots[[7]]) /
    wrap_elements(Dxy_plots[[7]]) /
    wrap_elements(plots[[8]]) /
    wrap_elements(Dxy_plots[[8]])
)
ggsave("p4.pdf", plot = p4, width = 11.7, height = 8.3, dpi = 300, bg = "white")

## --- P5 ---
p5 <- (
  wrap_elements(plots[[9]]) /
    wrap_elements(Dxy_plots[[9]]) /
    wrap_elements(plots[[10]]) /
    wrap_elements(Dxy_plots[[10]])
)
ggsave("p5.pdf", plot = p5, width = 11.7, height = 8.3, dpi = 300, bg = "white")

## --- P6 ---
p6 <- (
  wrap_elements(plots[[11]]) /
    wrap_elements(Dxy_plots[[11]]) /
    wrap_elements(plots[[12]]) /
    wrap_elements(Dxy_plots[[12]])
)
ggsave("p6.pdf", plot = p6, width = 11.7, height = 8.3, dpi = 300, bg = "white")

## --- P7 ---
p7 <- (
  wrap_elements(plots[[13]]) /
    wrap_elements(Dxy_plots[[13]]) /
    wrap_elements(plots[[14]]) /
    wrap_elements(Dxy_plots[[14]])
)
ggsave("p7.pdf", plot = p7, width = 11.7, height = 8.3, dpi = 300, bg = "white")

## --- P8 ---
p8 <- (
  wrap_elements(plots[[15]]) /
    wrap_elements(Dxy_plots[[15]])
)
ggsave("p8.pdf", plot = p8, width = 11.7, height = 8.3, dpi = 300, bg = "white")



