package org.openmrs.module.ipdapp.model;

import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.User;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmittedLog;

import java.util.Date;

public class DischargedPatient {
    private int id;
    private Date dischargeDate;
    private User user;
    private String status;
    private Date admissionDate;
    private String patientName;
    private String gender;
    private String bed;
    private String patientIdentifier;
    private Concept admittedWard;
    private IpdPatientAdmittedLog ipdPatientAdmittedLog;

    public DischargedPatient() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getDischargeDate() {
        return dischargeDate;
    }

    public void setDischargeDate(Date dischargeDate) {
        this.dischargeDate = dischargeDate;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public Date getAdmissionDate() {
        return admissionDate;
    }

    public void setAdmissionDate(Date admissionDate) {
        this.admissionDate = admissionDate;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getBed() {
        return bed;
    }

    public void setBed(String bed) {
        this.bed = bed;
    }

    public String getPatientIdentifier() {
        return patientIdentifier;
    }

    public void setPatientIdentifier(String patientIdentifier) {
        this.patientIdentifier = patientIdentifier;
    }

    public Concept getAdmittedWard() {
        return admittedWard;
    }

    public void setAdmittedWard(Concept admittedWard) {
        this.admittedWard = admittedWard;
    }

    public IpdPatientAdmittedLog getIpdPatientAdmittedLog() {
        return ipdPatientAdmittedLog;
    }

    public void setIpdPatientAdmittedLog(IpdPatientAdmittedLog ipdPatientAdmittedLog) {
        this.ipdPatientAdmittedLog = ipdPatientAdmittedLog;
    }
}
