# =============================================================================
# FIGURE: ACP REC MEMBERSHIP MAP (for paper Section 2)
# =============================================================================
# Run locally -- needs internet access to fetch Natural Earth shapefiles the
# first time (cached afterward by rnaturalearth). Reuses REC_MEMBERSHIP_STATIC,
# MRT_REC, TLS_REC, BDI_RWA_REC, COD_REC, and REC_COLOURS from the two pipeline
# scripts, so source 01_build_panel.r (or at least its Sections 2-3) and
# 02_estimate_gravity.r's REC_COLOURS definition before running this.
#
# Africa-only: Caribbean (CARIFORUM) and Pacific (PIF) panels were dropped
# rather than fixed for the antimeridian rendering bug, since Table 0 already
# carries CARIFORUM/PIF membership in tabular form.

library(sf)
library(rnaturalearth)
library(dplyr)
library(ggplot2)

# --- Build a static country -> REC lookup (current-day membership, ignoring
# the time-varying spells -- a membership MAP is a point-in-time picture, not
# a panel variable, so it uses each country's LATEST coded REC) -------------
# NOTE: KEN_UGA_REC and TZA_REC must be included in this bind_rows().
# REC_MEMBERSHIP_STATIC no longer carries KEN/UGA/TZA at all (they were made
# time-varying in 01_build_panel.r -- see its line-346 comment), so without
# these two tables the join below silently drops all three countries and
# only BDI/RWA show up as EAC on the map.
rec_map_lookup <- bind_rows(
  REC_MEMBERSHIP_STATIC,
  MRT_REC     |> filter(year == max(year)) |> select(iso3, rec),
  TLS_REC     |> filter(year == max(year)) |> select(iso3, rec),
  BDI_RWA_REC |> filter(year == max(year)) |> select(iso3, rec),
  COD_REC     |> filter(year == max(year)) |> select(iso3, rec),
  KEN_UGA_REC |> filter(year == max(year)) |> select(iso3, rec),
  TZA_REC     |> filter(year == max(year)) |> select(iso3, rec)
) |>
  filter(!is.na(rec)) |>
  distinct(iso3, .keep_all = TRUE)

world <- ne_countries(scale = "medium", returnclass = "sf") |>
  left_join(rec_map_lookup, by = c("iso_a3" = "iso3"))

# Africa-only panel below (coord_sf just clips the view -- it does not drop
# rows -- so CARIFORUM/PIF countries would otherwise still supply their `rec`
# levels to scale_fill_manual and appear as legend swatches with nothing
# plotted under them). Blank their `rec` to NA here so the legend matches what
# is actually drawn.
AFRICA_RECS <- c("ECOWAS", "Central Africa", "SADC", "EAC", "ESA")
world <- world |>
  mutate(rec = if_else(rec %in% AFRICA_RECS, rec, NA_character_))

make_panel <- function(world_sf, xlim, ylim, title) {
  ggplot(world_sf) +
    geom_sf(aes(fill = rec), colour = "grey40", linewidth = 0.15) +
    geom_sf(data = world_sf |> filter(is.na(rec)),
            fill = "grey92", colour = "grey70", linewidth = 0.1) +
    coord_sf(xlim = xlim, ylim = ylim, expand = FALSE) +
    scale_fill_manual(values = REC_COLOURS, na.translate = FALSE, name = "REC") +
    labs(title = title) +
    theme_minimal() +
    theme(axis.text = element_blank(), axis.title = element_blank(),
          panel.grid = element_blank(), legend.position = "bottom")
}

fig_bloc_map <- make_panel(world, xlim = c(-20, 55), ylim = c(-35, 25), NULL)

print(fig_bloc_map)
ggsave("OUTPUT/figures/fig_bloc_map.png", fig_bloc_map, width = 8, height = 8, dpi = 300)
