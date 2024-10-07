ARG es_version
FROM docker.elastic.co/elasticsearch/elasticsearch:$es_version
# the ARG has to be doubled,
# cf. https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG es_version
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install pl.allegro.tech.elasticsearch.plugin:elasticsearch-analysis-morfologik:$es_version
