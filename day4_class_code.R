2+3
x <- 10
x
micro <- read.csv("mouse_microbiome.csv")
head(micro)
summary(micro)
# Isolate the column Firmicutes and calculate mean and variance
micro$Firmicutes
mean(micro$Firmicutes)
var(micro$Firmicutes)

micro$Total <- micro$Firmicutes + micro$Proteobacteria + micro$Actinobacteria +
                micro$Bacteroidetes + micro$Other
micro$Firm_prop <- micro$Firmicutes/micro$Total
head(micro)
table(micro$Source)
hist(micro$Firm_prop)
boxplot(Firm_prop ~ Source, data=micro)
str(micro)

# CLAUDE CODE STARTS HERE
library(ggplot2)
library(scales)
library(tidyr)

micro$Source <- factor(micro$Source, levels = c("Gut", "Stool"))
stopifnot(all(table(micro$Mouse, micro$Source) == 1))

# ---- Paired test ----
wide <- pivot_wider(micro[, c("Mouse", "Source", "Firm_prop")],
                    names_from = Source, values_from = Firm_prop)
wt <- wilcox.test(wide$Gut, wide$Stool, paired = TRUE, exact = FALSE)
n_pairs <- nrow(wide)

p_lab <- if (wt$p.value < 0.001) {
  "italic(p) < 0.001"
} else {
  paste0("italic(p) == ", formatC(wt$p.value, format = "f", digits = 3))
}

# ---- Layout: points/lines at x = 1, 2; boxes offset outward ----
micro$x_pt  <- as.numeric(micro$Source)
micro$x_box <- ifelse(micro$Source == "Gut", 0.72, 2.28)

cols <- c(Gut = "#2A6F97", Stool = "#C8553D")

y_max  <- max(micro$Firm_prop)
y_br   <- y_max * 1.07          # bracket height
tick   <- y_max * 0.025         # bracket tick length

p <- ggplot(micro) +
  # paired lines
  geom_line(aes(x = x_pt, y = Firm_prop, group = Mouse),
            colour = "grey70", linewidth = 0.3, alpha = 0.8) +
  # points
  geom_point(aes(x = x_pt, y = Firm_prop, fill = Source),
             shape = 21, size = 2.3, colour = "white", stroke = 0.4) +
  # slim boxes, offset outward
  geom_boxplot(aes(x = x_box, y = Firm_prop, group = Source, colour = Source),
               width = 0.16, outlier.shape = NA, fill = "white",
               linewidth = 0.45, median.linewidth = 0.9) +
  # significance bracket
  annotate("segment", x = 1, xend = 2, y = y_br, yend = y_br, linewidth = 0.35) +
  annotate("segment", x = c(1, 2), xend = c(1, 2),
           y = y_br, yend = y_br - tick, linewidth = 0.35) +
  annotate("text", x = 1.5, y = y_br + tick * 1.6, label = p_lab,
           parse = TRUE, size = 3.4) +
  scale_fill_manual(values = cols) +
  scale_colour_manual(values = cols) +
  scale_x_continuous(breaks = 1:2,
                     labels = c(paste0("Gut\n(n = ", n_pairs, ")"),
                                paste0("Stool\n(n = ", n_pairs, ")")),
                     limits = c(0.55, 2.45), expand = c(0, 0)) +
  scale_y_continuous(labels = percent_format(accuracy = 1),
                     limits = c(0, y_br + tick * 4),
                     expand = expansion(mult = c(0, 0)),
                     breaks = pretty_breaks(5)) +
  labs(x = NULL, y = "Firmicutes (% of reads)") +
  theme_classic(base_size = 11, base_family = "sans") +
  theme(
    legend.position  = "none",
    axis.line.x      = element_blank(),
    axis.ticks.x     = element_blank(),
    axis.line.y      = element_line(linewidth = 0.4, colour = "grey20"),
    axis.ticks.y     = element_line(linewidth = 0.4, colour = "grey20"),
    axis.ticks.length.y = unit(2.5, "pt"),
    axis.text        = element_text(colour = "grey15"),
    axis.text.x      = element_text(size = 10.5, lineheight = 0.95,
                                    margin = margin(t = 4)),
    axis.title.y     = element_text(margin = margin(r = 8)),
    plot.margin      = margin(10, 10, 6, 8)
  )

p
# CLAUDE CODE ENDS HERE
gut<-micro[micro$Source=="Gut",]
stool<-micro[micro$Source=="Stool",]
t.test(gut$Firm_prop, stool$Firm_prop, paired=TRUE)
# paired t-test

write.csv(micro, "microbiome_results.csv")
