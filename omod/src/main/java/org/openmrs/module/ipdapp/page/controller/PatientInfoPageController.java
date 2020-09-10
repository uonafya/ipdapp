package org.openmrs.module.ipdapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.*;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.IpdPatientVitalStatistics;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.ipdapp.utils.IpdConstants;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by Francis on 1/7/2016.
 */
public class PatientInfoPageController {
    public void get(@RequestParam(value = "search",required = true) String search, PageModel model) {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        PatientService patientService = Context.getService(PatientService.class);;

        List<Patient> patientList = patientService.getPatients(null,search, null, true,null,null);

        Patient patient = patientList.get(0);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patient.getPatientId());

        model.addAttribute("patient", patient);
        model.addAttribute("patientIdentifier", search);
        model.addAttribute("patientInformation", patientInformation);

        //gets list of doctors
        Concept ipdConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_IPDWARD));
        List<ConceptAnswer> list = (ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);
        if (CollectionUtils.isNotEmpty(list)) {
            Collections.sort(list, new ConceptAnswerComparator());
        }
        model.addAttribute("listIpd", list);

        //displays the list of doctors
        String doctorRoleProps = Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_NAME_DOCTOR_ROLE);
        Role doctorRole = Context.getUserService().getRole(doctorRoleProps);
        if (doctorRole != null) {
            List<User> listDoctor = Context.getUserService().getUsersByRole(doctorRole);
            model.addAttribute("listDoctor", listDoctor);
        }

        //Diet list
        List<Concept> dietConcept= ipdService.getDiet();
        model.addAttribute("dietList", dietConcept);

        //Vital statistics
        List<IpdPatientVitalStatistics> ipdPatientVitalStatistics=ipdService.getIpdPatientVitalStatistics(patient.getPatientId(), patientInformation.getPatientAdmissionLog().getId());
        model.addAttribute("ipdPatientVitalStatistics", ipdPatientVitalStatistics);

        //list of discharge outcomes
        Concept outComeList = Context.getConceptService().getConceptByName(HospitalCoreConstants.CONCEPT_ADMISSION_OUTCOME);
        model.addAttribute("listOutCome", outComeList.getAnswers());
    }
}
