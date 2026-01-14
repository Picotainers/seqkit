FROM debian:trixie AS builder
# install dependencies 
RUN apt-get update && \
   apt-get install -y git golang zlib1g-dev gcc binutils make g++ autoconf automake cmake libbz2-dev libatomic1 upx



RUN git clone https://github.com/shenwei356/seqkit.git && \
    cd seqkit && \
    #sed -i 's/go 1\.23\.0/go 1.23/' go.mod && \
    go build -ldflags "-s -w" -trimpath -o seqkit ./seqkit \
    git clone https://github.com/upx/upx.git && \
   # cd upx && \
   # git submodule init && \
   # git submodule update && \
   # make -j && \
   # cp build/release/upx /usr/local/bin/upx && \
   # cd .. && \
    upx -9 ./seqkit/seqkit


FROM  gcr.io/distroless/base

COPY --from=builder /seqkit/seqkit /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/seqkit"]
