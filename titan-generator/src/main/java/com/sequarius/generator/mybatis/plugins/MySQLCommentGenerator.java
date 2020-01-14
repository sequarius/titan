package com.sequarius.generator.mybatis.plugins;

import org.mybatis.generator.api.IntrospectedColumn;
import org.mybatis.generator.api.IntrospectedTable;
import org.mybatis.generator.api.dom.java.Field;
import org.mybatis.generator.api.dom.java.TopLevelClass;
import org.mybatis.generator.internal.DefaultCommentGenerator;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

/**
 * project titan
 *
 * @author Sequarius *
 * @since 14/01/2020
 */
public class MySQLCommentGenerator extends DefaultCommentGenerator {

    private Properties properties;

    public MySQLCommentGenerator() {
        properties = new Properties();
    }

    @Override
    public void addConfigurationProperties(Properties properties) {
        // 获取自定义的 properties
        this.properties.putAll(properties);
    }

    @Override
    public void addModelClassComment(TopLevelClass topLevelClass, IntrospectedTable introspectedTable) {
        String author = properties.getProperty("author");
        String dateFormat = properties.getProperty("dateFormat", "yyyy-MM-dd");
        SimpleDateFormat dateFormatter = new SimpleDateFormat(dateFormat);

        // 获取表注释
        String remarks = introspectedTable.getRemarks();

        topLevelClass.addImportedType(properties.getProperty("filedAnnotationClass"));
        topLevelClass.addImportedType(properties.getProperty("entityAnnotationClass"));

        topLevelClass.addJavaDocLine("/**");
        topLevelClass.addJavaDocLine(" * " + remarks);
        topLevelClass.addJavaDocLine(" *");
        topLevelClass.addJavaDocLine(" * @author " + author);
        topLevelClass.addJavaDocLine(" * @date " + dateFormatter.format(new Date()));
        topLevelClass.addJavaDocLine(" */");
        topLevelClass.addAnnotation("");

        String annotation = String.format("@Entity(name = \"%s\", displayName = \"%s\")",
                introspectedTable.getAliasedFullyQualifiedTableNameAtRuntime(),introspectedTable.getRemarks());
        topLevelClass.addAnnotation(annotation);

    }

    @Override
    public void addFieldComment(Field field, IntrospectedTable introspectedTable, IntrospectedColumn introspectedColumn) {
        // 获取列注释
        String remarks = introspectedColumn.getRemarks();
        if("createTime".equals(field.getName())){
            remarks = "创建日期";
        }else if("updateTime".equals(field.getName())){
            remarks = "更新日期";
        }else if ("id".equals(field.getName())){
            remarks = "id";
        }
        String annotation = String.format("@Filed(name = \"%s\", displayName = \"%s\", type = \"%s\", length = %d)",
                field.getName(),remarks,introspectedColumn.getActualTypeName(),introspectedColumn.getLength());
                field.addAnnotation(annotation);
        field.addJavaDocLine("/**");
        field.addJavaDocLine(" * " + remarks);
        field.addJavaDocLine(" */");
    }
}