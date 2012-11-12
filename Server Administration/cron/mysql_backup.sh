#!/bin/sh

#/usr/bin/mysqldump -uroot -p0pxLkukl0Nomaahkmo6O --all-databases > prod01_dtx_refreshedweb.sql
#/usr/bin/gzip prod01_dtx_refreshedweb.sql
#/bin/mv prod01_dtx_refreshedweb.sql.gz /sites/sqlBackups/`/bin/date + prod01_dtx_refreshedweb.sql-%Y%m%d.gz`

datetime=`date '+%m-%d-%y-%H-%M-%S'`
/usr/bin/mysqldump -uroot -p0pxLkukl0Nomaahkmo6O --all-databases > prod01_dtx_refreshedweb.sql
/usr/bin/gzip prod01_dtx_refreshedweb.sql
/bin/mv prod01_dtx_refreshedweb.sql.gz /sites/sqlBackups/prod01_dtx_refreshedweb.$datetime.sql.gz

find /sites/sqlBackups/prod01_dtx_refreshedweb.$datetime.sql.gz