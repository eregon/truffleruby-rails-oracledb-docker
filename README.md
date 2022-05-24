


# Run Rails on OCI
# Clone app
`git clone https://myapp-repo/ app`

For example:
`git clone  https://github.com/bjfish/rails-blog-sqlite.git app`
Update `.ruby-version` file to `3.0.3`

# Build
`docker build -t rbenv:test .`

# Run
1. `docker run -d -p 3000:80 rbenv:test`
2. `docker exec -it {your_container_name} bash -l -c 'source ~/.bashrc && cd /root/app && rails db:migrate'`

3. Visit http://localhost:3000/

# Connect to Oracle Autonomous Database
## Build with OCI Client
`docker build -f Dockerfile.oci8 -t rbenv:oci8 .`

## Run
Map the wallet location as a volume:
`docker run -v /home/opc/docker/app/wallet:/usr/lib/oracle/21/client64/lib/network/admin:Z,ro -d -p 3000:80 rbenv:oci8`

# Reference
- https://github.com/oracle/docker-images/blob/4b5e47f9f165e309572e1ebb1191d3c92d207dec/OracleLinuxDevelopers/oraclelinux8/nginx/1.20/Dockerfile
- https://github.com/oracle/docker-images/blob/da70e5f19987e236e6bb60faedede0c256e4cedb/OracleInstantClient/oraclelinux8/21/Dockerfile#L24
