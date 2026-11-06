#!/bin/bash
# To be run from qc-lookup/qartod directory.
# Modify the ~/host_repos/ directory below to 
# Load database connection information from .env file.
# Values read in by the load_qartod.py script:
#   POSTGRES_HOSTNAME
#   POSTGRES_USERNAME
#   POSTGRES_PASSWORD

if [ -f .env ]
then
  export $(cat .env | xargs)
fi
#set to production DB info for release
the_host=localhost
the_user=awips

#Path where https://github.com/oceanobservatories/qc-lookup is cloned
qc_lookup_repo_path=~/host_repos/qc-lookup/qartod/

#Probably should be /opt/miniconda2/envs/engine/stream_engine/sripts/ for release
stream_engine_path=~/host_repos/stream_engine/scripts/

for i in $(find . -mindepth 1 -type d \( -path ./velpt -o -name climatology_tables \) -prune -o -type d -print); do 
    echo "Processing QARTOD tests in $i"; 
    cd "$i"
    find . -type d -name climatology_tables -prune -o -type f -name "*.csv" -print -exec python ${stream_engine_path}load_qartod.py {} \;
    cd ..
done

# find $qc_lookup_repo_path -type d -name climatology_tables -prune -o -type f -name "*.csv" -print -exec python ${stream_engine_path}load_qartod.py {} \;
