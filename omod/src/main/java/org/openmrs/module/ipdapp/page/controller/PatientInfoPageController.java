package org.openmrs.module.ipdapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.*;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.IpdPatientVitalStatistics;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.ipdapp.model.NursingCarePlan;
import org.openmrs.module.ipdapp.model.NursingNote;
import org.openmrs.module.ipdapp.utils.IpdConstants;
import org.openmrs.module.ipdapp.utils.IpdUtils;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.module.kenyaui.annotation.AppPage;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 *
 */
@AppPage(IpdConstants.APP_IPD_APP)
public class PatientInfoPageController {


    public void get(@RequestParam(value = "search", required = true) String search, PageModel model) {
        IpdService ipdService = Context.getService(IpdService.class);
        PatientService patientService = Context.getService(PatientService.class);

        List<Patient> patientList = patientService.getPatients(null, search, null, true,null,null);

        Patient patient = patientList.get(0);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patient.getPatientId());
        PersonAttributeType paymentCategoryPaymentAttribute = Context.getPersonService().getPersonAttributeTypeByUuid("09cd268a-f0f5-11ea-99a8-b3467ddbf779");
        PersonAttributeType paymentCategorySubTypePaymentAttribute = Context.getPersonService()
                .getPersonAttributeTypeByUuid("972a32aa-6159-11eb-bc2d-9785fed39154");
        model.addAttribute("patient", patient);
        model.addAttribute("patientIdentifier", search);
        model.addAttribute("patientInformation", patientInformation);
        model.addAttribute("category", patient.getAttribute(paymentCategoryPaymentAttribute));
        model.addAttribute("subCategory", patient.getAttribute(paymentCategorySubTypePaymentAttribute));
        model.addAttribute("ipdNumber", IpdUtils.getIpdNumber(patient));

        //gets list of doctors
        Concept ipdConcept = Context.getConceptService().getConceptByUuid("5fc29316-0869-4b3b-ae2f-cc37c6014eb7");
        List<ConceptAnswer> list = (ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);
        if (CollectionUtils.isNotEmpty(list)) {
            Collections.sort(list, new ConceptAnswerComparator());
        }
        model.addAttribute("listIpd", list);

        //displays the list of doctors
        Role doctorRole = Context.getUserService().getRole("Doctor");
        if (doctorRole != null) {
            List<User> listDoctor = Context.getUserService().getUsersByRole(doctorRole);
            model.addAttribute("listDoctor", listDoctor);
        }

        //Diet list
        List<Concept> dietConcept= ipdService.getDiet();
        model.addAttribute("dietList", dietConcept);

        //Vital statistics
        List<IpdPatientVitalStatistics> ipdPatientVitalStatistics = ipdService.getIpdPatientVitalStatistics(patient.getPatientId(), patientInformation.getPatientAdmissionLog().getId());
        model.addAttribute("ipdPatientVitalStatistics", ipdPatientVitalStatistics);

        //list of discharge outcomes
        Concept outComeList = Context.getConceptService().getConceptByUuid("0c760f02-df3d-4280-b8b3-ea51aab94a69");
        model.addAttribute("listOutCome", outComeList.getAnswers());

        PatientDashboardService dashboardService = Context.getService(PatientDashboardService.class);
        Location location = Context.getService(KenyaEmrService.class).getDefaultLocation();

        EncounterType encounterType = Context.getEncounterService().getEncounterTypeByUuid("6e1105ba-f282-11ea-ad42-e7971c094de0");

        List<Encounter> encounters = dashboardService.getEncounter(patient, location, encounterType, null);

        List<NursingNote> nursingNotes = new ArrayList<NursingNote>();
        List<NursingCarePlan> nursingCarePlans = new ArrayList<NursingCarePlan>();

        Concept nursingNoteConcept = Context.getConceptService().getConceptByUuid("1238AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        Concept nursingCarePlanConcept = Context.getConceptService().getConceptByUuid("166021AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");


        for (Encounter enc : encounters) {

            StringBuilder notesDetailsSB = new StringBuilder();
            StringBuilder diagnosisSB = new StringBuilder();
            StringBuilder objectivesSB = new StringBuilder();
            StringBuilder expectedOutcomeSB = new StringBuilder();
            StringBuilder interventionSB = new StringBuilder();
            StringBuilder rationaleSB = new StringBuilder();
            StringBuilder evaluationSB = new StringBuilder();

            boolean isNursingNote = false, isNursingCarePlan = false;

            for (Obs obs : enc.getAllObs()) {
                if (obs.getConcept().equals(nursingNoteConcept)) {
                    notesDetailsSB.append(obs.getValueText());
                    isNursingNote = true;
                }

                if (obs.getConcept().equals(nursingCarePlanConcept)) {
                    isNursingCarePlan = true;
                    String DIAGNOSIS_OBS_KEY = "Diagnosis";
                    if (obs.getComment().equals(DIAGNOSIS_OBS_KEY)) {
                        diagnosisSB.append(obs.getValueText());
                    }
                    String OBJECTIVES_OBS_KEY = "Objectives";
                    if (obs.getComment().equals(OBJECTIVES_OBS_KEY)) {
                        objectivesSB.append(obs.getValueText());
                    }
                    String EXPECTED_OUTCOME_OBS_KEY = "ExpectedOutcome";
                    if (obs.getComment().equals(EXPECTED_OUTCOME_OBS_KEY)) {
                        expectedOutcomeSB.append(obs.getValueText());
                    }
                    String INTERVENTION_OBS_KEY = "Intervention";
                    if (obs.getComment().equals(INTERVENTION_OBS_KEY)) {
                        interventionSB.append(obs.getValueText());
                    }
                    String RATIONALE_OBS_KEY = "Rationale";
                    if (obs.getComment().equals(RATIONALE_OBS_KEY)) {
                        rationaleSB.append(obs.getValueText());
                    }
                    String EVALUATION_OBS_KEY = "Evaluation";
                    if (obs.getComment().equals(EVALUATION_OBS_KEY)) {
                        evaluationSB.append(obs.getValueText());
                    }
                }
            }


            if(isNursingNote){
                NursingNote nursingNote = new NursingNote();
                nursingNote.setDate(enc.getDateCreated());
                nursingNote.setEncounterId(enc.getEncounterId());
                nursingNote.setMedic(enc.getCreator().getGivenName() + " " + enc.getCreator().getFamilyName());

                nursingNote.setDetails(notesDetailsSB.toString());
                nursingNotes.add(nursingNote);
            }

            if(isNursingCarePlan){
                NursingCarePlan nursingCarePlan = new NursingCarePlan();
                nursingCarePlan.setDate(enc.getDateCreated());
                nursingCarePlan.setEncounterId(enc.getEncounterId());
                nursingCarePlan.setMedic(enc.getCreator().getGivenName() + " " + enc.getCreator().getFamilyName());

                nursingCarePlan.setDiagnosis(diagnosisSB.toString());
                nursingCarePlan.setObjectives(objectivesSB.toString());
                nursingCarePlan.setExpectedOutcome(expectedOutcomeSB.toString());
                nursingCarePlan.setIntervention(interventionSB.toString());
                nursingCarePlan.setRationale(rationaleSB.toString());
                nursingCarePlan.setEvaluation(evaluationSB.toString());

                nursingCarePlans.add(nursingCarePlan);
            }
        }

        model.addAttribute("nursingNotes", nursingNotes);

        model.addAttribute("nursingCarePlans", nursingCarePlans);
    }
}
