# An R script rather than a .lintr file, so that the two documentation
# linters below can be defined in place. See ?lintr::default_settings.
linters <- local({
  # Full stops that do not end a sentence.
  abbreviations <- c("e.g.", "i.e.", "etc.", "cf.", "vs.", "al.", "incl.")
  # Tags whose text roxygen2 renders as markdown prose.
  prose_tags <- c(
    "title", "description", "details", "param", "return", "returns",
    "seealso", "note", "format", "source", "references", "section",
    "field", "slot", "value"
  )
  closing <- "[]\"')]*"
  ns <- c(d = "http://commonmark.org/xml/1.0")

  bare <- function(word) {
    sub(paste0(closing, "$"), "", sub("^[(\\[\"']+", "", word))
  }
  is_abbreviation <- function(word) tolower(bare(word)) %in% abbreviations
  # Nor does a step number such as `2.`, an ellipsis, or a dotted
  # abbreviation such as `c.f.` end a sentence.
  is_not_an_end <- function(word) {
    is_abbreviation(word) ||
      grepl("^\\d+[.]$|[.][.][.]$|^([A-Za-z][.]){2,}$", bare(word))
  }

  # The text of every prose tag, one element per line, with the file line of
  # each and the file column just before its first character.
  prose_of <- function(filename, file_lines) {
    blocks <- tryCatch(
      suppressMessages(suppressWarnings(
        roxygen2::parse_file(filename, env = NULL)
      )),
      error = function(e) list()
    )
    tags <- unlist(lapply(blocks, `[[`, "tags"), recursive = FALSE)
    tags <- Filter(function(tag) tag$tag %in% prose_tags, tags)
    lapply(tags, function(tag) {
      text <- strsplit(tag$raw, "\n", fixed = TRUE)[[1]]
      if (tag$tag == "param") {
        text[[1]] <- sub("^\\s*\\S+\\s*", "", text[[1]])
      }
      line <- tag$line + seq_along(text) - 1L
      right <- sub("\\s+$", "", file_lines[line])
      list(
        text = text,
        line = line,
        offset = nchar(right) - nchar(sub("\\s+$", "", text))
      )
    })
  }

  # The inline pieces of a markdown paragraph with their positions: text,
  # code spans, line breaks and the rest (links, emphasis, ...). On the
  # continuation lines of a paragraph commonmark reports columns relative to
  # the paragraph's first line, so each piece is looked up on its own line,
  # searching from the reported column on.
  pieces <- function(paragraph, md_lines) {
    lapply(xml2::xml_children(paragraph), function(node) {
      pos <- xml2::xml_attr(node, "sourcepos")
      start <- as.integer(strsplit(sub("-.*", "", pos), ":")[[1]])
      content <- xml2::xml_text(node)
      col <- start[2]
      if (!is.na(col) && nzchar(content)) {
        rest <- substring(md_lines[[start[1]]], col)
        at <- regexpr(content, rest, fixed = TRUE)
        if (at > 0) col <- col + at - 1L
      }
      list(
        type = xml2::xml_name(node),
        content = content,
        line = start[1],
        col = col
      )
    })
  }

  # Every full stop in the text of a paragraph that is followed by
  # whitespace, with the word it ends and the first character after it.
  stops <- function(ps) {
    out <- list()
    pattern <- paste0("[.?!]", closing, "(?=\\s|$)")
    for (k in seq_along(ps)) {
      p <- ps[[k]]
      if (p$type != "text") next
      m <- gregexpr(pattern, p$content, perl = TRUE)[[1]]
      for (j in which(m > 0)) {
        end <- m[[j]] + attr(m, "match.length")[[j]] - 1L
        word <- tail(strsplit(substr(p$content, 1, end), "\\s+")[[1]], 1)
        rest <- substr(p$content, end + 1, nchar(p$content))
        if (grepl("\\S", rest)) {
          at <- end + regexpr("\\S", rest)
          after <- list(
            char = substr(p$content, at, at),
            line = p$line,
            col = p$col + at - 1L,
            same_line = TRUE
          )
        } else {
          q <- k + 1L
          same_line <- !(q <= length(ps) && ps[[q]]$type == "softbreak")
          if (!same_line) q <- q + 1L
          # A full stop directly followed by code or a link is no end.
          if (q > length(ps) || (same_line && !nzchar(rest))) next
          nq <- ps[[q]]
          after <- list(
            char = switch(nq$type,
              code = "`",
              link = "[",
              substr(nq$content, 1, 1)
            ),
            line = nq$line,
            col = if (nq$type == "code") nq$col - 1L else nq$col,
            same_line = same_line
          )
        }
        out[[length(out) + 1]] <- c(list(word = word), after)
      }
    }
    out
  }

  documentation_linter <- function(flag, message) {
    lintr::Linter(linter_level = "file", function(source_expression) {
      lines <- source_expression$file_lines
      lints <- list()
      for (t in prose_of(source_expression$filename, lines)) {
        md <- commonmark::markdown_xml(
          paste(t$text, collapse = "\n"),
          sourcepos = TRUE,
          extensions = TRUE
        )
        paragraphs <- xml2::xml_find_all(
          xml2::read_xml(md), "//d:paragraph", ns
        )
        for (paragraph in paragraphs) {
          for (s in Filter(flag, stops(pieces(paragraph, t$text)))) {
            line <- t$line[[s$line]]
            lints[[length(lints) + 1]] <- lintr::Lint(
              filename = source_expression$filename,
              line_number = line,
              column_number = t$offset[[s$line]] + s$col,
              type = "style",
              message = message,
              line = lines[[line]]
            )
          }
        }
      }
      lints
    })
  }

  lintr::linters_with_defaults(
    object_length_linter = NULL,
    object_name_linter = NULL,

    # Every sentence of the documentation starts on a line of its own, so
    # that editing a sentence rewraps that sentence only.
    sentence_per_line_linter = documentation_linter(
      function(s) {
        s$same_line && !is_abbreviation(s$word) &&
          (grepl("[[:upper:]]", s$char) || s$char %in% c("`", "[", "("))
      },
      "Start every sentence of the documentation on its own line."
    ),

    # It starts with a capitalised word, never with a lowercase one.
    sentence_case_linter = documentation_linter(
      function(s) grepl("[[:lower:]]", s$char) && !is_not_an_end(s$word),
      "Start the sentence with a capitalised word."
    )
  )
})
