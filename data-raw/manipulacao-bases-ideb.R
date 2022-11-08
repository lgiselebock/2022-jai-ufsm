

# IDEB - 2009 -------------------------------------------------------------

ideb <- readr::read_rds("docs/dados/01-ideb.rds")

ideb_2009 <- ideb |>
  dplyr::filter(ano == c(2005, 2007, 2009)) |>
  dplyr::filter(ensino == "fundamental") |>
  dplyr::group_by(sigla_uf, id_municipio) |>
  dplyr::mutate(
    media_ideb = round(mean(ideb, na.rm = TRUE), 2),
    id_municipio = as.numeric(id_municipio)
  ) |>
  dplyr::ungroup() |>
  dplyr::select(
    sigla_uf,
    id_municipio,
    media_ideb
  ) |>
  dplyr::distinct(id_municipio, .keep_all = TRUE) |>
  dplyr::mutate(ano = 2009) |>
  dplyr::relocate(ano, .before = sigla_uf)

readr::write_rds(ideb_2009, "docs/dados/13-ideb-2009.rds")


# IDEB - 2019 -------------------------------------------------------------

ideb <- readr::read_rds("docs/dados/01-ideb.rds")

ideb_2019 <- ideb |>
  dplyr::filter(ano == c(2015, 2017, 2019)) |>
  dplyr::filter(ensino == "fundamental") |>
  dplyr::group_by(sigla_uf, id_municipio) |>
  dplyr::mutate(
    media_ideb = round(mean(ideb, na.rm = TRUE), 2),
    id_municipio = as.numeric(id_municipio)
  ) |>
  dplyr::ungroup() |>
  dplyr::select(
    sigla_uf,
    id_municipio,
    media_ideb
  ) |>
  dplyr::distinct(id_municipio, .keep_all = TRUE) |>
  dplyr::mutate(ano = 2019) |>
  dplyr::relocate(ano, .before = sigla_uf)

readr::write_rds(ideb_2019, "docs/dados/14-ideb-2019.rds")


# IDEB (POR ESTADOS) - 2009 -----------------------------------------------

ideb_2009 |>
  dplyr::group_by(sigla_uf) |>
  dplyr::summarise(
    media_ideb_09 = mean(media_ideb, na.rm = TRUE)
  ) |>
  dplyr::ungroup()


# IDEB (POR ESTADOS) - 2019 -----------------------------------------------

ideb_2019 |>
  dplyr::group_by(sigla_uf) |>
  dplyr::summarise(
    media_ideb_19 = mean(media_ideb, na.rm = TRUE)
  ) |>
  dplyr::ungroup()
