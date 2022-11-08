

# INVESTIMENTO PUBLICO MUNICIPAL ------------------------------------------

investimento_publico <- readr::read_rds("docs/dados/02-investimento-publico.rds")

invest_publico <- investimento_publico |>
  dplyr::mutate(
    data = dplyr::case_when(
      ano == 2004 ~ "2004-01-01",
      ano == 2005 ~ "2005-01-01",
      ano == 2006 ~ "2006-01-01",
      ano == 2007 ~ "2007-01-01",
      ano == 2008 ~ "2008-01-01",
      ano == 2014 ~ "2014-01-01",
      ano == 2015 ~ "2015-01-01",
      ano == 2016 ~ "2016-01-01",
      ano == 2017 ~ "2017-01-01",
      ano == 2018 ~ "2018-01-01"
    ),
    data = lubridate::ymd(data),
    valor_deflacionado = deflateBR::deflate(
      valor,
      nominal_dates = data,
      real_date = "12/2019",
      index = "igpdi"
    )
  )

readr::write_rds(invest_publico, "docs/dados/15-invest-publico.rds")




