package org.openmrs.module.ipdapp.model;

import org.openmrs.User;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;

import java.util.Date;

public class DischargedPatient {
    private int id;
    private Date dischargeDate;
    private User user;
    private String status;
    private IpdPatientAdmitted ipdPatientAdmitted;

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

    public IpdPatientAdmitted getIpdPatientAdmitted() {
        return ipdPatientAdmitted;
    }

    public void setIpdPatientAdmitted(IpdPatientAdmitted ipdPatientAdmitted) {
        this.ipdPatientAdmitted = ipdPatientAdmitted;
    }
}
