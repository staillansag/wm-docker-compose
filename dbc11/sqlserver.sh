source ../.env

podman run --rm --network compose_default dbc dbConfigurator.sh \
    -a create \
    -d sqlserver \
    -c ISInternal,DocumentHistory,CrossReference,ISCoreAudit,DistributedLocking,ProcessAudit,ActiveTransfer,ActiveTransferArchive,CommonDirectoryServices \
    -v latest \
    -l "jdbc:wm:sqlserver://sqlserver:1433;databaseName=WM11" \
    --user "sa" --password "Manage100!" \
    --admin_user "sa" --admin_password "Manage100!" \
    --dbname "WM11"