package com.nilvera.xmlvalidationjavalin.models;

import java.util.List;

public class XmlValidationResultModel {
    private boolean isValid;
    private List<String> errors;

    public XmlValidationResultModel(boolean isValid, List<String> errors) {
        this.isValid = isValid;
        this.errors = errors;
    }

    public XmlValidationResultModel() {

    }

    public XmlValidationResultModel(boolean isValid) {
        this.isValid = isValid;
        errors = null;
    }

    public boolean getIsValid() {
        return isValid;
    }

    public List<String> getErrors() {
        return errors;
    }

    public void setIsValid(boolean valid) {
        isValid = valid;
    }

    public void setErrors(List<String> errors) {
        this.errors = errors;
    }
}
