

# INFRAESTRUTURA BASICA - 2009 -------------------------------------------


infraestrutura_basica <- readr::read_rds("docs/dados/03-infraestrutura-basica.rds")

infra_basica_2009 <- infraestrutura_basica |>
  dplyr::filter(ano == 2009) |>
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


# INFRAESTRUTURA FISICA - 2009 --------------------------------------------

infraestrutura_fisica <- readr::read_rds("docs/dados/04-infraestrutura-fisica.rds")

infra_fisica_2009 <- infraestrutura_fisica |>
  dplyr::filter(ano == 2009) |>
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


# DISPONIBILIDADE DE EQUIPAMENTOS - 2009 ----------------------------------

disponibilidade_equipamentos <- readr::read_rds("docs/dados/05-disponibilidade-equipamentos.rds")

disp_equip_2009 <- disponibilidade_equipamentos |>
  dplyr::filter(ano == 2009) |>
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


# UNIAO DAS BASES INFRAESTRUTURA ESCOLAR 2009 -----------------------------

infraestrutura_escolar_2009 <-
  dplyr::left_join(
    infra_basica_2009,
    infra_fisica_2009,
    by = c("ano", "sigla_uf", "id_municipio", "id_escola")
  ) |>
  dplyr::left_join(
    disp_equip_2009,
    by = c("ano", "sigla_uf", "id_municipio", "id_escola" = "id_entidade")
  )



# INDICE DE INFRAESTRUTURA ESCOLAR 2009 -----------------------------------

iie_2009 <- infraestrutura_escolar_2009 |>
  dplyr::group_by(ano, sigla_uf, id_municipio, id_escola) |>
  dplyr::mutate(
    iie_09 = sum(
      i_b,
      i_f,
      d_e,
      na.rm = TRUE
    ) / 3
  ) |>
  dplyr::ungroup()


readr::write_rds(iie_2009, "docs/dados/11-iie-2009.rds")



# MONTAGEM DA TABELA DE IIE 2009 ------------------------------------------

iie_2009_estados <- iie_2009 |>
  dplyr::group_by(sigla_uf) |>
  dplyr::summarise(
    media = round(mean(iie_09), 4),
    mediana = round(median(iie_09), 4),
    minimo = round(min(iie_09), 4),
    maximo = round(max(iie_09), 4),
    desvio_padrao = round(sd(iie_09), 4),
    coeficiente_variacao = round(((desvio_padrao/media)*100), 2)
  ) |>
  dplyr::ungroup()
