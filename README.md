### Laravel Octane In Docker

This is simple minimum setup for running Laravel Octane in Docker

#### Usage : 

* Clone this repo, and then install the package with `composer install`
* Copy the `.env.example` into `.env`
* After that, you can build the image with command : `docker build . -t laradok:stable-1` (you can change the image name)
* Don't forget to start the `docker-compose.yml` with command `docker-compose up -d`
* After that, you can log-in to container shell with command : `docker-compose exec webapp /bin/sh`
* You can start the octane server with command : `rc-service supervisord start`. you can check if the octane start by looking the output
of command `ps -ef`

* And finally you can start the nginx service with command : `rc-service nginx start`. and you can check your webapp run at port 80
`http://127.0.0.1:80`


#### Used Tools : 

* Supervisor
* Swoole (to run laravel octane)
