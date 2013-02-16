package com.alfresco.consulting.automating;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.File;
import java.io.OutputStream;
import java.io.StringWriter;
import java.util.Properties;

import com.alfresco.locator.PropertiesLocator;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.xml.sax.SAXException;

public class AddStoreSelectorAspect {

    private static Properties props = PropertiesLocator.getProperties("dralf.properties");
    private static String shareConfigXmlFile=props.getProperty("shareConfigXmlFile");

    public static Node getNodeByName(NodeList nl,  String name)
    {
        int i,n=nl.getLength();
        for(i=0; i < n && !nl.item(i).getNodeName().equals(name); ++i)
            ;
        return i<n ? nl.item(i) : null;
    }

    public static void main(String args[]) {
        try {
            File file = new File(shareConfigXmlFile);
            //Create instance of DocumentBuilderFactory
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            //Get the DocumentBuilder
            DocumentBuilder docBuilder = factory.newDocumentBuilder();
            //Using existing XML Document
            Document doc = docBuilder.parse(file);
            //create the root element
            Element root = doc.getDocumentElement();
            //create child element
            Element childElement = doc.createElement("aspect");
            NodeList listOfConfigTags = doc.getElementsByTagName("config");
            int totalConfigs = listOfConfigTags.getLength();

            // Finding target config tag
            for (int i=0;i<totalConfigs;i++) {
                Node configtag = listOfConfigTags.item(i);
                NamedNodeMap attributes =  configtag.getAttributes();
                Node conditionNode = attributes.getNamedItem("condition");
                String conditionNodeValue = attributes.getNamedItem("condition")!=null?conditionNode.getNodeValue():"no_condition";
                if (conditionNodeValue.equals("DocumentLibrary")) {   // We are inside the target config Node
                    NodeList childNodes=configtag.getChildNodes();
                    Node aspectsNode = getNodeByName(childNodes,"aspects");
                    NodeList aspectsChildNodes=aspectsNode.getChildNodes();
                    Node aspectsVisibleNode = getNodeByName(aspectsChildNodes,"visible");
                    childElement.setAttribute("name","cm:storeSelector");
                    aspectsVisibleNode.appendChild(childElement);
                }
            }

            //set up a transformer
            TransformerFactory transfac = TransformerFactory.newInstance();
            Transformer trans = transfac.newTransformer();

            //create string from xml tree
            StringWriter sw = new StringWriter();
            StreamResult result = new StreamResult(sw);
            DOMSource source = new DOMSource(doc);
            trans.transform(source, result);
            String xmlString = sw.toString();

            OutputStream f0;
            byte buf[] = xmlString.getBytes();
            f0 = new FileOutputStream(shareConfigXmlFile);
            for(int i=0;i<buf .length;i++) {
                f0.write(buf[i]);
            }
            f0.close();
            buf = null;
        }
        catch(SAXException e) {
            e.printStackTrace();
        }
        catch(IOException e) {
            e.printStackTrace();
        }
        catch(ParserConfigurationException e) {
            e.printStackTrace();
        }
        catch(TransformerConfigurationException e) {
            e.printStackTrace();
        }
        catch(TransformerException e) {
            e.printStackTrace();
        }




    }
}