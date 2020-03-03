package com.sequarius.generator.mybatis.plugins;

import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.PluginAdapter;
import org.mybatis.generator.api.dom.xml.TextElement;
import org.mybatis.generator.api.dom.xml.Element;
import org.mybatis.generator.api.dom.xml.XmlElement;

import java.util.Iterator;
import java.util.List;


public class IgnoreAutoDatePlugin extends PluginAdapter {
    @Override
    public boolean sqlMapUpdateByExampleSelectiveElementGenerated(XmlElement element, IntrospectedTable introspectedTable) {
        removeTimeAttribute(element);
        return super.sqlMapUpdateByExampleSelectiveElementGenerated(element, introspectedTable);
    }

    @Override
    public boolean sqlMapUpdateByPrimaryKeySelectiveElementGenerated(XmlElement element, IntrospectedTable introspectedTable) {
        removeTimeAttribute(element);
        return super.sqlMapUpdateByPrimaryKeySelectiveElementGenerated(element, introspectedTable);
    }

    @Override
    public boolean sqlMapUpdateByExampleWithoutBLOBsElementGenerated(XmlElement element, IntrospectedTable introspectedTable) {
        removeTimeTextAttribute(element);
        return super.sqlMapUpdateByExampleWithoutBLOBsElementGenerated(element, introspectedTable);
    }

    @Override
    public boolean sqlMapUpdateByPrimaryKeyWithoutBLOBsElementGenerated(XmlElement element, IntrospectedTable introspectedTable) {
        removeTimeTextAttribute(element);
        return super.sqlMapUpdateByPrimaryKeyWithoutBLOBsElementGenerated(element, introspectedTable);
    }

    private void removeTimeTextAttribute(XmlElement element) {
        List<Element> elements = element.getElements();
        Iterator<Element> iterator = elements.iterator();
        while (iterator.hasNext()) {
            Element baseElements = iterator.next();
            if (!(baseElements instanceof TextElement)) {
                continue;
            }
            TextElement targetElement = (TextElement) baseElements;
            if (targetElement.getContent().contains("update_time") || targetElement.getContent().contains("create_time")) {
                iterator.remove();
            }
        }
        for (int i = elements.size() - 1; i >= 0; i--) {
            Element baseElements = elements.get(i);
            if (!(baseElements instanceof TextElement)) {
                continue;
            }
            TextElement targetElement = (TextElement) baseElements;
            String content = targetElement.getContent();
            if (content.trim().startsWith("where")) {
                continue;
            }
            if (content.endsWith(",")) {
                elements.set(i, new TextElement(content.substring(0, content.length() - 1)));
            }
            break;
        }
    }

    public boolean validate(List<String> warnings) {
        return true;
    }

    private void removeTimeAttribute(XmlElement element) {
        List<Element> elements = element.getElements();
        Iterator<Element> iterator = elements.iterator();
        while (iterator.hasNext()) {
            Element baseElements = iterator.next();
            if (!(baseElements instanceof XmlElement)) {
                continue;
            }
            XmlElement setTagElement = (XmlElement) baseElements;
            if (!setTagElement.getName().contains("set")) {
                continue;
            }
            List<Element> setTagElements = setTagElement.getElements();
            Iterator<Element> setTagIterator = setTagElements.iterator();
            while (setTagIterator.hasNext()) {
                Element currentElement = setTagIterator.next();
                if (!(currentElement instanceof XmlElement)) {
                    continue;
                }
                XmlElement setTagInnerElement = (XmlElement) currentElement;
                for (Element next : setTagInnerElement.getElements()) {
                    if (!(next instanceof TextElement)) {
                        continue;
                    }
                    TextElement textElement = (TextElement) next;
                    if (textElement.getContent().contains("update_time") || textElement.getContent().contains("create_time")) {
                        setTagIterator.remove();
                        break;
                    }
                }
            }
        }
    }
}
