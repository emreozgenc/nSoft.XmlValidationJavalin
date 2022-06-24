package com.nilvera.xmlvalidationjavalin.validators;

import com.nilvera.xmlvalidationjavalin.models.XmlValidationModel;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.LinkedList;
import java.util.List;

public class UblTrValidator implements Validator {

    private static final String UBL_TR_PATH = "com/nilvera/xmlvalidationjavalin/UBL-TR_Main_Schematron.xsl";

    @Override
    public XmlValidationModel validate(InputStream inputStream) {
        boolean isValid = true;
        List<String> errors = new LinkedList<>();

        try {
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            StreamSource source = new StreamSource(UblTrValidator.class.getClassLoader().getResourceAsStream(UBL_TR_PATH));
            Transformer ublTrMainSchematronValidation = transformerFactory.newTransformer(source);
            ByteArrayOutputStream arrayOutputStream = new ByteArrayOutputStream();
            StreamResult streamResult = new StreamResult(arrayOutputStream);

            ublTrMainSchematronValidation.transform(new StreamSource(inputStream), streamResult);

            if (arrayOutputStream.size() > 0) {
                XPathFactory xpathFactory = XPathFactory.newInstance();
                XPath xpath = xpathFactory.newXPath();
                XPathExpression expr = xpath.compile("/Errors/Error");
                DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                factory.setNamespaceAware(true);
                DocumentBuilder builder = factory.newDocumentBuilder();
                Document document = builder.parse(new ByteArrayInputStream(arrayOutputStream.toByteArray()));
                NodeList nodes = (NodeList) expr.evaluate(document, XPathConstants.NODESET);

                for (int i = 0; i < nodes.getLength(); ++i) {
                    errors.add(nodes.item(i).getTextContent());
                }

                if(errors.size() > 0) isValid = false;
            }
        } catch (Exception e) {
            System.out.println("An exception occurred : " + e.getMessage());
        }

        return new XmlValidationModel(isValid, errors);
    }
}
