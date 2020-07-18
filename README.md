# Roda JSON API Demo

This is a sketch of a docker-compose development environment for a toy
Roda app that:

- Serves only JSON (i.e. is "an API")
- Uses JWT for authentication
- Is implemented with Sequel and Minitest

There is a `/about` resource that is exempted from token auth; `/`
redirects there. In a real app, you would probably have other public
routes for things like logging in (POST a username and password, get a
token if they're valid, something like that). To avoid making any
choices that would limit how you could implement users and passwords, in
this small demo we'll just generate tokens outside of the API.

There is a `/hello` resource with a constant response for testing that
you are authenticated properly, and one tiny model, `Note`, made
available at `/notes`, with the usual GET and POST. There is no access
control on notes other than having a valid token; you'd probably want to
use your implementation of users to achieve this.

# Usage

There are `Rakefile`s in both the top-level directory and in `app`. The
root `Rakefile` is used on your host to orchestrate containers, and
`app/Rakefile` is for tasks that run inside the container. From the
root, run:

    rake

And the app and database containers will start. The default rake task,
`container:up`, just runs a wrapper script, `bin/docker-compose`. This
script selects a Docker Compose project and sets some environment
variables based on `RACK_ENV`. These are equivalent:

    rake container:up RACK_ENV=development
    RACK_ENV=development bin/docker-compose up

`development` is the default, so you don't have to specify it. If you
change it to `test`, everything will run in an independent set of
containers; you can have both sets running at the same time.

To run tests, do:

    rake container:test

This task always overrides `RACK_ENV` to `test` so that it runs in the
test Docker Compose project. It will start the test `postgres` service
in the background, so when you're done running tests, remember to stop
it with:

    rake container:down RACK_ENV=test

# Token Generation

Here's how you can make a request from your host into the container
(make sure the service is started with `rake container:up` first):

    token=$(rake container:token:generate)
    curl -sS -H "Authorization: Bearer $token" localhost:9292/hello | jq .

There are some rudimentary tests to verify that this works and
making the same request without a valid token does not.

# Secrets

`bin/docker-compose`, however you invoke it, will first call a host Rake
task that generates random secrets and stores them in
`tmp/secrets/db-password.txt` and `tmp/secrets/session-key.pem` (unless
those files already exist). If you ever want to regenerate them, delete
those files. The secrets directory is not mounted in the container; the
contents are passed in via environment variables.

# Layout

The `app` directory is mounted at `/plum` in the container, so that
you can edit files on the host and have them reloaded immediately in
development.

Bundler directories are under `bundle`; `bundle/$RACK_ENV` is mounted at
`/plum/vendor/bundle`. `bundle/host` is the bundle for running `rake`
outside the container.

The container entrypoint is `app/bin/entrypoint`; if you want to use
`docker-compose exec` rather than `docker-compose run`, remember to
prepend `bundle exec` to the inside-the-container command if necessary.

The entrypoint also always runs `bundle install` so that the first run
and any run after updating the `Gemfile` work; this could probably be
optimized.
