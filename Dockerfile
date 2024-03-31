FROM alpine:3.19
RUN apk update && \
    apk add \
        R>4.3 \
        R-dev>4.3.1 \
        g++ \
        make \
        libxml2-dev

WORKDIR /app
# Install R packages 
COPY renv.lock renv.lock
RUN R -q -e "install.packages('renv', repos = 'https://cloud.r-project.org')"

RUN mkdir -p renv
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json
RUN R -q -e  "renv::restore(repos = 'https://cloud.r-project.org')"

# Copy rest of files for app layer
COPY . .

CMD Rscript main.R
