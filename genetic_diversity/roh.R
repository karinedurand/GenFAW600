# Charger les bibliothèques nécessaires
library(tidyverse) 
library(ggpubr)      
library(viridis)     
library(patchwork)
setwd("/home/karine/Documents/Obsidian_Vault/Spodo/GenFAW600/LROH/")
# 1. Lire le fichier .roh (sortie de VCFtools)
# Remplacez "votre_fichier.roh" par le chemin vers votre fichier
roh_data <- read.table("whole.LROH",
                       header = TRUE,
                      sep = "\t")

# Convertir LENGTH_KB en LENGTH_KB (optionnel, pour une meilleure lisibilité)
roh_data$LENGTH_KB <- (roh_data$AUTO_END - roh_data$AUTO_START  ) / 1000
#Small ROH: Between 1KB and 10KB
Small_ROH <- roh_data[roh_data$LENGTH_KB > 1 & roh_data$LENGTH_KB < 10, ]# DOI: 10.1093/g3journal/jkab085 # reste 
Small_ROH <- Small_ROH[Small_ROH$N_VARIANTS_BETWEEN_MAX_BOUNDARIES > 15, ] # 82928 roh


#Medium ROH: between 1KB and 100KB
Medium_ROH <- roh_data[roh_data$LENGTH_KB > 10 & roh_data$LENGTH_KB < 100, ]
Medium_ROH  <- Medium_ROH[Medium_ROH$N_VARIANTS_BETWEEN_MAX_BOUNDARIES > 15, ] # 65938

Large_ROH  <- roh_data[roh_data$LENGTH_KB > 100 , ]
Large_ROH  <- Large_ROH[Large_ROH$N_VARIANTS_BETWEEN_MAX_BOUNDARIES > 15, ] # 44923

# 2. Lire les métadonnées (ex. : CSV avec colonnes "INDIV" et "POP")

meta_data <- read.csv("metadata_roh_country.csv", sep = "\t", header = FALSE)  # ou "," selon votre fichier

Small_ROH_pop <- left_join(Small_ROH, meta_data, by = c("INDV" = "V2")) 

Medium_ROH_pop <- left_join(Medium_ROH, meta_data, by = c("INDV" = "V2")) 

Large_ROH_pop <- left_join(Large_ROH , meta_data, by = c("INDV" = "V2")) 



####################################################################################################################"
# 2. Recalcule stats_roh AVEC V1 ordonné par individu 
#Ancêtres communs anciens,faible consanguinité, grande diversité génétique.
stats_Small <- Small_ROH_pop %>%
  group_by(INDV, V1) %>%
  summarise(
    Total_LROH = n(),
    Mean_Length_KB = mean(LENGTH_KB, na.rm = TRUE),
    Total_Length_KB = sum(LENGTH_KB, na.rm = TRUE),
    # somme des ROH uniquement sur les 28 premiers chromosomes pour F_ROH
    ROH_density = Total_Length_KB / 381125,
    .groups = "drop"
  )
stats_Small <- stats_Small %>%
  arrange(V1) %>%
  mutate(levels = row_number())
write.csv(stats_Small,"stats_Small.csv")

#petite taille effective (Ne), isolement géographique ou reproductif.consanguinité ancienne mais non immédiate

stats_Medium <-Medium_ROH_pop %>%
  group_by(INDV, V1) %>%
  summarise(
    Total_LROH = n(),
    Mean_Length_KB = mean(LENGTH_KB, na.rm = TRUE),
    Total_Length_KB = sum(LENGTH_KB, na.rm = TRUE),
    # somme des ROH uniquement sur les 28 premiers chromosomes pour F_ROH
    ROH_density = Total_Length_KB / 381125,
    .groups = "drop"
  )
stats_Medium <- stats_Medium %>%
  arrange(V1) %>%
  mutate(levels = row_number())
write.csv(stats_Medium,"stats_Medium.csv")

#Longs ROH Parents apparentés récemment (consanguinité récente)Individus issus de croisements consanguins récents

stats_Large <- Large_ROH_pop %>%
  group_by(INDV, V1) %>%
  summarise(
    Total_LROH = n(),
    Mean_Length_KB = mean(LENGTH_KB, na.rm = TRUE),
    Total_Length_KB = sum(LENGTH_KB, na.rm = TRUE),
    # somme des ROH uniquement sur les 28 premiers chromosomes pour F_ROH
    ROH_density = Total_Length_KB / 381125,
    .groups = "drop"
  )
stats_Large  <- stats_Large  %>%
  arrange(V1)%>%
  mutate(levels = row_number())
write.csv(stats_Large,"stats_Large.csv")


#####################################################################################ROH were divided into three classes based on size: short (0.5-1Mb), medium (1-5Mb) and large (>5Mb)#"
# 3. Visualisation : Distribution des longueurs de LROH par INDV

p1 <- ggplot(stats_Small, aes(x = levels, y = ROH_density, fill = V1)) +
  geom_col() +
  labs(  title = "Small 1-10KB",
         x = "Pop",
              y = "ROH_density)",
              fill = "Population") +
  theme_minimal() +
  scale_fill_viridis(discrete = TRUE)
