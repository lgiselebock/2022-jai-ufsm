

# IDEB --------------------------------------------------------------------

ideb <-
"SELECT *
FROM `basedosdados.br_inep_ideb.municipio`
WHERE ano IN (2005, 2007, 2009, 2015, 2017, 2019)" |>
  basedosdados::read_sql() |>
  dplyr::mutate_if(bit64::is.integer64, as.integer)


readr::write_rds(ideb, "docs/dados/01-ideb.rds")



# INVESTIMENTOS PUBLICOS --------------------------------------------------

investimento_publico <-
"SELECT ano, sigla_uf, id_municipio, conta, estagio_bd, id_conta_bd, conta_bd, valor
FROM `basedosdados.br_me_siconfi.municipio_despesas_funcao`
WHERE ano IN (2004, 2005, 2006, 2007, 2008, 2014, 2015, 2016, 2017, 2018) AND
      conta_bd = 'Educação' AND
      estagio_bd = 'Despesas Empenhadas'" |>
  basedosdados::read_sql() |>
  dplyr::mutate_if(bit64::is.integer64, as.integer)


readr::write_rds(investimento_publico, "docs/dados/02-investimento-publico.rds")



# INFRAESTRUTURA ----------------------------------------------------------


### Infraestrutura Básica -------------------------------------------------

#### Infraestrutura Básica - 2009 -----------------------------------------

infra_basica_2009 <- readr::read_delim(
  here::here("data-raw/data-censo-escolar/2009/dados/microdados_ed_basica_2009.csv"),
  delim = ";",
  escape_double = FALSE,
  trim_ws = TRUE,
  locale = readr::locale(encoding = "ISO-8859-1")
) |>
  janitor::clean_names() |>
  dplyr::select(
    nu_ano_censo,
    no_regiao,
    co_regiao,
    sg_uf,
    no_municipio,
    co_municipio,
    no_mesorregiao,
    co_mesorregiao,
    no_microrregiao,
    co_microrregiao,
    tp_dependencia,
    co_entidade,
    tp_localizacao,
    in_local_func_predio_escolar,
    in_agua_filtrada,
    # in_agua_potavel,
    in_agua_rede_publica,
    in_energia_rede_publica,
    in_esgoto_rede_publica,
    in_lixo_servico_coleta,
    in_alimentacao,
    in_internet
  ) |>
  dplyr::mutate(
    nu_ano_censo = as.integer(nu_ano_censo),
    co_regiao = as.integer(co_regiao),
    co_municipio = as.integer(co_municipio),
    co_mesorregiao = as.integer(co_mesorregiao),
    co_microrregiao = as.integer(co_microrregiao),
    tp_dependencia = as.integer(tp_dependencia),
    co_entidade = as.integer(co_entidade),
    tp_localizacao = as.integer(tp_localizacao),
    in_local_func_predio_escolar = as.integer(in_local_func_predio_escolar),
    in_agua_filtrada = as.integer(in_agua_filtrada),
    in_agua_rede_publica = as.integer(in_agua_rede_publica),
    in_energia_rede_publica = as.integer(in_energia_rede_publica),
    in_esgoto_rede_publica = as.integer(in_esgoto_rede_publica),
    in_lixo_servico_coleta = as.integer(in_lixo_servico_coleta),
    in_alimentacao = as.integer(in_alimentacao),
    in_internet = as.integer(in_internet)
  ) |>
  dplyr::rename(
    ano = nu_ano_censo,
    nome_regiao = no_regiao,
    id_regiao = co_regiao,
    sigla_uf = sg_uf,
    nome_municipio = no_municipio,
    id_municipio = co_municipio,
    nome_mesorregiao = no_mesorregiao,
    id_mesorregiao = co_mesorregiao,
    nome_microrregiao = no_microrregiao,
    id_microrregiao = co_microrregiao,
    tipo_dependencia = tp_dependencia,
    id_escola = co_entidade,
    tipo_localizacao = tp_localizacao,
    local_func_predio_escolar = in_local_func_predio_escolar,
    agua_filtrada_potavel = in_agua_filtrada,
    # in_agua_potavel,
    agua_rede_publica = in_agua_rede_publica,
    energia_rede_publica = in_energia_rede_publica,
    esgoto_rede_publica = in_esgoto_rede_publica,
    lixo_servico_coleta = in_lixo_servico_coleta,
    alimentacao = in_alimentacao,
    internet = in_internet
  ) |>
  dplyr::filter(
    tipo_dependencia %in% c(2, 3)
  )


