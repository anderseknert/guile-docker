FROM ubuntu:20.04

# https://www.gnutls.org/manual/gnutls-guile.html#Guile-Preparations

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential pkg-config file m4 wget libsigsegv2 libidn2-0 \
            libidn2-dev libunbound-dev libunbound8 libp11-kit-dev libp11-kit0 libp11-3 libp11-dev \
            guile-2.2 guile-2.2-dev guile-json guile-library && \
    # gmp
    cd /opt && wget --no-check-certificate https://gmplib.org/download/gmp/gmp-6.2.0.tar.xz && tar xf gmp-6.2.0.tar.xz && rm -rf gmp-6.2.0.tar.xz && \
    cd gmp-6.2.0 && ./configure && make && make install && \
    # nettle
    cd /opt && wget --no-check-certificate https://ftp.gnu.org/gnu/nettle/nettle-3.6.tar.gz && tar -xzf nettle-3.6.tar.gz && rm -rf nettle-3.6.tar.gz && \
    cd nettle-3.6 && ./configure --disable-openssl --enable-shared && make && make install && cp *.pc /usr/lib/pkgconfig/ && \
    # gnutls
    cd /opt && wget --no-check-certificate https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.14.tar.xz && tar xf gnutls-3.6.14.tar.xz && \
    rm -rf gnutls-3.6.14.tar.xz && cd gnutls-3.6.14 && \
    ./configure --enable-guile --with-guile-site-dir=/usr/share/guile/site --with-included-libtasn1 --with-included-unistring && make && make install && \
    # enable readline in REPL
    printf "(use-modules (ice-9 readline))\n(activate-readline)" > /root/.guile

CMD ["guile"]
