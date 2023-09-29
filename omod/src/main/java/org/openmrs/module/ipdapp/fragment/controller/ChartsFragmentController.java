package org.openmrs.module.ipdapp.fragment.controller;

import org.openmrs.Patient;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.IpdPatientVitalStatistics;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.fragment.FragmentConfiguration;
import org.openmrs.ui.framework.fragment.FragmentModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;

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

    public SimpleObject getChartDetails(
            @RequestParam("patientId") Integer patientId,
            @RequestParam(value ="chart", required = false) String chart,
            UiUtils ui
    ) {
        List<String> labels = new ArrayList<String>();
        List<Double> data = new ArrayList<Double>();

        String label = "";

        IpdService ipdService = Context.getService(IpdService.class);
        Patient patient = Context.getPatientService().getPatient(patientId);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patient.getPatientId());

        List<IpdPatientVitalStatistics> ipdPatientVitalStatistics = ipdService.getIpdPatientVitalStatistics(patient.getPatientId(), patientInformation.getPatientAdmissionLog().getId());


        if(chart.equals("morningAndEveningTemperatureChart")){
            label = "Morning & Evening Temperature Chart";
            LinkedHashMap<LocalDate, Map<String, Double>> tempData = new LinkedHashMap<>();
            LocalTime midDayLocalTime = LocalTime.of(12, 0);

            for (IpdPatientVitalStatistics obj: ipdPatientVitalStatistics) {
                Map<String, Double> map = new HashMap<>();
                LocalDateTime localDateTime = convertToLocalDateViaInstant(obj.getCreatedOn());
                if(localDateTime.toLocalTime().isBefore(midDayLocalTime)){
                    map.put("Morning", Double.valueOf(obj.getTemperature()));
                }else{
                    map.put("Evening", Double.valueOf(obj.getTemperature()));
                }

                tempData.put(localDateTime.toLocalDate(), map);
            }

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd");

            for (Map.Entry<LocalDate, Map<String, Double>> entry : tempData.entrySet()) {
                labels.add(formatter.format(entry.getKey()));
                data.add(entry.getValue().get("Morning"));
                data.add(entry.getValue().get("Evening"));
            }
        }

        SimpleObject dataSet = SimpleObject.create("label", label, "data", data);

        List<SimpleObject> dataSets = new ArrayList<>();
        dataSets.add(dataSet);

        return SimpleObject.create("labels", labels, "datasets", dataSets);
    }



    private LocalDateTime convertToLocalDateViaInstant(Date dateToConvert) {
        return dateToConvert.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime();
    }
}