#### Infraestrutura Básica - 2019 -----------------------------------------

infra_basica_2019 <- readr::read_delim(
  here::here("data-raw/data-censo-escolar/2019/dados/microdados_ed_basica_2019.csv"),
  delim = ";",
  escape_double = FALSE,
  trim_ws = TRUE,
  locale = readr::locale(encoding = "ISO-8859-1")
) |>
  janitor::clean_names() |>
  dplyr::select(
    nu_ano_censo,
    no_regiao,
    co_regiao,
    sg_uf,
    no_municipio,
    co_municipio,
    no_mesorregiao,
    co_mesorregiao,
    no_microrregiao,
    co_microrregiao,
    tp_dependencia,
    co_entidade,
    tp_localizacao,
    in_local_func_predio_escolar,
    # in_agua_filtrada,
    in_agua_potavel,
    in_agua_rede_publica,
    in_energia_rede_publica,
    in_esgoto_rede_publica,
    in_lixo_servico_coleta,
    in_alimentacao,
    in_internet
  ) |>
  dplyr::mutate(
    nu_ano_censo = as.integer(nu_ano_censo),
    co_regiao = as.integer(co_regiao),
    co_municipio = as.integer(co_municipio),
    co_mesorregiao = as.integer(co_mesorregiao),
    co_microrregiao = as.integer(co_microrregiao),
    tp_dependencia = as.integer(tp_dependencia),
    co_entidade = as.integer(co_entidade),
    tp_localizacao = as.integer(tp_localizacao),
    in_local_func_predio_escolar = as.integer(in_local_func_predio_escolar),
    # in_agua_filtrada,
    in_agua_potavel = as.integer(in_agua_potavel),
    in_agua_rede_publica = as.integer(in_agua_rede_publica),
    in_energia_rede_publica = as.integer(in_energia_rede_publica),
    in_esgoto_rede_publica = as.integer(in_esgoto_rede_publica),
    in_lixo_servico_coleta = as.integer(in_lixo_servico_coleta),
    in_alimentacao = as.integer(in_alimentacao),
    in_internet = as.integer(in_internet)
  ) |>
  dplyr::rename(
    ano = nu_ano_censo,
    nome_regiao = no_regiao,
    id_regiao = co_regiao,
    sigla_uf = sg_uf,
    nome_municipio = no_municipio,
    id_municipio = co_municipio,
    nome_mesorregiao = no_mesorregiao,
    id_mesorregiao = co_mesorregiao,
    nome_microrregiao = no_microrregiao,
    id_microrregiao = co_microrregiao,
    tipo_dependencia = tp_dependencia,
    id_escola = co_entidade,
    tipo_localizacao = tp_localizacao,
    local_func_predio_escolar = in_local_func_predio_escolar,
    agua_filtrada_potavel = in_agua_potavel,
    # in_agua_filtrada,
    agua_rede_publica = in_agua_rede_publica,
    energia_rede_publica = in_energia_rede_publica,
    esgoto_rede_publica = in_esgoto_rede_publica,
    lixo_servico_coleta = in_lixo_servico_coleta,
    alimentacao = in_alimentacao,
    internet = in_internet
  ) |>
  dplyr::filter(
    tipo_dependencia %in% c(2, 3)
  )


##### União das duas bases de Infraestrutura Básica -----------------------

infraestrutura_basica <- dplyr::bind_rows(infra_basica_2009, infra_basica_2019)



### Infraestrutura Física  ------------------------------------------------


