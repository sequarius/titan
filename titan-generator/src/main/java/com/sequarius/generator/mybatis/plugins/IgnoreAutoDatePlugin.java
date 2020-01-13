package com.sequarius.generator.mybatis.plugins;

import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.PluginAdapter;
import org.mybatis.generator.api.dom.xml.TextElement;
import org.mybatis.generator.api.dom.xml.VisitableElement;
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
        List<VisitableElement> elements = element.getElements();
        Iterator<VisitableElement> iterator = elements.iterator();
        while (iterator.hasNext()){
            VisitableElement baseElements=iterator.next();
            if (!(baseElements instanceof TextElement)){
                continue;
            }
            TextElement targetElement=(TextElement)baseElements;
            if(targetElement.getContent().contains("update_time")||targetElement.getContent().contains("create_time")){
                iterator.remove();
            }
        }
    }

    public boolean validate(List<String> warnings)
    {
        return true;
    }
    private void removeTimeAttribute(XmlElement element) {
        List<VisitableElement> elements = element.getElements();
        Iterator<VisitableElement> iterator = elements.iterator();
        while (iterator.hasNext()){
            VisitableElement baseElements=iterator.next();
            if (!(baseElements instanceof XmlElement)){
                continue;
            }
            XmlElement setTagElement=(XmlElement)baseElements;
            if(!setTagElement.getName().contains("set")){
                continue;
            }
            List<VisitableElement> setTagElements = setTagElement.getElements();
            Iterator<VisitableElement> setTagIterator = setTagElements.iterator();
            while (setTagIterator.hasNext()){
                VisitableElement currentElement = setTagIterator.next();
                if (!(currentElement instanceof XmlElement)){
                    continue;
                }
                XmlElement setTagInnerElement=(XmlElement)currentElement;
                for (VisitableElement next : setTagInnerElement.getElements()) {
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
