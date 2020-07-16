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

Run:

    bin/docker-compose up

This will generate `db-password.txt` and `session-key.pem` in
`.secrets/development`, if they do not already exist. Then, to make a
request from your host:

    token=$(bin/docker-compose exec api bundle exec rake token:generate)
    curl -sS -H "Authorization: Bearer $token" localhost:9292/hello | jq .

To run tests:

    bin/test
