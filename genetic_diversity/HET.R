library(ggplot2)
library(patchwork)
library(dplyr)
library(readr)


setwd("/home/karine/Documents/Obsidian_Vault/Spodo/GenFAW600/HET/")
imbreeding <- read_delim("imbreeding.het",  delim = "\t", escape_double = FALSE, trim_ws = TRUE)
sample  <- read_csv("metadata_roh.csv",          col_names = TRUE)

resultat <- merge(imbreeding, sample, by = "INDV")

# 1. Définis l'ordre exact des populations que tu veux
ordre_des_pops <- c(  "Invasive_east_198","Invasive_west_62", "USA_grasses_29","USA_81","Mex_27","Zambia_12")  # ← change ici !

# 2. Tri + création de l'indice
resultat_ordonne <- resultat %>%
  mutate(pop = factor(pop, levels = ordre_des_pops)) %>%   # force l'ordre des pops
  arrange(pop, INDV) %>%                                   # tri par pop puis par nom d'individu
  mutate(indice = row_number()) %>%                        # colonne 1, 2, 3, ..., n
  mutate(INDV_label = INDV)


ggplot(resultat_ordonne, aes(x = indice, y = F, fill = pop)) +
  geom_col(width = 0.95) +
  scale_x_continuous(breaks = resultat_ordonne$indice,
                     labels = resultat_ordonne$INDV_label) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 3)) +
  labs( y = "F", fill = "Pop") +
  scale_fill_brewer(palette = "Set1")+
  theme_minimal()



violin<-ggplot(resultat, aes(x = pop, y = F, fill = pop)) +
  geom_violin(trim = FALSE, alpha = 0.7) +
  geom_boxplot(width = 0.1, outlier.size = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_minimal()
violin
boxplot<-ggplot(resultat, aes(x = pop, y = F, fill = pop)) +
  geom_boxplot() +
  geom_boxplot(width = 0.1, outlier.size = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  theme_minimal()
boxplot

p <- (violin /
        boxplot)
ggsave("HET.pdf", plot = p, width = 11.7, height = 8.3, dpi = 300, bg = "white")

ggplot(resultat, aes(x = INDV, y = F, fill = pop)) +
  geom_col(width = 0.8) +
  theme_minimal()