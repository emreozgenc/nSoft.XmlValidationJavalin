package com.nilvera.xmlvalidationjavalin.models;

public class XmlValidationModel {
    private final XmlValidationResultModel result;
    private final String errorMessage;

    public XmlValidationModel(XmlValidationResultModel result, String errorMessage) {
        this.result = result;
        this.errorMessage = errorMessage;
    }

    public XmlValidationResultModel getResult() {
        return result;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
}
