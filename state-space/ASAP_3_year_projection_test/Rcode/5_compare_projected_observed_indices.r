source("4_calculate_projected_indices.r")

# 5_compare_projected_observed_indices.r
# how well did the projections predict the observed indices?

# remember to set working directory to source file location

agg.ind.plot <- ggplot(ind.pred.agg.df, aes(x=ProjYear, y=PredIndex, group=Index)) +
  geom_jitter(alpha=0.2, height = 0, width = 0.2) +
  geom_point(data = indices3proj.df, aes(x=ProjYear, y=ObsIndex, group=Index), color="red") +
  facet_wrap(~Index) +
  expand_limits(y = 0) +
  theme_bw()

#print(agg.ind.plot)
ggsave("..\\output\\aggregate_index_plot.png", agg.ind.plot)

# need to figure out a nice way to plot indices at age comparison
