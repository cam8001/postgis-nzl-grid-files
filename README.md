# Check NZL grids

Check if NZL geodetic transformation files are available in an AWS hosted PostgreSQL instance. Specifically used in `ap-southeast-6` (NZL) now that it is available :)

## Prerequsites

Create:

- An RDS instance running postgres
- Make sure you have connectivity to it
- I use an EC2 hosted in the same VPC, and use the PostgreSQL RDS setup wizard to create and associate appropriate Security Groups
- Make sure you record your passwords!!!

Then:

- Create `~/.pgpass`
- `chmod 600 ~/.pgpass`
- Add your host, username, and password(s) to that file
- The file format is: `hostname:port:database:username:password`, one per line. You can use `*` characters as wildcards (eg, for the database part of the spec)

# Usage

`psql -h myhostname.region.rds.amazonaws.com -U postgres -f check-grid.sql`

You should see some output confirming/denying grid file availability.

# Current outputs

### Aurora Postgres 16


```
psql:check-grid.sql:52: NOTICE:  Starting script...
psql:check-grid.sql:52: NOTICE:  PostGIS version: POSTGIS="3.5.1 0" [EXTENSION] PGSQL="160" GEOS="3.13.0-CAPI-1.19.0" PROJ="9.5.0 NETWORK_ENABLED=OFF URL_ENDPOINT=https://cdn.proj.org USER_WRITABLE_DIRECTORY=/tmp/proj DATABASE_PATH=/rdsdbbin/aurora/bin/../share/postgresql/proj/proj.db" (compiled against PROJ 9.5.0) LIBXML="2.12.5" LIBJSON="0.15.99" LIBPROTOBUF="1.3.0" WAGYU="0.5.0 (Internal)" TOPOLOGY
psql:check-grid.sql:52: NOTICE:  Proj version: 9.5.0 NETWORK_ENABLED=OFF URL_ENDPOINT=https://cdn.proj.org USER_WRITABLE_DIRECTORY=/tmp/proj DATABASE_PATH=/rdsdbbin/aurora/bin/../share/postgresql/proj/proj.db
psql:check-grid.sql:52: NOTICE:  Using 7 parameter conversion without NZGD49 transformation grid: 0.001 < 2.553
psql:check-grid.sql:52: NOTICE:  Conversion wrapped OK. We have the right grid files!!!!

```

### RDS Postgres 16.9

```
psql:check-grid.sql:52: NOTICE:  Starting script...
psql:check-grid.sql:52: NOTICE:  PostGIS version: POSTGIS="3.4.3 e365945" [EXTENSION] PGSQL="160" GEOS="3.13.0-CAPI-1.19.0" PROJ="9.5.0 NETWORK_ENABLED=OFF URL_ENDPOINT=https://cdn.proj.org USER_WRITABLE_DIRECTORY=/tmp/proj DATABASE_PATH=/rdsdbbin/postgres-16.9.R1/share/proj/proj.db" LIBXML="2.9.1" LIBJSON="0.15" LIBPROTOBUF="1.3.2" WAGYU="0.5.0 (Internal)" TOPOLOGY
psql:check-grid.sql:52: NOTICE:  Proj version: 9.5.0 NETWORK_ENABLED=OFF URL_ENDPOINT=https://cdn.proj.org USER_WRITABLE_DIRECTORY=/tmp/proj DATABASE_PATH=/rdsdbbin/postgres-16.9.R1/share/proj/proj.db
psql:check-grid.sql:52: NOTICE:  Using NZGD49 transformation grid: 0.002 < 2.554
psql:check-grid.sql:52: NOTICE:  Conversion wrapped OK. We have the right grid files!!!!
```


### Other bits

There is also a script here to enumerate available Postgres versions on Aurora.
You will need IAM permission `rds:DescribeDBEngineVersions` to run it.
