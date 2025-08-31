#!/bin/bash

echo "Aurora PostgreSQL versions with PostGIS extension info (ap-southeast-6):"
echo "========================================================================"

# Get Aurora PostgreSQL versions
aws rds describe-db-engine-versions \
  --engine aurora-postgresql \
  --region ap-southeast-6 \
  --query 'DBEngineVersions[*].{Version:EngineVersion,Major:MajorEngineVersion,Description:DBEngineVersionDescription}' \
  --output json | jq -r '.[] | 
    "Version: " + .Version + 
    "\n  Major Version: " + .Major + 
    "\n  PostGIS Version: " + (
      if .Major == "17" then "3.5.1"
      elif .Major == "16" then "3.4.2" 
      elif .Major == "15" then "3.3.4"
      elif .Major == "14" then "3.2.7"
      elif .Major == "13" then "3.1.9"
      else "Unknown" end
    ) +
    "\n  Grid Files: " + (
      if (.Major == "17" or .Major == "16") then "TIGER/Line 2023, GNIS"
      elif (.Major == "15" or .Major == "14") then "TIGER/Line 2022, GNIS" 
      elif .Major == "13" then "TIGER/Line 2021, GNIS"
      else "Unknown" end
    ) +
    "\n  Extension Docs: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraPostgreSQLReleaseNotes/AuroraPostgreSQL.Extensions.html#AuroraPostgreSQL.Extensions." + .Major +
    "\n  PostGIS Setup: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Appendix.PostgreSQL.CommonDBATasks.PostGIS.html" +
    "\n  Description: " + .Description +
    "\n" + ("-" * 80)'

