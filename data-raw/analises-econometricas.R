

# AMBITO MUNICIPAL --------------------------------------------------------

## IDEB --------------------------------------------------------------------

ideb_2009 <- readr::read_rds("docs/dados/13-ideb-2009.rds")
ideb_2019 <- readr::read_rds("docs/dados/14-ideb-2019.rds")


ideb_muni_2009 <- ideb_2009 |>
  dplyr::rename("media_ideb_2009" = "media_ideb") |>
  dplyr::mutate(id_municipio = as.numeric(id_municipio)) |>
  dplyr::select(-ano)


ideb_muni_2019 <- ideb_2019 |>
  dplyr::rename("media_ideb_2019" = "media_ideb") |>
  dplyr::select(-ano)



muni_ideb <-
  dplyr::left_join(
    ideb_muni_2009,
    ideb_muni_2019,
    by = c("sigla_uf", "id_municipio")
  )


# INVESTIMENTOS PUBLICOS --------------------------------------------------

invest_publico <- readr::read_rds("docs/dados/15-invest-publico.rds")


invest_publico_muni_2009 <- invest_publico |>
  dplyr::filter(ano %in% c(2004:2008)) |>
  dplyr::group_by(sigla_uf, id_municipio) |>
  dplyr::summarise(
    total_valor_deflacionado_2009 = sum(valor_deflacionado, na.rm = TRUE)
  ) |>
  dplyr::ungroup() |>
  dplyr::mutate(id_municipio = as.numeric(id_municipio))



invest_publico_muni_2019 <- invest_publico |>
  dplyr::filter(ano %in% c(2014:2018)) |>
  dplyr::group_by(sigla_uf, id_municipio) |>
  dplyr::summarise(
    total_valor_deflacionado_2019 = sum(valor_deflacionado, na.rm = TRUE)
  ) |>
  dplyr::ungroup() |>
  dplyr::mutate(id_municipio = as.numeric(id_municipio))


muni_invest <-
  dplyr::left_join(
    invest_publico_muni_2009,
    invest_publico_muni_2019,
    by = c("sigla_uf", "id_municipio")
  )


# INFRAESTRUTURA ESCOLAR --------------------------------------------------

iie_2009 <- readr::read_rds("docs/dados/11-iie-2009.rds")
iie_2019 <- readr::read_rds("docs/dados/12-iie-2019.rds")


infraestrutura_2009 <- iie_2009 |>
  dplyr::select(sigla_uf, id_municipio, iie_09) |>
  dplyr::group_by(sigla_uf, id_municipio) |>
  dplyr::summarise(
    iie_09 = mean(iie_09, na.rm = TRUE)
  ) |>
  dplyr::ungroup()

infraestrutura_2019 <- iie_2019 |>
  dplyr::select(sigla_uf, id_municipio, iie_19) |>
  dplyr::group_by(sigla_uf, id_municipio) |>
  dplyr::summarise(
    iie_19 = mean(iie_19, na.rm = TRUE)
  ) |>
  dplyr::ungroup()


muni_infra <-
  dplyr::left_join(
    infraestrutura_2009,
    infraestrutura_2019,
    by = c("sigla_uf", "id_municipio")
  )



# JUNTANDO AS TRÊS BASES --------------------------------------------------

dados_muni_raw <-
  dplyr::left_join(
    muni_infra,
    muni_ideb,
    by = c("sigla_uf", "id_municipio")
  ) |>
  dplyr::left_join(
    muni_invest,
    by = c("sigla_uf", "id_municipio")
  )



# ANALISE ECONOMETRICA ----------------------------------------------------

dados_muni <- dados_muni_raw |>
  dplyr::mutate(
    ln_iie_09 = log(iie_09),
    ln_iie_19 = log(iie_19),
    ln_ideb_09 = log(media_ideb_2009),
    ln_ideb_19 = log(media_ideb_2019),
    ln_invpublico_09 = log(total_valor_deflacionado_2009),
    ln_invpublico_19 = log(total_valor_deflacionado_2019)
  ) |>
  dplyr::select(
    sigla_uf,
    id_municipio,
    tidyselect::starts_with("ln")
  )


readr::write_rds(dados_muni, "docs/dados/16-dados-muni-econometricos.rds")



# INVESTIMENTOS PUBLICOS x INFRAESTRUTURA ESCOLAR -------------------------

inv_infra_2009 <- lm(
  formula = ln_iie_09 ~ ln_invpublico_09,
  data = dados_muni
)

summary(inv_infra_2009)


inv_infra_2019 <- lm(
  formula = ln_iie_19 ~ ln_invpublico_19,
  data = dados_muni
)

summary(inv_infra_2019)

broom::tidy(inv_infra_2009)

inv_infra_2009$coefficients
