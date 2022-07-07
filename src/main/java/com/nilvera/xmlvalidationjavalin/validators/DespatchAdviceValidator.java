package com.nilvera.xmlvalidationjavalin.validators;

import com.nilvera.xmlvalidationjavalin.models.XmlValidationModel;
import com.nilvera.xmlvalidationjavalin.models.XmlValidationResultModel;
import org.xml.sax.SAXException;

import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.SchemaFactory;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.util.LinkedList;
import java.util.List;

public class DespatchAdviceValidator implements Validator {

    private static final String SCHEMA_LANGUAGE = "http://www.w3.org/2001/XMLSchema";
    private static final String XSD_PATH = "static/document/xsd/maindoc/UBL-DespatchAdvice-2.1.xsd";
    private static SchemaFactory schemaFactory = SchemaFactory.newInstance(SCHEMA_LANGUAGE);
    private static final File xsdFile = new File(XSD_PATH);
    private static javax.xml.validation.Validator validator;

    static {
        try {
            validator = schemaFactory.newSchema(new StreamSource(xsdFile)).newValidator();
        } catch (SAXException e) {
            System.out.println(e.getMessage());
        }
    }

    public XmlValidationModel validate(InputStream inputStream) {
        XmlValidationResultModel resultModel = new XmlValidationResultModel();
        XmlValidationModel model = new XmlValidationModel();
        model.setResult(resultModel);
        model.getResult().setIsValid(false);
        List<String> errors = new LinkedList<>();
        try {
            StreamSource schemaValidationStreamSource = new StreamSource(inputStream);
            ByteArrayOutputStream schemaValidationByteArrayOutputStream = new ByteArrayOutputStream();
            StreamResult schemaValidationStreamResult = new StreamResult(schemaValidationByteArrayOutputStream);
            try {
                validator.validate(schemaValidationStreamSource, schemaValidationStreamResult);
            } catch (SAXException e) {
                errors.add(e.getMessage());
            }

            resultModel.setIsValid(errors.isEmpty());
            resultModel.setErrors(errors);
            model.setErrorMessage(null);
            return model;
        } catch (Exception e) {
            model.setResult(null);
            model.setErrorMessage(e.getMessage());
            return model;
        }
    }
}