#### Infraestrutura Física - 2009 -----------------------------------------

infra_fisica_2009 <- readr::read_delim(
  here::here("data-raw/data-censo-escolar/2009/dados/microdados_ed_basica_2009.csv"),
  delim = ";",
  escape_double = FALSE,
  trim_ws = TRUE,
  locale = readr::locale(encoding = "ISO-8859-1")
) |>
  janitor::clean_names() |>
  dplyr::select(
    nu_ano_censo,
    no_regiao,
    co_regiao,
    sg_uf,
    no_municipio,
    co_municipio,
    no_mesorregiao,
    co_mesorregiao,
    no_microrregiao,
    co_microrregiao,
    tp_dependencia,
    co_entidade,
    tp_localizacao,
    in_sala_professor,
    in_laboratorio_informatica,
    in_laboratorio_ciencias,
    in_quadra_esportes,
    in_cozinha,
    in_biblioteca,
    in_parque_infantil,
    in_banheiro_dentro_predio,
    in_banheiro_fora_predio
  ) |>
  dplyr::mutate(
    nu_ano_censo = as.integer(nu_ano_censo),
    co_regiao = as.integer(co_regiao),
    co_municipio = as.integer(co_municipio),
    co_mesorregiao = as.integer(co_mesorregiao),
    co_microrregiao = as.integer(co_microrregiao),
    tp_dependencia = as.integer(tp_dependencia),
    co_entidade = as.integer(co_entidade),
    tp_localizacao = as.integer(tp_localizacao),
    in_sala_professor = as.integer(in_sala_professor),
    in_laboratorio_informatica = as.integer(in_laboratorio_informatica),
    in_laboratorio_ciencias = as.integer(in_laboratorio_ciencias),
    in_quadra_esportes = as.integer(in_quadra_esportes),
    in_cozinha = as.integer(in_cozinha),
    in_biblioteca = as.integer(in_biblioteca),
    in_parque_infantil = as.integer(in_parque_infantil),
    in_banheiro_dentro_predio = as.integer(in_banheiro_dentro_predio),
    in_banheiro_fora_predio = as.integer(in_banheiro_fora_predio)
  ) |>
  dplyr::mutate(
    banheiro = ifelse(in_banheiro_dentro_predio > 0 | in_banheiro_fora_predio > 0, 1, 0),
    banheiro = as.integer(banheiro)
  ) |>
  dplyr::select(-c(in_banheiro_dentro_predio, in_banheiro_fora_predio)) |>
  dplyr::rename(
    ano = nu_ano_censo,
    nome_regiao = no_regiao,
    id_regiao = co_regiao,
    sigla_uf = sg_uf,
    nome_municipio = no_municipio,
    id_municipio = co_municipio,
    nome_mesorregiao = no_mesorregiao,
    id_mesorregiao = co_mesorregiao,
    nome_microrregiao = no_microrregiao,
    id_microrregiao = co_microrregiao,
    tipo_dependencia = tp_dependencia,
    id_escola = co_entidade,
    tipo_localizacao = tp_localizacao,
    sala_professor = in_sala_professor,
    laboratorio_informatica = in_laboratorio_informatica,
    laboratorio_ciencias = in_laboratorio_ciencias,
    quadra_esportes = in_quadra_esportes,
    cozinha = in_cozinha,
    biblioteca = in_biblioteca,
    parque_infantil = in_parque_infantil
  ) |>
  dplyr::filter(
    tipo_dependencia %in% c(2, 3)
  )


#### Infraestrutura Física - 2019 -----------------------------------------

