package org.openmrs.module.ipdapp.metadata;

import org.springframework.stereotype.Component;
import org.openmrs.module.metadatadeploy.bundle.AbstractMetadataBundle;
import org.openmrs.module.metadatadeploy.bundle.Requires;

import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.idSet;
import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.privilege;
import static org.openmrs.module.metadatadeploy.bundle.CoreConstructors.role;

/**
 * Implementation of access control to the app.
 */
@Component
@Requires(org.openmrs.module.kenyaemr.metadata.SecurityMetadata.class)
public class IpdSecurityMetadata extends AbstractMetadataBundle {

    public static class _Privilege {

        public static final String APP_IPD_APP = "App: ipdapp.home";
    }

    public static final class _Role {

        public static final String APPLICATION_IPD_MODULE = "EHR IPD";
    }

    /**
     * @see AbstractMetadataBundle#install()
     */
    @Override
    public void install() {
        install(privilege(_Privilege.APP_IPD_APP, "Able to access Key EHR IPD  module features"));
        install(role(_Role.APPLICATION_IPD_MODULE, "Can access EHR IPD module Application",
                idSet(org.openmrs.module.kenyaemr.metadata.SecurityMetadata._Role.API_PRIVILEGES_VIEW_AND_EDIT),
                idSet(_Privilege.APP_IPD_APP)));
    }
}
