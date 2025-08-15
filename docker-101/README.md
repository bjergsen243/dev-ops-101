# Example docker

## Delete meta properties if cannot start kafka
```
sudo rm ./data/kafka/data/meta.properties
```

## build & start docker-compose
```
docker-compose up -d --build
```

## start docker-compose
```
docker-compose up -d
```

## stop docker-compose
```
docker-compose down
```