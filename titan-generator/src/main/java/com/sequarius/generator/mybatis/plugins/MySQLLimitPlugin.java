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
        String pageEntityName="page";
        topLevelClass.addImportedType(new FullyQualifiedJavaType(PAGE_ENTITY_NAME));
        CommentGenerator commentGenerator = context.getCommentGenerator();
        Field field = new Field(pageEntityName,new FullyQualifiedJavaType(PAGE_ENTITY_NAME));
        field.setVisibility(JavaVisibility.PROTECTED);
        commentGenerator.addFieldComment(field, introspectedTable);
        topLevelClass.addField(field);
        char c = pageEntityName.charAt(0);
        String camel = Character.toUpperCase(c) + pageEntityName.substring(1);
        Method method = new Method("set" + camel);
        method.setVisibility(JavaVisibility.PUBLIC);
        method.addParameter(new Parameter(new FullyQualifiedJavaType(PAGE_ENTITY_NAME), pageEntityName));
        method.addBodyLine("this." + pageEntityName + "=" + pageEntityName + ";");
        commentGenerator.addGeneralMethodComment(method, introspectedTable);
        topLevelClass.addMethod(method);
        method = new Method("get" + camel);
        method.setVisibility(JavaVisibility.PUBLIC);
        method.setReturnType(new FullyQualifiedJavaType(PAGE_ENTITY_NAME));
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