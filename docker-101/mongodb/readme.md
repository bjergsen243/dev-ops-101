# MongoDB Docker

## Config network
add to host file: 
```
127.0.0.1 mongo1
127.0.0.1 mongo2
127.0.0.1 mongo3
```

give read, write, and execute permissions for everyone
```sh
  sudo chmod -R 777 /scripts
```

```sh
  sudo chmod -R 777 ${MOUNT_FOLDER}
```