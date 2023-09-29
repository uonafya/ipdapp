package org.openmrs.module.ipdapp.fragment.controller;

import org.openmrs.Concept;
import org.openmrs.Location;
import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.IpdPatientVitalStatistics;
import org.openmrs.module.kenyaemr.api.KenyaEmrService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

public class ChartsFragmentController {

    public void controller(
            FragmentConfiguration config,
            FragmentModel model
    ){
        config.require("patientId");
        Integer patientId = Integer.parseInt(config.get("patientId").toString());

        IpdService ipdService = Context.getService(IpdService.class);
        Patient patient = Context.getPatientService().getPatient(patientId);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patient.getPatientId());

        List<IpdPatientVitalStatistics> ipdPatientVitalStatistics = ipdService.getIpdPatientVitalStatistics(patient.getPatientId(), patientInformation.getPatientAdmissionLog().getId());

        model.addAttribute("ipdPatientVitalStatistics", ipdPatientVitalStatistics);
        model.addAttribute("patient", patient);
    }

    public List<SimpleObject> getTemperatureData(@RequestParam(value="patientId") Integer patientId, UiUtils ui) {

        IpdService ipdService = Context.getService(IpdService.class);
        Patient patient = Context.getPatientService().getPatient(patientId);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patient.getPatientId());

        List<IpdPatientVitalStatistics> ipdPatientVitalStatistics = ipdService.getIpdPatientVitalStatistics(patient.getPatientId(), patientInformation.getPatientAdmissionLog().getId());



        return SimpleObject.fromCollection(ipdPatientVitalStatistics, ui, "id", "name");
    }
}
