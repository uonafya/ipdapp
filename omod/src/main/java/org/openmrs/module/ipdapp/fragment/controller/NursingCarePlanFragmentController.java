package org.openmrs.module.ipdapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.ipdapp.model.NursingCarePlan;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class NursingCarePlanFragmentController {

    private final String DIAGNOSIS_OBS_KEY = "Diagnosis";
    private final String OBJECTIVES_OBS_KEY = "Objectives";
    private final String EXPECTED_OUTCOME_OBS_KEY = "ExpectedOutcome";
    private final String INTERVENTION_OBS_KEY = "Intervention";
    private final String RATIONALE_OBS_KEY = "Rationale";
    private final String EVALUATION_OBS_KEY = "Evaluation";


    public void controller(
            FragmentConfiguration config,
            FragmentModel model,
            UiUtils ui
    ){
        config.require("patientId");
        Integer patientId = Integer.parseInt(config.get("patientId").toString());
        PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
        Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();

        Patient patient = Context.getPatientService().getPatient(patientId);

        model.addAttribute("patient", patient);
    }


    public void saveNursingCarePlan(
            @RequestParam(value ="patientId", required = false) Integer patientId,
            @RequestParam(value ="diagnosis", required = false) String diagnosis,
            @RequestParam(value ="objectives", required = false) String objectives,
            @RequestParam(value ="expectedOutcome", required = false) String expectedOutcome,
            @RequestParam(value ="intervention", required = false) String intervention,
            @RequestParam(value ="rationale", required = false) String rationale,
            @RequestParam(value ="evaluation", required = false) String evaluation
    ) {

        HospitalCoreService hcs = Context.getService(HospitalCoreService.class);


        Patient patient = Context.getPatientService().getPatient(patientId);

        Concept nursingCarePlanConcept = Context.getConceptService().getConceptByUuid("166021AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

        EncounterType encounterType = Context.getEncounterService().getEncounterTypeByUuid("6e1105ba-f282-11ea-ad42-e7971c094de0");

        User user = Context.getAuthenticatedUser();
        Date date = new Date();

        Obs obsGroup = hcs.getObsGroupCurrentDate(patient.getPersonId());

        Encounter encounter = new Encounter();
        encounter.setEncounterType(encounterType);
        Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();
        encounter.setPatient(patient);
        encounter.setCreator(user);
        encounter.setEncounterDatetime(date);
        encounter.setLocation(location);
        encounter.setProvider(getEncounterRole(), getProvider(user));


        if (StringUtils.isNotBlank(diagnosis)) {
            Obs obs = new Obs();
            obs.setObsGroup(obsGroup);
            obs.setConcept(nursingCarePlanConcept);
            obs.setComment(DIAGNOSIS_OBS_KEY);
            obs.setValueText(diagnosis);
            obs.setCreator(user);
            obs.setDateCreated(date);
            obs.setEncounter(encounter);
            obs.setPerson(patient);
            encounter.addObs(obs);
        }

        if (StringUtils.isNotBlank(objectives)) {
            Obs obs = new Obs();
            obs.setObsGroup(obsGroup);
            obs.setConcept(nursingCarePlanConcept);
            obs.setComment(OBJECTIVES_OBS_KEY);
            obs.setValueText(objectives);
            obs.setCreator(user);
            obs.setDateCreated(date);
            obs.setEncounter(encounter);
            obs.setPerson(patient);
            encounter.addObs(obs);
        }

        if (StringUtils.isNotBlank(expectedOutcome)) {
            Obs obs = new Obs();
            obs.setObsGroup(obsGroup);
            obs.setConcept(nursingCarePlanConcept);
            obs.setComment(EXPECTED_OUTCOME_OBS_KEY);
            obs.setValueText(expectedOutcome);
            obs.setCreator(user);
            obs.setDateCreated(date);
            obs.setEncounter(encounter);
            obs.setPerson(patient);
            encounter.addObs(obs);
        }

        if (StringUtils.isNotBlank(intervention)) {
            Obs obs = new Obs();
            obs.setObsGroup(obsGroup);
            obs.setConcept(nursingCarePlanConcept);
            obs.setComment(INTERVENTION_OBS_KEY);
            obs.setValueText(intervention);
            obs.setCreator(user);
            obs.setDateCreated(date);
            obs.setEncounter(encounter);
            obs.setPerson(patient);
            encounter.addObs(obs);
        }

        if (StringUtils.isNotBlank(rationale)) {
            Obs obs = new Obs();
            obs.setObsGroup(obsGroup);
            obs.setConcept(nursingCarePlanConcept);
            obs.setComment(RATIONALE_OBS_KEY);
            obs.setValueText(rationale);
            obs.setCreator(user);
            obs.setDateCreated(date);
            obs.setEncounter(encounter);
            obs.setPerson(patient);
            encounter.addObs(obs);
        }

        if (StringUtils.isNotBlank(evaluation)) {
            Obs obs = new Obs();
            obs.setObsGroup(obsGroup);
            obs.setConcept(nursingCarePlanConcept);
            obs.setComment(EVALUATION_OBS_KEY);
            obs.setValueText(evaluation);
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
