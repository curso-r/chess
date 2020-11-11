library(magrittr)

# Convert a chapter from M60MG to PGN
chapter_to_pgn <- function(file) {

  # Get headers
  headers <- file %>%
    xml2::read_html(encoding = "UTF-8") %>%
    xml2::xml_find_all("//h1") %>%
    xml2::xml_text() %>%
    dplyr::tibble(str = .) %>%
    dplyr::mutate(
      str = stringr::str_remove(str, "\\[.+\\] ?"),
      White = stringr::str_extract(str, "[a-zA-Z]+(?= - )"),
      Black = stringr::str_extract(str, "(?<= - )[a-zA-Z]+"),
      Date = stringr::str_c(stringr::str_extract(str, "[0-9]{4}"), ".??.??"),
      Event = stringr::str_extract(str, ".+(?= [0-9]{4})"),
      Opening = ifelse(!is.na(dplyr::lag(Event)), str, NA_character_)
    ) %>%
    tidyr::pivot_longer(White:Opening, names_to = "key", values_to = "val") %>%
    dplyr::select(-str) %>%
    dplyr::filter(!is.na(val)) %>%
    dplyr::mutate(header = stringr::str_c("[", key, ' "', val, '"]')) %>%
    dplyr::pull(header) %>%
    stringr::str_c(collapse = "\n") %>%
    stringr::str_c("\n\n")

  # Parse one move of the mainline
  parse_mainline <- . %>%
    xml2::read_html() %>%
    xml2::xml_find_all("//tr") %>%
    purrr::map(~list(
      turn = xml2::xml_text(xml2::xml_find_first(.x, "td[1]")),
      w_piece = xml2::xml_attr(xml2::xml_find_first(.x, "td[2]//img"), "src"),
      w_move = xml2::xml_text(xml2::xml_find_first(.x, "td[2]")),
      b_piece = xml2::xml_attr(xml2::xml_find_first(.x, "td[3]//img"), "src"),
      b_move = xml2::xml_text(xml2::xml_find_first(.x, "td[3]"))
    )) %>%
    purrr::transpose() %>%
    dplyr::as_tibble() %>%
    tidyr::unnest(dplyr::everything()) %>%
    dplyr::mutate(
      w_move = ifelse(w_move == "\u2026", "...", w_move),
      b_move = ifelse(b_move == "\u2026", "...", b_move),
      w_piece = dplyr::case_when(
        stringr::str_detect(w_piece, "bis") ~ "B",
        stringr::str_detect(w_piece, "hars") ~ "N",
        stringr::str_detect(w_piece, "rook") ~ "R",
        stringr::str_detect(w_piece, "queen") ~ "Q",
        stringr::str_detect(w_piece, "king") ~ "K",
        TRUE ~ ""
      ),
      b_piece = dplyr::case_when(
        stringr::str_detect(b_piece, "bis") ~ "B",
        stringr::str_detect(b_piece, "hars") ~ "N",
        stringr::str_detect(b_piece, "rook") ~ "R",
        stringr::str_detect(b_piece, "queen") ~ "Q",
        stringr::str_detect(b_piece, "king") ~ "K",
        TRUE ~ ""
      )
    ) %>%
    tidyr::unite("w", w_piece, w_move, sep = "") %>%
    tidyr::unite("b", b_piece, b_move, sep = "") %>%
    dplyr::mutate(
      line = 1,
      turn = as.numeric(turn),
      turn = ifelse(is.na(turn), dplyr::lag(turn) + 1, turn),
      w = ifelse(stringr::str_detect(w, "resign"), stringr::str_c("{ 0-1 ", w, " }"), w),
      b = ifelse(stringr::str_detect(b, "resign"), stringr::str_c("{ 1-0 ", b, " }"), b),
      move = stringr::str_c(turn, ". ", w, " ", b),
      ply = ifelse(w == "...", 2, 1)
    ) %>%
    dplyr::select(line, move, turn) # ply

  # Aux regular expressions
  piece_rx <- . %>%
    stringr::str_c('<img alt="" src="../Images/', ., '.jpg">') %>%
    stringr::fixed()
  rx_turn <- "(?<=^|\\s|\\()([0-9]{1,2})(\\s)"
  ply1 <- "([BNRQKa-hx0-8\\-\\+\\=\\!\\?]{2,}|\\.{3})"
  ply2 <- "(\\s[BNRQKa-hx0-8\\-\\+\\=\\!\\?]{2,})?"

  # Convert one string to notation
  line_to_notation <- . %>%
    stringr::str_split("(?=[\\(\\)\\[\\]])") %>%
    purrr::flatten_chr() %>%
    stringr::str_split("(?<=[\\(\\)\\[\\]])") %>%
    purrr::flatten_chr() %>%
    stringr::str_squish() %>%
    stringr::str_replace_all("\\[", "(") %>%
    stringr::str_replace_all("\\]", ")") %>%
    dplyr::tibble(str = .) %>%
    dplyr::mutate(
      oparens = ifelse(dplyr::lag(str == "(", default = FALSE), "(", ""),
      cparens = ifelse(dplyr::lead(str == ")", default = FALSE), ")", ""),
      str = stringr::str_extract_all(str, paste0(rx_turn, ply1, ply2))
    ) %>%
    tibble::rowid_to_column("id") %>%
    tidyr::unnest(str) %>%
    dplyr::mutate(
      turn = as.numeric(stringr::str_squish(stringr::str_extract(str, rx_turn))),
      ply = stringr::str_extract(str, paste0(rx_turn, ply1)),
      ply = ifelse(stringr::str_detect(ply, "\\.{3}"), 2, 1),
      cparens2 = dplyr::if_else(
        dplyr::lag(turn) > turn & oparens == "" & dplyr::lag(oparens) == ""
        & cparens == "" & dplyr::lag(cparens) == "",
        "(", "", ""
      ),
      cparens2 = dplyr::if_else(
        dplyr::lag(turn) == turn & dplyr::lag(ply) == ply
        & dplyr::lag(cparens) == "" & oparens == "",
        "(", cparens2, ""
      ),
      oparens2 = ifelse(dplyr::lead(cparens2, default = "") == "(", ")", ""),
      str = stringr::str_c(str, oparens2),
      str = stringr::str_c(cparens2, str)
    ) %>%
    dplyr::group_by(id) %>%
    dplyr::summarise(
      turn = turn[1],
      str = stringr::str_c(str, collapse = " "),
      oparens = oparens[1],
      cparens = cparens[1],
      .groups = "drop"
    ) %>%
    dplyr::mutate(
      str = stringr::str_replace_all(str, rx_turn, "\\1.\\2"),
      str = stringr::str_c(oparens, str, cparens)
    ) %>%
    dplyr::summarise(
      line = 2,
      move = stringr::str_c(str, collapse = " "),
      move = stringr::str_replace_all(move, "\\. \\.{3}", "..."),
      move = stringr::str_c("(", move, ")"),
      move = stringr::str_replace_all(
        move, paste0("([0-9]{1,2})\\. (", ply1, ") \\1\\.{3}"), "\\1. \\2"
      ),
      turn = ifelse(move == "()", NA_real_, min(turn))
    )

  # Parse one paragraph of variation
  parse_variation <- . %>%
    stringr::str_c(collapse = "") %>%
    xml2::read_html(encoding = "UTF-8") %>%
    xml2::xml_find_all("//p[@class='indent']") %>%
    purrr::map_chr(as.character) %>%
    stringr::str_remove_all("\u201c") %>%
    stringr::str_replace_all("><", "> <") %>%
    stringr::str_replace_all(piece_rx("bis"), "B") %>%
    stringr::str_replace_all(piece_rx("hars"), "N") %>%
    stringr::str_replace_all(piece_rx("rook"), "R") %>%
    stringr::str_replace_all(piece_rx("queen"), "Q") %>%
    stringr::str_replace_all(piece_rx("king"), "K") %>%
    stringr::str_remove('^<p class="indent">') %>%
    stringr::str_remove('</p>$') %>%
    stringr::str_replace_all("\u2026", " ... ") %>%
    stringr::str_remove_all("(<em>|</em>)") %>%
    stringr::str_remove_all("<a.*?</a>") %>%
    purrr::map_dfr(line_to_notation) %>%
    dplyr::filter(!is.na(turn))

  # Convert chapter to PGN
  file %>%
    xml2::read_html(encoding = "UTF-8") %>%
    xml2::xml_find_all("//table/tr|//p[@class='indent']") %>%
    purrr::map_dfr(~dplyr::tibble(node = list(.x))) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(type = xml2::xml_attr(node, "class")) %>%
    dplyr::ungroup() %>%
    tibble::rowid_to_column("id") %>%
    dplyr::mutate(
      tmp = type == "indent" & dplyr::lag(type) == "indent",
      id = dplyr::if_else(tmp, NA_integer_, id, id)
    ) %>%
    tidyr::fill(id) %>%
    dplyr::group_by(id) %>%
    dplyr::summarise(
      type = type[1],
      node = purrr::map(node, as.character),
      node = stringr::str_c(node, collapse = ""),
      .groups = "drop"
    ) %>%
    dplyr::distinct() %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      data = ifelse(type == "indent", list(parse_variation(node)), NULL),
      data = ifelse(!is.list(data[[1]]), list(parse_mainline(node)), data)
    ) %>%
    dplyr::select(id, data) %>%
    tidyr::unnest(data) %>%
    dplyr::mutate(move = ifelse(is.na(move), "{ 1-0 White resigns }", move)) %>%
    dplyr::pull(move) %>%
    stringr::str_remove_all("\n") %>%
    stringr::str_c(collapse = " ") %>%
    stringr::str_squish() %>%
    stringr::str_replace_all("\\. \\.{3}", "...") %>%
    stringr::str_remove_all("(?<= )\\.{3}") %>%
    stringr::str_squish() %>%
    stringr::str_replace_all(
      paste0("([0-9]{1,2})\\. (", ply1, ") \\1\\.{3}"), "\\1. \\2"
    ) %>%
    stringr::str_c(headers, .)
}

# Iterate over chapters
"data-raw/m60mg/" %>%
  fs::dir_ls() %>%
  purrr::map(chapter_to_pgn) %>%
  stringr::str_c(collapse = "\n\n") %>%
  readr::write_file("data-raw/m60mg.pgn")
