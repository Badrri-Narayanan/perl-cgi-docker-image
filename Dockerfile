FROM httpd:2.4

# installs PERL debian dependencies required for CPAN and for mod_perl apache http integration
RUN apt-get update && apt-get -y install \
    libapache2-mod-perl2 perl gcc make \
    libapr1-dev libfile-spec-native-perl \
    libperl-dev libaprutil1-dev

# installs PERL CGI dependencies using CPAN
RUN cpan Module::Build CGI

# copies mod_perl sourcecode to root path of container
COPY ./mod_perl-2.0.12.tar.gz /root/

# mod_perl downloaded from https://perl.apache.org/download/
# unpacks, installs and connects mod_perl to apache httpd server. We do this since debian no longer comes with mod_perl package in APT
RUN cd; tar -xvzf mod_perl-2.0.12.tar.gz mod_perl-2.0.12; cd mod_perl-2.0.12; perl Makefile.PL MP_AP_PREFIX=/usr/local/apache2; make; make install

# replaces our custom httpd server configuration to the container's httpd config. 
# This config instructs apache http server on how to use mod_perl
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf


# this step is redundant if you are using Kubernetes
EXPOSE 8080
