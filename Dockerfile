# Build stage
FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y \
    wget \
    cmake \
    build-essential \
    zlib1g-dev \
    libzstd-dev \
    cpio \
    && rm -rf /var/lib/apt/lists/*

# install blast libraries
RUN wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.11.0/ncbi-blast-2.11.0+-src.tar.gz \
    && tar xzf ncbi-blast-2.11.0+-src.tar.gz \
    && cd ncbi-blast-2.11.0+-src/c++ \
    && ./configure --prefix=$HOME/BLAST2.11 --with-static --without-debug --without-exe --without-boost --without-gui \
    && make -j8 \
    && make install

WORKDIR /build
RUN wget http://github.com/bbuchfink/diamond/archive/v2.1.10.tar.gz \
    && tar xzf v2.1.10.tar.gz \
    && cd diamond-2.1.10 \
    && mkdir bin \
    && cd bin \
    && cmake -DEXTRA=ON -DBLAST_INCLUDE_DIR=$HOME/BLAST2.11/include/ncbi-tools++ -DBLAST_LIBRARY_DIR=$HOME/BLAST2.11/lib .. \
    && make -j8

# Final stage
FROM ubuntu:22.04
MAINTAINER mriffle@uw.edu

COPY --from=builder /build/diamond-2.1.10/bin/diamond /usr/bin/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 755 /usr/bin/diamond && \
    chmod 755 /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
