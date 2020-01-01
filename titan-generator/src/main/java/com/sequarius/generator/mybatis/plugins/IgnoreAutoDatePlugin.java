package com.sequarius.generator.mybatis.plugins;

import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.PluginAdapter;
import org.mybatis.generator.api.dom.xml.Attribute;
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
//        removeTimeTextAttribute(element);
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
        int removeCommaIndex=0;
        TextElement replaceElement=null;
        Iterator<VisitableElement> iterator = elements.iterator();
        while (iterator.hasNext()){
            VisitableElement baseElements=iterator.next();
            if (baseElements instanceof TextElement){
                TextElement targetElment=(TextElement)baseElements;
                if(targetElment.getContent().contains("update_time")||targetElment.getContent().contains("create_time")){
                    iterator.remove();
                }
            }
            if (baseElements instanceof TextElement){
                TextElement targetElment=(TextElement)baseElements;
                if(targetElment.getContent().contains("where")){
                    removeCommaIndex=1;
                    replaceElement=(TextElement)(elements.get(removeCommaIndex));
                    String content = replaceElement.getContent().trim();
                    replaceElement=new TextElement(content.substring(0,content.length()-1));
                }
            }
            iterator.next();
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
            XmlElement targetElment=(XmlElement)baseElements;
            if(targetElment.getName().contains("set")){
                List<VisitableElement> innerElements = targetElment.getElements();
                for (int i1 = 0; i1 < innerElements.size(); i1++) {
                    VisitableElement baseInnerElements=elements.get(i1);
                    if (!(baseInnerElements instanceof XmlElement)){
                        continue;
                    }
                    targetElment=(XmlElement)innerElements.get(i1);
                    Iterator<Attribute> attributeIterator = targetElment.getAttributes().iterator();
                    while (attributeIterator.hasNext()){
                        attributeIterator.remove();
                    }
                }
            }
        }
    }
}
