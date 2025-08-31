-- Enable postgis
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE EXTENSION IF NOT EXISTS postgis_topology;

-- confirm it is installed
SELECT postgis_version ();

SET client_min_messages TO NOTICE;

DO
$$
DECLARE
   testpt GEOMETRY;
   testpt2 GEOMETRY;
   test7prm GEOMETRY;
   testgrid GEOMETRY;
   convtm GEOMETRY;
   convpt GEOMETRY;
   convpt2 GEOMETRY;
   x double precision;
   y double precision;
BEGIN
    BEGIN
        RAISE NOTICE 'Starting script...';
        RAISE NOTICE 'PostGIS version: %', postgis_full_version();
        RAISE NOTICE 'Proj version: %',postgis_proj_version();
        testpt=ST_SetSRID(ST_Point(173,-42),4167);
        testpt2=ST_SetSRID(ST_POINT(-187,-42),4167);
        test7prm=ST_SetSRID(ST_Point(172.99986158,-42.00170000),4272);
        testgrid=ST_SetSRID(ST_Point(172.99984074,-42.00171693),4272);
        convpt=ST_Transform(testpt, 4272);
        x=round(st_distancespheroid(test7prm,convpt,'SPHEROID["International 1924",6378388,297]')::numeric,3);
        y=round(st_distancespheroid(testgrid,convpt,'SPHEROID["International 1924",6378388,297]')::numeric,3);
        IF x < y THEN
            RAISE NOTICE 'Using 7 parameter conversion without NZGD49 transformation grid: % < %',x,y;
        ELSE
            RAISE NOTICE 'Using NZGD49 transformation grid: % < %',y,x;
        END if;
        convpt2=ST_Transform(testpt2, 4272);
        x=round(st_distancespheroid(convpt,convpt2,'SPHEROID["International 1924",6378388,297]')::numeric,3);
        IF x > 0.01 THEN
            RAISE NOTICE 'Difference between wrapped and unwrapped NZGD49 conversion: %',x;
        ELSE
            RAISE NOTICE 'Conversion wrapped OK. We have the right grid files!!!!';
        END if;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error: %', SQLERRM;
    END;
END;
$$;
