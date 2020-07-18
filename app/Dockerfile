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
ENV BUNDLE_APP_CONFIG /plum/.bundle

COPY bin/entrypoint bin/entrypoint
ENTRYPOINT ["bin/entrypoint"]
CMD ["rake", "run"]