infra_fisica_2019 <- readr::read_delim(
  here::here("data-raw/data-censo-escolar/2019/dados/microdados_ed_basica_2019.csv"),
  delim = ";",
  escape_double = FALSE,
  trim_ws = TRUE,
  locale = readr::locale(encoding = "ISO-8859-1")
) |>
  janitor::clean_names() |>
  dplyr::select(
    nu_ano_censo,
    no_regiao,
    co_regiao,
    sg_uf,
    no_municipio,
    co_municipio,
    no_mesorregiao,
    co_mesorregiao,
    no_microrregiao,
    co_microrregiao,
    tp_dependencia,
    co_entidade,
    tp_localizacao,
    in_sala_professor,
    in_laboratorio_informatica,
    in_laboratorio_ciencias,
    in_quadra_esportes,
    in_cozinha,
    in_biblioteca,
    in_parque_infantil,
    in_banheiro
  ) |>
  dplyr::mutate(
    nu_ano_censo = as.integer(nu_ano_censo),
    co_regiao = as.integer(co_regiao),
    co_municipio = as.integer(co_municipio),
    co_mesorregiao = as.integer(co_mesorregiao),
    co_microrregiao = as.integer(co_microrregiao),
    tp_dependencia = as.integer(tp_dependencia),
    co_entidade = as.integer(co_entidade),
    tp_localizacao = as.integer(tp_localizacao),
    in_sala_professor = as.integer(in_sala_professor),
    in_laboratorio_informatica = as.integer(in_laboratorio_informatica),
    in_laboratorio_ciencias = as.integer(in_laboratorio_ciencias),
    in_quadra_esportes = as.integer(in_quadra_esportes),
    in_cozinha = as.integer(in_cozinha),
    in_biblioteca = as.integer(in_biblioteca),
    in_parque_infantil = as.integer(in_parque_infantil),
    in_banheiro = as.integer(in_banheiro)
  ) |>
  dplyr::rename(
    ano = nu_ano_censo,
    nome_regiao = no_regiao,
    id_regiao = co_regiao,
    sigla_uf = sg_uf,
    nome_municipio = no_municipio,
    id_municipio = co_municipio,
    nome_mesorregiao = no_mesorregiao,
    id_mesorregiao = co_mesorregiao,
    nome_microrregiao = no_microrregiao,
    id_microrregiao = co_microrregiao,
    tipo_dependencia = tp_dependencia,
    id_escola = co_entidade,
    tipo_localizacao = tp_localizacao,
    sala_professor = in_sala_professor,
    laboratorio_informatica = in_laboratorio_informatica,
    laboratorio_ciencias = in_laboratorio_ciencias,
    quadra_esportes = in_quadra_esportes,
    cozinha = in_cozinha,
    biblioteca = in_biblioteca,
    parque_infantil = in_parque_infantil,
    banheiro = in_banheiro
  ) |>
  dplyr::filter(
    tipo_dependencia %in% c(2, 3)
  )


##### União das duas bases de Infraestrutura Física -----------------------

infraestrutura_fisica <- dplyr::bind_rows(infra_fisica_2009, infra_fisica_2019)



### Disponibilidade de Equipamentos ---------------------------------------


#### Disponibilidade de Equipamentos - 2009 -------------------------------

disp_equipamentos_2009 <- readr::read_delim(
  here::here("data-raw/data-censo-escolar/2009/dados/microdados_ed_basica_2009.csv"),
  delim = ";",
  escape_double = FALSE,
  trim_ws = TRUE,
  locale = readr::locale(encoding = "ISO-8859-1")
) |>
  janitor::clean_names() |>
  dplyr::select(
    nu_ano_censo,
    no_regiao,
    co_regiao,
    sg_uf,
    no_municipio,
    co_municipio,
    no_mesorregiao,
    co_mesorregiao,
    no_microrregiao,
    co_microrregiao,
    tp_dependencia,
    co_entidade,
    tp_localizacao,
    in_equip_tv,
    in_equip_copiadora,
    in_equip_impressora,
    in_computador
  ) |>
  dplyr::mutate(
    nu_ano_censo = as.integer(nu_ano_censo),
    co_regiao = as.integer(co_regiao),
    co_municipio = as.integer(co_municipio),
    co_mesorregiao = as.integer(co_mesorregiao),
    co_microrregiao = as.integer(co_microrregiao),
    tp_dependencia = as.integer(tp_dependencia),
    co_entidade = as.integer(co_entidade),
    tp_localizacao = as.integer(tp_localizacao),
    in_equip_tv = as.integer(in_equip_tv),
    in_equip_copiadora = as.integer(in_equip_copiadora),
    in_equip_impressora = as.integer(in_equip_impressora),
    in_computador = as.integer(in_computador)
  ) |>
  dplyr::rename(
    ano = nu_ano_censo,
    nome_regiao = no_regiao,
    id_regiao = co_regiao,
    sigla_uf = sg_uf,
    nome_municipio = no_municipio,
    id_municipio = co_municipio,
    nome_mesorregiao = no_mesorregiao,
    id_mesorregiao = co_mesorregiao,
    nome_microrregiao = no_microrregiao,
    id_microrregiao = co_microrregiao,
    tipo_dependencia = tp_dependencia,
    id_entidade = co_entidade,
    tipo_localizacao = tp_localizacao,
    tv = in_equip_tv,
    copiadora = in_equip_copiadora,
    impressora = in_equip_impressora,
    computador = in_computador
  ) |>
  dplyr::filter(
    tipo_dependencia %in% c(2, 3)
  )


