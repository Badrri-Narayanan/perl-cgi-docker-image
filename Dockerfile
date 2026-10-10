# Pinned to a Debian point release so the build stays reproducible.
# Debian packages mod_perl for its own apache2, so nothing has to be compiled.
FROM debian:13.7-slim

# hadolint ignore=DL3008
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        apache2 \
        libapache2-mod-perl2 \
        libcgi-pm-perl; \
    rm -rf /var/lib/apt/lists/*

COPY apache/ports.conf /etc/apache2/ports.conf
COPY apache/perl-cgi-global.conf /etc/apache2/conf-available/perl-cgi-global.conf
COPY apache/perl-cgi-site.conf /etc/apache2/sites-available/perl-cgi-site.conf

# mod_perl needs the prefork MPM. The CGI modules are not needed because mod_perl
# runs .cgi/.pl files in-process, and autoindex is dropped to avoid directory listings.
# security.conf is edited in place so the server stops advertising its OS and version.
RUN set -eux; \
    a2dismod -q -f mpm_event autoindex status; \
    a2enmod -q mpm_prefork perl; \
    a2disconf -q serve-cgi-bin other-vhosts-access-log; \
    a2enconf -q perl-cgi-global; \
    a2dissite -q 000-default; \
    a2ensite -q perl-cgi-site; \
    sed -ri 's/^ServerTokens .*/ServerTokens Prod/; s/^ServerSignature .*/ServerSignature Off/' \
        /etc/apache2/conf-available/security.conf; \
    ln -sfT /dev/stderr /var/log/apache2/error.log; \
    ln -sfT /dev/stdout /var/log/apache2/access.log; \
    rm -f /var/www/html/index.html; \
    apache2ctl configtest

COPY sample_perl_cgi_programs/ /var/www/html/

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080

# HTTP::Tiny ships with core Perl, so no extra package is needed for the probe.
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD perl -MHTTP::Tiny -e 'exit(HTTP::Tiny->new->get("http://127.0.0.1:8080/")->{success} ? 0 : 1)'

# SIGWINCH makes apache finish in-flight requests before exiting.
STOPSIGNAL SIGWINCH

ENTRYPOINT ["docker-entrypoint.sh"]
