podman build --platform linux/amd64 \
    --build-arg INSTALLER_USERNAME=${INSTALLER_USERNAME} \
    --build-arg INSTALLER_PASSWORD=${INSTALLER_PASSWORD} \
    --build-arg INSTALLER_PRODUCTS=e2ei/11/WmSAP_10.1.0.0.1013/CDC/WmSAPcdc,e2ei/11/DCC_11.1.0.0.26/CDC/DatabaseComponentConfigurator,e2ei/11/PE_11.1.0.0.130/CDC/WPEcdc,e2ei/11/BRMS_11.1.0.0.881/CDC/WOKcdc,e2ei/11/TN_11.1.0.0.608/CDC/TNScdc,e2ei/11/IS_11.1.0.0.1136/CDC/PIEcdc,e2ei/11/WMN_11.1.0.0.181/CDC/WMNcdc,e2ei/11/MFT_11.1.0.0.804/CDC/MATcdc,e2ei/11/YAI_11.1.0.0.866/CDC/YAIcdc,e2ei/11/MWS_11.1.0.0.825/CDC/MWScdc,e2ei/11/BAM_11.1.0.0.798/CDC/OBEcdc,e2ei/11/WST_11.1.0.0.40/CDC/WSTcdc,e2ei/11/BAM_11.1.0.0.798/CDC/OBECentConfCdc \
    --build-arg INSTALLER_FIXES= \
    -t dbc:11.1 .