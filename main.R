library(rvest)
library(stringr)
library(magrittr)

vars = Sys.getenv(c("MAX_DEPTH", "MAX_PAGES", "START_URL"), unset = NA)
MAX_DEPTH = ifelse(!is.na(vars["MAX_DEPTH"]), as.numeric(vars["MAX_DEPTH"]), 3)
MAX_PAGES = ifelse(!is.na(vars["MAX_PAGES"]), as.numeric(vars["MAX_PAGES"]), 10)
START_URL = ifelse(!is.na(vars["START_URL"]), vars["START_URL"], "/wiki/Philosophy")

DOMAIN = "https://en.wikipedia.org"

unvisited = list(list(url = START_URL, depth = 0))
visited = c()

get_article <- function(page) {
    page %>% 
        html_elements(css = ".mw-content-ltr")
}

get_article_links <- function(article) {
    article %>% 
        html_elements(css = "p a[title]") %>%
        html_attr("href") %>% 
        str_subset("^/wiki/.*$")
}


while (length(unvisited) > 0 && length(visited) <= MAX_PAGES) {
    # Pop off unvisited
    current <- head(unvisited, 1)
    unvisited <- tail(unvisited, length(unvisited) - 1)
    
    url <- current[[1]]$url
    depth <- current[[1]]$depth
    # Get the article
    page <- read_html(paste(DOMAIN, url, sep = "/")) 
    title <- page %>% 
      html_elements(css = "title") %>% 
      html_text2
    if (!(title %in% visited)) {
        print(title)
        # If depth < MAX_DEPTH add links to 
        # head of unvisited
        if (depth < MAX_DEPTH) {
            to_visit <- page %>% 
                get_article %>% 
                get_article_links
            unvisited <- append(
              unvisited,
              lapply(to_visit, function(url){list(url = url, depth = depth + 1)}),
              after = 0
            )
        }
        # 
        # Append current url to visited
        visited <- c(visited, title)
        Sys.sleep(runif(1, 0.1, 0.3))
    }
}

