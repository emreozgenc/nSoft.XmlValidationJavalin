package com.nilvera.xmlvalidationjavalin.validators;

import com.nilvera.xmlvalidationjavalin.models.XmlValidationModel;
import com.nilvera.xmlvalidationjavalin.models.XmlValidationResultModel;
import org.xml.sax.SAXException;

import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.SchemaFactory;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.LinkedList;
import java.util.List;

public class InvoiceValidator implements Validator {

    private static final String SCHEMA_LANGUAGE = "http://www.w3.org/2001/XMLSchema";
    private static final String XSD_PATH = "static/document/xsd/maindoc/UBL-Invoice-2.1.xsd";
    private static InputStream xsdFile = UblTrValidator.class.getResourceAsStream(XSD_PATH);
    private static SchemaFactory schemaFactory = SchemaFactory.newInstance(SCHEMA_LANGUAGE);

    public XmlValidationModel validate(InputStream inputStream) {
        xsdFile = UblTrValidator.class.getResourceAsStream(XSD_PATH);
        List<String> errors = new LinkedList<>();
        try {
            xsdFile = UblTrValidator.class.getResourceAsStream(XSD_PATH);
            StreamSource schemaValidationStreamSource = new StreamSource(inputStream);
            ByteArrayOutputStream schemaValidationByteArrayOutputStream = new ByteArrayOutputStream();
            StreamResult schemaValidationStreamResult = new StreamResult(schemaValidationByteArrayOutputStream);

            try {
                javax.xml.validation.Validator validator = schemaFactory.newSchema(new StreamSource(xsdFile)).newValidator();
                validator.validate(schemaValidationStreamSource, schemaValidationStreamResult);
            } catch (SAXException e) {
                errors.add(e.getMessage());
            }

            XmlValidationResultModel resultModel = new XmlValidationResultModel(errors.isEmpty(), errors);
            return new XmlValidationModel(resultModel, null);
        } catch (Exception e) {
            return new XmlValidationModel(null, e.getMessage());
        }
    }
}
