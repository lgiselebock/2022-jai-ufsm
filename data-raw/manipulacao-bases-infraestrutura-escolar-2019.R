
# INFRAESTRUTURA BASICA 2019 ---------------------------------------------

infraestrutura_basica <- readr::read_rds("docs/dados/03-infraestrutura-basica.rds")

infra_basica_2019 <- infraestrutura_basica |>
  dplyr::filter(ano == 2019) |>
  dplyr::select(
    -c(
      nome_regiao,
      id_regiao,
      nome_municipio,
      nome_mesorregiao,
      id_mesorregiao,
      nome_microrregiao,
      id_microrregiao,
      tipo_dependencia
    )
  ) |>
  dplyr::group_by(sigla_uf, id_municipio, id_escola) |>
  tidyr::drop_na() |>
  dplyr::mutate(
    i_b = sum(
      local_func_predio_escolar,
      agua_filtrada_potavel,
      agua_rede_publica,
      energia_rede_publica,
      esgoto_rede_publica,
      lixo_servico_coleta,
      alimentacao,
      internet,
      na.rm = TRUE
    ) / 8
  ) |>
  dplyr::ungroup() |>
  dplyr::select(
    ano,
    sigla_uf,
    id_municipio,
    id_escola,
    i_b
  )


# INFRAESTRUTURA FÍSICA - 2019 --------------------------------------------

infraestrutura_fisica <- readr::read_rds("docs/dados/04-infraestrutura-fisica.rds")

infra_fisica_2019 <- infraestrutura_fisica |>
  dplyr::filter(ano == 2019) |>
  dplyr::select(
    -c(
      nome_regiao,
      id_regiao,
      nome_municipio,
      nome_mesorregiao,
      id_mesorregiao,
      nome_microrregiao,
      id_microrregiao,
      tipo_dependencia
    )
  ) |>
  dplyr::group_by(sigla_uf, id_municipio, id_escola) |>
  tidyr::drop_na() |>
  dplyr::mutate(
    i_f = sum(
      sala_professor,
      laboratorio_informatica,
      laboratorio_ciencias,
      quadra_esportes,
      cozinha,
      biblioteca,
      parque_infantil,
      banheiro,
      na.rm = TRUE
    ) / 8
  ) |>
  dplyr::ungroup() |>
  dplyr::select(
    ano,
    sigla_uf,
    id_municipio,
    id_escola,
    i_f
  )


# DISPONIBILIDADES DE EQUIPAMENTOS - 2019 ---------------------------------

disponibilidade_equipamentos <- readr::read_rds("docs/dados/05-disponibilidade-equipamentos.rds")

disp_equip_2019 <- disponibilidade_equipamentos |>
  dplyr::filter(ano == 2019) |>
  dplyr::select(
    -c(
      nome_regiao,
      id_regiao,
      nome_municipio,
      nome_mesorregiao,
      id_mesorregiao,
      nome_microrregiao,
      id_microrregiao,
      tipo_dependencia
    )
  ) |>
  dplyr::group_by(sigla_uf, id_municipio, id_entidade) |>
  tidyr::drop_na() |>
  dplyr::mutate(
    d_e = sum(
      tv,
      copiadora,
      impressora,
      computador,
      na.rm = TRUE
    ) / 4
  ) |>
  dplyr::ungroup() |>
  dplyr::select(
    ano,
    sigla_uf,
    id_municipio,
    id_entidade,
    d_e
  )



# UNIAO DAS BASES DE INFRAESTRUTURA ESCOLAR - 2019 ------------------------

infraestrutura_escolar_2019 <-
  dplyr::left_join(
    infra_basica_2019,
    infra_fisica_2019,
    by = c("ano", "sigla_uf", "id_municipio", "id_escola")
  ) |>
  dplyr::left_join(
    disp_equip_2019,
    by = c("ano", "sigla_uf", "id_municipio", "id_escola" = "id_entidade")
  )



# INDICE DE INFRAESTRUTURA ESCOLAR - 2019 ---------------------------------

iie_2019 <- infraestrutura_escolar_2019 |>
  dplyr::group_by(ano, sigla_uf, id_municipio, id_escola) |>
  dplyr::mutate(
    iie_19 = sum(
      i_b,
      i_f,
      d_e,
      na.rm = TRUE
    ) / 3
  ) |>
  dplyr::ungroup()


readr::write_rds(iie_2019, "docs/dados/12-iie-2019.rds")



