package com.nilvera.xmlvalidationjavalin.models;

public class XmlValidationModel {
    private XmlValidationResultModel result;
    private String errorMessage;

    public XmlValidationModel(XmlValidationResultModel result, String errorMessage) {
        this.result = result;
        this.errorMessage = errorMessage;
    }

    public XmlValidationModel() {

    }

    public XmlValidationResultModel getResult() {
        return result;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setResult(XmlValidationResultModel result) {
        this.result = result;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
}
