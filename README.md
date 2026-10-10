# Perl CGI scripts Docker Image

A Docker image for running and developing legacy Perl CGI scripts on Apache httpd with mod_perl. Customize the Dockerfile to suit your needs.

The image is based on `debian:13.7-slim` and uses Debian's packaged `apache2`, `libapache2-mod-perl2` (mod_perl 2.0.13) and `libcgi-pm-perl`, so nothing is compiled at build time.

## Quick Start

All you need is Docker with the Compose plugin.

Start the container:

```sh
docker compose up --build
```

Open <http://localhost:8080/> to try the sample scripts.

Stop and remove the container:

```sh
docker compose down
```

## Development vs. deployment

- **Development** (`docker compose`): `sample_perl_cgi_programs/` is bind-mounted into `/var/www/html`, so edits to your scripts show up on the next request without a rebuild.
- **Deployment** (`docker build`): the scripts are copied into the image at build time, so the image is self-contained and immutable:

  ```sh
  docker build -t perl-cgi-app .
  docker run --rm -p 8080:8080 -e SAMPLE_ENV_VAR=hello perl-cgi-app
  ```

Changes to the Dockerfile or to anything under `apache/` need a rebuild (`docker compose up --build`).

## Adding your own scripts

Put `.cgi` or `.pl` files in `sample_perl_cgi_programs/` (or point the volume at your own directory). They run through `ModPerl::PerlRun`, so ordinary CGI scripts work unmodified. `hello.cgi` shows the recommended pattern:

- `use strict; use warnings;`
- read parameters with `CGI->new->param(...)` instead of parsing the query string by hand
- escape anything user-supplied with `CGI::escapeHTML` before printing it
- cap request size with `$CGI::POST_MAX`

## Environment variables

Container environment variables are not visible to scripts automatically. List each one with a `PassEnv` line in `apache/perl-cgi-site.conf`, then set it in `docker-compose.yml` or with `docker run -e`. `demo_program.pl` prints `SAMPLE_ENV_VAR` as an example.

## Project layout

| Path | Purpose |
|------|---------|
| `Dockerfile` | Installs apache2 + mod_perl, enables prefork/perl, disables CGI, autoindex and status modules |
| `docker-entrypoint.sh` | Runs apache in the foreground as PID 1 |
| `apache/ports.conf` | Listens on port 8080 |
| `apache/perl-cgi-global.conf` | `ServerName` and Perl switches |
| `apache/perl-cgi-site.conf` | Virtual host: document root, mod_perl handler, `PassEnv` |
| `sample_perl_cgi_programs/` | Sample form and scripts |

## CI

`.github/workflows/ci.yml` lints the Dockerfile (hadolint), the entrypoint (shellcheck) and the Perl scripts (perlcritic), then builds the image and smoke-tests the sample scripts.

## Contributing

Issues and pull requests are welcome.
