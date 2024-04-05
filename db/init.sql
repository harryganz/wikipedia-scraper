CREATE TABLE IF NOT EXISTS URLS (
    URL_ID SERIAL PRIMARY KEY,
    URL_VALUE VARCHAR(255)
); 
CREATE TABLE IF NOT EXISTS OUTLINKS (
    PAGE_ID INTEGER NOT NULL REFERENCES URLS(URL_ID),
    OUTLINK_ID INTEGER NOT NULL REFERENCES URLS(URL_ID),
    PRIMARY KEY (PAGE_ID, OUTLINK_ID)
);
CREATE TABLE IF NOT EXISTS ARTICLES (
    ARTICLE_ID SERIAL PRIMARY KEY,
    URL_ID INTEGER REFERENCES URLS(URL_ID),
    TITLE TEXT,
    BODY TEXT
);
CREATE INDEX IF NOT EXISTS ARTICLES_TEXT_IDX ON ARTICLES USING GIN (to_tsvector('english', TITLE || ' ' || BODY));