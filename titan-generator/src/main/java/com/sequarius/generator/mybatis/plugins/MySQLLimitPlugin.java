package com.sequarius.generator.mybatis.plugins;


import org.mybatis.generator.api.CommentGenerator;
import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.PluginAdapter;
import org.mybatis.generator.api.dom.java.*;
import org.mybatis.generator.api.dom.xml.Attribute;
import org.mybatis.generator.api.dom.xml.TextElement;
import org.mybatis.generator.api.dom.xml.XmlElement;

import java.util.List;


public class MySQLLimitPlugin extends PluginAdapter {

    private static final String PAGE_ENTITY_NAME = "com.sequarius.titan.common.Page";



    @Override
    public boolean modelExampleClassGenerated(TopLevelClass topLevelClass, IntrospectedTable introspectedTable)
    {
        String pageClassFullName=getProperties().getProperty("pageEntityName",PAGE_ENTITY_NAME);
        String pageEntityName="page";
        topLevelClass.addImportedType(new FullyQualifiedJavaType(pageClassFullName));
        CommentGenerator commentGenerator = context.getCommentGenerator();
        Field field = new Field(pageEntityName,new FullyQualifiedJavaType(pageClassFullName));
        field.setVisibility(JavaVisibility.PROTECTED);
        commentGenerator.addFieldComment(field, introspectedTable);
        topLevelClass.addField(field);
        char c = pageEntityName.charAt(0);
        String camel = Character.toUpperCase(c) + pageEntityName.substring(1);
        Method method = new Method("set" + camel);
        method.setVisibility(JavaVisibility.PUBLIC);
        method.addParameter(new Parameter(new FullyQualifiedJavaType(pageClassFullName), pageEntityName));
        method.addBodyLine("this." + pageEntityName + "=" + pageEntityName + ";");
        commentGenerator.addGeneralMethodComment(method, introspectedTable);
        topLevelClass.addMethod(method);
        method = new Method("get" + camel);
        method.setVisibility(JavaVisibility.PUBLIC);
        method.setReturnType(new FullyQualifiedJavaType(pageClassFullName));
        method.addBodyLine("return " + pageEntityName + ";");
        commentGenerator.addGeneralMethodComment(method, introspectedTable);
        topLevelClass.addMethod(method);
        return super.modelExampleClassGenerated(topLevelClass, introspectedTable);
    }
    @Override
    public boolean sqlMapSelectByExampleWithoutBLOBsElementGenerated(XmlElement element, IntrospectedTable introspectedTable)
    {
        XmlElement page = new XmlElement("if");
        page.addAttribute(new Attribute("test", "page != null"));
        page.addElement(new TextElement("limit #{page.begin} , #{page.length}"));
        element.addElement(page);
        return super.sqlMapUpdateByExampleWithoutBLOBsElementGenerated(element, introspectedTable);
    }

    public boolean validate(List<String> warnings)
    {
        return true;
    }
}