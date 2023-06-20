FROM crystallang/crystal:1.1.1-alpine

WORKDIR /app

COPY shard.yml ./
COPY shard.lock ./

RUN shards install

COPY . .

RUN crystal build --release src/rick_and_morty_meo.cr

EXPOSE 3000

CMD ["./rick_and_morty_meo"]
