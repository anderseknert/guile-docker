FROM ubuntu

# https://www.gnutls.org/manual/gnutls-guile.html#Guile-Preparations

RUN apt-get update && \
    apt-get install -y build-essential pkg-config file m4 wget libsigsegv2 libidn2-0 libidn2-dev libunbound-dev libunbound2 \
            libp11-kit-dev libp11-kit0 libp11-3 libp11-dev \
            guile-2.2 guile-2.2-dev guile-json guile-library \
    # gmp
    cd /opt && wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz && tar xf gmp-6.1.2.tar.xz && rm -rf gmp-6.1.2.tar.xz && \
    cd gmp-6.1.2 && ./configure && make && make install && \
    # nettle
    cd /opt && wget https://ftp.gnu.org/gnu/nettle/nettle-3.4.1.tar.gz && tar -xzf nettle-3.4.1.tar.gz && rm -rf nettle-3.4.1.tar.gz && \
    cd nettle-3.4.1 && ./configure --disable-openssl --enable-shared && make && make install && cp *.pc /usr/lib/pkgconfig/ && \
    # gnutls
    cd /opt && wget https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.6.tar.xz && tar xf gnutls-3.6.6.tar.xz && \
    rm -rf gnutls-3.6.6.tar.xz && cd gnutls-3.6.6 && \
    ./configure --enable-guile --with-guile-site-dir=/usr/share/guile/site --with-included-libtasn1 --with-included-unistring && make && make install && \
    # TODO: Run as normal user?
    printf "(use-modules (ice-9 readline))\n(activate-readline)" > /root/.guile

CMD ["guile"]
