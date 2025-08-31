Check which version of Postgres Aurora are available:

# Get Aurora PostgreSQL versions
aws rds describe-db-engine-versions \
  --engine aurora-postgresql \
  --region ap-southeast-6 \
  --query 'DBEngineVersions[*].{Version:EngineVersion,Major:MajorEngineVersion,Description:DBEngineVersionDescription}'
