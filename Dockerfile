FROM ruby:2.7-buster

ARG HOST_UID
RUN apt install libpq-dev && \
    adduser \
        --uid "${HOST_UID?need HOST_UID}" \
        --disabled-password \
        --gecos "plum dev user" \
        plum

USER plum
WORKDIR /plum

RUN bundle config set path .docker/bundle

COPY bin/entrypoint bin/entrypoint
COPY bin/run.container-stub bin/run
ENTRYPOINT ["bin/entrypoint"]
CMD ["bin/run"]
