package com.nilvera.xmlvalidationjavalin.validators;

import com.nilvera.xmlvalidationjavalin.models.XmlValidationResultModel;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.LinkedList;
import java.util.List;

public class UblTrValidator implements Validator {

    private static final String UBL_TR_PATH = "UBL-TR_Main_Schematron.xsl";
    private static final TransformerFactory transformerFactory = TransformerFactory.newInstance();
    private static final XPathFactory xPathFactory = XPathFactory.newInstance();
    private static final XPathExpression expr;
    private static final DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
    private static final DocumentBuilder documentBuilder;
    private static InputStream xslStream = UblTrValidator.class.getClassLoader().getResourceAsStream(UBL_TR_PATH);
    private static final StreamSource streamSource;
    private static final Transformer ublTrMainSchematronValidationTransformer;

    static {
        try {
            streamSource = new StreamSource(xslStream);
            documentBuilder = documentBuilderFactory.newDocumentBuilder();
            expr = xPathFactory.newXPath().compile("/Errors/Error");
            documentBuilderFactory.setNamespaceAware(true);
            ublTrMainSchematronValidationTransformer = transformerFactory.newTransformer(streamSource);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    @Override
    public XmlValidationResultModel validate(InputStream inputStream) {
        List<String> errors = new LinkedList<>();
        try {
            xslStream = UblTrValidator.class.getClassLoader().getResourceAsStream(UBL_TR_PATH);
            ByteArrayOutputStream arrayOutputStream = new ByteArrayOutputStream();
            StreamResult streamResult = new StreamResult(arrayOutputStream);
            StreamSource inputStreamSource = new StreamSource(inputStream);
            ublTrMainSchematronValidationTransformer.transform(inputStreamSource, streamResult);

            if (arrayOutputStream.size() > 0) {
                Document document = documentBuilder.parse(new ByteArrayInputStream(arrayOutputStream.toByteArray()));
                NodeList nodes = (NodeList) expr.evaluate(document, XPathConstants.NODESET);
                for (int i = 0; i < nodes.getLength(); ++i) {
                    errors.add(nodes.item(i).getTextContent());
                }
            }
            xslStream.close();
            inputStream.close();
        } catch (Exception e) {
            return null;
        }
        return new XmlValidationResultModel(!(errors.size() > 0), errors);
    }
}