#### Disponibilidade de Equipamentos - 2019 -------------------------------

disp_equipamentos_2019 <- readr::read_delim(
  here::here("data-raw/data-censo-escolar/2019/dados/microdados_ed_basica_2019.csv"),
  delim = ";",
  escape_double = FALSE,
  trim_ws = TRUE,
  locale = readr::locale(encoding = "ISO-8859-1")
) |>
  janitor::clean_names() |>
  dplyr::select(
    nu_ano_censo,
    no_regiao,
    co_regiao,
    sg_uf,
    no_municipio,
    co_municipio,
    no_mesorregiao,
    co_mesorregiao,
    no_microrregiao,
    co_microrregiao,
    tp_dependencia,
    co_entidade,
    tp_localizacao,
    in_equip_tv,
    in_equip_copiadora,
    in_equip_impressora,
    in_computador
  ) |>
  dplyr::mutate(
    nu_ano_censo = as.integer(nu_ano_censo),
    co_regiao = as.integer(co_regiao),
    co_municipio = as.integer(co_municipio),
    co_mesorregiao = as.integer(co_mesorregiao),
    co_microrregiao = as.integer(co_microrregiao),
    tp_dependencia = as.integer(tp_dependencia),
    co_entidade = as.integer(co_entidade),
    tp_localizacao = as.integer(tp_localizacao),
    in_equip_tv = as.integer(in_equip_tv),
    in_equip_copiadora = as.integer(in_equip_copiadora),
    in_equip_impressora = as.integer(in_equip_impressora),
    in_computador = as.integer(in_computador)
  ) |>
  dplyr::rename(
    ano = nu_ano_censo,
    nome_regiao = no_regiao,
    id_regiao = co_regiao,
    sigla_uf = sg_uf,
    nome_municipio = no_municipio,
    id_municipio = co_municipio,
    nome_mesorregiao = no_mesorregiao,
    id_mesorregiao = co_mesorregiao,
    nome_microrregiao = no_microrregiao,
    id_microrregiao = co_microrregiao,
    tipo_dependencia = tp_dependencia,
    id_entidade = co_entidade,
    tipo_localizacao = tp_localizacao,
    tv = in_equip_tv,
    copiadora = in_equip_copiadora,
    impressora = in_equip_impressora,
    computador = in_computador
  ) |>
  dplyr::filter(
    tipo_dependencia %in% c(2, 3)
  )


##### União das duas bases de Disponibilidade de Equipamentos -------------

disponibilidade_equipamentos <- dplyr::bind_rows(disp_equipamentos_2009, disp_equipamentos_2019)


readr::write_rds(infraestrutura_basica, "docs/dados/03-infraestrutura-basica.rds")
readr::write_rds(infraestrutura_fisica, "docs/dados/04-infraestrutura-fisica.rds")
readr::write_rds(disponibilidade_equipamentos, "docs/dados/05-disponibilidade-equipamentos.rds")