p1
# b) Nombre total de LROH par individu et par population
p2 <- ggplot(stats_Medium, aes(x = levels, y = ROH_density, fill = V1)) +
  geom_col() +
  labs(  title = "Medium 10-100KB",
         x = "Pop",
         y = "ROH_density)",
         fill = "Population") +
  theme_minimal() +
  scale_fill_viridis(discrete = TRUE)
p2
# c) Longueur totale des LROH par individu et par population
p3 <- ggplot(stats_Large, aes(x = levels, y = ROH_density, fill = V1)) +
  geom_col() +
  labs(  title = "Large > 100KB",
         x = "Pop",
         y = "ROH_density)",
         fill = "Population") +
  theme_minimal() +
  scale_fill_viridis(discrete = TRUE)
p3


# Afficher les graphiques
print(p1)
print(p2)
print(p3)

# 6. Sauvegarder les graphiques (optionnel)

p_combined <- p1 / p2 / p3
p_combined
ggsave("ROH_density.pdf", plot = p_combined, width = 10, height = 6, dpi = 300)




######################################################################################################"
#BY CHROM
########################################################################################################

library(dplyr)
library(ggplot2)
library(patchwork)
chrom_length <- read_csv("chrom_length.csv")

Large_ROH_pop <- Large_ROH_pop %>%
  left_join(chrom_length, by = "CHROM")

# === 1. Préparer les données : ROH par CHROM et POPULATION ===
Large_by_chr_pop <- Large_ROH_pop %>% 
  mutate(CHROM = as.factor(CHROM)) %>% 
  group_by(V1, CHROM) %>%
  summarise( Total_Length_KB = sum(LENGTH_KB),
             chrom_length = first(chrom_length), # taille du chromosome correspondante
             ROH_density = Total_Length_KB / chrom_length, .groups = "drop" )


p5=ggplot(Large_by_chr_pop %>%
            filter(V1 %in% c("Africa")) , aes(x = CHROM, y = ROH_density, fill = V1)) +
  geom_col(width = 0.8) +  
  labs(title = "Africa",
       x = "Pop",
       y = "ROH_density",
       fill = "Pop") +
  theme_minimal() + theme(legend.position = "none") +scale_fill_viridis(discrete = TRUE)+ylim(0,30)
p5
p6=ggplot(Large_by_chr_pop %>%
            filter(V1 %in% c("Invasive_west_62")) , aes(x = CHROM, y = ROH_density, fill = V1)) +
  geom_col(width = 0.8) +  
  labs(title = "Invasive_west_62",
       x = "Pop",
       y = "ROH_density",
       fill = "Pop") +
  theme_minimal() + theme(legend.position = "none") +scale_fill_viridis(discrete = TRUE)+ylim(0,30)
p6
p7=ggplot(Large_by_chr_pop %>%
            filter(V1 %in% c("Malaysia")) , aes(x = CHROM, y = ROH_density, fill = V1)) +
  geom_col(width = 0.8) +  
  labs(title = "Malaysia",
       x = "Pop",
       y = "ROH_density",
       fill = "Pop") +
  theme_minimal() + theme(legend.position = "none") +scale_fill_viridis(discrete = TRUE)+ylim(0,30)
p7
p8=ggplot(Large_by_chr_pop %>%
            filter(V1 %in% c("Mex_27")) , aes(x = CHROM, y = ROH_density, fill = V1)) +
  geom_col(width = 0.8) +  
  labs(title = "Mex_27",
       x = "Pop",
       y = "ROH_density",
       fill = "Pop") +
  theme_minimal() + theme(legend.position = "none") +scale_fill_viridis(discrete = TRUE)+ylim(0,30)
p8

p9=ggplot(Large_by_chr_pop %>%
            filter(V1 %in% c("USA_81")) , aes(x = CHROM, y = ROH_density, fill = V1)) +
  geom_col(width = 0.8) +  
  labs(title = "USA_81",
       x = "Pop",
       y = "ROH_density",
       fill = "Pop") +
  theme_minimal() + theme(legend.position = "none") +scale_fill_viridis(discrete = TRUE)+ylim(0,30)
p9
p10=ggplot(Large_by_chr_pop %>%
             filter(V1 %in% c("USA_grasses_29")) , aes(x = CHROM, y = ROH_density, fill = V1)) +
  geom_col(width = 0.8) +  
  labs(title = "USA_grasses_29",
       x = "Pop",
       y = "ROH_density",
       fill = "Pop") +
  theme_minimal() + theme(legend.position = "none") +scale_fill_viridis(discrete = TRUE)+ylim(0,30)
p10
p11=ggplot(Large_by_chr_pop %>%
             filter(V1 %in% c("Zambia_12")) , aes(x = CHROM, y = ROH_density, fill = V1)) +
  geom_col(width = 0.8) +  
  labs(title = "Zambia_12",
       x = "Pop",
       y = "ROH_density",
       fill = "Pop") +
  theme_minimal() + theme(legend.position = "none")  +scale_fill_viridis(discrete = TRUE)+ylim(c(0,30))
p11

# ==============================================================
# 6. Afficher et sauvegarder
# ==============================================================

p_final <- p5 / p6 / p7 / p11
p_final
ggsave("ROH_density_by_chrom_invasive.pdf", plot = p_final, width = 10, height = 6, dpi = 300)

p_final2 <-p8/ p9 / p10 
p_final2

ggsave("ROH_density_by_chrom_native.pdf", plot = p_final2, width = 10, height = 6, dpi = 300, bg = "white")

