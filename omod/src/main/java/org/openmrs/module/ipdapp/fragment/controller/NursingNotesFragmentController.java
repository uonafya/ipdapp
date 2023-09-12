package org.openmrs.module.ipdapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.*;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;

public class NursingNotesFragmentController {

    public void controller(
            FragmentConfiguration config,
            FragmentModel model
    ){
        config.require("patientId");
        Integer patientId = Integer.parseInt(config.get("patientId").toString());
        PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
        Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();

        //IpdService ipdService = Context.getService(IpdService.class);
        //IpdPatientAdmitted admitted = ipdService.getAdmittedByPatientId(patientId);
        Patient patient = Context.getPatientService().getPatient(patientId);

        model.addAttribute("patient", patient);
    }


    public void saveNursingNotes(
            @RequestParam(value ="patientId", required = false) Integer patientId,
            @RequestParam(value ="details", required = false) String details
    ) {

        HospitalCoreService hcs = Context.getService(HospitalCoreService.class);


        Patient patient = Context.getPatientService().getPatient(patientId);

        User user = Context.getAuthenticatedUser();
        Date date = new Date();

        Concept nursingNoteConcept = Context.getConceptService().getConceptByUuid("1238AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

        Obs obsGroup = hcs.getObsGroupCurrentDate(patient.getPersonId());

        EncounterType encounterType = Context.getEncounterService().getEncounterTypeByUuid("6e1105ba-f282-11ea-ad42-e7971c094de0");

        Encounter encounter = new Encounter();
        encounter.setEncounterType(encounterType);
        Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();
        encounter.setPatient(patient);
        encounter.setCreator(user);
        encounter.setEncounterDatetime(date);
        encounter.setLocation(location);
        encounter.setProvider(getEncounterRole(), getProvider(user));


        if (StringUtils.isNotBlank(details)) {
            Obs obs = new Obs();
            obs.setObsGroup(obsGroup);
            obs.setConcept(nursingNoteConcept);
            obs.setValueText(details);
            obs.setCreator(user);
            obs.setDateCreated(date);
            obs.setEncounter(encounter);
            obs.setPerson(patient);
            encounter.addObs(obs);
        }

        Context.getEncounterService().saveEncounter(encounter);

    }

    private Provider getProvider(User user) {
        Provider provider = null;
        for (Provider prov:Context.getProviderService().getProvidersByPerson(user.getPerson())){
            if(prov != null) {
                provider = prov;
                break;
            }
        }

        return provider;
    }

    private EncounterRole getEncounterRole() {
        return Context.getEncounterService().getEncounterRoleByUuid("a0b03050-c99b-11e0-9572-0800200c9a66");
    }
}
