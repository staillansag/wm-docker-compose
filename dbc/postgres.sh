source ../.env

podman run --rm --network compose_default dbc dbConfigurator.sh \
    -a create \
    -d pgsql \
    -c ISInternal,DocumentHistory,CrossReference,ISCoreAudit,DistributedLocking,ProcessAudit \
    -v latest \
    -l "jdbc:wm:postgresql://postgres:5432;databaseName=wm11" \
    -u "${DB_USERNAME}" \
    -p "${DB_PASSWORD}"