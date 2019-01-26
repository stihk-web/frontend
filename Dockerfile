FROM golang:1.11-alpine3.8 AS BUILDER
RUN mkdir /app
ADD ./src /app/
WORKDIR /app
#RUN go get -u github.com/bwmarrin/discordgo
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

FROM alpine:3.8 as alpine
RUN apk add -U --no-cache ca-certificates

FROM scratch
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=BUILDER /app/main /
EXPOSE 80
CMD ["/main"]
