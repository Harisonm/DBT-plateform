Welcome to DBT project using in Docker

# Setup project
## Using DBT from local

### Using DBT from python virtualenv (not recommended)
Few things are required.

First go to source Folder from cd :
```bash
cd source
```

and setup DBT_PROFILES_DIR : 
```
bash
export DBT_PROFILES_DIR=./profiles/big_query/
```

after that setup the environment, run (copy/past this in your terminal) :
```bash
python3 -m pip install virtualenv \
	&& virtualenv .venv -p 3.8 \
	&& source .venv/bin/activate \
	&& python -m pip install --upgrade pip \
	&& python -m pip -r requirements.txt
```

*N.B. : to exit from the virtual environment, execute the command `deactivate`.*

Finally, set-up the `dbt` configuration : [documentation](https://docs.getdbt.com/dbt-cli/configure-your-profile)

You can check the configuration is valid with the following command :
```bash
dbt debug
```

Try running the following commands to run and test all models:
``` bash
dbt run
dbt test
```

Generate and run dbt docs:
```bash
dbt docs generate
dbt docs serve
```

### Using DBT from Docker (recommended)
#### Using DBT in development mode (recommended)
```bash
make dev
```

search container Id to run docker cmd : 
```bash
docker ps
```

launch docker deps, debug and docs generate :
```bash
docker exec -it <container_id> dbt deps
docker exec -it <container_id> dbt debug  
docker exec -it <container_id> dbt docs generate  
```

launch model :
```bash
docker exec -it $(docker ps -qf "name=dbt_p") dbt run --select <model_name>
```


#### Using DBT in production mode
```bash
make prod
```
#### Mount DBT via the Docker command (prod like)
Copy your profiles.yml (generate from dbt or create from scratch) in dbt-sb/source

Build DBT image
```bash
docker build -t dbt_p -f Dockerfile_prod .
or 

docker build -t dbt_p --build-arg MY-ENV-VARIABLE  .
```

Run dbt doc serve with other port
```bash
docker run -d --name <container_name> -p <port_number_in_local>:<port_number_in_container> -it dbt_p docs serve --port <port_number_in_container>
```
-d : run container used daemon mode 

Example : 
```bash
docker run -d --name dbt -p 8001:8001 -it dbt_p docs serve --port 8001
```

open in browser this link : 
http://localhost:<port_number>

### example 

Run dbt model
```bash
docker run -it dbt_p run --select <MODEL_NAME> --vars 'current_date: 2020-06-29'
```

without knowing the name of the upstream container 
```bash
docker exec -it $(docker ps -qf "name=dbt_p") dbt run --select <MODEL_NAME> --vars 'current_date: 2020-01-02'
```

```bash
docker exec -it $(docker ps -qf "name=dbt_p") dbt run --select <MODEL_NAME>  --vars '{"type_of_ingestion": "daily_append", "write_strategy": "merge"}'
```
```bash
docker exec -it $(docker ps -qf "name=dbt_p") dbt run --select <MODEL_NAME>  --vars 'type_of_ingestion: daily_appen','write_strategy: merge'
```

Add dbt in network of Airflow Container : Connect DBT container in other container
```bash
docker run -d --net airflow-plateform-docker_default --name dbt -p 8001:8001 -it dbt_p docs serve --port 8001
```


### Using specific Model (basic command dbt)
```bash
dbt run --select my_dbt_project_name   # runs all models in your project
dbt run --select my_dbt_model          # runs a specific model
dbt run --select path.to.my.models     # runs all models in a specific directory
dbt run --select my_package.some_model # run a specific model in a specific package
dbt run --select tag:nightly           # run models with the "nightly" tag
dbt run --select path/to/models        # run models contained in path/to/models
dbt run --select path/to/my_model.sql  # run a specific model by its path
```


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

# License

The source code of this program is dual-licensed under the EUPL v1.2 and AGPLv3 licenses.