library(rvest)
library(magrittr)

MAX_DEPTH = 3
DOMAIN = "en.wikipedia.org"
searched_urls = c()
to_search = c("https://en.wikipedia.org/wiki/Philosophy")
current_depth = 0

get_article <- function(page) {
    page %>% 
        html_elements(css = ".mw-content-ltr")
}

get_article_links <- function(article) {
    article %>% 
        html_elements(css = "p a[title]") %>%
        html_attr("href")
}

links <- read_html(to_search) %>%
    get_article %>%
    get_article_links

print(links)


